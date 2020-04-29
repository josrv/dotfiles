#!/usr/bin/env bash

##### Initialization #####

# Create IPC pipe
pipe=/tmp/lemonbar
if [[ ! -p $pipe ]]; then
  mkfifo $pipe
fi

lock=/tmp/lemonbar.lock
exec 200>$lock

# Cleanup tasks
trap "exit" INT TERM
trap "rm -f $pipe" EXIT
trap "kill 0" EXIT 

##### Blocks ######

# Blocks (index number is used in IPS message):
# 0 -- BSPWM workspaces indicator
# 1 -- Clock
# 2 -- VPN status

# BSPWM workspace indicator
#TODO separate reading and formatting
bspwm_workspaces() {
  while read -r line; do
    case $line in
      W*)
        IFS=':'
        set -- ${line#?}
        RESULT=""
        while [ $# -gt 0 ]; do
          item="$1"
          case $item in
            f*)
              # free desktop
              RESULT="$RESULT%{F#a2a5aa}\uf10c %{F-}"
              ;;
            o*)
              # occupied desktop
              RESULT="$RESULT%{F#A2A5AA}\uf111 %{F-}"
              ;;
            O* | F*)
              # focused desktop
              RESULT="$RESULT\uf111 "
              ;;
          esac
          shift
        done
    esac
    echo -e "__0$RESULT" > $pipe & # send an update to the pipe
  done < <(bspc subscribe report)
}

clock() {
  while true
  do
    RESULT="$(date '+%a %d %b %H:%M')"
    echo -e "__1$RESULT" > $pipe & # send an update to the pipe
    sleep 60 
  done
}

#TODO may be abstracted as Runit service status
vpn() {
  while true
  do
    [ $(cat /etc/sv/openvpn/supervise/stat) = "run" ] && RESULT="VPN: up" || RESULT="VPN: down"
    echo -e "__2$RESULT" > $pipe & # send an update to the pipe
    sleep 5
  done
}

##### Block processes #####

bspwm_workspaces &
clock &
vpn &

###### Event loop ######
# Read messages from the pipe and update the bar

while true
do
  if read line <$pipe; then
    #echo "new line: $line"
    case $line in
      __0*)
        bspwm_workspaces=${line:3}
        ;;
      __1*)
        clock=${line:3}
        ;;
      __2*)
        vpn=${line:3}
        ;;
    esac

    echo -e "%{l} $bspwm_workspaces %{r}$vpn %{B#665b5b} $clock %{B-}"
  fi
done

