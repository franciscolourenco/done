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
```
fisher install done
```

#### Manually:
```
curl -Lo ~/.config/fish/functions/_done.fish --create-dirs raw.githubusercontent.com/fisherman/done/master/_done.fish
```

## Update

```
fisher update
```

[Subscribe](http://eepurl.com/cAcU3P) to be notified on updates.

## Support
- fish 2.3.0+
- macOS 10.8+ via Notification Center. For notification with icons, please `brew install terminal-notifier`. Tab detection not supported for now.
- Linux via `notify-send`. Otherwise bell sound is played. Window detection supported.
- Windows: Upvote https://github.com/fisherman/done/issues/5 if interested.

## Contributors
- [Francisco Lourenço](https://github.com/aristidesfl/) - Maintainer
- [Daniel Wehner](https://dawehner.github.io/) - Proof of Concept
- [Thanh Duc Nguyen](http://iamthanh.com/) - Logo
