param (
    [Parameter(Mandatory=$true, HelpMessage="FQDN and port for Deep Security Manager; ex dsm.example.com:443--")][string]$manager,
    [Parameter(Mandatory=$true, HelpMessage="DeepSecurity Manager Username with api access--")][string]$user,
    [Parameter(Mandatory=$true, HelpMessage="Agent Hostname that should be deactivated--")][string]$agentHostname,
    [Parameter(Mandatory=$false)][string]$tenant
)

##################### Authentication Block Start #####################
$passwordinput = Read-host "Password for Deep Security Manager" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordinput))

[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
$Global:DSMSoapService = New-WebServiceProxy -uri "https://$manager/webservice/Manager?WSDL" -Namespace "DSSOAP" -ErrorAction Stop
$Global:DSM = New-Object DSSOAP.ManagerService
try {
    if (!$tenant) {
        $Global:SID = $DSM.authenticate($user, $password)
        }
    else {
        $Global:SID = $DSM.authenticateTenant($tenant, $user, $password)
        }
}
catch {
    Write-Host "An error occurred during authentication. Verify username and password and try again. `nError returned was: $($_.Exception.Message)"
    exit
}
##################### Authentication Block End #####################


# Search computers list using hostname provided by $agentHostname in param
$output = $DSM.hostRetrieveByName($agentHostname, $SID)

if (!$output.ID) {
	Write-Host "Unable to find hostname.  Please verify that the hostname you entered exists in the DSM console."
}
else {
	Write-Host "Found the following computer object"
	# Ouput hostID of computer object
	$output.ID
	# Output hostname of computer object
	$output.name

	# Deactivate computer object using the hostID provided by $output.ID
	Write-Host "Deactivating computer object"
	$DSM.hostAgentDeactivate($output.ID, $SID)

	# Sleep for 10 seconds
	Write-Host "Sleaping for 10 seconds"
	Start-Sleep -s 10

	# Clear the warnings and errors using the hostID provided by $output.ID	
	Write-Host "Clearing warnings and errors on computer object"
	$DSM.hostClearWarningsErrors($output.ID, $SID)

	Write-Host "Script Complete, logging out"
}

# Log out
$DSM.endSession($SID)
