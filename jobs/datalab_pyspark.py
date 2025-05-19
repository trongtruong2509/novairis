# get input path
!pip install boto3

from pyspark.sql import SparkSession
import boto3
import re

def get_stream_data_path(bucket_name, stream_name):
    # Get SparkSession
    spark = SparkSession.builder.getOrCreate()

    # Extract configurations
    endpoint_url = spark.conf.get("spark.hadoop.fs.s3a.endpoint")
    access_key = spark.conf.get("spark.hadoop.fs.s3a.access.key")
    secret_key = spark.conf.get("spark.hadoop.fs.s3a.secret.key")

    # Configure boto3 client
    s3 = boto3.client(
        's3',
        endpoint_url=endpoint_url,
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
    )

    response = s3.list_objects_v2(Bucket=bucket_name, Prefix=stream_name)

    data_path = ""
    # Check if files exist
    if 'Contents' in response:
        # Regular expression to match the file format
        file_pattern = re.compile(r'^\d{4}_\d{2}_\d{2}_\d+_\d+\.csv$')
        
        for obj in response['Contents']:
            file_name = obj['Key'].split('/')[-1]  # Get the file name
            if file_pattern.match(file_name):
                data_path = f"s3a://{bucket_name}/{stream_name}/{file_name}"
                print(f"Matched file: {file_name}")
                # Do something with the file, e.g., process it or download it
                break
    else:
        print("No files found in the specified prefix.")

    return data_path
# ================================================================

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, from_unixtime, regexp_replace
from pyspark.sql.types import StructType, StructField, StringType, TimestampType, DoubleType

json_schema = StructType([
    StructField("FIPS", StringType(), True),
    StructField("Admin2", StringType(), True),
    StructField("Province_State", StringType(), True),
    StructField("Country_Region", StringType(), True),
    StructField("Last_Update", StringType(), True),
    StructField("Lat", StringType(), True),
    StructField("Long_", StringType(), True),
    StructField("Confirmed", StringType(), True),
    StructField("Deaths", StringType(), True),
    StructField("Recovered", StringType(), True),
    StructField("Active", StringType(), True),
    StructField("Combined_Key", StringType(), True),
    StructField("Incident_Rate", StringType(), True),
    StructField("Case_Fatality_Ratio", StringType(), True)
])

def transform_airbyte_to_delta(input_path, delta_table_path):
    # Read the CSV file
    df = spark.read \
        .option("header", "true") \
        .option("multiline", "true") \
        .option("quote", "\"") \
        .option("escape", "\"") \
        .csv(input_path)
    
    # Clean and parse the JSON data
    # First, remove any escaped quotes in the JSON string
    cleaned_df = df.withColumn("_airbyte_data", regexp_replace("_airbyte_data", "\\\\\"", "\""))
    
    # Parse the JSON data and explode into columns
    # Note: We're not selecting the Airbyte columns here
    parsed_df = cleaned_df.withColumn("parsed_data", from_json(col("_airbyte_data"), json_schema)) \
        .select("parsed_data.*")  # Only select the actual data columns
    
    # Convert numeric strings to appropriate types
    final_df = parsed_df \
        .withColumn("Lat", col("Lat").cast(DoubleType())) \
        .withColumn("Long_", col("Long_").cast(DoubleType())) \
        .withColumn("Confirmed", col("Confirmed").cast(DoubleType())) \
        .withColumn("Deaths", col("Deaths").cast(DoubleType())) \
        .withColumn("Recovered", col("Recovered").cast(DoubleType())) \
        .withColumn("Active", col("Active").cast(DoubleType())) \
        .withColumn("Incident_Rate", col("Incident_Rate").cast(DoubleType())) \
        .withColumn("Case_Fatality_Ratio", col("Case_Fatality_Ratio").cast(DoubleType()))

    # Debug: Show the data at each transformation step
    print("Original Data:")
    df.show(2, truncate=False)
    print("\nCleaned Data:")
    cleaned_df.show(2, truncate=False)
    print("\nParsed Data:")
    parsed_df.show(2, truncate=False)
    print("\nFinal Data:")
    final_df.show(2, truncate=False)
    
    # final_df.write.format("delta").mode("overwrite").save(delta_table_path)
    
    spark.sql(f"""
        CREATE DATABASE IF NOT EXISTS deltadb
        LOCATION '{delta_table_path}/deltadb.db'
        """)
    
    # Drop the existing table if it exists
    spark.sql("DROP TABLE IF EXISTS deltadb.test_covid")
    
    # First, write the data as a managed table
    final_df.write \
        .format("delta") \
        .mode("overwrite") \
        .option("overwriteSchema", "true") \
        .saveAsTable("deltadb.test_covid")
    
    # final_df.write \
    #     .format("delta") \
    #     .mode("overwrite") \
    #     .option("overwriteSchema", "true") \
    #     .save(delta_table_path)

    return final_df

# Example usage
bucket_name="test-raw"
stream_name="12-01-2020.csv"
input_path = get_stream_data_path(bucket_name, stream_name)
processed_data_path = "s3a://processed-data/covid-data"

df = transform_airbyte_to_delta(input_path, processed_data_path)

# Optional: Show the first few rows of transformed data
df.show(5, truncate=False)





spark.sql("create table deltadb.covid_data using delta location 's3a://processed-data/covid-data'")

spark.sql('use deltadb')
spark.sql('show tables').show()

spark.sql('select * from covid_data').show()