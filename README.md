# Netcat-Scanner

### Author: Edgar Medina. 



## A simple bash script to scan a target or a list of targets for open ports. The script can scan a single port or a range of ports. The script can output the results in CSV or JSON format and provides verbose output.

## Usage

	./netcat-scanner.sh [-t target] [-p port | -r range] [-f file] [-o output format] [-v verbose] [-T timeout]

	Options:

	-t target: specify the target hostname or IP address to scan.
	-p port: specify a single port to scan.
	-r range: specify a range of ports to scan (e.g. 1-65535).
	-f file: specify a file containing a list of targets to scan.
	-o output format: specify the output format (csv or json).
	-v verbose: print verbose output while scanning.
	-T timeout: specify the timeout duration in seconds.

## Examples

# Scan a single target for an open port 80:

bash

	./netcat-scanner.sh  -t example.com -p 80

# Scan a range of ports for an open port on a single target:

bash

	./netcat-scanner.sh  -t example.com -r 1-1024


# Scan a list of targets in a file for an open port 80:

bash

	./netcat-scanner.sh  -f targets.txt -p 80


# Scan a list of targets in a file for a range of ports:

bash

	./netcat-scanner.sh  -f targets.txt -r 1-1024


## Output format

# The script can output the results in CSV or JSON format. The default format is CSV.

## CSV format:


	target,port,status,service
	example.com,80,open,


## JSON format:

	{
	  "target": "example.com",
	  "port": 80,
	  "status": "open",
	}

## Dependencies

# The script requires nc (Netcat) to be installed on your system.
