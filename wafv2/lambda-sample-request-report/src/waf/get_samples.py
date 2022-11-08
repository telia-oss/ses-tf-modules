import os

import boto3
from datetime import datetime, timedelta


REGION=os.getenv("REGION", default="eu-west-1")
client = boto3.client('wafv2', region_name=REGION)

WEB_ACL_ARN = os.getenv("WEB_ACL_ARN")
RULE_METRIC_NAME = os.getenv("RULE_METRIC_NAME")
SCOPE = os.getenv("SCOPE")



def build_time_window(start_time: list[str], end_time: list[str]) -> dict:
    """
    start_time amd end_time in format of array ['yyyy'. 'MM', 'dd', 'HH25', 'mm', 'ss'].
    if no parameters presented,  datetime.now() and datetime.now() - timedelta(hours=2) is used
    """

    _start_time = ""
    _end_time = ""
    if start_time and len(start_time) == 6 and end_time and len(start_time) == 6:
        _start_time = start_time
        _end_time = end_time
    else:
        now: datetime = datetime.now()
        _start_time = now - timedelta(hours=2)
        _end_time = now

    return {
        'StartTime': _start_time,
        'EndTime': _end_time
    }

def get_sampled_request(start_time: list[str], end_time: list[str]):
    response = client.get_sampled_requests(
        WebAclArn=WEB_ACL_ARN,
        RuleMetricName=RULE_METRIC_NAME,
        Scope=SCOPE,
        TimeWindow=build_time_window(start_time, end_time),
        MaxItems=500
    )
    return response
