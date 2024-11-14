from logging import getLogger

logger = getLogger(__name__)


def lambda_handler(event, context):
    logger.critical("🚨🚨🚨")
