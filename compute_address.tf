resource "google_compute_address" "nat_gateway" {
  name   = "nat-gateway"
  region = var.gcp_regions["tokyo"]
}
