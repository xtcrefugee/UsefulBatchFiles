#!/bin/sh
dialogval=$(kdialog --yesnocancel "Enable or disable SMT on the CPU.\nSMT is currently `cat /sys/devices/system/cpu/smt/control`.\n" --yes-label "Enable SMT" --no-label "Disable SMT")
dialogval=$?
if [ $dialogval -eq 0 ]; then
  #enable
  ./smtctl.sh -s on
elif [ $dialogval -eq 1 ]; then
  #disable
  ./smtctl.sh -s off
fi
