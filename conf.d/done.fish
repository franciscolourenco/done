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

if not status is-interactive
    exit
end

set -g __done_version 1.16.5

function __done_run_powershell_script
    set -l powershell_exe (command --search "powershell.exe")

    if test $status -ne 0
        and command --search wslvar

        set -l powershell_exe (wslpath (wslvar windir)/System32/WindowsPowerShell/v1.0/powershell.exe)
    end

    if string length --quiet "$powershell_exe"
        and test -x "$powershell_exe"

        set cmd (string escape $argv)

        eval "$powershell_exe -Command $cmd"
    end
end

function __done_windows_notification -a title -a message
    if test "$__done_notify_sound" -eq 1
        set soundopt "<audio silent=\"false\" src=\"ms-winsoundevent:Notification.Default\" />"
    else
        set soundopt "<audio silent=\"true\" />"
    end

    __done_run_powershell_script "
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
[Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null

\$toast_xml_source = @\"
    <toast>
        $soundopt
        <visual>
            <binding template=\"ToastText02\">
                <text id=\"1\">$title</text>
                <text id=\"2\">$message</text>
            </binding>
        </visual>
    </toast>
\"@

\$toast_xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$toast_xml.loadXml(\$toast_xml_source)

\$toast = New-Object Windows.UI.Notifications.ToastNotification \$toast_xml

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(\"fish\").Show(\$toast)
"
end

function __done_get_focused_window_id
    if type -q lsappinfo
        lsappinfo info -only bundleID (lsappinfo front) | cut -d '"' -f4
    else if test -n "$SWAYSOCK"
        and type -q jq
        swaymsg --type get_tree | jq '.. | objects | select(.focused == true) | .id'
    else if begin
            test "$XDG_SESSION_DESKTOP" = gnome; and type -q gdbus
        end
        gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval 'global.display.focus_window.get_id()'
    else if type -q xprop
        and test -n "$DISPLAY"
        # Test that the X server at $DISPLAY is running
        and xprop -grammar >/dev/null 2>&1
        xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2
    else if uname -a | string match --quiet --ignore-case --regex microsoft
        __done_run_powershell_script '
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class WindowsCompat {
        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();
    }
"@
[WindowsCompat]::GetForegroundWindow()
'
    else if set -q __done_allow_nongraphical
        echo 12345 # dummy value
    end
end

function __done_is_tmux_window_active
    set -q fish_pid; or set -l fish_pid %self

    # find the outermost process within tmux
    # ppid != "tmux" -> pid = ppid
    # ppid == "tmux" -> break
    set tmux_fish_pid $fish_pid
    while set tmux_fish_ppid (ps -o ppid= -p $tmux_fish_pid | string trim)
        and ! string match -q "tmux*" (basename (ps -o exe= -p $tmux_fish_ppid))
        set tmux_fish_pid $tmux_fish_ppid
    end

    # tmux session attached and window is active -> no notification
    # all other combinations -> send notification
    tmux list-panes -a -F "#{session_attached} #{window_active} #{pane_pid}" | string match -q "1 1 $tmux_fish_pid"
end

function __done_is_screen_window_active
    string match --quiet --regex "$STY\s+\(Attached" (screen -ls)
end

function __done_is_process_window_focused
    # Return false if the window is not focused

    if set -q __done_allow_nongraphical
        return 1
    end

    set __done_focused_window_id (__done_get_focused_window_id)
    if test "$__done_sway_ignore_visible" -eq 1
        and test -n "$SWAYSOCK"
        string match --quiet --regex "^true" (swaymsg -t get_tree | jq ".. | objects | select(.id == "$__done_initial_window_id") | .visible")
        return $status
    else if test "$__done_initial_window_id" != "$__done_focused_window_id"
        return 1
    end
    # If inside a tmux session, check if the tmux window is focused
    if type -q tmux
        and test -n "$TMUX"
        __done_is_tmux_window_active
        return $status
    end

    # If inside a screen session, check if the screen window is focused
    if type -q screen
        and test -n "$STY"
        __done_is_screen_window_active
        return $status
    end

    return 0
end

function __done_humanize_duration -a milliseconds
    set -l seconds (math --scale=0 "$milliseconds/1000" % 60)
    set -l minutes (math --scale=0 "$milliseconds/60000" % 60)
    set -l hours (math --scale=0 "$milliseconds/3600000")

    if test $hours -gt 0
        printf '%s' $hours'h '
    end
    if test $minutes -gt 0
        printf '%s' $minutes'm '
    end
    if test $seconds -gt 0
        printf '%s' $seconds's'
    end
end

# verify that the system has graphical capabilities before initializing
if test -z "$SSH_CLIENT" # not over ssh
    and count (__done_get_focused_window_id) >/dev/null # is able to get window id
    set __done_enabled
end

if set -q __done_allow_nongraphical
    and set -q __done_notification_command
    set __done_enabled
end

if set -q __done_enabled
    set -g __done_initial_window_id ''
    set -q __done_min_cmd_duration; or set -g __done_min_cmd_duration 5000
    set -q __done_exclude; or set -g __done_exclude 'git (?!push|pull|fetch)'
    set -q __done_notify_sound; or set -g __done_notify_sound 0
    set -q __done_sway_ignore_visible; or set -g __done_sway_ignore_visible 0

    function __done_started --on-event fish_preexec
        set __done_initial_window_id (__done_get_focused_window_id)
    end

    function __done_ended --on-event fish_prompt
        set -l exit_status $status

        # backwards compatibility for fish < v3.0
        set -q cmd_duration; or set -l cmd_duration $CMD_DURATION

        if test $cmd_duration
            and test $cmd_duration -gt $__done_min_cmd_duration # longer than notify_duration
            and not __done_is_process_window_focused # process pane or window not focused
            and not string match -qr $__done_exclude $history[1] # don't notify on git commands which might wait external editor

            # Store duration of last command
            set -l humanized_duration (__done_humanize_duration "$cmd_duration")

            set -l title "Done in $humanized_duration"
            set -l wd (string replace --regex "^$HOME" "~" (pwd))
            set -l message "$wd/ $history[1]"
            set -l sender $__done_initial_window_id

            if test $exit_status -ne 0
                set title "Failed ($exit_status) after $humanized_duration"
            end

            if set -q __done_notification_command
                eval $__done_notification_command
                if test "$__done_notify_sound" -eq 1
                    echo -e "\a" # bell sound
                end
            else if type -q terminal-notifier # https://github.com/julienXX/terminal-notifier
                if test "$__done_notify_sound" -eq 1
                    terminal-notifier -message "$message" -title "$title" -sender "$__done_initial_window_id" -sound default
                else
                    terminal-notifier -message "$message" -title "$title" -sender "$__done_initial_window_id"
                end

            else if type -q osascript # AppleScript
                osascript -e "display notification \"$message\" with title \"$title\""
                if test "$__done_notify_sound" -eq 1
                    echo -e "\a" # bell sound
                end

            else if type -q notify-send # Linux notify-send
                # set urgency to normal
                set -l urgency normal

                # use user-defined urgency if set
                if set -q __done_notification_urgency_level
                    set urgency "$__done_notification_urgency_level"
                end
                # override user-defined urgency level if non-zero exitstatus
                if test $exit_status -ne 0
                    set urgency critical
                    if set -q __done_notification_urgency_level_failure
                        set urgency "$__done_notification_urgency_level_failure"
                    end
                end

                notify-send --hint=int:transient:1 --urgency=$urgency --icon=utilities-terminal --app-name=fish "$title" "$message"

                if test "$__done_notify_sound" -eq 1
                    echo -e "\a" # bell sound
                end

            else if type -q notify-desktop # Linux notify-desktop
                set -l urgency
                if test $exit_status -ne 0
                    set urgency "--urgency=critical"
                end
                notify-desktop $urgency --icon=utilities-terminal --app-name=fish "$title" "$message"
                if test "$__done_notify_sound" -eq 1
                    echo -e "\a" # bell sound
                end

            else if uname -a | string match --quiet --ignore-case --regex microsoft
                __done_windows_notification "$title" "$message"

            else # anything else
                echo -e "\a" # bell sound
            end

        end
    end
end

function __done_uninstall -e done_uninstall
    # Erase all __done_* functions
    functions -e __done_ended
    functions -e __done_started
    functions -e __done_get_focused_window_id
    functions -e __done_is_tmux_window_active
    functions -e __done_is_screen_window_active
    functions -e __done_is_process_window_focused
    functions -e __done_windows_notification
    functions -e __done_run_powershell_script
    functions -e __done_humanize_duration

    # Erase __done variables
    set -e __done_version
end
