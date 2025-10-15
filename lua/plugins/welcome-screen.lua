return {
  "folke/snacks.nvim",
  -- A tabela 'keys' é um recurso do lazy.nvim para definir atalhos
  -- que só são ativados quando o plugin é carregado.
  -- 'opts' agora contém apenas as opções específicas do snacks.nvim
  opts = {
    picker = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
███████╗███████╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
██╔════╝██╔════╝██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
█████╗  █████╗  █████╗  ██║   ██║██║   ██║██║██╔████╔██║
██╔══╝  ██╔══╝  ██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║     ███████╗██║     ╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚══════╝╚═╝      ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
      },
      sections = {
        {
          pane = 1,
          {
            section = "terminal",
            cmd = "ascii-image-converter ~/.config/nvim/imgs/edward.jpg -C -b --threshold 80 -d 60,20",
            height = 17,
            padding = 1,
          },
          { section = "header", header = "teste", padding = 1 },
        },
        { section = "recent_files", gap = 1, padding = 1, pane = 2 },
        { section = "keys", gap = 1, padding = 1, pane = 2 },
        { section = "startup", padding = 1, pane = 2 },
      },
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    -- A configuração do terminal dentro de 'opts' pode ficar vazia
    -- pois os atalhos estão sendo cuidados pelo lazy.nvim
  },
}
