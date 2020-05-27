#!/usr/bin/env bash

echo "Start logging. Press Ctrl+C to stop...";

echo=false

command=${1:-''}

case "$command" in
  "echo") echo=true;;
  '.') lx-log 'x-starts-at:' $(pwd)
esac

cmd=""
prev_cmd=""
until false;
	do 
		if $echo; then
		  echo -e "> \c"; read cmd;
		else
		  read -s cmd;
		fi
			case "$cmd" in
				"echo")
				echo $prev_cmd;
				echo "> echo";
				;;
				"list")
				less +G $(lx-log --datafile);
				;;
				"clear")
				clear;
				;;
				"date")
				lx-log --date;
				;;
			      'pwd')
				lx-log $(pwd)
				;;
				"exit") echo "Done."; exit;;
				"")
				echo "[Null]";
				;;
				*)
				prev_cmd="$cmd"
				lx-log $cmd;
			len=${#cmd};
				echo "[Logged "${#cmd}" character(s).]";
				;;
			esac
done
