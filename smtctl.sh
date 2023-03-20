#!/bin/sh
export HISTIGNORE='*sudo -S*'
smtopt="none"
rootpw="your_root_password"
while getopts hs: opt; do
  case $opt in
    h)
       echo "Usage: smtctl.sh -s [on/off]"
       echo "SMT is currently `cat /sys/devices/system/cpu/smt/control`"
       exit 0
       ;;
    s) smtopt=$OPTARG
       ;;
  esac
done
if [ $smtopt = "on" ]; then
  sudo -S -v -p '' <<<"$rootpw"
  echo on | sudo tee /sys/devices/system/cpu/smt/control > /dev/null
  echo "SMT is now `cat /sys/devices/system/cpu/smt/control`"
  sudo -k
elif [ $smtopt = "off" ]; then
  sudo -S -v -p '' <<<"$rootpw"
  echo off | sudo tee /sys/devices/system/cpu/smt/control > /dev/null
  echo "SMT is now `cat /sys/devices/system/cpu/smt/control`"
  sudo -k
else
  echo "Invalid option, usage: smtctl.sh -s [on/off]"
  echo "SMT is currently `cat /sys/devices/system/cpu/smt/control`"
fi
unset rootpw
unset HISTIGNORE
