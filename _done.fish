function _done --on-event fish_prompt
	set -l platform
	set -l terminals "tmux|iTerm"

	if command -s tell > /dev/null
		set platform osx
	else if command -s notify-send > /dev/null
		set platform linux
	else
		echo "fisherman/done: could not detect your platform."
		return 1
	end

	if test $CMD_DURATION
		# Store duration of last command
		set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')

		# OS X notification when a command takes longer than notify_duration
		set notify_duration 10000
		set exclude_cmd "zsh|bash|less|man|more|ssh|drush php"
		if begin
				test $CMD_DURATION -gt $notify_duration
				and echo $history[1] | grep -vqE "^($exclude_cmd).*"
			end

			switch $platform
				case osx
					# Only show the notification if terminal is not focused
					echo "
						tell application \"System Events\"
							set activeApp to name of first application process whose frontmost is true
							if \"$terminals\" is not in activeApp then
								display notification \"Finished in $duration\" with title \"$history[1]\"
							end if
						end tell
						" | osascript
				case linux
					set active_window (xprop -id (xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME)
					if echo $active_window | grep -vqE $terminals
						notify-send "Finished in $duration with title $history[1]"
					end
			end
		end
	end
end
