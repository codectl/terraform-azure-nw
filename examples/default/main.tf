module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "southeastasia"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "storage" {
  source  = "codectl/sa/azure"
  version = "~> 1.0"

  storage = {
    name                = module.naming.storage_account.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
  }
}

module "network" {
  source  = "codectl/vnet/azure"
  version = "~> 1.0"


  vnet = {
    name                = module.naming.virtual_network.name
    address_space       = ["10.18.0.0/16"]
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

    subnets = {
      sn1 = {
        address_prefixes       = ["10.18.1.0/24"]
        network_security_group = {}
      }
    }
  }
}

module "watcher" {
  source  = "codectl/nw/azure"
  version = "~> 1.0"

  watchers = {
    watcher = {
      name                = module.naming.network_watcher.name
      location            = module.rg.groups.demo.location
      resource_group_name = module.rg.groups.demo.name
    }
  }
}
