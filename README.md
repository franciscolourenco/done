<h1 align="center">
  <img src="https://i.imgur.com/0LElCjU.png" alt="done" width="300"></a>
  <br>
</h1>

<h4 align="center">A <a href="https://fishshell.com/">fish shell</a> package to automatically receive notifications when long processes finish.</h4>

<p align="center">
  <a href="https://opencollective.com/done" alt="Financial Contributors on Open Collective"><img src="https://opencollective.com/done/all/badge.svg?label=financial+contributors" /></a> <img src="https://img.shields.io/badge/stability-stable-green.svg" alt="Stability: Stable">
  <img src="https://img.shields.io/github/release/franciscolourenco/done.svg" alt="Release version">
  <img src="https://img.shields.io/badge/fish-%3E=2.3.0-orange.svg" alt="fish >=2.3.0">
  <img src="https://img.shields.io/badge/license-MIT-lightgray.svg" alt="License: MIT">
</p>
<br>

Just go on with your normal life. You will get a notification when a process takes more than 5 seconds finish, and the terminal window not in the foreground.

After installing you could type, for instance `sleep 6`, and start using other app. After 6 seconds you should get a notification.

## Installation

#### Using [Fisher](https://github.com/jorgebucaran/fisher)

```fish
fisher install franciscolourenco/done
```

#### Manually

```fish
curl -Lo ~/.config/fish/conf.d/done.fish --create-dirs https://raw.githubusercontent.com/franciscolourenco/done/master/conf.d/done.fish
```

#### Arch Linux

Install the `fish-done` package from AUR.

```fish
yay -S fish-done
```

## Dependencies

- If you want notifications with icons on macOS, please install `terminal-notifier` with

```fish
brew install terminal-notifier
```

- If you are using https://swaywm.org please install `jq`.


- If you are using Windows Subsystem for Linux (WSL) you may need to install [wslu](https://github.com/wslutilities/wslu), but usually it is pre-installed.

## Updating

```fish
fisher update franciscolourenco/done
```

## Settings

#### Only display notifications if a command takes more than a certain amount of time

```fish
set -U __done_min_cmd_duration 5000  # default: 5000 ms
```

#### Prevent specific commands from triggering notifications. Accepts a regex.

This is useful to exclude commands like `git commit` for instance, since it could trigger unwanted notifications if it is configured to use an external editor. This is also useful with `set -U __done_allow_nongraphical 1` to prevent notifications for commands normally run interactively that you do not want to get done notifications for.

```fish
set -U __done_exclude 'git (?!push|pull)'  # default: all git commands, except push and pull. accepts a regex.
```

#### Execute a custom command instead of showing the default notifications. The `done` notification title and message can also be passed.

```fish
set -U __done_notification_command "your-command \$title \$message"
```

#### Play sound when showing notifications.

```fish
set -U __done_notify_sound 1
```

#### When using `sway`, do not show notifications for visible windows.

```fish
set -U __done_sway_ignore_visible 1
```

#### For Linux, set the urgency level for notifications sent via notify-send (low, normal, critical). The default is "normal" for regular commands, and "critical" for failed commands.

```fish
set -U __done_notification_urgency_level low
set -U __done_notification_urgency_level_failure normal
```

#### Allow notifications to be sent on systems without graphical capabilities. Note this requires you to also set `__done_notification_command`.

```fish
set -U __done_allow_nongraphical 1
```

## Support

- [fish](https://fishshell.com) 2.3.0+
- macOS 10.8+ via Notification Center.
- Linux via `notify-send`. Otherwise bell sound is played.
- Windows 10 via Windows Subsystem for Linux (WSL) and PowerShell.

## Credits

- [Francisco Lourenço](https://github.com/aristidesfl/) - Maintainer
- [Daniel Wehner](https://dawehner.github.io/) - Proof of Concept
- [Thanh Duc Nguyen](http://iamthanh.com/) - Logo

## Contributors

### Code Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/franciscolourenco/done/graphs/contributors"><img src="https://opencollective.com/done/contributors.svg?width=890&button=false" /></a>

### Financial Contributors

Become a financial contributor and help us sustain our community. [[Contribute](https://opencollective.com/done/contribute)]

#### Individuals

<a href="https://opencollective.com/done"><img src="https://opencollective.com/done/individuals.svg?width=890"></a>

#### Organizations

Support this project with your organization. Your logo will show up here with a link to your website. [[Contribute](https://opencollective.com/done/contribute)]

<a href="https://opencollective.com/done/organization/0/website"><img src="https://opencollective.com/done/organization/0/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/1/website"><img src="https://opencollective.com/done/organization/1/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/2/website"><img src="https://opencollective.com/done/organization/2/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/3/website"><img src="https://opencollective.com/done/organization/3/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/4/website"><img src="https://opencollective.com/done/organization/4/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/5/website"><img src="https://opencollective.com/done/organization/5/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/6/website"><img src="https://opencollective.com/done/organization/6/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/7/website"><img src="https://opencollective.com/done/organization/7/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/8/website"><img src="https://opencollective.com/done/organization/8/avatar.svg"></a>
<a href="https://opencollective.com/done/organization/9/website"><img src="https://opencollective.com/done/organization/9/avatar.svg"></a>

## License

Done is MIT licensed. See [LICENSE](LICENSE) for details.
