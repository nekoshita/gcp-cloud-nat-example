resource "google_compute_router" "my_router" {
  name    = "my-router"
  region = var.gcp_regions["tokyo"]
  network = google_compute_network.my_network.id

  bgp {
    # ローカルASN番号を割り振る
    asn = 64514
    # ルーターの設定をカスタムすることもできるか今回はしない
  }
}
