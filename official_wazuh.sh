# /ecs/auth decoder
<decoder name="ecs_auth_decoder">
    <prematch type="osregex">\d\d:\d\d:\d\d.\d+\S\d+ [\S+]</prematch>
</decoder>

<decoder name="ecs_child">
  <parent>ecs_auth_decoder</parent>
  <regex >^(\d+-\d+-\d+) (\d\d:\d\d:\d\d.\d+\S\d+)\s[(\S+)]\s+[(\w+)]\s+[(\S+)]\s+(\w+)\s+(\d*)\s*(\S+)\s+(\.+)</regex>
  <order>timestamp.date,timestamp.time,thread,service,session_id,level,code,class,message</order>
</decoder>

# /ecs/auth rules
<group name="custom_rules,ecs_auth_rules,">
	<rule id="100100" level="3">
		<field name="service">auth</field>
    <decoded_as>ecs_auth_decoder</decoded_as>
    <description>ECS authentication message</description>
  </rule>
  
  <rule id="100101" level="3">
    <decoded_as>ecs_auth_decoder</decoded_as>
    <if_sid>100100</if_sid>
    <field name="level" negate="no" >INFO</field>
    <description>ECS authentication message information</description>
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
        <field type="pcre2" name="response_code">2\d{2}</field>
        <description>Successful API Gateway request.</description>
    </rule>

    <!-- Rule for Client Errors (4xx) in API Gateway requests -->
    <rule id="100202" level="8">
        <decoded_as>aws-api-gateway</decoded_as>
        <field type="pcre2" name="response_code">4\d{2}</field>
        <description>Client error detected in API Gateway request.</description>
    </rule>

    <!-- Rule for Server Errors (5xx) in API Gateway requests -->
    <rule id="100203" level="10">
        <decoded_as>aws-api-gateway</decoded_as>
        <field type="pcre2" name="response_code">5\d{2}</field>
        <description>Server error detected in API Gateway request.</description>
    </rule>

    <!-- Rule for Requests Using POST Method in API Gateway requests -->
    <rule id="100204" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <field name="method">POST</field>
        <description>API Gateway request using POST method.</description>
    </rule>

    <!-- Rule for Requests Using GET Method in API Gateway requests -->
    <rule id="100205" level="5">
        <decoded_as>aws-api-gateway</decoded_as>
        <field type="pcre2" name="method">GET</field>
        <description>API Gateway request using GET method.</description>
    </rule>

    <!-- Rule for Large Responses (Response Length > 1000 Bytes) in API Gateway requests -->
    <rule id="100206" level="6">
        <decoded_as>aws-api-gateway</decoded_as>
        <field type="pcre2" name="response_length">\d{4,}</field>
        <description>Large response detected in API Gateway request (response size > 1000 bytes).</description>
    </rule>
</group>
