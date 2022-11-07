$user = [Security.Principal.WindowsIdentity]::GetCurrent();
$isadmin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
if (!($isadmin))
    {
        Write-Host Please run this script in an Admin session
    } 
else 
    {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        choco install -y virtualbox
        choco install -y wireshark
        choco install -y winpcap
    }