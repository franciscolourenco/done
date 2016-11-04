# done

A [fish](https://fishshell.com/) plug-in to automatically get notified when long processes are finished.

## Install


#### Using [fisherman](http://fisherman.sh/):
```
fisher install done
```

#### Manually:
```
curl -Lo ~/.config/fish/functions/fish_right_prompt.fish --create-dirs raw.githubusercontent.com/fisherman/done/master/fish_right_prompt.fish
```


## Usage

Just go on with your normal life. You will get a notification when processes which take longer than 10 seconds finish, if the terminal window is in the background.
Customizing these settings may be supported in the future.

To test you could type, for instance `sleep 15`, and start using other app. After 15 seconds you should get a notification.

## Compatibility

Implemented using fish_right_prompt, so it can be used together with other fish_prompt packages. Except if they also user a fish_right_prompt.

## Support
- OS X 10.8+: Notification Center
- Linux: Planned
- Windows: Planned

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
