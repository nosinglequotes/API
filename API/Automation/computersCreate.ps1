param (
  [Parameter(Mandatory=$true, HelpMessage="FQDN and port for Deep Security Manager; ex dsm.example.com:443--")][string]$manager,
  [Parameter(Mandatory=$true, HelpMessage="DeepSecurity Manager API Key")][string]$apikey
)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$endPoint = "computers"

$url = "https://$manager/api/$endPoint"

$headers = @{
  "api-version" = "v1"
  "api-secret-key" = $apikey
}

$hostname = "LinuxServer1"
$displayName = "DisplayName"
$description = "Created By API"

$hash = @{

    "hostName"= $hostname;
    "displayName"= $displayName;
    "description"= $description;
    "groupID"= 0;
    "policyID"= 0;
    "assetImportanceID"= 0;
    "relayListID"= 0

}
$params = $hash | convertto-json

Invoke-WebRequest -Uri $url -Method Post -ContentType "application/json" -Headers $headers -Body $params