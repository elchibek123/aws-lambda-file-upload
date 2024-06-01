import json
import boto3
import base64


def lambda_handler(event, context):
    s3 = boto3.client('s3')

    bucket_name = event["pathParameters"]["bucket"]
    file_name = event["queryStringParameters"]["file"]

    fileObj = s3.get_object(Bucket=bucket_name, Key=file_name)
    file_content = fileObj["Body"].read()
    
    print(bucket_name, file_name)
    
    return {
        'statusCode': 200,
        'headers': {
            "Content-Type": "application/pdf"
        },
        'body': base64.b64encode(file_content).decode('utf-8'),
        "isBase64Encoded": True
    }