# Get the input parameters
[string]$EmailToAddress = Get-VstsInput -Name emailToAddress
[string]$EmailUsers = Get-VstsInput -Name emailUsers
[string]$EmailCcAddress = Get-VstsInput -Name emailCcAddress
[string]$EmailSubject = Get-VstsInput -Name emailSubject
[string]$EmailBody = Get-VstsInput -Name emailBody

# Print input values
Write-Host "Email To Address = $EmailToAddress"
Write-Host "Email Users      = $EmailUsers"
Write-Host "Email CC Address = $EmailCcAddress"
Write-Host "Email Subject    = $EmailSubject"
Write-Host "Email Body       = $EmailBody"

$pat = "Bearer $env:System_AccessToken"
$collectionUri = $env:System_TeamFoundationCollectionUri
$org = $collectionUri.split("/")[3]
$project = $env:System_TeamProject
$releaseId = $env:RELEASE_RELEASEID

Write-Host "Organization     = $org"
Write-Host "Project          = $project"
Write-Host "Release Id       = $releaseId"

## Get tfsids of users whom to send mail
$mailToUsers = "$EmailToAddress"
$mailToUsersArr = $mailToUsers -split ","
$mailCcUsers = "$EmailCcAddress"
$mailCcUsersArr = $mailCcUsers -split ","

$teamsUrl ="${collectionUri}_apis/projects/${project}/teams?api-version=5.1"
$teamData = Invoke-RestMethod -Uri "$teamsUrl" -Headers @{Authorization = $pat}
$teams = $teamData.value.id

##Get list of members in all teams
$usersArray = @()
foreach($team in $teams) {
    $usrurl = "${collectionUri}_apis/projects/${project}/teams/${team}/members?api-version=5.1"
    $userdata = Invoke-RestMethod -Uri "$usrurl" -Headers @{Authorization = $pat}
    $users = $userdata.value
    foreach($user in $users) {
        $userid = $user.identity.id
        $usermail = $user.identity.uniqueName
        $userrecord = "$userid"+":"+"$usermail"
        $usersArray += $userrecord
    }
}
## filter unique users
$finalUsersArray = $usersArray | sort -Unique
## create final hash of emails and tfsids
$usershash = @{}
for ($i = 0; $i -lt $finalUsersArray.count; $i++) {
    $usershash[$finalUsersArray[$i].split(":")[1]] = $finalUsersArray[$i].split(":")[0]
}
##
## create list of tfsid of mailers
foreach($userEmail in $mailToUsersArr) {
    $toAddresses = $toAddresses +'"'+$usershash[$userEmail]+'",'
}
Write-Host "To addresses    = $toAddresses"
foreach($userEmail in $mailCcUsersArr) {
    $ccAddresses = $ccAddresses +'"'+$usershash[$userEmail]+'",'
}
Write-Host "CC addresses    = $ccAddresses"


Add-Type -AssemblyName System.Web
$uri = "https://${org}.vsrm.visualstudio.com/${project}/_apis/Release/sendmail/${releaseId}?api-version=3.2-preview.1"
$encodedURL = [uri]::EscapeUriString($uri)
#Write-Host "URL              = $encodedURL"

$requestBody =
@"
{
    "senderType":1,
    "to":{"tfsIds":[$toAddresses]},
    "cc":{"tfsIds":[$ccAddresses]},
    "body":"$EmailBody",
    "subject":"$EmailSubject"
}
"@
Try {
    Write-Host "Sending email..."
    Invoke-RestMethod -Uri $encodedURL -Body $requestBody -Method POST -Headers @{Authorization = $pat} -ContentType "application/json"
    Write-Host "Email sent Successfully."
}
Catch {
    $_.Exception
}