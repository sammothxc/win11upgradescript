param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

# Configuration
$GroupName = "OIT-TS-Windows11-Upgrade-Available"

# Check if Active Directory module is available
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Clear-Host
    Write-Error "x Active Directory module is not available. Please install RSAT: Active Directory Tools." -ForegroundColor Red
    exit 1
}
[System.Console]::Clear()
Write-Host "$([char]8730) Active Directory module installed" -ForegroundColor Green

# Import AD module
Import-Module ActiveDirectory

# Check if user has permission (can query a known object)
try {
    Get-ADDomain > $null
} catch {
    Clear-Host
    Write-Error "x You do not have permission to query Active Directory. Run with proper privileges." -ForegroundColor Red
    exit 1
}
Write-Host "$([char]8730) Running with priveleges" -ForegroundColor Green

# Try to get the computer object
$Computer = Get-ADComputer -Identity $ComputerName -ErrorAction SilentlyContinue

if (-not $Computer) {
    Clear-Host
    Write-Host "x Computer '$ComputerName' not found in Active Directory." -ForegroundColor Red
    exit 1
}

# Show details and prompt for confirmation
Write-Host "-> Computer Found" -ForegroundColor Yellow
Write-Host " - Name: $($Computer.Name)"
Write-Host " - OU Groups: $($Computer.DistinguishedName)"
Write-Host ""
$confirm = Read-Host "Do you want to add this computer to group '$GroupName'? (y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "x Operation cancelled." -ForegroundColor Red
    exit 0
}

# Add computer to the group
try {
    Add-ADGroupMember -Identity $GroupName -Members $Computer
    Write-Host "$([char]8730) $ComputerName successfully added to group '$GroupName'." -ForegroundColor Green
} catch {
    Write-Error "x Failed to add computer to group. Error: $_" -ForegroundColor Red
}
