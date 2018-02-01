echo "Start logging. Press Ctrl+C to stop...";

echo=false

[ -n "$1" ] && command=$1

if [ "$command" = "echo" ]
  then
  echo=true
fi

cmd=""
prev_cmd=""
until false;
	do 
		if $echo
		  then
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
