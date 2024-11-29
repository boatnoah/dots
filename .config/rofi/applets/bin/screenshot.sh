#!/usr/bin/env bash
## Author  : Modified by Human
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="Select an area to screenshot"

# Set window dimensions
list_col='1'
list_row='2'
win_width='400px'

# Options
option_1=" Copy to Clipboard"
option_2=" Save to Screenshots"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2" | rofi_cmd
}

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
screenshots_dir="`xdg-user-dir PICTURES`/Screenshots"
file="Screenshot_${time}_${geometry}.png"



# Temp file for screenshot
temp_file="/tmp/$file"

# Copy screenshot to clipboard
copy_shot() {
	maim -s -b 2 -c 0.35,0.55,0.85,0.25 -l > "$temp_file"
	if [ $? -eq 0 ]; then
		xclip -selection clipboard -t image/png < "$temp_file"
		feh "$temp_file" &
		dunstify -u low --replace=699 "Screenshot Copied to Clipboard"
	else
		dunstify -u low --replace=699 "Screenshot Cancelled"
	fi
}

# Save or delete screenshot
save_or_delete_shot() {
	maim -s -b 2 -c 0.35,0.55,0.85,0.25 -l > "$temp_file"
	if [ $? -eq 0 ]; then
		feh "$temp_file" &
		feh_pid=$!
		
		# Rofi prompt to save or delete (using original theme)
		choice=$(echo -e "Save\nDelete" | rofi -theme-str "window {width: 400px;}" -theme-str "listview {columns: 1; lines: 2;}" -dmenu -p "Save Screenshot" -markup-rows -theme ${theme})
		
		# Kill feh regardless of choice
		kill $feh_pid 2>/dev/null
		
		if [ "$choice" = "Save" ]; then
			cp "$temp_file" "$screenshots_dir/$file"
			dunstify -u low --replace=699 "Screenshot Saved to $screenshots_dir"
		else
			dunstify -u low --replace=699 "Screenshot Deleted"
		fi
		
		# Clean up temp file
		rm "$temp_file"
	else
		dunstify -u low --replace=699 "Screenshot Cancelled"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		copy_shot
        ;;
    $option_2)
		save_or_delete_shot
        ;;
esac
