;extends

; Existing: quarto comment blocks
(
(comment) @comment
(#match? @comment "^\\#\\|")
) @text.literal

; Pipe operator |> gets a distinct highlight
(binary_operator
  operator: "|>" @keyword.operator)

; Magrittr pipe %>% and other special operators (%in%, %*%, etc.)
; "special" is an anonymous token, so we match it in the bracket syntax
["special"] @keyword.operator

; Assignment operators
(binary_operator
  operator: "<-" @keyword.operator)

(binary_operator
  operator: "<<-" @keyword.operator)

(binary_operator
  operator: "->" @keyword.operator)

(binary_operator
  operator: "->>" @keyword.operator)

; Formula operator (~) used heavily in R
(binary_operator
  operator: "~" @keyword.operator)

; $ and @ member access: highlight the rhs as a field
(extract_operator
  operator: "$" @punctuation.delimiter
  rhs: (identifier) @variable.member)

(extract_operator
  operator: "@" @punctuation.delimiter
  rhs: (identifier) @variable.member)

; Namespace operator (pkg::func) - make pkg stand out
(namespace_operator
  lhs: (identifier) @module
  operator: "::" @punctuation.delimiter)

(namespace_operator
  lhs: (identifier) @module
  operator: ":::" @punctuation.delimiter)
