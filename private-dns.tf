locals {
  path_to_dns_config = "../dns-config/"
}

resource "azurerm_resource_group" "private_dns" {
  name     = "sandbox-private-dns"
  location = "Brazil South"
}

module "private_zones" {
  source = "./modules/private-dns-zones"
  
  # Here, the module is actually called how many times necessary
  for_each = fileset(local.path_to_dns_config, "*")

  zone_file = each.value
}
