<wodle name="aws-s3">
    <disabled>no</disabled>
    <interval>5m</interval>
    <run_on_start>yes</run_on_start>
    <service type="cloudwatchlogs">
      <aws_profile>633</aws_profile>
      <aws_log_groups>/aws/guardduty/malware-scan-events</aws_log_groups>
      <only_logs_after>2024-JAN-01</only_logs_after>
      <regions>us-east-1</regions>
    </service>
  </wodle>

aws logs describe-log-streams --log-group-name "/aws/lambda/function_ecs_alerts_up_down"

aws logs get-log-events --log-group-name "/aws/lambda/function_ecs_alerts_up_down" --log-stream-name "2024/11/24/[$LATEST]014e986570be40ed8ebe653d70274eaf"

  "/aws/lambda/function_ecs_alerts_up_down"

  aws logs get-log-record \
    --log-group-name "/aws/lambda/function_ecs_alerts_up_down" \
    --log-stream-name "2024/11/24/[$LATEST]014e986570be40ed8ebe653d70274eaf"

    aws logs filter-log-events \
    --log-group-name "/aws/lambda/function_ecs_alerts_up_down" \
    --filter-pattern "ERROR" \
    --limit 5

    aws logs start-query \
    --log-group-name "/aws/lambda/function_ecs_alerts_up_down" \
    --start-time $(date -d '10 minutes ago' +%s) \
    --end-time $(date +%s) \
    --query-string "fields @timestamp, @message, @ptr | sort @timestamp desc | limit 1"
14
aws logs get-query-results --query-id 4b83eb46-0d74-4870-9171-998024c55401

CoUBCkgKNDgwNjk4NDI2OTM0ODovYXdzL2xhbWJkYS9mdW5jdGlvbl9lY3NfYWxlcnRzX3VwX2Rvd24QASIOCI3Ci+21MhCn/LD0tjISNRoYAgZXdiUaAGZg6/ARx6YABnQ/b5AAAAWiIAEolO/zi7YyMNz184u2MjgWQK8LSIIXUIsNGAAgARAUGAE=

.*\[threadPoolTaskScheduler-\d+\] \[bblpscredit\] \*\*ERROR\*\* \d+ ([^ ]+) : (.*)$


<decoder name="bblpscredit_decoder_example">
    <program_name>bblpscredit_decoder</program_name>
<!-- </decoder> -->
<decoder name="bblpscredit_decoder">
    <prematch>bblpscredit</prematch>
</decoder>
<decoder name="bblpscredit_decoder">
    <parent>bblpscredit_decoder</parent>
    <regex offset="after_parent"> [/] (\w+) 1 ([\w.]+) : (.+)</regex>
    <order>status,src_api,message</order>
</decoder>

<group name="custom_rules_example,">
  <rule id="100001" level="5">
      <program_name>bblpscredit_decoder_example</program_name>
    <description>Error detected in bblpscredit</description>
  </rule>
</group>

# success
<decoder name="medium">
        <prematch>^(\d+-\d+-\d+ \d+:\d+:\d+.\d++\d+) </prematch>
</decoder>

<decoder name="medium_child">
    <parent>medium</parent>
    <regex offset="after_parent">^[threadPoolTaskScheduler-2] [bblpscredit] [/] (\w+) 1 (\.+)</regex>
    <order>status_info,message</order>
</decoder>

<decoder name="fapi">
    <prematch>[fapi]\s+\S+</prematch>
</decoder>

<decoder name="fapi_child">
    <parent>fapi</parent>
    <regex offset="after_parent">^\s+(\w+)\.+</regex>
    <order>status_info</order>
</decoder>


07.12.2024 07:05:06.724+0700 [http-nio-8080-exec-2] [fapi] [eec98aa9-6aa0-4586-842e-3e12000052e0/new] ERROR c.f.controllers.FapiControllerAdvice.handleException - bank.account.not.found

==========================================================================================

<decoder name="auth">
        <prematch>[auth]\s+[\S+]</prematch>
</decoder>

<decoder name="auth_child">
  <parent>auth</parent>
  <regex offset="after_parent">^\s+(\w+)\s+1\s+(\S+)\s+:\s+(\.+)</regex>
  <order>status,api_name,message</order>
</decoder>

<decoder name="fapi">
    <prematch>[fapi]\s+[\S+]</prematch>
</decoder>

<decoder name="fapi_child">
    <parent>fapi</parent>
    <regex offset="after_parent">^\s+(\w+)\s+(\S+)\s+(\.+)</regex>
    <order>status_info,api,message</order>
</decoder>



# auth
06-12-2024 07:28:06.806+0700 [http-nio-8080-exec-3] [auth] [068a3f7e-a78f-409a-8cd6-1ff53d79f735/new]  INFO 1 c.f.auth.security.filter.LoggingFilter.doFilterInternal : SpringSecurity.InternalLogic Request: method=POST path=/oauth/token query='grant_type=password&client_id=cimb_app_stage&client_secret=********&username=cimb_app_stage&password=********' params='{grant_type=[password], client_id=[cimb_app_stage], client_secret=[********], username=[cimb_app_stage], password=[********]}' body='
05-12-2024 17:24:08.407+0700 [SpringApplicationShutdownHook] [auth] [/] ERROR 1 c.f.a.a.p.token.BaseTokenProvider.logout : Can't invalidate auth token: Failed to connect to localhost/127.0.0.1:8080

# api/gateway

# 100201
43.204.58.124,17/Dec/2024:03:08:25 +0000,POST,$default,HTTP/1.1,200,140,C6muji15hcwEJVw=


