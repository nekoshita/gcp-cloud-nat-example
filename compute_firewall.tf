resource "google_compute_firewall" "enable_access_from_internet" {
  name    = "enable-access-from-internet-firewall"
  network = google_compute_network.my_network.name

  direction = "INGRESS"

  # 通信を許可するprotocolとportを指定する
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # 対象のVMインスタンスのタグを指定する
  target_tags = ["enable-access-from-internet"]

  # アクセスを許可するIPアドレス範囲を指定する
  # とりあえず動けばいいので、全てのIPアドレス範囲からアクセスを許可することにする
  source_ranges = ["0.0.0.0/0"]

  # CloudLoggingにFlowLogログを出力したい場合は設定する
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "enable_access_from_my_subnetwork" {
  name    = "my-subnetwork-firewall"
  network = google_compute_network.my_network.name

  direction = "INGRESS"

  # 通信を許可するprotocolとportを指定する
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # 対象のVMインスタンスのタグを指定する
  target_tags = ["enable-access-from-my-subnetwork"]

  # アクセスを許可するIPアドレス範囲を指定する
  # 今回はmy_subnetwork内からのアクセスを許可したいので、my_subnetworkのIPアドレス範囲を指定する
  source_ranges = [google_compute_subnetwork.my_subnetwork.ip_cidr_range]

  # CloudLoggingにFlowLogログを出力したい場合は設定する
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
