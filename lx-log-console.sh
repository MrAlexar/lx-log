echo "Start logging. Press Ctrl+C to stop...";
until false;
	do 
		read cmd;
		lx-log $cmd;
done