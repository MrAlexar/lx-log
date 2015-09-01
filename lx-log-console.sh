echo "Start logging. Press Ctrl+C to stop...";
until false;
	do 
		read -s cmd;
		lx-log $cmd;
done