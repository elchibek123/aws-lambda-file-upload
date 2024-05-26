import json
import base64
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    s3 = boto3.client("s3")
    bucket_name = "private-sandbox-us-east-1-s3-bucket-001"
    object_key = "file.pdf"

    try:
        get_file_content = event["content"]
        decode_content = base64.b64decode(get_file_content)
        s3.put_object(Bucket=bucket_name, Key=object_key, Body=decode_content)
        
        return {
            "statusCode": 200,
            "body": json.dumps("Thanks for using!")
        }

    except KeyError:
        return {
            "statusCode": 400,
            "body": json.dumps("The request did not contain 'content' key.")
        }

    except ClientError as e:
        return {
            "statusCode": 500,
            "body": json.dumps(f"An error occurred: {e}")
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps(f"An unexpected error occurred: {e}")
        }
