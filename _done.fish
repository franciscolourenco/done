# MIT License

# Copyright (c) 2016 Francisco Lourenço & Daniel Wehner

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# done v0.4.0


set _initial_window_id ''

function _get_window_id
	if _is_available lsappinfo
		lsappinfo info -only bundleID (lsappinfo front) | cut -d '"' -f4
	else if _is_available xprop
		xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2
	end

end

function _is_terminal_focused
	test $_initial_window_id = (_get_window_id)
end

function _is_available
	type -q $argv
end

function _started --on-event fish_preexec
	set _initial_window_id (_get_window_id)
end

function _done --on-event fish_prompt

	if test $CMD_DURATION
		# Store duration of last command
		set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
		set notify_duration 10000
		set exclude_cmd "zsh|bash|less|man|more|ssh|drush php|git add|vim"

		if begin
				test $CMD_DURATION -gt $notify_duration  # longer than notify_duration
				and echo $history[1] | grep -vqE "^($exclude_cmd).*" # not excluded command
				and not _is_terminal_focused  # terminal or window not in foreground
			end

			set -l title "Finished in $duration"
			set -l message "$history[1]"

			if _is_available terminal-notifier  # https://github.com/julienXX/terminal-notifier
				terminal-notifier -message "$message" -title "$title" -sender "$_initial_window_id"

			else if _is_available osascript  # AppleScript
				osascript -e "display notification \"$message\" with title \"$title\""

			else if _is_available notify-send # Linux notify-send
				notify-send --icon=terminal --app-name=terminal "$title" "$message"

			else  # anything else
      	echo -e "\a" # bell sound
			end

		end
	end
end
