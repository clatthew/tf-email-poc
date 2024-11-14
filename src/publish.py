from boto3 import client
from os import environ

sns_client = client("sns")


def lambda_handler(event={}, context={}):
    email = {
        "TopicArn": environ["sns_topic_arn"],
        "Message": "!!!!!!!! - with ❤️ from python",
        "Subject": "🚨",
    }

    sns_client.publish(**email)


if __name__ == "__main__":
    lambda_handler()
