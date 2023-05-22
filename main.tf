terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.57.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_eventhub_namespace" "example" {
  name                = "PpdTanuEventHubNamespace"
  location            = "centralindia"
  resource_group_name = "azurespandterra"
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Production"
  }
}

resource "azurerm_eventhub" "example" {
  name                = "acceptanceTestEventHub"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = "azurespandterra"
  partition_count     = 2
  message_retention   = 1
}