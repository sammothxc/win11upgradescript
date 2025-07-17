param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

# Configuration
$GroupName = "OIT-TS-Windows11-Upgrade-Available"

# Check if Active Directory module is available
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "x Active Directory module is not available. Please install RSAT: Active Directory Tools." -ForegroundColor Red
    exit 1
}

# Import AD module
Import-Module ActiveDirectory

# Check if user has permission (can query a known object)
try {
    Get-ADDomain > $null
} catch {
    Write-Error "x You do not have permission to query Active Directory. Run with proper privileges." -ForegroundColor Red
    exit 1
}

# Try to get the computer object
$Computer = Get-ADComputer -Identity $ComputerName -ErrorAction SilentlyContinue

if (-not $Computer) {
    Write-Host "x Computer '$ComputerName' not found in Active Directory." -ForegroundColor Red
    exit 1
}

# Show details and prompt for confirmation
Write-Host "$([char]8730) Found computer:" -ForegroundColor Green
Write-Host " - Name: $($Computer.Name)"
Write-Host " - DistinguishedName: $($Computer.DistinguishedName)"
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
