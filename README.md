# t

Search your project directories and open a new Tmux session for the selected project

## Installation

t uses [fzf](https://github.com/junegunn/fzf) and bash.

Installing through [homebrew](https://brew.sh/) is recommended, as you'll get
the dependencies automatically.

```
brew install nick-f/labs/t
```

## Configuration

There are some configuration options that can be set as environment variables.
Set them however you normally set environment variables in your shell or on a
per-command basis.

### T_PATHS

This determines what paths are going to be checked for your projects. It should
be a string containing one or more paths separated by the value of
`T_PATHS_DELIMITER`.

Each path should be absolute.

```
T_PATHS="~/Code /tmp/projects"
```

### T_PATHS_DELIMITER

The default delimiter is a space ` `. You might want to customise the delimiter
if you have paths that contain spaces.

```
T_PATHS_DELIMITER=","
T_PATHS="~/Code,/tmp/projects"
```

## Usage

```
t

# or

T_PATHS="~/Code" t
```
