
0. install required packages

1. create instances, install docker

# docker https://docs.docker.com/engine/install/ubuntu/
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

2. instal wazuh app
# deployment: https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html
# agentless: https://documentation.wazuh.com/current/user-manual/capabilities/agentless-monitoring/connection.html

# clone wazuh
git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.2

# enter single-node dir
cd wazuh-docker/single-node

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
sudo docker exec -it single-node-wazuh.manager-1 bash

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


# ============================================================================ #
# AWS Clould 

1. install AWS cli
sudo apt update
sudo apt install unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

2. Config aws profile 
aws configure --profile <profile_name>

3. Update docker compose file to mount aws credentials
# https://documentation.wazuh.com/current/cloud-security/amazon/services/prerequisites/credentials.html


5. aws config cloudwatch logs
# https://documentation.wazuh.com/current/cloud-security/amazon/services/supported-services/cloudwatchlogs.html

<wodle name="aws-s3">
  <disabled>no</disabled>
  <interval>5m</interval>
  <run_on_start>yes</run_on_start>
  <service type="cloudwatchlogs">
    <aws_profile>default</aws_profile>
    <aws_log_groups>/ecs/fapi</aws_log_groups>
    <only_logs_after>2022-JAN-01</only_logs_after>
    <regions>ap-south-1</regions>
  </service>
</wodle>


# describe logs
aws logs describe-log-streams --log-group-name "/aws/lambda/function_ecs_alerts_up_down"

aws logs get-log-events --log-group-name "/aws/lambda/function_ecs_alerts_up_down" --log-stream-name "2024/11/24/[$LATEST]014e986570be40ed8ebe653d70274eaf"


# decoder

<decoder name="medium">
        <prematch>[fapi]\s+</prematch>
</decoder>

<decoder name="medium_child">
    <parent>medium</parent>
    <regex offset="after_parent">^\S+\s+(\w+)\s+(\S+)\s+\S+\s+(\.+)</regex>
    <order>status_info,api_name,message</order>
</decoder>

<decoder name="auth">
        <prematch>[auth]\s+\S+</prematch>
</decoder>

<decoder name="auth_child">
  <parent>auth</parent>
  <regex offset="after_parent">^\s+(\w+)\s+1\s+(\S+)\s+:\s+(\.+)</regex>
  <order>status_info,api_name,message</order>
</decoder>


<group name="custom_rules_example,">
  <rule id="100010" level="3">
    <decoded_as>auth</decoded_as>
    <description>User auth</description>
  </rule>

  <rule id="100011" level="7">
    <if_sid>100010</if_sid>
    <decoded_as>auth</decoded_as>
    <status>ERROR</status>
    <description>User Auth Failed</description>
  </rule>
</group>

#ecs decoder
<decoder name="ecs_decoder">
  <prematch type="osregex">\d\d:\d\d:\d\d.\d+\S\d+ [\S+]</prematch>
</decoder>

<decoder name="ecs_child">
  <parent>ecs_decoder</parent>
  <regex offset="after_parent">^\s+[(\w+)]\s+[\S+]\s+(\w+)\s+\d*\s*(\S+)\s+(\.+)</regex>
  <order>service,status,api_name,description</order>
</decoder>


# rules
<group name="custom_rules_example,">
  <rule id="100010" level="3">
	  <decoded_as>ecs_decoder</decoded_as>
	  <field name="status_info">ERROR</field>
    <description>ECS service error</description>
  </rule>
  
  <rule id="100011" level="6">
    <if_sid>100010</if_sid>
    <field name="service">fapi</field>
    <description>Service fapi has error</description>
  </rule>

  <rule id="100012" level="12">
    <if_sid>100010</if_sid>
    <field name="service">auth</field>
    <description>Service authenication has error</description>
  </rule>
  
  <rule id="100013" level="7">
    <if_sid>100010</if_sid>
    <field name="service">baycredit</field>
    <description>Service baycredit has error</description>
  </rule>
</group>

# log
# 30.11.2024 02:03:52.776+0700 [SpringApplicationShutdownHook] [fapi] [/] ERROR c.f.a.a.p.token.BaseTokenProvider.logout - Error clear token: response code 503


# delete alert indexes
# https://groups.google.com/g/wazuh/c/Jo8ldO6Cwo4
# How to see your indices list:
curl -u admin:SecretPassword https://3.109.128.149:9200/_cat/indices/wazuh-alerts* -k
curl -u admin:SecretPassword -XDELETE https://192.168.1.30:9200/wazuh-alerts-4.x-2024.12.07 -k

# refresh field indexes
https://groups.google.com/g/wazuh/c/hfgJPJj9wJY

# logtest
/var/ossec/bin/wazuh-logtest


# queue
https://documentation.wazuh.com/current/user-manual/agent/agent-management/antiflooding.html
https://groups.google.com/g/wazuh/c/czB6W8mDbFM
https://www.reddit.com/r/Wazuh/comments/1e65yc8/wazuh_agent_queue_flooded/