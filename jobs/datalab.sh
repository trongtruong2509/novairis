# ======================== minio ======================== #
# install mc: https://min.io/docs/minio/linux/reference/minio-mc.html
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

# mc stuff
mc alias set myminio http://172.17.0.1:9000 pieter Testpass2024
mc ls myminio

mc cp <file_path> myminio/your-bucket-name/
mc ls myminio/your-bucket-name

# connect deltalake with minio test
raw_data_path = "s3a://test-raw/12-01-2020.csv"
spark.read.option("header", True).csv(raw_data_path).show()

#5. Process Data with Spark: Clean and Transform Data:
df = spark.read.option("header", True).csv(raw_data_path)
df_cleaned = df.filter(df["Confirmed"].isNotNull()) \
               .select("Country_Region", "Last_Update", "Confirmed", "Deaths")
df_cleaned.show()

#Write Transformed Data Back to MinIO: Save as a Delta Lake table.
processed_data_path = "s3a://processed-data/covid-data"
df_cleaned.write.format("delta").mode("overwrite").save(processed_data_path)


# beeline
beeline 
!connect jdbc:hive2://localhost:10000 scott tiger

select * from delta.`s3a://processed-data/covid-data`;

# superset connect
hive://hive@172.17.0.1:10000


# flow

# minio
create buckets:
  - test-raw (landing bucket)
  - processed-data (store delta lake data)

# sftp
upload file to pieter1

# airbyte
- create source
  - user name
  - pass
  - host: IP
  - port: 2022


  https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.27/mysql-connector-java-8.0.27.jar


docker exec -it delta_test-spark-thrift-1 beeline -u jdbc:hive2://localhost:10000

CREATE DATABASE deltadb;
USE deltadb;
CREATE TABLE test_table (id INT, name STRING) USING delta LOCATION 's3a://warehouse/deltadb/test_table';
INSERT INTO test_table VALUES (1, 'test');
SELECT * FROM test_table;


spark.sql("SHOW DATABASES").show()
spark.sql("SHOW TABLES IN deltadb").show()

spark.sql("SELECT * FROM `temp_covid`").show()

# datahub config for ingestion delta lake (minio/s3)
source:
    type: delta-lake
    config:
        base_path: 's3a://processed-data/covid-data'
        s3:
            aws_config:
                aws_access_key_id: pieter
                aws_secret_access_key: Testpass2024
                aws_endpoint_url: 'http://172.17.0.1:9000'
sink:
    type: datahub-rest
    config:
        server: 'http://datahub-gms:8080'
