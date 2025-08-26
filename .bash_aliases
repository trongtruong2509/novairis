
# This file contains all the aliases I use in my terminal.

# ===============================================================================
# TERRAFORM ALIASES
# ===============================================================================
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfv="terraform validate"
alias tff="terraform fmt"
alias tfshow="terraform show"
alias tfout="terraform output"

# Terraform apply aliases
alias tfa="terraform apply"
alias tfapp="terraform apply --auto-approve"

# Terraform destroy aliases  
alias tfd="terraform destroy"
alias tfdes="terraform destroy --auto-approve"

# Terraform workspace management
alias tfw="terraform workspace"
alias tfws="terraform workspace show"
alias tfwl="terraform workspace list"

# ===============================================================================
# TERRAGRUNT ALIASES
# ===============================================================================
alias tg="terragrunt"
alias tgi="terragrunt init"
alias tgp="terragrunt plan"
alias tgv="terragrunt validate"
alias tgf="terragrunt hclfmt"
alias tgshow="terragrunt show"
alias tgout="terragrunt output"

# Terragrunt apply aliases
alias tga="terragrunt apply"
alias tgapp="terragrunt apply --auto-approve"

# Terragrunt destroy aliases
alias tgd="terragrunt destroy"
alias tgdes="terragrunt destroy --auto-approve"

# Terragrunt run-all aliases
alias tgra="terragrunt run-all"
alias tgrap="terragrunt run-all plan"
alias tgraa="terragrunt run-all apply"
alias tgraapp="terragrunt run-all apply --auto-approve"
alias tgrad="terragrunt run-all destroy"
alias tgrades="terragrunt run-all destroy --auto-approve"

# ===============================================================================
# ANSIBLE ALIASES
# ===============================================================================
alias a="ansible"
alias ap="ansible-playbook"
alias apc="ansible-playbook --check"
alias apd="ansible-playbook --diff"
alias apcd="ansible-playbook --check --diff"
alias av="ansible-vault"
alias ave="ansible-vault edit"
alias avd="ansible-vault decrypt"
alias avc="ansible-vault create"
alias ag="ansible-galaxy"
alias agi="ansible-galaxy install"
alias agl="ansible-galaxy list"
alias ac="ansible-config"
alias ai="ansible-inventory"
alias ail="ansible-inventory --list"

# ===============================================================================
# KUBERNETES ALIASES
# ===============================================================================
alias k="kubectl"

# Basic kubectl operations
alias kg="kubectl get"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias ka="kubectl apply"
alias kaf="kubectl apply -f"
alias kdelf="kubectl delete -f"

# Pod operations
alias kgp="kubectl get pods"
alias kgpa="kubectl get pods --all-namespaces"
alias kgpw="kubectl get pods --watch"
alias kdp="kubectl describe pod"
alias kdelp="kubectl delete pod"
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kex="kubectl exec -it"

# Service operations
alias kgs="kubectl get services"
alias kds="kubectl describe service"
alias kdels="kubectl delete service"

# Deployment operations
alias kgd="kubectl get deployments"
alias kdd="kubectl describe deployment"
alias kdeld="kubectl delete deployment"
alias ksd="kubectl scale deployment"
alias krd="kubectl rollout restart deployment"

# Namespace operations
alias kgns="kubectl get namespaces"
alias kns="kubectl config set-context --current --namespace"
alias kcn="kubectl config view --minify | grep namespace"

# ConfigMap and Secret operations
alias kgcm="kubectl get configmaps"
alias kgsec="kubectl get secrets"
alias kdcm="kubectl describe configmap"
alias kdsec="kubectl describe secret"

# Node operations
alias kgno="kubectl get nodes"
alias kdno="kubectl describe node"

# Context operations
alias kctx="kubectl config current-context"
alias kctxs="kubectl config get-contexts"
alias kctxu="kubectl config use-context"

# ===============================================================================
# KUBECTL DRY-RUN EXPORT
# ===============================================================================
export do="--dry-run=client -o yaml"

# ===============================================================================
# GIT ALIASES
# ===============================================================================
alias g="git"

# Basic git operations
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcam="git commit -am"

# Branch operations
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcm="git checkout main"
alias gcd="git checkout develop"

# Remote operations
alias gp="git push"
alias gpo="git push origin"
alias gpom="git push origin main"
alias gpl="git pull"
alias gplo="git pull origin"
alias gplom="git pull origin main"
alias gf="git fetch"
alias gfa="git fetch --all"

# Log and history
alias gl="git log --oneline"
alias gll="git log --oneline -10"
alias glg="git log --graph --oneline --decorate"
alias gls="git log --stat"
alias gsh="git show"

# Diff operations
alias gd="git diff"
alias gdc="git diff --cached"
alias gds="git diff --staged"

# Stash operations
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gsts="git stash show"
alias gstd="git stash drop"

# Reset and clean
alias gr="git reset"
alias grh="git reset --hard"
alias grs="git reset --soft"
alias gcl="git clean -fd"

# Merge and rebase
alias gm="git merge"
alias grb="git rebase"
alias grbi="git rebase -i"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

# Remote management
alias gra="git remote add"
alias grr="git remote remove"
alias grv="git remote -v"

# Add, commit amend and force push
alias gfp="git add . && git commit --amend --no-edit && git push --force"

# ===============================================================================
# DOCKER ALIASES
# ===============================================================================
alias d="docker"
alias dp="docker ps"
alias dc="docker compose"
alias dcup="docker compose up -d"
alias dcdown="docker compose down"