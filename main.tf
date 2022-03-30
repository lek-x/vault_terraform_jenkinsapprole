provider "vault" {
token = var.token
address = var.address
}




#resource "vault_auth_backend" "approle" {
#  type = "approle"
#}

data "vault_auth_backend" "get_approle" {
  path = "approle"
}

###Create approle with name jenkins and policy jenkins
resource "vault_approle_auth_backend_role" "jenkins" {
  backend         = data.vault_auth_backend.get_approle.path
  role_name       = "jenkins"
  token_policies  = ["jenkins"]
  #bind_secret_id = false
  token_num_uses = 0
  secret_id_num_uses = 0

}

###Create policy jenkins2
resource "vault_policy" "jenkins" {
  name = "jenkins"

  policy = <<EOT
path "secrets/creds/*" {
 capabilities =["read"]
}

EOT
}

###Mount kv1 engine store
resource "vault_mount" "git" {
  path        = "secrets/"
  type        = "kv"
  description = "Store for github secrets for Jenkins"
}


###Create credentials in kv store
resource "vault_generic_secret" "github_token" {
  path = "secrets/creds/github_t"

  data_json = <<EOT
{
  "password":   "${var.g_token}",
  "username": "lek-x"
}
EOT
}

###Create credentials in kv store
resource "vault_generic_secret" "github_pass" {
  path = "secrets/creds/github_p"

  data_json = <<EOT
{
  "password":  "${var.g_pass}",
  "username": "lek-x"
}
EOT
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = data.vault_auth_backend.get_approle.path
  role_name = vault_approle_auth_backend_role.jenkins.role_name
} 

data "vault_approle_auth_backend_role_id" "role" {
  backend   = "approle"
  role_name = "jenkins"
}

output "role-id" {
  value = vault_approle_auth_backend_role.jenkins.role_id
}



output "secret_id" {
  value = vault_approle_auth_backend_role_secret_id.id
  sensitive = true

}