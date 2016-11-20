<h1 align="center">
  <img src="https://i.imgur.com/0LElCjU.png" alt="done" width="300"></a>
  <br>
</h1>

<h4 align="center">A <a href="https://fishshell.com/">fish</a> plugin to automatically receive a notification when long processes finish.</h4>

<p align="center">
  <img src="https://img.shields.io/badge/stability-experimental-orange.svg" alt="Stability: Experimental">
  <img src="https://img.shields.io/badge/fisherman-v0.2.2-blue.svg" alt="v0.2.2">
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

## Support
- OS X 10.8+: Notification Center
- Linux: `notify-send`, provided on Ubuntu by `libnotify-bin`.
- Windows: Planned

## Contributors
- [Francisco Lourenço](https://github.com/aristidesfl/) - Maintainer
- [Daniel Wehner](https://dawehner.github.io/) - Concept
- [Thanh Duc Nguyen](http://iamthanh.com/) - Logo

## License
MIT License

Copyright (c) 2016 Francisco Lourenço & Daniel Wehner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
