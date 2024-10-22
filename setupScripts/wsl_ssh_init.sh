#!/usr/bin/env bash

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	PWSH_PATH=`which pwsh.exe`
	if [ -x "${PWSH_PATH}" ]; then
		WIN_HOMEPATH=$(pwsh.exe -nop -c "echo \$Env:HOMEPATH" | sed -e "s///g" -e "s/\\\\/\//g")
		WIN_HOMEDRIVE=$(pwsh.exe -nop -c "echo \$Env:HOMEDRIVE" | sed -e "s///g" -e "s/://")
	else
		WIN_HOMEPATH=$(powershell.exe -nop -c "echo \$Env:HOMEPATH" | sed )
	fi
	WIN_HOME_MNT_PATH="/mnt/${WIN_HOMEDRIVE,,}${WIN_HOMEPATH}"
	if [ -d "$WIN_HOME_MNT_PATH/.ssh" ] && [ ! -d "$HOME/.ssh" ]; then
		echo ".ssh is found"
		cp --no-preserve=ownership -r "$WIN_HOME_MNT_PATH/.ssh" "$HOME/.ssh"
		chmod 700 "$HOME/.ssh"
		chmod 600 ~/.ssh/*
	fi
else
	echo "not wsl"
fi
