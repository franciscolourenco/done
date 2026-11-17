# Contributing to Done

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

Please open an issue and discuss the problem / feature before starting to code.

## Code style

Keep the style consistent with existent code.


## Tests

The shell tests are run with [fishtape](https://github.com/jorgebucaran/fishtape):

```console
$ fishtape test/*.fish
```

The window ID cache has its own script, which needs an interactive shell
because the plugin only loads in one:

```console
$ fish --no-config --interactive tests/window-cache.fish
```


## Git Commit Messages

Follow [the seven rules of a great git commit message](http://chris.beams.io/posts/git-commit/#seven-rules):

1. Separate subject from body with a blank line
1. Limit the subject line to 50 characters
1. Capitalize the subject line
1. Do not end the subject line with a period
1. Use the imperative mood in the subject line
1. Wrap the body at 72 characters
1. Use the body to explain what and why vs. how



