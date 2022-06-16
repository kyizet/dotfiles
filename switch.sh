#!/usr/bin/bash

# DIRS
DIR=`pwd`
DIR_bspwm="$HOME/.config/bspwm/"
DIR_sxhkd="$HOME/.config/sxhkd/"
DIR_polybar="$HOME/.config/polybar/"
DIR_rofi="$HOME/.config/rofi/"
DIR_picom="$HOME/.config/picom/"
DIR_wallpaper="$HOME/Pictures/Wallpapers/"
DIR_nmdmenu="$HOME/.config/networkmanager-dmenu"
DIR_chrome="" ### Can't be set without setting the chrome_profile value first

# Vars
themes=()
set_theme=""
chrome_profile=""

# Switch themes
switch_themes() {
	echo "Hey"
}

cat << EOF
/ __| _ __ __ (_)| |_  __ | |_        |_   _|| |_   ___  _ __   ___ 
\__ \ \ V  V /| ||  _|/ _||   \         | |  |   \ / -_)| '  \ / -_)
|___/  \_/\_/ |_| \__|\__||_||_|        |_|  |_||_|\___||_|_|_|\___|
EOF
echo "[+] Theme: "

declare -i i=1
for dir in *;
	do 
		if [[ -d $dir ]]; then
			themes+=($dir)
			echo "->[$i] ${dir^}";
			i+=1;
		fi
	done

echo ""
read -p "[?] Choose Theme: " chosen_theme
if [[ "$chosen_theme" =~ ^[0-9]+$ ]]
	then
		echo -e "[+] You chose ${themes[$chosen_theme-1]^}\n"
		set_theme=${themes[$chosen_theme-1]}
		cd $set_theme
		read -p "[?] Chrome profile name: " chrome_profile
		DIR_chrome="$HOME/.mozilla/firefox/$(grep "$chrome_profile" $HOME/.mozilla/firefox/profiles.ini | grep Path | sed 's/[=a-zA-z]\{1,\}//')"
else
		echo -e "\n[-] Invalid Choice, Exiting\n"
		fi

if [[ -e . ]];
then
	echo -e "[+] Switching Themes\n"
	for f in *;
	do
			case $f in
				"bspwm")
					echo -e "[+] Copying bspwm config"
					cp -r $f/* "$DIR_bspwm"
					echo -e "[+] Done\n"

				;;
				"picom")
					echo -e "[+] Copying picom config"
					cp -r $f/* "$DIR_picom"
					echo -e "[+] Done\n"
				;;
				"polybar")
					echo -e "[+] Copying polybar config"
					cp -r $f/* "$DIR_polybar"
					echo -e "[+] Done\n"
				;;
				"rofi")
					echo -e "[+] Copying rofi config"
					cp -r $f/* "$DIR_rofi" 
					echo -e "[+] Done\n"
				;;
				"sxhkd")
					echo -e "[+] Copying sxhkd config"
					cp -r $f/* "$DIR_sxhkd"
					echo -e "[+] Done\n"
				;;
				"Wallpapers")
					echo -e "[+] Copying Wallpapers"
					cp -r $f/* "$DIR_wallpaper"
					echo -e "[+] Done\n"
				;;
				"networkmanager-dmenu")
					echo -e "[+] Copying networkmanager-dmenu"
					cp -r $f/* "$DIR_nmdmenu"
					echo -e "[+] Done\n"
				;;
				"chrome")
					echo -e "[+] Copying chrome profile"
					cp -r $f/* "$DIR_chrome/chrome"
					cp -r "$f/user.js" "$DIR_chrome/"
					echo -e "[+] Done\n"
				;;
			esac
	done
else
	echo "[-] Empty theme"
fi
