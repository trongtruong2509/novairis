
# This file contains all the aliases I use in my terminal.

# Aliases for terraform and Terragrunt
alias tf="terraform"
alias tfi="terraform init"
alias tfapp="terraform apply --auto-approve"
alias tfdes="terraform destroy --auto-approve"
alias tfp="terraform plan"

alias tg="terragrunt"
alias tgi="terragrunt init"
alias tgp="terragrunt plan"
alias tga="terragrunt apply -auto-approve"

alias ap="ansible-playbook"

alias k="kubectl"

alias d="docker"
alias dp="docker ps"
alias dc="docker compose"
alias dcup="docker compose up -d"
alias dcdown="docker compose down"

#alias do="--dry-run=client -o yaml"

export do="--dry-run=client -o yaml"