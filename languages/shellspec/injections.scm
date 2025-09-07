; Inject shell highlighting in function definitions
(function_definition
  body: (compound_statement) @injection.content
  (#set! injection.language "bash"))

; Inject shell in command substitutions
(command_substitution
  "$(" @injection.punctuation.bracket
  (_) @injection.content
  (#set! injection.language "bash")
  ")" @injection.punctuation.bracket)

; Inject shell in When blocks with call/run
(simple_command
  (command_name) @_when
  (#eq? @_when "When")
  (word) @_action
  (#match? @_action "^(call|run)$")
  (word)+ @injection.content
  (#set! injection.language "bash"))

; Inject shell in arithmetic expressions
(arithmetic_expansion
  "$((" @injection.punctuation.bracket
  (_) @injection.content
  (#set! injection.language "bash")
  "))" @injection.punctuation.bracket)

; Inject shell in process substitution
(process_substitution
  "<(" @injection.punctuation.bracket
  (_) @injection.content
  (#set! injection.language "bash")
  ")" @injection.punctuation.bracket)

(process_substitution
  ">(" @injection.punctuation.bracket
  (_) @injection.content
  (#set! injection.language "bash")
  ")" @injection.punctuation.bracket)
