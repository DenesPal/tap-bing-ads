Param(
   [string]$ClientId = "db41b09d-6e50-4f4a-90ac-5a99caefb52f"
)
$ErrorActionPreference = "Stop"

$RedirectUri = "https://login.live-int.com/oauth20_desktop.srf"
$RedirectUri = [System.Web.HttpUtility]::UrlEncode($RedirectUri)

Write-Output "Visit the authorization URL, and authorize the app to your account:"
Write-Output "https://login.live-int.com/oauth20_authorize.srf?client_id=$ClientId&scope=bingads.manage&response_type=code&redirect_uri=$RedirectUri&prompt=login"

$url = Read-Host "Grant consent in the browser, and then enter the landing URL here"
$uri = [System.Uri]$url
$queryParams = [System.Web.HttpUtility]::ParseQueryString($uri.Query)
$code = $queryParams["code"]
Write-Output "Code is: $code"

# Get the initial access and refresh tokens.

$response = Invoke-WebRequest https://login.live-int.com/oauth20_token.srf -ContentType application/x-www-form-urlencoded -Method POST -Body "client_id=$ClientId&scope=bingads.manage&code=$code&grant_type=authorization_code&redirect_uri=$RedirectUri"

$oauthTokens = ($response.Content | ConvertFrom-Json)
Write-Output "Access token: " $oauthTokens.access_token
Write-Output "Access token expires in: " $oauthTokens.expires_in
Write-Output "Refresh token: " $oauthTokens.refresh_token

## The access token will expire e.g., after one hour.
## Use the refresh token to get new access and refresh tokens.
#
#$response = Invoke-WebRequest https://login.live-int.com/oauth20_token.srf -ContentType application/x-www-form-urlencoded -Method POST -Body "client_id=$ClientId&scope=bingads.manage&code=$code&grant_type=refresh_token&refresh_token=$($oauthTokens.refresh_token)"
#
#$oauthTokens = ($response.Content | ConvertFrom-Json)
#Write-Output "Access token: " $oauthTokens.access_token
#Write-Output "Access token expires in: " $oauthTokens.expires_in
#Write-Output "Refresh token: " $oauthTokens.refresh_token
