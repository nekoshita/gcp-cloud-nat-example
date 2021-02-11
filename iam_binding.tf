resource "google_project_iam_binding" "access_user" {
  role = google_project_iam_custom_role.my_custom_role.id

  members = [
    "user:${var.allowed_user_mail}",
  ]
}

resource "google_project_iam_binding" "bastion" {
  role = google_project_iam_custom_role.bastion.id

  members = [
    "serviceAccount:${google_service_account.bastion.email}",
  ]
}
