
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar


# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.1.3/hadoop-common-3.1.3.jar
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/3.1.0/hadoop-common-3.1.0.jar
# wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar
# wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar
# https://repo1.maven.org/maven2/org/apache/hive/hive-serde/3.1.3/hive-serde-3.1.3.jar
# https://repo1.maven.org/maven2/org/apache/hive/hive-common/3.1.3/hive-common-3.1.3.jar
# https://repo1.maven.org/maven2/org/apache/hive/hive-exec/3.1.3/hive-exec-3.1.3.jar
# https://repo1.maven.org/maven2/org/apache/hive/hive-metastore/3.1.3/hive-metastore-3.1.3.jar

# hadoop
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-runtime/3.3.4/hadoop-client-runtime-3.3.4.jar
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/3.3.4/hadoop-hdfs-3.3.4.jar
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-mapreduce-client-core/3.3.4/hadoop-mapreduce-client-core-3.3.4.jar
# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client/3.3.4/hadoop-client-3.3.4.jar

https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client/3.1.0/hadoop-client-3.1.0.jar
https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-client-runtime/3.1.0/hadoop-client-runtime-3.1.0.jar
https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-yarn-server-web-proxy/3.1.0/hadoop-yarn-server-web-proxy-3.1.0.jar

# https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.1.0/hadoop-aws-3.1.0.jar

# https://github.com/delta-io/delta/releases/download/v3.1.0/delta-hive-assembly_2.12-3.1.0.jar
- ./jars/delta-hive-assembly_2.12-3.1.0.jar:/opt/spark/aux_jars/delta-hive-assembly_2.12-3.1.0.jar
# <property>
#   <name>hive.input.format</name>
#   <value>io.delta.hive.HiveInputFormat</value>
# </property>
# <property>
#   <name>hive.tez.input.format</name>
#   <value>io.delta.hive.HiveInputFormat</value>
# </property>
