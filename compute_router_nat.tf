resource "google_compute_router_nat" "my-router-nat" {
  name   = "my-router-nat"
  router = google_compute_router.my_router.name
  region = var.gcp_regions["tokyo"]

  # 自動で外部IPアドレスを取得するモードか、自分で外部IPアドレスを設定するモードが選択する
  # NATの外部IPアドレスは、固定したい用途のが多いと思うので、今回はマニュアルで行う
  nat_ip_allocate_option = "MANUAL_ONLY"
  # 外部IPアドレスは複数設定できる
  # 1つの外部IPアドレスごとに、全ポート数65536から
  # well-knownポートの1024個を差し引いた64512個のポートを利用可能
  # min_ports_per_vmというオプションでVMインスタンスごとに割り振るポート数を指定できる
  nat_ips = [google_compute_address.nat_gateway.self_link]

  # どのサブネットに対して有効にするか設定できるが、
  # 今回はサブネットが1つしかないので全てのサブネットに対して有効にする
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  # CloudLoggingにログを出力したい場合は下のオプションを付与する
  log_config {
    enable = true
    filter = "ALL"
  }
}
