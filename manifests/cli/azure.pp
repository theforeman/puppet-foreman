# @summary This installs the AzureRM plugin for Hammer CLI
#
class foreman::cli::azure {
  foreman::cli::plugin { 'foreman_azure_rm':
  }
}
