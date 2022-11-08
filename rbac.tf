resource "tls_private_key" "rbac" {
  algorithm = "ECDSA"
  rsa_bits = "4096"
}

resource "tls_cert_request" "rbac" {
  key_algorithm   = "ECDSA"
  private_key_pem = tls_private_key.rbac.private_key_pem

  subject {
    common_name  = var.rbac_admin_user
    organization = var.rbac_admin_org
  }
}


resource "null_resource" "rbac" {
  triggers = {
    tls_cert_request = tls_cert_request.rbac.cert_request_pem
  }
    provisioner "local-exec" {
          command = "./rbac.sh ${base64encode(tls_cert_request.rbac.cert_request_pem)} ${format("%s-authentication",var.rbac_admin_user)}"
  }
