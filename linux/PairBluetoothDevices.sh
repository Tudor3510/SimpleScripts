#!/bin/bash
echo "The script will remove the mouse and keyboard and will open settings for pairing them again"
echo -n "This will begin in 2 seconds ... press ctrl+c to cancel it"
sleep 1
echo -e "\rThis will begin in 1 second ... press ctrl+c to cancel it "
sleep 1

# Command producing output
command_output=$(bluetoothctl devices)

mouse_address="empty"
keyboard_address="empty"

# Iterate through the lines using a while loop with process substitution
while IFS= read -r line; do
   	if [[ $line == *"Logi M650 L"* ]]; then
  		mouse_address=$(echo "$line" | awk -v word="Device" '{ for(i=1;i<=NF;i++) if($i == word) print $(i+1) }')
  	elif [[ $line == *"Magic Keyboard"* ]]; then
        	keyboard_address=$(echo "$line" | awk -v word="Device" '{ for(i=1;i<=NF;i++) if($i == word) print $(i+1) }')
    	fi
done < <(echo "$command_output")
# Now mouse_address and keyboard_address are accessible outside the while loop



if [ "$mouse_address" != "empty" ]; then
	bluetoothctl remove $mouse_address
fi

if [ "$keyboard_address" != "empty" ]; then
	bluetoothctl remove $keyboard_address
fi


if [ "$mouse_address" != "empty" ]; then
	bluetoothctl remove $mouse_address
fi

if [ "$keyboard_address" != "empty" ]; then
	bluetoothctl remove $keyboard_address
fi

nohup gnome-control-center bluetooth >/dev/null 2>&1 &
sleep 2
