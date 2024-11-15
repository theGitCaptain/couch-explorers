import json

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        if 'prompt' not in body or not body['prompt']:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Prompt is required in the request body.'})
            }
            
        prompt = body['prompt']
        
        return {
            'statusCode': 200,
            'body': json.dumps({'message': f'Received prompt: {prompt}'})
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }