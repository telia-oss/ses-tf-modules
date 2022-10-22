import json
import logging
import os
import sys
import unittest

test_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(test_dir + "/../src")
from main import lambda_handler

os.environ["RDS_ECS_MAP"] = """
[{"ecs_cluster":"my-ecs-cluster","ecs_services":["smy-ecs-service-1","my-ecs-service-2"],"rds_instance":"my-rds-instance"}]
"""


class LambdaLocalRunner(unittest.TestCase):
    """
    This runner will run the lambda locally with the event stored in test-event.json
    Please set AWS credentials before running this script
    """

    def test_run_main(self):

        with open(test_dir + '/test-event.json', 'r') as event_file:
            event = json.load(event_file)

        try:
            lambda_handler(event)
        except Exception as e:
            logging.exception(e)
            self.fail("Exception occurred")


if __name__ == '__main__':
    unittest.main()
