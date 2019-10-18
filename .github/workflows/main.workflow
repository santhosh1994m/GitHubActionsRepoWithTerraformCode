workflow "Terraform" {
  resolves = "terraform-plan"
  on = "push"
}

action "filter-to-pr-open-synced" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|synchronize'"
}

action "terraform-fmt" {
  uses = "hashicorp/terraform-github-actions/fmt@v4.5"
  needs = "filter-to-pr-open-synced"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-init" {
  uses = "hashicorp/terraform-github-actions/init@v4.5"
  needs = "terraform-fmt"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-validate" {
  uses = "hashicorp/terraform-github-actions/validate@v4.5"
  needs = "terraform-init"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
  }
}

action "terraform-plan" {
  uses = "hashicorp/terraform-github-actions/plan@v4.5"
  needs = "terraform-validate"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
    # If you're using Terraform workspaces, set this to the workspace name.
    TF_ACTION_WORKSPACE = "default"
  }
}

action "terraform-apply" {
  uses = "hashicorp/terraform-github-actions/plan@v4.5"
  needs = "terraform-paln"
  secrets = ["GITHUB_TOKEN"]
  env = {
    TF_ACTION_WORKING_DIR = "."
    # If you're using Terraform workspaces, set this to the workspace name.
   
  }
}
