# Certificate Error Scanner

A bash script designed to identify hosts requiring client TLS certificate authentication by detecting SSL/TLS certificate errors during connection attempts.

When a host requires client certificate authentication and you don't provide one, it typically responds with "sslv3 alert bad certificate" error. This script automates the detection of such hosts.

Tool was created during a Live Hacking Event (LHE) for HackerOne (H1-6102)

## How It Works

The script attempts to connect to each host using `curl` and analyzes the SSL/TLS handshake errors. When it detects the "sslv3 alert bad certificate" error, it flags the host as potentially requiring client certificate authentication.

## Usage

1. Create a `hosts.txt` file with your target hosts (one per line):

```
api.example.com:443
secure-endpoint.target.com:8443
# Comments are supported
```

2. Run the script:
```bash
./certificate_scanner.sh
```

3. Check the results in `certificate_check_results.txt`

## Output

The script provides:
- **Console output** with color-coded results:
  - 🔴 Red: Certificate error detected (likely requires client cert)
  - 🟡 Yellow: Other errors detected
  - 🟢 Green: No certificate errors
  
- **Results file** (`certificate_check_results.txt`) containing:
  - Timestamp of the scan
  - Detailed results for each host
  - Relevant error messages for further analysis


