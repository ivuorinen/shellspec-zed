# Zed ShellSpec Extension

Language support for ShellSpec BDD testing framework in Zed editor.

## Features

- Syntax highlighting for ShellSpec DSL keywords
- Smart indentation for nested test blocks
- Code outline navigation
- Bracket matching and auto-completion
- Test execution integration

## Installation

1. Install via Zed's extension gallery (when published)
2. Or manually: clone to `~/.config/zed/extensions/shellspec/`

## File Types

Automatically detects files with:

- `*_spec.sh`
- `*.spec.sh`

## Usage

### Test Execution

Use Zed's task system to run tests:

```json
{
  "tasks": {
    "shellspec-test": {
      "label": "Run ShellSpec Test",
      "command": "shellspec",
      "args": ["$ZED_RELATIVE_FILE"],
      "cwd": "$ZED_WORKTREE_ROOT"
    },
    "shellspec-all": {
      "label": "Run All Tests",
      "command": "shellspec",
      "cwd": "$ZED_WORKTREE_ROOT"
    }
  }
}
```

### Language Server

Uses bash-language-server for shell script features. Install with:

```bash
npm install -g bash-language-server
```

## Contributing

Issues and PRs welcome at <https://github.com/ivuorinen/shellspec-zed>

## License

MIT
