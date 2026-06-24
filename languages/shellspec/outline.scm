; Test suites
(command
  (command_name) @_name
  (#match? @_name "^(Describe|Context|ExampleGroup)$")
  [(word) (string) (raw_string)] @name) @item

; Individual tests
(command
  (command_name) @_name
  (#match? @_name "^(It|Specify|Example)$")
  [(word) (string) (raw_string)] @name) @item

; Focused tests
(command
  (command_name) @_name
  (#match? @_name "^f(Describe|Context|It|Specify|Example)$")
  [(word) (string) (raw_string)] @name) @item

; Skipped tests
(command
  (command_name) @_name
  (#match? @_name "^x(Describe|Context|It|Specify|Example)$")
  [(word) (string) (raw_string)] @name) @item

; Hooks
(command
  (command_name) @_name
  (#match? @_name "^(BeforeEach|AfterEach|BeforeAll|AfterAll)$")
  [(word) (string) (raw_string)] @name) @item

; Function definitions
(function_definition
  name: (word) @name) @item
