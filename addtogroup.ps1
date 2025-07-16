param(
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

# Configuration
$GroupName = "OIT-TS-Windows11-Upgrade-Available"

# Check if Active Directory module is available
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "❌ Active Directory module is not available. Please install RSAT: Active Directory Tools."
    exit 1
}

# Import AD module
Import-Module ActiveDirectory

# Check if user has permission (can query a known object)
try {
    Get-ADDomain > $null
} catch {
    Write-Error "❌ You do not have permission to query Active Directory. Run with proper privileges."
    exit 1
}

# Try to get the computer object
$Computer = Get-ADComputer -Identity $ComputerName -ErrorAction SilentlyContinue

if (-not $Computer) {
    Write-Host "❌ Computer '$ComputerName' not found in Active Directory."
    exit 1
}

# Show details and prompt for confirmation
Write-Host "Found computer:"
Write-Host " - Name: $($Computer.Name)"
Write-Host " - DistinguishedName: $($Computer.DistinguishedName)"
Write-Host ""
$confirm = Read-Host "Do you want to add this computer to group '$GroupName'? (y/n)"

if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "❌ Operation cancelled."
    exit 0
}

# Add computer to the group
try {
    Add-ADGroupMember -Identity $GroupName -Members $Computer
    Write-Host "✅ $ComputerName successfully added to group '$GroupName'."
} catch {
    Write-Error "❌ Failed to add computer to group. Error: $_"
}