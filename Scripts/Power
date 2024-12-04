#!/bin/bash

help () {
  echo 'Syntax: Power <OPTION>'
  echo 'Options:'
  echo '-s, --shutdown'
  echo '-r, --reboot'
  echo '-l, --logout'
  echo '-f, --firmware'
  echo '-h, --help'
}

if [[ "$#" -le 0 ]] || [[ "$#" -gt 1 ]]; then
	printf "\033[0;31mError: Please enter one argument\033[0m\n"
  help
  exit 1
fi

delayedAction () {
  sleep 5
  action
}

common () {
  delayedAction &
  delayedPID=$(echo $!)
  yad --image=dialog-warning --title="${1}?" --button="$1 now":0 --button="Cancel":1 --text="$2 in 5 seconds"

  if [[ "$?" == 0 ]]; then
    action
  else
    kill -SIGTERM $delayedPID
    echo 'Cancelled'
    exit 0
  fi
}

shutdown () {
  action () { systemctl poweroff;}
  common 'Shut down' 'Shutting down'
}

reboot () {
  action () { systemctl reboot;}
  common 'Reboot' 'Rebooting'
}

logoutFunc () {
  action () { hyprctl dispatch exit;}
  common 'Log out' 'Logging out'
}

firmware () {
  action () { systemctl reboot --firmware-setup;}
  common 'Reboot' 'Booting to FW Setup'
}

if [[ "$1" == '-s' ]] || [[ "$1" == '--shutdown' ]]; then
  shutdown
elif [[ "$1" == '-r' ]] || [[ "$1" == '--reboot' ]]; then
  reboot
elif [[ "$1" == '-l' ]] || [[ "$1" == '--logout' ]]; then
  logoutFunc
elif [[ "$1" == '-f' ]] || [[ "$1" == '--firmware' ]]; then
  firmware
else
  if [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
    help
    exit 0
  else
    printf "\033[0;31mError: Invalid argument\033[0m\n"
    help
    exit 1
  fi
fi

exit 0

