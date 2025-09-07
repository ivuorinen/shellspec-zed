; Individual test execution
(simple_command
  (command_name) @_name
  (#match? @_name "^(It|Specify|Example)$")
  (word) @run) @shellspec-test

; Test suite execution
(simple_command
  (command_name) @_name
  (#match? @_name "^(Describe|Context|ExampleGroup)$")
  (word) @run) @shellspec-suite

; Focused test execution
(simple_command
  (command_name) @_name
  (#match? @_name "^f(It|Specify|Example)$")
  (word) @run) @shellspec-focused-test

; Focused suite execution
(simple_command
  (command_name) @_name
  (#match? @_name "^f(Describe|Context|ExampleGroup)$")
  (word) @run) @shellspec-focused-suite

; Pending test markers
(simple_command
  (command_name) @_name
  (#match? @_name "^(Pending|Todo)$")
  (word) @run) @shellspec-pending
