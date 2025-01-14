
# ossec.conf
<remote>
    <connection>syslog</connection>
    <port>514</port>
    <protocol>tcp</protocol>
    <allowed-ips>192.168.1.22</allowed-ips>
    <local_ip>172.18.0.2</local_ip>
</remote>

---
# endpoint /etc/rsyslog.conf
# Forward logs from syslog
if $programname == 'syslog' then {
    action(type="omfwd" target="192.168.1.30" port="514" protocol="tcp")
}
& ~

# Forward logs from messages
if $programname == 'messages' then {
    action(type="omfwd" target="192.168.1.30" port="514" protocol="tcp")
}
& ~

# Forward logs from fail.log (requires imfile to monitor it as it's not a direct program source)
if $programname == 'fail' then {
    action(type="omfwd" target="192.168.1.30" port="514" protocol="tcp")
}
& ~

# Forward logs from ufw.log (requires imfile to monitor it as it's not a direct program source)
if $programname == 'ufw' then {
    action(type="omfwd" target="192.168.1.30" port="514" protocol="tcp")
}
& ~
---
imfile: https://chatgpt.com/c/67626206-8f80-800e-94d4-3f970dafb5fe
# 2. Monitor Specific Files with imfile
# For logs like /var/log/fail.log and /var/log/ufw.log that don't have a programname associated with them, you need to use the imfile module to monitor them.

# Add imfile Rules:
# Load the imfile module (if not already loaded):

# conf
# Copy code
# module(load="imfile")  # Load file monitoring module
# Define rules for specific files:

# conf
# Copy code
# # Monitor /var/log/fail.log
# input(type="imfile"
#       File="/var/log/fail.log"
#       Tag="fail"
#       Severity="info"
#       Facility="local1")

# # Monitor /var/log/ufw.log
# input(type="imfile"
#       File="/var/log/ufw.log"
#       Tag="ufw"
#       Severity="info"
#       Facility="local2")

# restart rsyslog
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

# tcpdump
sudo tcpdump -i eth0 udp port 514

# validate rsyslog conf
sudo rsyslogd -N1

#----------------------------------------------------------
# == client setup ==
1. edit /etc/rsyslog.conf
*.* @@<ip>:514

2. restart rsyslog

3. check rsyslog connection/status

# wazuh config update
