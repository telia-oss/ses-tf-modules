import boto3
import json
import logging
import os

ecs_client = boto3.client('ecs')
INPUT_DATA_KEY = "RDS_ECS_MAP"


def lambda_handler(event=None, context=None):

    """
    Lambda function handling events RDS-EVENT-0006 from RDS end restarting ECS services.
    :param event see test/test-event.json
    :param context

    Lambda  is expecting RDS_ECS_MAP env variable containing a mapping for RDS/ECS, please see test/test-event.json
    In order to be run the code locally, please use test/lambda_local_runner.py
    """
    logging.getLogger().setLevel(logging.INFO)
    rds_ecs_map = validate_input_env_data()
    validate_event(event)

    if "RDS-EVENT-0006" != event["detail"]["EventID"]:
        logging.info("Not the RDS restart event, finishing")
        return
    event_rds_instance = event["detail"]["SourceIdentifier"]

    error_count = 0
    for record in rds_ecs_map:
        if record["rds_instance"] == event_rds_instance:
            ec = restart_ecs_services(record["ecs_cluster"], record["ecs_services"])
            error_count = error_count + ec
    if error_count > 0:
        msg = f"Errors count: {error_count}"
        logging.error(msg)
        raise Exception(msg)


def validate_input_env_data():
    if INPUT_DATA_KEY not in os.environ:
        raise ValueError(f"{INPUT_DATA_KEY} has not been set")
    rds_ecs_map = json.loads(os.environ.get('RDS_ECS_MAP'))
    logging.info(f"{INPUT_DATA_KEY} {rds_ecs_map}")
    return rds_ecs_map


def validate_event(event):
    if event is None:
        raise ValueError("event is None but should contain RDS event")
    logging.info(f"Event {event}")
    event_id = event.get('detail', {}).get('EventID', 'n/a')
    if event_id == "n/a" or not event_id.startswith("RDS"):
        msg = f"Event has a bad content, EventID = {event_id}"
        logging.error(msg)
        raise ValueError(msg)
    logging.info("Event validation succeeded")


def restart_ecs_services(ecs_cluster, ecs_service_list):
    error_count = 0
    for ecs_service in ecs_service_list:
        try:
            restart_ecs_service(ecs_cluster, ecs_service)
        except Exception:
            logging.exception(f"Problem to restart the service {ecs_service} in cluster {ecs_cluster}")
            error_count = error_count + 1
    return error_count


def restart_ecs_service(ecs_cluster, ecs_service):
    logging.info(f"Restarting ECS service {ecs_service} in cluster {ecs_cluster}")
    ecs_client.update_service(cluster=ecs_cluster, service=ecs_service, forceNewDeployment=True)
