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

			switch (uname)
				case Darwin # macOS
					echo "
						tell application \"System Events\"
							set activeApp to name of first application process whose frontmost is true
							if \"iTerm\" is not in activeApp then
								display notification \"Finished in $duration\" with title \"$history[1]\"
							end if
						end tell
						" | osascript
				case Linux
					notify-send "Finished in $duration with title $history[1]"
        case "*"
          # bell sound
          echo -e "\a"
			end
		end
	end
end
