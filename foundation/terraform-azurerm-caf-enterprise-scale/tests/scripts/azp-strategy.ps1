#!/usr/bin/pwsh

#
# PowerShell Script
# - Generate Azure Pipelines Strategy
#

###############################################
# Configure PSScriptAnalyzer rule suppression.
###############################################

# The following SuppressMessageAttribute entries are used to surpress
# PSScriptAnalyzer tests against known exceptions as per:
# https://github.com/powershell/psscriptanalyzer#suppressing-rules
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required to enable authentication.')]
param ()

$ErrorActionPreference = "Stop"

Write-Information "==> Generating Azure Pipelines Strategy Matrix..." -InformationAction Continue

$jsonDepth = 4
$terraformUrl = "https://api.github.com/repos/hashicorp/terraform/tags"
$azurermProviderUrl = "https://registry.terraform.io/v1/providers/hashicorp/azurerm"

########################################
# Terraform Versions
# - Base Version: "0.13.2"
# - Latest Versions:
#     0.13.* (latest 1)
#     0.14.* (latest 1)
#     0.15.* (latest 1)
########################################

$terraformVersionsResponse = Invoke-RestMethod -Method Get -Uri $terraformUrl -FollowRelLink
$terraformVersionsAll = $terraformVersionsResponse.name -replace "v", ""

$terraformVersions = @("0.13.2")
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.13.\d{1,2}(?!-)" } | Select-Object -First 1
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.14.\d{1,2}(?!-)" } | Select-Object -First 1
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.15.\d{1,2}(?!-)" } | Select-Object -First 1

$terraformVersions = $terraformVersions | Sort-Object

$terraformVersionsCount = $terraformVersions.Count

#######################################
# Terraform AzureRM Provider Versions
# - Base Version: (2.41.0)
# - Latest Versions: (latest 1)
#######################################

$azurermProviderVersionBase = "2.41.0"
$azurermProviderVersionLatest = (Invoke-RestMethod -Method Get -Uri $azurermProviderUrl).version

#######################################
# Generate Subscription Aliases
#######################################

Write-Information "==> Checking for `"Az.Accounts`" PowerShell module..." -InformationAction Continue
if ((Get-Module -ListAvailable "Az.Accounts").Count -eq 0) {
    Install-Module -Name "Az.Accounts" -Force
}
Import-Module -Name "Az.Accounts" -Force

Write-Information "==> Getting Subscription Aliases..." -InformationAction Continue

Write-Verbose "Switching Azure Context using Client ID [$($env:ARM_CLIENT_ID)]."
$Credential = New-Object System.Management.Automation.PSCredential (
    $($env:ARM_CLIENT_ID),
    $($env:ARM_CLIENT_SECRET | ConvertTo-SecureString -AsPlainText -Force)
)
$ctx = Connect-AzAccount `
    -ServicePrincipal `
    -Tenant $($env:ARM_TENANT_ID) `
    -SubscriptionId $($env:ARM_SUBSCRIPTION_ID) `
    -Credential $Credential `
    -WarningAction SilentlyContinue

Write-Information " Successfully authenticated account ($($ctx.Context.Account.Id))." -InformationAction Continue

Write-Verbose "Checking for Subscription Aliases."
$subscriptionAliases = [PSCustomObject]@{}
for ($i = 1; $i -lt (($terraformVersionsCount * 2) + 1); $i++) {
    $alias = "csu-tf-management-$i"
    $aliasesApiVersion = "2020-09-01"
    $requestPath = "/providers/Microsoft.Subscription/aliases/$($alias)?api-version=$($aliasesApiVersion)"
    $requestMethod = "GET"
    $aliasResponse = Invoke-AzRestMethod -Method $requestMethod -Path $requestPath
    if ($aliasResponse.StatusCode -eq "200") {
        $subscriptionId = ($aliasResponse.Content | ConvertFrom-Json).properties.subscriptionId
        Write-Information " Found Subscription Alias ($($alias))." -InformationAction Continue
    }
    else {
        Write-Warning "Unable to find Subscription Alias ($($alias)). Failing back to current Subscription context ($($env:ARM_SUBSCRIPTION_ID))."
        $subscriptionId = $env:ARM_SUBSCRIPTION_ID
    }
    $subscriptionAliases | Add-Member `
        -NotePropertyName "$alias" `
        -NotePropertyValue "$subscriptionId"
}

#############################################################################
# Set a multi-job output variable to control strategy matrix for test jobs.
#############################################################################

Write-Information "==> Building Strategy Matrix..." -InformationAction Continue

$matrixObject = [PSCustomObject]@{}
for ($i = 0; $i -lt $terraformVersionsCount; $i++) {
    $terraformVersion = $terraformVersions[$i]
    $jobId1 = ($i * 2) + 1
    $jobId2 = ($i * 2) + 2
    $jobName1 = "$jobId1. (TF: $terraformVersion, AZ: $azurermProviderVersionBase)"
    $jobName2 = "$jobId2. (TF: $terraformVersion, AZ: $azurermProviderVersionLatest)"
    $matrixObject | Add-Member `
        -NotePropertyName $jobName1 `
        -NotePropertyValue @{
        TF_VERSION                    = $terraformVersion
        TF_AZ_VERSION                 = $azurermProviderVersionBase
        TF_JOB_ID                     = $jobId1
        TF_SUBSCRIPTION_ID_MANAGEMENT = ($subscriptionAliases."csu-tf-management-$jobId1")
    }
    Write-Information " Added job to matrix ($($jobName1))." -InformationAction Continue
    $matrixObject | Add-Member `
        -NotePropertyName $jobName2 `
        -NotePropertyValue @{
        TF_VERSION                    = $terraformVersion
        TF_AZ_VERSION                 = $azurermProviderVersionLatest
        TF_JOB_ID                     = $jobId2
        TF_SUBSCRIPTION_ID_MANAGEMENT = ($subscriptionAliases."csu-tf-management-$jobId2")
    }
    Write-Information " Added job to matrix ($($jobName2))." -InformationAction Continue
}

# Convert PSCustomObject to JSON.
$matrixJsonOutput = $matrixObject | ConvertTo-Json -Depth $jsonDepth -Compress

# Save the matrix value to an output variable for downstream consumption .
Write-Output "##vso[task.setVariable variable=matrix_json;isOutput=true]$matrixJsonOutput"
