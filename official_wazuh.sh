# /ecs/auth decoder
<decoder name="ecs_auth_decoder">
    <prematch type="osregex">\d\d:\d\d:\d\d.\d+\S\d+ [\S+]</prematch>
</decoder>


<decoder name="ecs_child">
  <parent>ecs_auth_decoder</parent>
  <regex offset="after_parent">\s+[(\w+)]\s+[(\S+)]\s+(\w+)\s+(\d*)\s*(\S+)\s+(\.+)</regex>
  <order>service,session_id,level,code,class,message</order>
</decoder>

# /ecs/auth rules
<group name="custom_rules,ecs_auth_rules,">
	<rule id="100100" level="0">
		<field name="service">auth</field>
    <decoded_as>ecs_auth_decoder</decoded_as>
    <description>ECS authentication message</description>
  </rule>
  
  <rule id="100102" level="9">
    <if_sid>100100</if_sid>
    <field name="level">INFO</field>
    <field name="message">InvalidTokenException</field>
    <description>ECS authentication ERROR: InvalidTokenException, Token was not recognised</description>
	  </rule>

	  <rule id="100103" level="7">
    <if_sid>100100</if_sid>
    <field name="level">ERROR</field>
    <field name="message">Can't invalidate auth token</field>
    <description>ECS authentication ERROR: Can't invalidate auth token</description>
  </rule>

  <rule id="100104" level="5">
    <if_sid>100100</if_sid>
    <field name="level">INFO</field>
    <field name="message">HttpErrorController.handleError</field>
    <description>ECS authentication ERROR: HttpErrorController.handleError</description>
  </rule>

  <rule id="100105" level="4">
    <if_sid>100100</if_sid>
    <field name="level">WARN</field>
    <description>ECS authentication warning</description>
  </rule>

   <rule id="100106" level="4">
    <if_sid>100100</if_sid>
    <field name="level">WARN</field>
    <field name="message">InvalidGrantException</field>
    <description>ECS authentication warning: InvalidGrantException</description>
  </rule>
</group>


# /api/gateway decoder
<decoder name="aws-api-gateway">
    <prematch >^\d+.\d+.\d+.\d+,\d+/\w+/\d+:\d+:\d+:\d+</prematch>
    <regex type="pcre2">^(\d+.\d+.\d+.\d+),(\d+/\w+/\d+:\d+:\d+:\d+ \+\d+),(\w+),([\$\w\/]+),(HTTP\/\d.\d),(\d+),(\d+),([\w=]+)</regex>
    <order>ip,timestamp,method,resource,protocol,response_code,response_length,request_id</order>
</decoder>

<group name="aws-api-gateway,">
    <!-- Rule for all parsed API Gateway logs -->
    <rule id="100200" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <description>API Gateway log received.</description>
    </rule>

    <!-- Rule for successful API Gateway requests -->
    <rule id="100201" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field type="pcre2" name="response_code">2\d{2}</field>
        <description>Successful API Gateway request.</description>
    </rule>

    <!-- Rule for Client Errors (4xx) in API Gateway requests -->
    <rule id="100202" level="8">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field type="pcre2" name="response_code">4\d{2}</field>
        <description>Client error detected in API Gateway request.</description>
    </rule>

    <!-- Rule for Server Errors (5xx) in API Gateway requests -->
    <rule id="100203" level="10">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field type="pcre2" name="response_code">5\d{2}</field>
        <description>Server error detected in API Gateway request.</description>
    </rule>

    <!-- Rule for Large Responses (Response Length > 1000 Bytes) in API Gateway requests -->
    <rule id="100206" level="6">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field type="pcre2" name="response_length">\d{4,}</field>
        <description>Large response detected in API Gateway request (response size > 1000 bytes).</description>
    </rule>
</group>


 <!-- Rule for Requests Using POST Method in API Gateway requests -->
    <rule id="100204" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field name="method">POST</field>
        <description>API Gateway request using POST method.</description>
    </rule>

    <!-- Rule for Requests Using GET Method in API Gateway requests -->
    <rule id="100205" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <if_sid>100200</if_sid>
        <field type="pcre2" name="method">GET</field>
        <description>API Gateway request using GET method.</description>
    </rule>

43.204.58.124,17/Dec/2024:03:08:25 +0000,POST,$default,HTTP/1.1,200,140,C6muji15hcwEJVw=

43.204.58.124,17/Dec/2024:03:08:25 +0000,POST,$default,HTTP/1.1,400,140,C6muji15hcwEJVw=

43.204.58.124,17/Dec/2024:03:08:25 +0000,POST,$default,HTTP/1.1,530,140,C6muji15hcwEJVw=

43.204.58.124,17/Dec/2024:03:08:25 +0000,POST,$default,HTTP/1.1,200,140444,C6muji15hcwEJVw=


<group name="firewall,">
  <rule id="4100" level="0" overwrite="yes">
    <category>firewall</category>
    <description>Firewall rules grouped.</description>
  </rule>

  <!-- UFW blocked connection attempts -->
  <rule id="100301" level="5">
    <if_sid>4100</if_sid>
    <match>[UFW BLOCK]</match>
    <description>UFW: Connection attempt blocked</description>
  </rule>

  <!-- Multiple connection attempts blocked from same source -->
  <rule id="100302" level="10" frequency="8" timeframe="120">
    <if_matched_sid>100301</if_matched_sid>
    <same_source_ip />
    <description>UFW: Multiple connection attempts blocked from same source IP</description>
    <mitre>
      <id>T1110</id>
      <id>T1046</id>
    </mitre>
  </rule>

  <!-- High number of blocked connections to sensitive ports -->
  <rule id="100303" level="12">
    <if_sid>100301</if_sid>
    <match>DPT=22|DPT=3389|DPT=3306</match>
    <description>UFW: Blocked connection attempt to sensitive port</description>
    <mitre>
      <id>T1021</id>
    </mitre>
  </rule>

  <!-- Port scan detection 
  <rule id="100304" level="10" frequency="8" timeframe="60">
    <if_sid>100301</if_sid>
    <same_source_ip />
    <different_port />
    <description>UFW: Possible port scan detected</description>
    <mitre>
      <id>T1046</id>
    </mitre>
  </rule>
  -->

  <!-- Invalid packets -->
  <rule id="100305" level="6">
    <if_sid>4100</if_sid>
    <match>INVALID|MALFORMED</match>
    <description>UFW: Invalid/malformed packet detected</description>
  </rule>

  <!-- Detect outbound connection attempts -->
  <rule id="100306" level="3">
    <if_sid>4100</if_sid>
    <match>OUT=</match>
    <description>UFW: Outbound connection logged</description>
  </rule>

  <!-- High volume of blocked traffic 
  <rule id="100307" level="10" frequency="15" timeframe="60">
    <if_sid>100301</if_sid>
    <description>UFW: High volume of blocked connections</description>
  </rule>
  -->

    <!-- allow packets -->
  <rule id="100308" level="6">
    <if_sid>4100</if_sid>
    <match>UFW ALLOW</match>
    <description>UFW: allow</description>
  </rule>

  <rule id="100308" level="6">
    <if_sid>4100</if_sid>
    <match>UFW AUDIT</match>
    <description>UFW: audit</description>
  </rule>
</group>

<rule id="4101" level="5" overwrite="yes">
    <if_sid>4100</if_sid>
    <action>UFW DENY</action>
    <options>no_log</options>
    <description>Firewall audit event.</description>
    <group>firewall_drop,pci_dss_1.4,gpg13_4.12,gdpr_IV_35.7.d,hipaa_164.312.a.1,nist_800_53_SC.7,tsc_CC6.7,tsc_CC6.8,</group>
  </rule>

  <rule id="4151" level="10" frequency="18" timeframe="45" ignore="240" overwrite="yes">
    <if_matched_sid>4101</if_matched_sid>
    <same_source_ip />
    <description>Multiple Firewall drop events from same source.</description>
    <group>multiple_drops,pci_dss_1.4,pci_dss_10.6.1,gpg13_4.12,gdpr_IV_35.7.d,hipaa_164.312.a.1,hipaa_164.312.b,nist_800_53_SC.7,nist_800_53_AU.6,tsc_CC6.7,tsc_CC6.8,tsc_CC7.2,tsc_CC7.3,</group>
  </rule>