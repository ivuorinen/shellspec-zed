; ShellSpec keywords are ordinary shell commands/arguments in the bash grammar,
; not anonymous grammar tokens. They must be matched as (command_name) / (word)
; nodes with predicates — a bare ["Describe"] list matches nothing.

; Generic command name (overridden by the keyword rules below).
(command_name) @function

; BDD structure keywords (statement-leading command names)
((command_name) @keyword.function
  (#match? @keyword.function "^(Describe|Context|ExampleGroup|It|Specify|Example|Todo)$"))

; Prefixed block keywords
((command_name) @keyword.function.inactive
  (#match? @keyword.function.inactive "^x(Describe|Context|ExampleGroup|It|Specify|Example)$"))
((command_name) @keyword.function.focus
  (#match? @keyword.function.focus "^f(Describe|Context|ExampleGroup|It|Specify|Example)$"))

; Control flow keywords
((command_name) @keyword.control
  (#match? @keyword.control "^(Pending|Skip|When|The|Assert|End)$"))

; Hook keywords
((command_name) @keyword.function
  (#match? @keyword.function "^(BeforeEach|AfterEach|BeforeAll|AfterAll|BeforeCall|AfterCall|BeforeRun|AfterRun|Before|After)$"))

; Helper keywords
((command_name) @keyword
  (#match? @keyword "^(Include|Set|Data|Parameters|Dump|Path|File|Dir)$"))

; Evaluation keywords (appear as arguments, e.g. `When call ...`)
((word) @function.method
  (#match? @function.method "^(call|run|command|script|source)$"))

; Assertion keywords
((word) @keyword.operator
  (#match? @keyword.operator "^(should|not)$"))
((word) @variable.builtin
  (#match? @variable.builtin "^(output|stdout|error|stderr|status|variable|path)$"))

; Matchers
((word) @function.method
  (#match? @function.method "^(equal|eq|be|exist|valid|satisfy|match|start_with|end_with|include|contain)$"))

; Modifiers
((word) @variable.parameter
  (#match? @variable.parameter "^(line|word|length|contents|result|first|second|third|of)$"))

; Language chains
((word) @keyword.operator
  (#match? @keyword.operator "^(a|an|as|the)$"))

; Tags (key:value pairs)
((word) @label
  (#match? @label "^\\w+:\\w+$"))

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
