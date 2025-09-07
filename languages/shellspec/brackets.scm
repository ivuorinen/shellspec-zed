; Quote pairs
("'" @open "'" @close)
("\"" @open "\"" @close)

; Command substitution
("$(" @open ")" @close)
("${" @open "}" @close)

; Parentheses
("(" @open ")" @close)

; Square brackets
("[" @open "]" @close)

; Curly braces
("{" @open "}" @close)

; ShellSpec block structure (if using End keyword)
(simple_command
  (command_name) @_cmd
  (#match? @_cmd "^(Describe|Context|It|Specify|Example)$")) @open

(simple_command
  (command_name) @_end
  (#eq? @_end "End")) @close
