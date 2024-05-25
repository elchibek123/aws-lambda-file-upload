import json
import base64
import boto3


def lambda_handler(event, context):
    s3 = boto3.client("s3")
    get_file_content = event["content"]
    decode_content = base64.b64decode(get_file_content)
    s3_upload = s3.put_object(Bucket="bucket-name", Key="file.pdf", Body=decode_content)

    return {"statusCode": 200, "body": json.dumps("Thanks for using!")}