**Powershell Script to add a computer to the `OIT-TS-Windows11-Upgrade-Available` Active Directory group**

Pre-requisites: You need to be logged into YOUR net-id account (local Admin won't work), and [RSAT: Active Directory Services](https://activedirectorypro.com/install-rsat-remote-server-administration-tools-windows-10/) must be installed with Optional Features.

1. Download this script by clicking on the 'addtogroup.ps1' in this github repo, and then click on the download icon on the top right.

2. Open powershell and navigate to where the script was downloaded (don't run powershell as admin, then `cd .\Downloads\` most likely)

3. Run `.\addtogroup.ps1 -ComputerName "COMPUTER-NAME"` (make sure to replace `COMPUTER-NAME` with the actual computer name.

**IF YOU GET AN ERROR SIMILAR TO "RUNNING SCRIPTS IS DISABLED ON THIS SYSTEM":**
1. Run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser`
2. Select `Yes to All`
3. Re-run the script command
