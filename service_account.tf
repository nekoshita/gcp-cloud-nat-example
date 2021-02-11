resource "google_service_account" "bastion" {
  account_id   = "bastion"
  display_name = "My Service Account For Bastion"
}

resource "google_service_account" "my_instance" {
  account_id   = "my-instance"
  display_name = "My Service Account For My Instance"
}
