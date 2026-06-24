# Nitpicker Findings
Generated: 2026-06-24
Last validated: 2026-06-25

## Summary
- Total: 10 | Open: 0 | Fixed: 10 | Invalid: 0
- Critical: 2 | High: 3 | Medium: 2 | Low: 3 (all fixed)

## Open Findings

_None._

## Fixed

### Pass 1 — 2026-06-25

#### [N-010] All query files reference non-existent node `simple_command`
Severity: Critical
Category: correctness
Area: languages/shellspec/{highlights,brackets,indents,outline,runnables,injections}.scm
Problem: Every query used `(simple_command ...)`, but tree-sitter-bash has no
`simple_command` node — the node is `command` (field `name:` → `command_name`).
A query referencing an unknown node type fails to compile and disables the entire
query file in Zed.
Evidence: `node-types.json` at the pinned grammar rev contains `command` (with
`name: command_name`) and no `simple_command`; verified programmatically.
Fixed: 2026-06-25
Notes: Replaced `simple_command` → `command` across all six query files. Added
scripts/validate-queries.py which flags exactly this class of error (confirmed it
reports `simple_command` as unknown and passes the corrected files).

#### [N-001] Grammar name mismatch — extension loads no grammar
Severity: Critical
Category: correctness
Area: extension.toml, languages/shellspec/config.toml
Problem: `extension.toml` declared `[grammars.shellspec]` while `config.toml` set
`grammar = "bash"` — no `bash` grammar is declared, so Zed loads no parser and
every tree-sitter feature is dead.
Fixed: 2026-06-25
Notes: Set `config.toml` `grammar = "shellspec"` to match the declared grammar.

#### [N-002] Grammar `rev` pinned to a moving branch, not a commit SHA
Severity: High
Category: reliability
Area: extension.toml
Problem: `rev = "main"` is non-reproducible and rejected by the Zed extensions
registry, which requires a commit SHA.
Fixed: 2026-06-25
Notes: Pinned `rev = "a06c2e4415e9bc0346c6b86d401879ffb44058f7"`
(tree-sitter/tree-sitter-bash master HEAD at fix time). Renovate can bump it.

#### [N-003] BDD keyword highlighting via `["Literal"]` patterns never matched
Severity: High
Category: correctness
Area: languages/shellspec/highlights.scm
Problem: Keyword highlighting used anonymous-token list syntax
(`["Describe" ...] @keyword.function`), which matches grammar tokens; ShellSpec
keywords are `command_name`/`word` nodes, so the rules matched nothing.
Fixed: 2026-06-25
Notes: Rewrote highlights.scm to predicate form — structure/hook/control/helper
keywords match `(command_name)` with `#match?`; assertion/matcher/modifier/chain
words match `(word)` with `#match?`. Node references validated against the
grammar. Visual scope precedence (generic `@function` first, keyword scopes
after) follows Zed's last-match convention and should be eyeballed in a live Zed
preview, but the rules now match the correct nodes — which was the defect.

#### [N-004] Runnables never triggered for quoted test descriptions
Severity: High
Category: correctness
Area: languages/shellspec/runnables.scm
Problem: Patterns required a `(word)` description, but idiomatic ShellSpec quotes
descriptions (`It 'returns 0'`), which parse as `string`/`raw_string`.
Fixed: 2026-06-25
Notes: Changed the description capture to `[(word) (string) (raw_string)] @run`
in all five rules (and `simple_command` → `command` per N-010).

#### [N-005] Outline omitted entries for quoted descriptions
Severity: Medium
Category: maintainability
Area: languages/shellspec/outline.scm
Problem: Same root cause as N-004 — `(word) @name` missed quoted descriptions.
Fixed: 2026-06-25
Notes: Changed to `[(word) (string) (raw_string)] @name` in each rule.

#### [N-006] Query files were never validated against the grammar
Severity: Medium
Category: tests
Area: scripts/validate-queries.py, .github/workflows/validate-queries.yml
Problem: No CI/pre-commit step parsed the `.scm` queries against the grammar, so
node-type errors (N-010) and dead rules (N-003/004/005/007) shipped silently.
Fixed: 2026-06-25
Notes: Added scripts/validate-queries.py (stdlib-only) that reads the pinned
grammar rev from extension.toml, fetches its node-types.json, and verifies every
node type referenced in languages/**/*.scm exists. Wired it into a new
validate-queries.yml workflow (zizmor-clean, minimal permissions, pinned
checkout). Verified earlier suspicions: `number` and `arithmetic_expansion` DO
exist in the grammar (no fix needed there); the real defect was `simple_command`.

#### [N-007] Dead highlight rules that can never match a single `word` node
Severity: Low
Category: correctness
Area: languages/shellspec/highlights.scm
Problem: `(word) ... (#match? "^Skip\\s+if$")` (a word has no whitespace) and
`(word) ... (#eq? "#|")` (`#|` lexes as a comment) never matched.
Fixed: 2026-06-25
Notes: Removed both inert rules during the highlights.scm rewrite.

#### [N-008] brackets.scm Describe/End pair could not match as a bracket pair
Severity: Low
Category: correctness
Area: languages/shellspec/brackets.scm
Problem: `@open` and `@close` were in two separate top-level patterns (and used
the non-existent `simple_command`), so Zed could not associate them as a pair.
Fixed: 2026-06-25
Notes: Removed the non-functional Describe/End block; kept the correct quote,
command-substitution, paren, bracket, and brace delimiter pairs.

#### [N-009] README listed capabilities the extension does not provide
Severity: Low
Category: docs
Area: README.md
Problem: Features listed "auto-completion" as an extension capability; completion
comes from bash-language-server, not the extension.
Fixed: 2026-06-25
Notes: Reworded to "Bracket matching and auto-close pairs", clarified test
execution as runnable detection, and attributed completion/diagnostics to
bash-language-server.

## Invalid

_None._
