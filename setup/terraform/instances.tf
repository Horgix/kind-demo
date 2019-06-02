resource "scaleway_server" "test-instance" {
  name  = "scw-pcd-kind-demo"
  type  = "DEV1-XL"
  # Ubuntu_Bionic_Beaver
  image = "f974feac-abae-4365-b988-8ec7d1cec10d"

  dynamic_ip_required = true
  tags = [
    "paris-container-day",
    "demo",
    "kind",
  ]
}

output "Scaleway - Instance IP" {
  value = "${scaleway_server.test-instance.public_ip}"
}

output "Scaleway - SSH command" {
  value = "ssh root@${scaleway_server.test-instance.public_ip}"
}
