

1. create instances, install docker

2. instal wazuh app
# deployment: https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html
# agentless: https://documentation.wazuh.com/current/user-manual/capabilities/agentless-monitoring/connection.html

# clone wazuh
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2

#gen ssl
sudo docker compose -f generate-indexer-certs.yml run --rm generator

# run docker
sudo docker compose up -d

# default credentials for login
# admin and SecretPassword


#========================================================
# in this case: aws pem file is ./test_1.pem

# copy aws pem file to ec2 wazuh
scp -i test_1.pem test_1.pem ubuntu@54.162.128.59:/tmp/test_1.pem

# copy aws pem file to wazuh manager container 
sudo docker cp <source_path> <container_name_or_id>:<destination_path>
sudo docker cp /tmp/test_1.pem 7182826925e4:/tmp/test_1.pem

# wazuh manager container => enter inside container
# change owner of key file
chown 999:999 /tmp/test_1.pem

# install packages
yum install -y util-linux openssh-server openssh-clients vim

# Assign a valid shell
#usermod -s /bin/bash wazuh

#generate ssh keys with path /var/ossec/.ssh/id_rsa
ssh-keygen 

# copy generated key to endpoint 
cat /var/ossec/.ssh/id_rsa.pub | ssh -i /tmp/test_1.pem ubuntu@3.87.26.114 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh'


# Add the endpoint by running the following command on the Wazuh server:
/var/ossec/agentless/register_host.sh add ubuntu@3.87.26.114 NOPASS


# CONFIGURATION

#install expect (root)
yum install -y expect

# change owner of private key
chown -R 999:999 /var/ossec/.ssh/id_rsa

# change owner group of agentless folder
# chown :999 /var/ossec/agentless

# add agentless config to /var/ossec/etc/ossec.conf
<agentless>
  <type>ssh_generic_diff</type>
  <frequency>200</frequency>
  <host>ubuntu@3.87.26.114</host>
  <state>periodic_diff</state>
  <arguments>cat /var/log/nginx/access.log</arguments>
</agentless>

# restart wazuh manager
 /var/ossec/bin/wazuh-control restart

# check logs manager

# When the expect package is present, and Wazuh is restarted, you should see a message similar to the following in the /var/ossec/logs/ossec.log file:
``` 
wazuh-agentlessd: INFO: Test passed for 'ssh_integrity_check_linux'.
```

#When Wazuh has connected to the monitored endpoint, you should see a message similar to the following in the same log file:
```
wazuh-agentlessd: INFO: ssh_integrity_check_linux: user@example_adress.com: Starting.
wazuh-agentlessd: INFO: ssh_integrity_check_linux: user@example_adress.com: Finished.
```

4. check logs in web dashboard
https://documentation.wazuh.com/current/user-manual/capabilities/agentless-monitoring/visualization.html


5. aws config
<wodle name="aws-s3">
  <disabled>no</disabled>
  <interval>5m</interval>
  <run_on_start>yes</run_on_start>
  <service type="cloudwatchlogs">
    <aws_profile>default</aws_profile>
    <aws_log_groups>/ecs/auth</aws_log_groups>
    <only_logs_after>2022-JAN-01</only_logs_after>
    <regions>ap-south-1</regions>
  </service>
</wodle>


# describe logs
aws logs describe-log-streams --log-group-name "/aws/lambda/function_ecs_alerts_up_down"

aws logs get-log-events --log-group-name "/aws/lambda/function_ecs_alerts_up_down" --log-stream-name "2024/11/24/[$LATEST]014e986570be40ed8ebe653d70274eaf"
