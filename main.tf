resource "azurerm_resource_group" "project-rg" {
  name     = "tf-resources"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "project-vn" {
  name                = "tf-network"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "project-sn" {
  name                 = "tf-subnet"
  resource_group_name  = azurerm_resource_group.project-rg.name
  virtual_network_name = azurerm_virtual_network.project-vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "project-sec-g" {
  name                = "tf-security-group"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "project-sec-rule" {
  name                        = "security-rules"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.home_ip_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.project-rg.name
  network_security_group_name = azurerm_network_security_group.project-sec-g.name
}

resource "azurerm_subnet_network_security_group_association" "project-sga" {
  subnet_id                 = azurerm_subnet.project-sn.id
  network_security_group_id = azurerm_network_security_group.project-sec-g.id
}

resource "azurerm_public_ip" "project-pub-ip" {
  name                = "public-ip-address"
  resource_group_name = azurerm_resource_group.project-rg.name
  location            = azurerm_resource_group.project-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "project-interface" {
  name                = "p-network-interface"
  location            = azurerm_resource_group.project-rg.location
  resource_group_name = azurerm_resource_group.project-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.project-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.project-pub-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "project-vm" {
  name                  = "project-virtual-machine"
  resource_group_name   = azurerm_resource_group.project-rg.name
  location              = azurerm_resource_group.project-rg.location
  size                  = var.vm_size
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.project-interface.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/projectazkey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}