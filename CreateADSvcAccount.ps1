#===================================#
# AUTHOR:  Daniel Örneling 			#
# DATE:    30/11/2015				#
# SCRIPT:  CreateADSvcAccount.ps1	#
# Version: 1.0						#
#===================================#
		param (
		[Parameter(Mandatory=$true)]
			[string] $system,
			
		[Parameter(Mandatory=$true)]
			[string] $function	
	)

$account = $system + $function
$newaccount = $account + "_Svc"

<#
Generate a secure password
#>

$characters = 'abcdefghkmnprstuvwxyzABCDEFGHKLMNPRSTUVWXYZ'
$nonchar = '123456789!$%&?+#@'
$length = 12  #The total length will be 14, the last two characters are nonchar.

<# 
select random characters
#>

$random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
$random2 = 1..2 | ForEach-Object { Get-Random -Maximum $nonchar.length }

$private:ofs= "" 
$password = [String]$characters[$random] + [String]$nonchar[$random2]

<#
Create the account
#>

$displayname = $system + " " + $function + " Service account"
	$SamAccountName = $system + $function + "_Svc"
	$UserPrincipalName = $account + "_Svc" + "@Yourdomain.xx" #Insert your own domain here
    $AccountPassword = ConvertTo-SecureString $Password -AsPlainText -Force

	 New-ADUser -SamAccountName $SamAccountName `
	-UserPrincipalName $UserPrincipalName `
	-DisplayName $displayname `
	-givenname $system `
	-name $displayname `
	-surname $function `
	-ChangePasswordAtLogon:$False `
	-Description "This service account was created using Azure Automation in OMS. " `
	-path "OU=Users,OU=Orneling,DC=Orneling,DC=Intra" ` #Change this OU to match your needs
    -AccountPassword $AccountPassword `
    -Enabled:$True `
    -PasswordNeverExpires $True
    
Write-Output "The account created is $($newaccount) with the password $($password)"