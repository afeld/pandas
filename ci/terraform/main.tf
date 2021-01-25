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

resource "azurerm_storage_management_policy" "prs" {
  storage_account_id = azurerm_storage_account.storeacc.id

  # automatically purge old content
  # https://docs.microsoft.com/en-us/azure/storage/blobs/storage-lifecycle-management-concepts?tabs=azure-portal#expire-data-based-on-age
  rule {
    name    = "expirationRule"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 14
      }
    }
  }
}

output "container" {
  value = azurerm_storage_account.storeacc.primary_web_host
}
