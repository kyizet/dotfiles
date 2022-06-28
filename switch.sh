#!/usr/bin/bash

# DIRS
DIR=`pwd`
DIR_bspwm="$HOME/.config/bspwm"
DIR_sxhkd="$HOME/.config/sxhkd"
DIR_polybar="$HOME/.config/polybar"
DIR_rofi="$HOME/.config/rofi"
DIR_picom="$HOME/.config/picom"
DIR_wallpaper="$HOME/Pictures/Wallpapers"
DIR_nmdmenu="$HOME/.config/networkmanager-dmenu"
DIR_chrome="" ### Can't be set without setting the chrome_profile value first

### Vars
themes=()
set_theme=""
chrome_profile=""

#spinner
spinner=('-' '\' '|' '/')

### Functions
spinner() {
	while [ 1 ]
	do
		for spin in ${spinner[@]}
		do
			echo -en "\r[$spin]"
			sleep .1
		done
	done
}

copy_config(){
	if [[ -d $1 ]]
	then
		echo -e "\r[+] Copying $2 configs"
		cp -r $3/* "$1"
	else
		echo -e "\r[-] $2 config directory not found" 
		echo -e "\r[+] Creating one and copying"
		mkdir -p $1
		cp -r $3/* "$1"
	fi
}

#Switch themes
switch_theme() {
	cd $set_theme
	if [[ -e . ]];
	then
		echo "[+] Switching Themes "
		echo "[-------------------]"
		spinner &
		spinner_pid=$!
		for f in *;
		do
			echo -en "\033[2K"
			case $f in
				"bspwm")
					copy_config $DIR_bspwm "bspwm" $f
					;;
				"picom")
					copy_config $DIR_picom "picom" $f
					;;
				"polybar")
					copy_config $DIR_polybar "polybar" $f
					;;
				"rofi")
					copy_config $DIR_rofi "rofi" $f
					;;
				"sxhkd")
					copy_config $DIR_sxhkd "sxhkd" $f
					;;
				"Wallpapers")
					copy_config $DIR_wallpaper "Wallpapers" $f
					;;
				"networkmanager-dmenu")
					copy_config $DIR_nmdmenu "networkmanager-dmenu" $f
					;;
				"chrome")
					copy_config "$DIR_chrome/chrome" "chrome" $f
					;;
				"vim")
					echo -e "\r[+] Copying vimrc configs"
					cp "$f/.vimrc" "$HOME"
					;;
			esac
		done
		kill $spinner_pid
		echo -e "\r[+] Everything copied\n"
	else
		echo "[-] Empty theme"
	fi
}

#show and choose themes
choose_theme(){
	echo "[+] Themes: "
	declare -i i=1
	for dir in *;
	do 
		if [[ -d $dir ]]; then
			themes+=($dir)
			echo "[$i] ${dir^}";
			i+=1;
		fi
	done

	echo ""
	read -p "[?] Choose Theme: " chosen_theme

	if [[ "$chosen_theme" =~ ^[0-9]+$ ]]
	then
		echo -e "[+] You chose ${themes[$chosen_theme-1]^}\n"
		set_theme=${themes[$chosen_theme-1]}
		read -p "[?] Chrome profile name: " chrome_profile
		DIR_chrome="$HOME/.mozilla/firefox/$(grep "$chrome_profile" $HOME/.mozilla/firefox/profiles.ini | grep Path | sed 's/[Path=]\{1,\}//')"
		echo -e "Your chrome profile is at $DIR_chrome\n"
	else
		echo -e "\n[-] Invalid Choice, Exiting\n"
		exit 0
	fi
}

### Some decorations for the start of the program
cat << EOF
/ __| _ __ __ (_)| |_  __ | |_        |_   _|| |_   ___  _ __   ___ 
\__ \ \ V  V /| ||  _|/ _||   \         | |  |   \ / -_)| '  \ / -_)
|___/  \_/\_/ |_| \__|\__||_||_|        |_|  |_||_|\___||_|_|_|\___|
EOF

main() {
	choose_theme
	switch_theme
	if [[ -d $HOME/.vim/bundle/Vundle.vim ]]
	then
		:
	else
		git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	fi
	vim +PluginInstall +qall
	echo "VimPlugins are up to date!"
}

main
