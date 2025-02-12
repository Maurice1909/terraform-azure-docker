output "ip_address" {
  description = "ip address of vm"

  value = azurerm_linux_virtual_machine.project-vm.public_ip_addresses
}
# output = "resource-type" "resource-name" "desired-output"

output "vm_id" {
  description = "Virtual machine ID"
  value       = azurerm_linux_virtual_machine.project-vm.id
}
