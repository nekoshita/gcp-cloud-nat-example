resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "my_subnetwork" {
  name   = "my-subnetwork"
  region = var.gcp_regions["tokyo"]

  # サブネットで使用したい内部IPアドレスの範囲を指定する
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.my_network.self_link

  # CloudLoggingにFlowLogログを出力したい場合は設定する
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  # GCPのリソースへアクセスする際、VPC内部のリソース（GCEとか）がインターネット回線でなく、
  # Googleの内部ネットワークを通じてアクセスできるようになる
  private_ip_google_access = true
}
