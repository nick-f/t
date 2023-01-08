# t

Search your project directories and open a new Tmux session for the selected project

## Installation

### Dependencies

t uses [fzf](https://github.com/junegunn/fzf) and bash.

### Homebrew

Installing through [homebrew](https://brew.sh/) is recommended, as you'll get
the dependencies automatically.

Homebrew renames the script to simply `t`.

```
brew install nick-f/labs/t
```

### Manual installation

Download [t.bash](https://github.com/nick-f/t/blob/main/t.bash) and place it in a folder
that is included in your `PATH`.

To make it easier to type you can rename it to `t`.

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

Add a trailing slash to the path to also include that directory as an option.

To include `~/Code` as well as any subdirectories of `~/Code`:

```
T_PATHS="~/Code/"
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

## Contributing

This project uses [Semantic Versioning] and [Conventional Commits].

[Semantic Versioning]: https://semver.org
[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/

PRs welcome.
