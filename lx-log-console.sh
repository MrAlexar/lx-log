echo "Start logging. Press Ctrl+C to stop...";
until false;
	do 
		read -s cmd;
		len=${#cmd};
		if [ $len != 0 ]; then
			lx-log $cmd;
			echo "Logged " ${#cmd} " character(s).";
		else
			echo "Null";
		fi
done