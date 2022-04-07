# Get the input parameters
[string]$EmailToAddress = Get-VstsInput -Name emailToAddress
[string]$EmailCcAddress = Get-VstsInput -Name emailCcAddress
[string]$EmailSubject = Get-VstsInput -Name emailSubject
[string]$EmailBody = Get-VstsInput -Name emailBody

$pat = "Bearer $env:System_AccessToken"

Add-Type -AssemblyName System.Web
$org = $(System.TeamFoundationCollectionUri).split("/")[3]
$uri = "https://${org}.vsrm.visualstudio.com/$(System.TeamProject)/_apis/Release/sendmail/$(RELEASE.RELEASEID)?api-version=3.2-preview.1"
$encodedURL = [uri]::EscapeUriString($uri)

$requestBody =
@"
{
    "senderType":1,
    "to":"$EmailToAddress",
    "cc":"$EmailCcAddress",
    "body":"$EmailBody",
    "subject":"$EmailSubject"
}
"@
Try {
    Invoke-RestMethod -Uri $encodedURL -Body $requestBody -Method POST -Headers @{Authorization = $pat} -ContentType "application/json"
}
Catch {
    $_.Exception
}