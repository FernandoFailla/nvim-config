--- blink.cmp source that provides R dataframe column name completions
--- by querying a running R session via vim-slime.
---
--- It uses treesitter to walk up the AST from the cursor position,
--- looking for a pipe chain or a ggplot/dplyr function call, and
--- extracts the dataframe identifier. Then it sends `names(df)` to
--- the R terminal and parses the output.

--- @module 'blink.cmp'
--- @class blink.cmp.Source
local source = {}

--- How long to wait (ms) for R to respond
local TIMEOUT_MS = 500

--- Filetypes where this source should be active
local R_FILETYPES = { r = true, rmd = true, rmarkdown = true, quarto = true }

--- Functions where the first argument is a dataframe
local DATA_FIRST_FUNCS = {
  ggplot = true,
  with = true,
  within = true,
  subset = true,
  transform = true,
}

function source.new(_, _)
  return setmetatable({}, { __index = source })
end

function source:enabled()
  -- Only enable in R-related filetypes
  if not R_FILETYPES[vim.bo.filetype] then
    return false
  end
  -- Only enable if there is a running R terminal via slime
  local channels = vim.g.slime_last_channel
  return channels ~= nil and #channels > 0
end

--- Check if a binary_operator node is a pipe (|> or %>%)
---@param node TSNode
---@return boolean
local function is_pipe_operator(node)
  if node:type() ~= 'binary_operator' then
    return false
  end
  local op = node:child(1)
  if not op then
    return false
  end
  local op_type = op:type()
  -- |> shows as type "|>", %>% shows as type "special"
  return op_type == '|>' or op_type == 'special'
end

--- Walk up treesitter nodes from cursor to find the dataframe name.
--- R treesitter represents pipes as binary_operator nodes:
---   binary_operator: child(0)=lhs, child(1)=operator("|>" or special), child(2)=rhs
---
--- Handles these patterns:
---   df |> ggplot(aes(x = ))       -- pipe: df is left-hand side
---   df %>% mutate(new_col = old)  -- magrittr pipe
---   ggplot(df, aes(x = ))         -- first argument of data-first function
---@return string|nil dataframe name, or nil if not detected
local function find_dataframe_at_cursor()
  -- For quarto files, we need to handle injected R code
  local node = vim.treesitter.get_node { ignore_injections = false }
  if not node then
    return nil
  end

  local current = node
  while current do
    local ntype = current:type()

    -- Case 1: We are inside a binary_operator that is a pipe
    if is_pipe_operator(current) then
      -- Walk to the topmost pipe in the chain
      while current:parent() and is_pipe_operator(current:parent()) do
        current = current:parent()
      end
      -- The leftmost child (child(0)) of the top pipe is the dataframe
      local lhs = current:child(0)
      if lhs then
        local text = vim.treesitter.get_node_text(lhs, 0)
        -- Clean up: trim whitespace
        text = text:match '^%s*(.-)%s*$'
        if text ~= '' then
          return text
        end
      end
    end

    -- Case 2: We are inside a call like ggplot(df, aes(...))
    if ntype == 'call' then
      local func_node = current:child(0)
      if func_node then
        local func_name = vim.treesitter.get_node_text(func_node, 0)
        if DATA_FIRST_FUNCS[func_name] then
          -- Check if this call is the RHS of a pipe (then df is the pipe's LHS)
          if current:parent() and is_pipe_operator(current:parent()) then
            local pipe = current:parent()
            while pipe:parent() and is_pipe_operator(pipe:parent()) do
              pipe = pipe:parent()
            end
            local lhs = pipe:child(0)
            if lhs then
              local text = vim.treesitter.get_node_text(lhs, 0):match '^%s*(.-)%s*$'
              if text ~= '' then
                return text
              end
            end
          else
            -- Not in a pipe: first argument is the dataframe
            local args = current:child(1) -- arguments node
            if args then
              for child in args:iter_children() do
                if child:type() == 'argument' then
                  -- First argument (which has no name= prefix, or the value part)
                  local value = child:field 'value'
                  if value and #value > 0 then
                    local text = vim.treesitter.get_node_text(value[1], 0):match '^%s*(.-)%s*$'
                    if text ~= '' then
                      return text
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    -- Case 3: Our parent is a pipe binary_operator
    if current:parent() and is_pipe_operator(current:parent()) then
      local pipe = current:parent()
      while pipe:parent() and is_pipe_operator(pipe:parent()) do
        pipe = pipe:parent()
      end
      local lhs = pipe:child(0)
      if lhs then
        local text = vim.treesitter.get_node_text(lhs, 0):match '^%s*(.-)%s*$'
        if text ~= '' then
          return text
        end
      end
    end

    current = current:parent()
  end

  return nil
end

--- Send a command to the R terminal and capture the output.
--- Uses the slime channel to communicate with the running R process.
---@param r_cmd string the R command to send
---@return string[] lines of output from R
local function query_r_terminal(r_cmd)
  local channels = vim.g.slime_last_channel
  if not channels or #channels == 0 then
    return {}
  end

  -- Use the most recent channel (last in the list)
  local channel = channels[#channels]
  local jobid = channel.jobid
  local bufnr = channel.bufnr

  -- Validate the channel/buffer still exists
  if not jobid or not vim.api.nvim_buf_is_valid(bufnr) then
    return {}
  end

  -- Record the current state of the terminal buffer
  local tick_before = vim.api.nvim_buf_get_changedtick(bufnr)

  -- Send the command
  vim.api.nvim_chan_send(jobid, r_cmd .. '\n')

  -- Wait for output to appear
  vim.wait(TIMEOUT_MS, function()
    return vim.api.nvim_buf_get_changedtick(bufnr) ~= tick_before
  end, 20)

  -- Small extra wait for output to stabilize
  vim.wait(80, function()
    return false
  end, 80)

  -- Read output lines from the terminal buffer, scanning backwards
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local i = line_count
  local max_search = 100
  local lines = {}

  while i > 0 and max_search > 0 do
    local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
    -- Stop at the R prompt. Radian uses 'r$> ' or '>  ', vanilla R uses '> '
    -- Also match the command we sent (names(...)) to avoid capturing it
    if line and (line:match '^r%$>' or line:match '^>') then
      break
    end
    if line and line ~= '' then
      table.insert(lines, 1, line)
    end
    i = i - 1
    max_search = max_search - 1
  end

  return lines
end

--- Parse R's names() output into a list of column names.
--- R output looks like: [1] "col1" "col2" "col3"
---                       [4] "col4" "col5"
---@param lines string[]
---@return string[]
local function parse_r_names(lines)
  local names = {}
  for _, line in ipairs(lines) do
    for name in line:gmatch '"([^"]+)"' do
      table.insert(names, name)
    end
  end
  return names
end

--- Cache: { [dataframe_name] = { items = {...}, time = os.time() } }
local cache = {}
local CACHE_TTL_SEC = 10

function source:get_completions(ctx, callback)
  local df_name = find_dataframe_at_cursor()

  if not df_name or df_name == '' then
    callback { items = {}, is_incomplete_forward = false, is_incomplete_backward = false }
    return
  end

  -- Check cache
  local cached = cache[df_name]
  if cached and (os.time() - cached.time) < CACHE_TTL_SEC then
    callback { items = vim.deepcopy(cached.items), is_incomplete_forward = false, is_incomplete_backward = false }
    return
  end

  -- Query R terminal
  local lines = query_r_terminal('names(' .. df_name .. ')')
  local col_names = parse_r_names(lines)

  if #col_names == 0 then
    callback { items = {}, is_incomplete_forward = false, is_incomplete_backward = false }
    return
  end

  local CompletionItemKind = require('blink.cmp.types').CompletionItemKind

  --- @type lsp.CompletionItem[]
  local items = {}
  for _, name in ipairs(col_names) do
    table.insert(items, {
      label = name,
      kind = CompletionItemKind.Field,
      insertText = name,
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      documentation = {
        kind = 'markdown',
        value = 'Column from `' .. df_name .. '`',
      },
    })
  end

  -- Update cache
  cache[df_name] = {
    items = vim.deepcopy(items),
    time = os.time(),
  }

  callback { items = items, is_incomplete_forward = false, is_incomplete_backward = false }
end

return source
