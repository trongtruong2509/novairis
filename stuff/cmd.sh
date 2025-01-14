
# nginx access and error logs file

# net stats
apt install net-tools
netstat -lptun


ssh-keygen -t rsa -b 4096 -f ~/.ssh/do_ansible_key -C "devopsuwp@gmail.com"

#To start the SSH agent, you can run the following commands:
#1. **Start the SSH agent**:
#This command will start the agent and output its process ID.

  eval "$(ssh-agent -s)"

#2. **Add your SSH key** (if not already added):
# Replace `your_private_key` with the filename of your private key (typically `id_rsa` or `id_ed25519`).

  ssh-add ~/.ssh/your_private_key

# You should now be able to use your SSH key for connections without needing to enter the passphrase every time. Let me know if you need any more help with SSH setup!

# Start SSH agent if not running
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Add your key if not added
ssh-add -l &>/dev/null || ssh-add ~/.ssh/do_ansible_key

# change group
sudo chown $(whoami):$(whoami) docker-compose.yml

# find files with given name
sudo find / -type f -name "filename"

# see uid
 id -u <username>

# basic check
nc -zv <IP> <port>

# check with ssl
openssl s_client -connect 139.59.237.252:10001