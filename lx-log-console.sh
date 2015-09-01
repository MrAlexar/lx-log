echo "Start logging. Press Ctrl+C to stop...";
until false;
	do 
		read -s cmd;
		lx-log $cmd;
		echo "Logged " ${#cmd} " character(s).";
done