import json
import base64
import boto3


def lambda_handler(event, context):
    s3 = boto3.client("s3")
    bucket_name = event["pathParameters"]["bucket"]
    file_name = event["queryStringParameters"]["file"]
    bucket_name = event["params"]["path"]["bucket"]
    file_name = event["params"]["querystring"]["file"]

    URL = s3.generate_presigned_url(
        "get_object", Params={"Bucket": bucket_name, "Key": file_name}, ExpiresIn=3600
    )

    # URL = s3.generate_presigned_post(
    #     Bucket=bucket_name, Key=file_name, Fields=None, Conditions=None, ExpiresIn=3600
    # )

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"URL": URL}),
    }