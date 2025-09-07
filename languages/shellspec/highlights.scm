; BDD Structure Keywords
["Describe" "Context" "ExampleGroup"] @keyword.function
["It" "Specify" "Example"] @keyword.function
["Todo"] @keyword.function

; Prefixed block keywords
["xDescribe" "xContext" "xExampleGroup" "xIt" "xSpecify" "xExample"] @keyword.function.inactive
["fDescribe" "fContext" "fExampleGroup" "fIt" "fSpecify" "fExample"] @keyword.function.focus

; Control flow
["Pending" "Skip"] @keyword.control
["When" "The" "Assert"] @keyword.control
["End"] @keyword.control

; Hook keywords
["BeforeEach" "AfterEach" "BeforeAll" "AfterAll"] @keyword.function
["BeforeCall" "AfterCall" "BeforeRun" "AfterRun"] @keyword.function
["Before" "After"] @keyword.function

; Helper keywords
["Include" "Set" "Data" "Parameters" "Dump"] @keyword
["Path" "File" "Dir"] @keyword

; Evaluation keywords
["call" "run" "command" "script" "source"] @function.method

; Assertion keywords
["should" "not"] @keyword.operator
["output" "stdout" "error" "stderr" "status" "variable" "path"] @variable.builtin

; Matchers
["equal" "eq" "be" "exist" "valid" "satisfy"] @function.method
["match" "start_with" "end_with" "include" "contain"] @function.method

; Modifiers
["line" "word" "length" "contents" "result"] @variable.parameter
["first" "second" "third" "of"] @variable.parameter

; Language chains
["a" "an" "as" "the"] @keyword.operator

; Skip conditional
(word) @keyword.control
  (#match? @keyword.control "^Skip\\s+if$")

; Test descriptions and strings
(string) @string
(raw_string) @string

; Comments
(comment) @comment

; Numbers
(number) @number

; Variables
(variable_name) @variable
(variable_assignment) @variable

; Function definitions
(function_definition
  name: (word) @function)

; Command names
(command_name) @function

; Data block markers
(word) @punctuation.special
  (#eq? @punctuation.special "#|")

; Tags (key:value pairs)
(word) @label
  (#match? @label "\\w+:\\w+")
