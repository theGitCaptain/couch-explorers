import base64
import boto3
import json
import os
import random
import uuid

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

BUCKET_NAME = os.environ.get("S3_BUCKET")
CANDIDATE_NUMBER = os.environ.get("CANDIDATE_NUMBER")
MODEL_ID = "amazon.titan-image-generator-v1"

def generate_image(prompt):
    seed = random.randint(0, 2147483647)
    request_payload = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "quality": "standard",
            "cfgScale": 8.0,
            "height": 1024,
            "width": 1024,
            "seed": seed,
        }
    }
    
    response = bedrock_client.invoke_model(modelId=MODEL_ID, body=json.dumps(request_payload))
    model_response = json.loads(response["body"].read())
    
    base64_image_data = model_response["images"][0]
    image_data = base64.b64decode(base64_image_data)
    
    return image_data, seed
    
def upload_image_to_s3(image_data, seed):
    unique_id = str(uuid.uuid4())
    s3_image_path = f"{CANDIDATE_NUMBER}/titan_{unique_id}.png"
    s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)
    image_url = f"s3://{BUCKET_NAME}/{s3_image_path}"
    
    return image_url

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        if 'prompt' not in body or not body['prompt']:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Prompt is required in the request body.'})
            }
            
        prompt = body['prompt']
        image_data, seed = generate_image(prompt)
        image_url = upload_image_to_s3(image_data, seed)
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'Image generated succesfully!', 'image_url': image_url})
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }