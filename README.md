# Watchly CLI

`watchly` is a command-line tool that watches for file system changes and
executes a command when changes are detected.

It uses a polling-based approach rather than native file system events. This
makes it reliable across environments where evented file watchers are
unavailable or unreliable, including virtual machines, Vagrant setups, network
file systems, containers, and remote or synced volumes.

*`watcher-cli` is a thin wrapper around the [Watchly][watchly] Ruby gem.*

## Installation

```bash
gem install watchly-cli
```

## Usage

<!-- START USAGE -->
```console
$ watchly --help
watchly — run a command when files change

Watches files matching one or more glob patterns and runs a command when
they change.

When the command runs, environment variables are set with the list of
changed files (see below).

Usage:
  watchly COMMAND [options] [GLOB...]

Options:
  -i, --interval N
    Loop interval in seconds [default: 1]

  -q, --quiet
    Print less to screen

  -e, --each
    Run the command once per added or changed file

  -m, --immediate
    Execute the command before watching

  -h --help
    Show this help

Parameters:
  COMMAND
    Command to run on change

  GLOB
    One or more glob patterns [default: *.*]

Environment Variables:
  WATCHLY_FILES
    Added and modified files, one per line

  WATCHLY_ADDED
    Added files, one per line

  WATCHLY_MODIFIED
    Modified files, one per line

  WATCHLY_REMOVED
    Removed files, one per line

  WATCHLY_FILE
    The file currently being processed (only with --each)

Examples:
  watchly 'echo "$WATCHLY_FILES"' 'spec/**/*.rb' 'lib/**/*.*'

```
<!-- END USAGE -->


## Contributing / Support

If you experience any issue, have a question, or if you wish
to contribute, feel free to [open an issue][issues].

[watchly]: https://github.com/dannyben/watchly
[issues]: https://github.com/dannyben/watchly-cli/issues
