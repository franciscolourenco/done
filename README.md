<h1 align="center">
  <img src="https://i.imgur.com/0LElCjU.png" alt="done" width="300"></a>
  <br>
</h1>

<h4 align="center">A <a href="https://fishshell.com/">fish</a> plugin to automatically receive notifications when long processes finish.</h4>

<p align="center">
  <img src="https://img.shields.io/badge/stability-stable-green.svg" alt="Stability: Stable">
  <img src="https://img.shields.io/github/release/fisherman/done.svg" alt="Release version">
  <img src="https://img.shields.io/badge/fish-%3E=2.3.0-orange.svg" alt="fish >=2.3.0">
  <img src="https://img.shields.io/badge/license-MIT-lightgray.svg" alt="License: MIT">
</p>
<br>

Just go on with your normal life. You will get a notification when a process takes more than 10 seconds finish, and the terminal window not in the foreground.
Customizing these settings may be supported in the future.

To test you could type, for instance `sleep 15`, and start using other app. After 15 seconds you should get a notification.



## Install


#### Using [fisherman](http://fisherman.sh/):
```bash
fisher install done
```

#### Manually:
```bash
curl -Lo ~/.config/fish/functions/humanize_duration.fish --create-dirs https://raw.githubusercontent.com/fisherman/humanize_duration/master/humanize_duration.fish
curl -Lo ~/.config/fish/conf.d/done.fish --create-dirs https://raw.githubusercontent.com/fisherman/done/master/conf.d/done.fish
```

#### Terminal Notifier
Notification with icons on macOS require `terminal-notifier` to be installed.

```bash
brew install terminal-notifier
```


## Update

```bash
fisher update
```

[Subscribe](http://eepurl.com/cAcU3P) to be notified on updates.

## Configure


```bash
# notify only if command takes more than 5000 ms (default)
set -U __done_min_cmd_duration 5000
```

## Support
- fish 2.3.0+
- macOS 10.8+ via Notification Center.
- Linux via `notify-send`. Otherwise bell sound is played.
- Windows: Upvote https://github.com/fisherman/done/issues/5 if interested.

## Credits
- [Francisco Lourenço](https://github.com/aristidesfl/) - Maintainer
- [Daniel Wehner](https://dawehner.github.io/) - Proof of Concept
- [Thanh Duc Nguyen](http://iamthanh.com/) - Logo
