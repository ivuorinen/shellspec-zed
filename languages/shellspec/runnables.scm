; Individual test execution
(command
  (command_name) @_name
  (#match? @_name "^(It|Specify|Example)$")
  [(word) (string) (raw_string)] @run) @shellspec-test

; Test suite execution
(command
  (command_name) @_name
  (#match? @_name "^(Describe|Context|ExampleGroup)$")
  [(word) (string) (raw_string)] @run) @shellspec-suite

; Focused test execution
(command
  (command_name) @_name
  (#match? @_name "^f(It|Specify|Example)$")
  [(word) (string) (raw_string)] @run) @shellspec-focused-test

; Focused suite execution
(command
  (command_name) @_name
  (#match? @_name "^f(Describe|Context|ExampleGroup)$")
  [(word) (string) (raw_string)] @run) @shellspec-focused-suite

; Pending test markers
(command
  (command_name) @_name
  (#match? @_name "^(Pending|Todo)$")
  [(word) (string) (raw_string)] @run) @shellspec-pending
