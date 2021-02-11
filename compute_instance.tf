resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "f1-micro"
  zone         = var.gcp_zones["tokyo-a"]

  # Firewallルールやルートの設定のためのタグ名を付与する
  tags = ["enable-access-from-internet"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # my_subnetworkにインスタンスを起動する
    network    = google_compute_network.my_network.name
    subnetwork = google_compute_subnetwork.my_subnetwork.name
    # 踏み台として使うので外部IPアドレスを割り振る
    # 外部IPアドレスを割り振る方法は次の2種類ある。静的外部IPアドレス、エフェメラル外部IPアドレス
    # 今回はエフェメラル外部IPアドレス（インスタンス起動時に発行される外部IPアドレス）を割り振る
    access_config {}
  }

  service_account {
    # https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam
    # インスタンスで完全な cloud-platform アクセス スコープを設定すると、すべての Google Cloud リソースに対する完全アクセス権を付与できる
    # その後、IAM ロールを使用してサービス アカウントの API アクセス権を安全に制限することをGoogleは推奨している
    email  = google_service_account.bastion.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    # 料金を抑えるためにプリエンプティブルにしておく
    preemptible = true
    # プリエンプティブルの場合は下のオプションが必須
    automatic_restart = false
  }
}

resource "google_compute_instance" "my_instance" {
  name         = "my-instance"
  machine_type = "f1-micro"
  zone         = var.gcp_zones["tokyo-a"]

  # Firewallルールやルートの設定のためのタグ名を付与する
  tags = ["enable-access-from-my-subnetwork"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # my_subnetworkにインスタンスを起動する
    network    = google_compute_network.my_network.name
    subnetwork = google_compute_subnetwork.my_subnetwork.name
    # このインスタンスは外部IPアドレスは割り振らないので、access_configはコメントアウトしておく
    # access_config {}
  }

  service_account {
    # https://cloud.google.com/compute/docs/access/service-accounts#accesscopesiam
    # インスタンスで完全な cloud-platform アクセス スコープを設定すると、すべての Google Cloud リソースに対する完全アクセス権を付与できる
    # その後、IAM ロールを使用してサービス アカウントの API アクセス権を安全に制限することをGoogleは推奨している
    email  = google_service_account.my_instance.email
    scopes = ["cloud-platform"]
  }

  scheduling {
    # 料金を抑えるためにプリエンプティブルにしておく
    preemptible = true
    # プリエンプティブルの場合は下のオプションが必須
    automatic_restart = false
  }
}
