import json
import base64
import boto3
import email


def lambda_handler(event, context):
    s3 = boto3.client("s3")

    post_data = base64.b64decode(event["body"])

    try:
        content_type = event["headers"]["Content-Type"]
    except:
        content_type = event["headers"]["content-type"]

    ct = "Content-Type: " + content_type + "\n"

    msg = email.message_from_bytes(ct.encode() + post_data)

    print("Multipart check : ", msg.is_multipart())

    if msg.is_multipart():
        multipart_content = {}
        for part in msg.get_payload():
            if part.get_filename():
                file_name = part.get_filename()
            multipart_content[
                part.get_param("name", header="content-disposition")
            ] = part.get_payload(decode=True)

        file_name = json.loads(multipart_content["Metadata"])["filename"]
        s3_upload = s3.put_object(
            Bucket="bucket-name", Key=file_name, Body=multipart_content["file"]
        )

        return {"statusCode": 200, "body": json.dumps("File uploaded successfully!")}
    else:
        return {"statusCode": 500, "body": json.dumps("Upload failed!")}