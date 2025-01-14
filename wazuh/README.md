
## Agentless setup
To add agentless endpoints that use public key authentication, perform the following steps on the Wazuh server.

Generate a public key with the following command. It saves the public key in /var/ossec/.ssh/id_rsa.pub by default.
```bash
sudo -u wazuh ssh-keygen
```

Run the following command to copy the public key to the monitored endpoint. Replace user@test.com with the username and the hostname or IP address of the agentless endpoint.
```bash
ssh-copy-id -i /var/ossec/.ssh/id_rsa.pub user@test.com
```
Add the endpoint by running the following command on the Wazuh server:

```bash
/var/ossec/agentless/register_host.sh add user@test.com NOPASS
```
The command output must be similar to the following:
```bash
Output
*Host user@test.com added.
```