# aks/main.tf

provider "azurerm" {
  features {}
}

module "network" {
  source            = "../TP_Terraform_simplon_network"  # Chemin relatif vers le module réseau
  resource_group_name = "my-aks-rg"
  vnet_name           = "my-aks-vnet"
  subnet_name         = "my-aks-subnet"
  location            = "westeurope"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks-cluster"
  location            = "East US"
  resource_group_name = module.network.resource_group_name
  dns_prefix          = "exampleaksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }
}

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.example.id
}
