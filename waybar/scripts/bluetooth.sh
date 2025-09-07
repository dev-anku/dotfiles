!/bin/bash

status=$(bluetoothctl show | grep "Powered: yes")

if [[ "$status" == *"yes"* ]]; then
  bluetoothctl power off
else
  bluetoothctl power on && bluetoothctl connect B4:A1:65:A2:32:4F 
fi

