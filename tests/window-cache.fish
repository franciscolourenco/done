#!/usr/bin/env fish
# Run with fish --no-config --interactive tests/window-cache.fish.
set -gx SSH_CLIENT test
set -g __done_allow_nongraphical 1
set -g __done_notification_command 'echo notified >>$notification_log'
source (status dirname)/../conf.d/done.fish
set -e __done_allow_nongraphical
set -e TMUX
set -e STY
set -e TMUX_PANE
set -e SWAYSOCK
set -e HYPRLAND_INSTANCE_SIGNATURE
set -e NIRI_SOCKET
set -e __done_kitty_remote_control
set -g probe_log (mktemp)
set -g notification_log (mktemp)
set -g probe_id 123
set -g probe_status 0

function __done_get_focused_window_id
    echo probe >>$probe_log
    printf '%s\n' $probe_id
    return $probe_status
end

function check -a description
    if not eval $argv[2..]
        echo "FAIL: $description" >&2
        rm -f $probe_log $notification_log
        exit 1
    end
    echo "PASS: $description"
end

__done_started
set -g probe_id 456
__done_started
check 'ordinary shells reuse the first ID' 'test "$__done_initial_window_id" = 123'
check 'no second preexec probe' 'test (count (cat $probe_log)) -eq 1'
set -g cmd_duration 1
__done_ended 'sleep 0'
check 'short commands skip focus probes' 'test (count (cat $probe_log)) -eq 1'
set -g cmd_duration 6000
__done_ended 'sleep 6'
check 'long commands query current focus' 'test (count (cat $probe_log)) -eq 2'
check 'changed focus notifies' 'test (count (cat $notification_log)) -eq 1'
set -g probe_id 123
__done_ended 'sleep 6'
check 'focused long commands do not notify' 'test (count (cat $notification_log)) -eq 1'

for multiplexer in TMUX STY
    set -g $multiplexer session
    __done_started
    set -g probe_id 789
    __done_started
    check "$multiplexer refreshes the window ID" 'test "$__done_initial_window_id" = 789'
    set -e $multiplexer
    set -g probe_id 123
end
check 'multiplexers probe on every command' 'test (count (cat $probe_log)) -eq 7'

for invalid in '' ' ' 0 000 0x000 null none "(false, '')" "(true, '0')"
    set -g __done_initial_window_id ''
    set -g probe_id "$invalid"
    __done_started
    check "reject no-window result: '$invalid'" 'test -z "$__done_initial_window_id"'
    set -g probe_id 123
    __done_started
    check 'retry succeeds' 'test "$__done_initial_window_id" = 123'
end
set -g __done_initial_window_id ''
set -g probe_status 1
__done_started
check 'failed queries are not cached' 'test -z "$__done_initial_window_id"'
set -g probe_status 0
__done_started
check 'failed query is retried' 'test "$__done_initial_window_id" = 123'
set -g __done_initial_window_id ''
set -g probe_id 123 456
__done_started
check 'multiple IDs are not cached' 'test -z "$__done_initial_window_id"'
for valid in 456 0x123 abc123 com.apple.Terminal "(true, '123')"
    set -g __done_initial_window_id ''
    set -g probe_id "$valid"
    __done_started
    set -g probe_id changed
    __done_started
    set -g expected_id "$valid"
    check "cache backend ID: $valid" 'test "$__done_initial_window_id" = "$expected_id"'
end
set -g __done_initial_window_id ''
__done_started
check 'explicit reset learns a new window' 'test "$__done_initial_window_id" = changed'
rm -f $probe_log $notification_log
