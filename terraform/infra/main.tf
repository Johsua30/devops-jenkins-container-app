provider "azurerm" {
  features {}
  
  subscription_id = "4dc63939-80f6-4f50-bd19-bc605cf2786d"
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Immportamos el resource group
data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

# Creamos el acr
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true 
}

# Creamos un log analytics workspace para almacenar logs
resource "azurerm_log_analytics_workspace" "log" {
  name                = "${var.containerapp_name}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Creamos el ambiente para la app
resource "azurerm_container_app_environment" "env" {
  name                       = "${var.containerapp_name}-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}
