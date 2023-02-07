locals {
  # path_to_dns_config = "../dns-config/"
  path_to_dns_config = "../"

  records = yamldecode(file("${local.path_to_dns_config}${var.zone_file}"))
}

data "azurerm_resource_group" "private_dns" {
  name = "sandbox-private-dns"
}

resource "azurerm_private_dns_zone" "this" {
  name                = trimsuffix(var.zone_file, ".yaml")
  resource_group_name = data.azurerm_resource_group.private_dns.name
}

resource "azurerm_private_dns_a_record" "this" {
  for_each = { 
    for k, v in local.records : k => v
    if v.type == "A"
  }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = data.azurerm_resource_group.private_dns.name
  ttl                 = each.value.ttl
  records             = [each.value.value]
}

resource "azurerm_private_dns_cname_record" "example" {
  for_each = { 
    for k, v in local.records : k => v
    if v.type == "CNAME"
  }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = data.azurerm_resource_group.private_dns.name
  ttl                 = each.value.ttl
  record              = each.value.value
}

resource "azurerm_private_dns_txt_record" "example" {
  for_each = { 
    for k, v in local.records : k => v
    if v.type == "TXT"
  }

  name                = each.key
  zone_name           = azurerm_private_dns_zone.this.name
  resource_group_name = data.azurerm_resource_group.private_dns.name
  ttl                 = each.value.ttl

  record {
    value = each.value.value
  }
}
