; Test suites
(simple_command
  (command_name) @_name
  (#match? @_name "^(Describe|Context|ExampleGroup)$")
  (word) @name) @item

; Individual tests
(simple_command
  (command_name) @_name
  (#match? @_name "^(It|Specify|Example)$")
  (word) @name) @item

; Focused tests
(simple_command
  (command_name) @_name
  (#match? @_name "^f(Describe|Context|It|Specify|Example)$")
  (word) @name) @item

; Skipped tests
(simple_command
  (command_name) @_name
  (#match? @_name "^x(Describe|Context|It|Specify|Example)$")
  (word) @name) @item

; Hooks
(simple_command
  (command_name) @_name
  (#match? @_name "^(BeforeEach|AfterEach|BeforeAll|AfterAll)$")
  (word) @name) @item

; Function definitions
(function_definition
  name: (word) @name) @item
