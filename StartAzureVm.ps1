<#
.DESCRIPTION
    That Powershell Workflow Runbook is used to start Azure VMs from Azure Automation

.NOTES
    Version:                20211026: Initial version
    Author:                 Arnaud Morvillier
    Powershell Version :    5 or higher
#>

workflow StartAzureVm
{
#######################################################################
## Set parameters
#######################################################################    
    Param(
    [string]$ResourceGroupName,
    [string]$VmName
)

#######################################################################
## Set variables
#######################################################################
$subscriptionId = Get-AutomationVariable -Name 'Var_SubscriptionId'
$tenantId = Get-AutomationVariable -Name 'Var_TenantId'
$loggingClientID = Get-AutomationVariable -Name 'Var_DevOps_ClientId'
$loggingSecret = Get-AutomationVariable -Name 'Var_DevOps_SecretId'


#######################################################################
## Authentication to Azure
#######################################################################
$secStringPassword = ConvertTo-SecureString $loggingSecret -AsPlainText -Force
$credObject = New-Object System.Management.Automation.PSCredential ($loggingClientID, $secStringPassword)
Connect-AzAccount -ServicePrincipal -SubscriptionId $subscriptionId -TenantId $tenantId -Credential $credObject


#######################################################################
## Start VM
#######################################################################
$StartVm = Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VmName -ErrorAction Continue
	if ($StartVm.Status -ne 'Succeeded')
		{
			# The VM failed to start, so send notice
        	    Write-Output ($VmName + " failed to start.")
        	    Write-Error ($VmName + " failed to start. Error was:") -ErrorAction Continue
				Write-Error (ConvertTo-Json $StartVm.Error) -ErrorAction Continue
		}
		else
		{
			# The VM is started 
				Write-Output ($VmName + " has been started.")
		}
}
