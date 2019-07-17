param (
    [Parameter(Mandatory=$true, HelpMessage="FQDN and port for Deep Security Manager; ex dsm.example.com:443--")][string]$manager,
    [Parameter(Mandatory=$true, HelpMessage="DeepSecurity Manager Username with api access--")][string]$user,
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


$systemInformation = $DSM.systemInformationRetrieve($SID)

Write-Host $systemInformation.key


# Log out
$DSM.endSession($SID)
