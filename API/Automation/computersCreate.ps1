[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$manager = "app.deepsecurity.trendmicro.com"
$endPoint = "computers"

$apikey = "YOUR_API_KEY"


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