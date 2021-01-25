provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "site" {
  name     = "pandas-site"
  location = "Central US"
}

resource "azurerm_storage_account" "storeacc" {
  name                     = "pandaspr"
  resource_group_name      = azurerm_resource_group.site.name
  location                 = azurerm_resource_group.site.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  static_website {
    index_document = "index.html"
  }
}
