#!/bin/bash

# Function to print the usage information
usage() {
  echo "Usage: $0 [-t target] [-p port | -r range] [-f file] [-o output format] [-v verbose] [-T timeout]"
  echo "  -t target     : specify the target hostname or IP address to scan"
  echo "  -p port       : specify a single port to scan"
  echo "  -r range      : specify a range of ports to scan (e.g. 1-65535)"
  echo "  -f file       : specify a file containing a list of targets to scan"
  echo "  -o output     : specify the output format (csv or json)"
  echo "  -v verbose    : print verbose output while scanning"
  echo "  -T timeout    : specify the timeout duration in seconds"
  exit 1
}

# Define the default values
target=""
port=""
range=""
file=""
format="csv"
verbose=0
timeout=10

# Parse the command-line options
while getopts "t:p:r:f:o:v:T:" opt; do
  case $opt in
    t) target="$OPTARG" ;;
    p) port="$OPTARG" ;;
    r) range="$OPTARG" ;;
    f) file="$OPTARG" ;;
    o) format="$OPTARG" ;;
    v) verbose=1 ;;
    T) timeout="$OPTARG" ;;
    \?) usage ;;
  esac
done

# Check if at least one of the target options is specified
if [ -z "$target" ] && [ -z "$file" ]; then
  echo "Error: no target specified"
  usage
fi

# Check if a port or a range is specified
if [ -z "$port" ] && [ -z "$range" ]; then
  echo "Error: no port or range specified"
  usage
fi

# Check if the specified output format is valid
if [ "$format" != "csv" ] && [ "$format" != "json" ]; then
  echo "Error: invalid output format specified"
  usage
fi

# Function to scan a single target and a single port
scan_target_port() {
  local target="$1"
  local port="$2"

  # Check if the port is open using netcat
  if nc -z -w "$timeout" "$target" "$port"; then
    status="open"
  else
    status="closed"
  fi

  # Print the results
  if [ "$verbose" -eq 1 ]; then
    echo "Target: $target"
    echo "Port: $port"
    echo "Status: $status"
    echo ""
  fi

  # Output the results to the specified format
  if [ "$format" == "csv" ]; then
    echo "$target,$port,$status,$service"
  elif [ "$format" == "json" ]; then

    echo "{"
    echo "  \"target\": \"$target\","
    echo "  \"port\": $port,"
    echo "  \"status\": \"$status\","
    echo "}"
  fi
}

# Function to scan a single target and a range of ports
scan_target_range() {
  local target="$1"
  local range="$2"

  IFS='-' read -r start end <<< "$range"

  for port in $(seq "$start" "$end"); do
    scan_target_port "$target" "$port"
  done
}

# Function to scan a list of targets and a single port
scan_list_port() {
  local file="$1"
  local port="$2"

  while IFS= read -r target; do
    scan_target_port "$target" "$port"
  done < "$file"
}



# Function to scan a list of targets and a range of ports
scan_list_range() {
  local file="$1"
  local range="$2"

  while IFS= read -r target; do
    scan_target_range "$target" "$range"
  done < "$file"
}

# Main
if [ -n "$target" ] && [ -n "$port" ]; then
  scan_target_port "$target" "$port"
elif [ -n "$target" ] && [ -n "$range" ]; then
  scan_target_range "$target" "$range"
elif [ -n "$file" ] && [ -n "$port" ]; then
  scan_list_port "$file" "$port"
elif [ -n "$file" ] && [ -n "$range" ]; then
  scan_list_range "$file" "$range"
fi
