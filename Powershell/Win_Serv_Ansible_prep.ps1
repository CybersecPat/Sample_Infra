# Ensure the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You need to run this script as an Administrator!"
    exit 1
}

# Install the necessary features (WMF, PowerShell, and WinRM)
Install-WindowsFeature -Name "WindowsPowerShell", "WinRM"

# Set up WinRM to listen for HTTP requests
winrm quickconfig -q

# Configure WinRM to allow basic authentication
winrm set winrm/config/service/auth '@{Basic="true"}'

# Allow unencrypted traffic (not recommended for production environments)
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

# Set up a firewall rule to allow traffic on the WinRM port (5985 for HTTP)
New-NetFirewallRule -Name "Allow WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5985

Write-Output "Windows Server 2022 is now ready to be managed by Ansible!"

#Important Notes:

#This script sets up WinRM to allow unencrypted traffic, which is not recommended for production environments. In a production environment, you should use HTTPS with a valid SSL certificate.
#Basic authentication sends the username and password in clear text. It's recommended to use HTTPS or other secure authentication methods in production.
#Always review and test scripts in a safe environment before applying them to production servers.
#Once the Windows server is set up, you can use Ansible's win_ping module to test connectivity from your Ansible control node: