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



set _bundleID ''

function _get_bundle_id
	lsappinfo info -only bundleID (lsappinfo front) | cut -d '"' -f4
end

function _is_terminal_focused
	test $_bundleID = _get_bundle_id
end

function _is_command_available
	type -q $argv
end


function _started --on-event fish_preexec
	if _is_command_available lsappinfo
		set _bundleID _get_bundle_id
	end
end

function _done --on-event fish_prompt

	if test $CMD_DURATION
		# Store duration of last command
		set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')

		# when a command takes longer than notify_duration
		set notify_duration 10000
		set exclude_cmd "zsh|bash|less|man|more|ssh|drush php|git add|vim"

		if begin
				test $CMD_DURATION -gt $notify_duration
				and echo $history[1] | grep -vqE "^($exclude_cmd).*"
			end

			set -l message "Finished in $duration"
			set -l title "$history[1]"

			if test (uname) = 'Darwin' # macOS
				if not _is_terminal_focused
					if _is_command_available terminal-notifier # if command available
						terminal-notifier -message "$message" -title "$title" -sender "$_bundleID"
					else
						osascript -e "display notification \"$message\" with title \"$title\""
					end
				end

			else if _is_command_available notify-send # linux
				notify-send "Finished in $duration with title $history[1]"

			else # anything else
      	echo -e "\a" # bell sound
			end
		end
	end
end
