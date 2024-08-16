import json


def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Welcome to DevOps(Assessment 2) of Default API')
    }
