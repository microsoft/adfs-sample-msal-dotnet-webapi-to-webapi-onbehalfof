param([Parameter(Mandatory=$false)][PSCredential]$Credential=$null, [Parameter(Mandatory=$false)][string]$TenantId)
Import-Module AzureAD
$ErrorActionPreference = 'Stop'

Function Cleanup
{
<#
.Description
This function removes the Azure AD applications for the sample. These applications were created by the Configure.ps1 script
#>
   [CmdletBinding()]
    param(
        [Parameter(HelpMessage='Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
        [PSCredential] $Credential,
        [string] $tenantId
    )

   process
   {
    # $tenantId is the Active Directory Tenant. This is a GUID which represents the "Directory ID" of the AzureAD tenant 
    # into which you want to create the apps. Look it up in the Azure portal in the "Properties" of the Azure AD. 

    # Login to Azure PowerShell (interactive if credentials are not already provided:
    # you'll need to sign-in with creds enabling your to create apps in the tenant)
    if (!$Credential -and $TenantId)
    {
        $creds = Connect-AzureAD -TenantId $tenantId
    }
    else
    {
        if (!$TenantId)
        {
            $creds = Connect-AzureAD -Credential $Credential
        }
        else
        {
            $creds = Connect-AzureAD -TenantId $tenantId -Credential $Credential
        }
    }

    if (!$tenantId)
    {
        $tenantId = $creds.Tenant.Id
    }
    $tenant = Get-AzureADTenantDetail
    $tenantName =  ($tenant.VerifiedDomains | Where { $_._Default -eq $True }).Name
    
    # Removes the applications
    Write-Host "Cleaning-up applications from tenant '$tenantName'"

    Write-Host "Removing 'service' (TodoListService-OBO) if needed"
    $app=Get-AzureADApplication -Filter "identifierUris/any(uri:uri eq 'https://$tenantName/TodoListService-OBO')"  
    if ($app)
    {
        Remove-AzureADApplication -ObjectId $app.ObjectId
        Write-Host "Removed."
    }

    Write-Host "Removing 'client' (TodoListClient-OBO) if needed"
    $app=Get-AzureADApplication -Filter "DisplayName eq 'TodoListClient-OBO'"  
    if ($app)
    {
        Remove-AzureADApplication -ObjectId $app.ObjectId
        Write-Host "Removed."
    }

    Write-Host "Removing 'spa' (TodoListSPA-OBO) if needed"
    $app=Get-AzureADApplication -Filter "identifierUris/any(uri:uri eq 'https://$tenantName/TodoListSPA-OBO')"  
    if ($app)
    {
        Remove-AzureADApplication -ObjectId $app.ObjectId
        Write-Host "Removed."
    }

   }
}

Cleanup -Credential $Credential -tenantId $TenantId
