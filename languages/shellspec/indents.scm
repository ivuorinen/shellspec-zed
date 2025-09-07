; Indent content inside BDD blocks
(simple_command
  (command_name) @_name
  (#match? @_name "^(Describe|Context|ExampleGroup|It|Specify|Example)$")) @indent

; Indent prefixed blocks
(simple_command
  (command_name) @_name
  (#match? @_name "^[xf](Describe|Context|ExampleGroup|It|Specify|Example)$")) @indent

; Indent hook content
(simple_command
  (command_name) @_name
  (#match? @_name "^(BeforeEach|AfterEach|BeforeAll|AfterAll|BeforeCall|AfterCall|BeforeRun|AfterRun)$")) @indent

; Indent Data blocks
(simple_command
  (command_name) @_name
  (#match? @_name "^(Data|Parameters)$")) @indent

; Indent function definitions
(function_definition) @indent

; Indent compound statements
(compound_statement) @indent

; Indent conditional statements
(if_statement) @indent
(for_statement) @indent
(while_statement) @indent

; Indent pipeline continuations
(pipeline) @indent

; Dedent End keyword
(simple_command
  (command_name) @_name
  (#eq? @_name "End")) @dedent
