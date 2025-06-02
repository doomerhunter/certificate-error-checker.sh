#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# File containing list of hosts (one per line)
HOSTS_FILE="hosts.txt"

# Output file for results
RESULTS_FILE="certificate_check_results.txt"

# Check if hosts file exists
if [ ! -f "$HOSTS_FILE" ]; then
    echo -e "${RED}Error: Hosts file '$HOSTS_FILE' not found.${NC}"
    echo "Please create this file with one host per line (format: hostname:port)"
    echo "Example: target.com:443"
    exit 1
fi

# Clear previous results
echo "Certificate Check Results - $(date)" > "$RESULTS_FILE"
echo "=======================================" >> "$RESULTS_FILE"

# Process each host
while IFS= read -r host || [[ -n "$host" ]]; do
    # Skip empty lines and comments
    [[ -z "$host" || "$host" =~ ^# ]] && continue
    
    echo -e "${YELLOW}Checking $host...${NC}"
    
    # Run curl with verbose output and capture it
    output=$(curl -m 3 -vvv "https://$host" 2>&1)
    
    # Check for the specific certificate error
    if echo "$output" | grep -q "sslv3 alert bad certificate"; then
        echo -e "${RED}✗ Certificate error detected for $host${NC}"
        echo "✗ $host - Certificate error detected" >> "$RESULTS_FILE"
        echo "$output" | grep -E "SSL|TLS|certificate|error" >> "$RESULTS_FILE"
        echo "----------------------------------------" >> "$RESULTS_FILE"
    else
        # Check if there were other errors
        if echo "$output" | grep -q "error"; then
            echo -e "${YELLOW}⚠ Other error detected for $host${NC}"
            echo "⚠ $host - Other error detected" >> "$RESULTS_FILE"
            echo "$output" | grep -E "error|SSL|TLS" >> "$RESULTS_FILE"
            echo "----------------------------------------" >> "$RESULTS_FILE"
        else
            echo -e "${GREEN}✓ No certificate errors for $host${NC}"
            echo "✓ $host - No certificate errors" >> "$RESULTS_FILE"
        fi
    fi
    
    echo ""
done < "$HOSTS_FILE"

echo -e "${GREEN}Certificate check completed. Results saved to $RESULTS_FILE${NC}"
