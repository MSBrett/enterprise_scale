locals {
  import_command       = "Import-Module ADDSDeployment"
  password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
  install_ad_command   = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 60"
  exit_code_hack       = "exit 0"

  powershell_command   = "${local.install_ad_command}; ${local.password_command}; ${local.import_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"


  install_forest     = "Install-WindowsFeature -Name AD-Domain-Services,DNS -IncludeManagementTools; Import-Module ADDSDeployment; $domain = Get-ADDomain -ErrorAction SilentlyContinue;  if ($null -eq $domain) { $password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force;  Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true;  shutdown -r -t 60;  exit 0; } else { write-output 'AD Forest already configured';  exit 0; }"

}