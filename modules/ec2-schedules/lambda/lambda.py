import json
import os

import boto3


def _get_instance_ids():
    raw = os.environ.get("INSTANCE_IDS", "[]")
    try:
        value = json.loads(raw)
        if isinstance(value, list):
            return value
    except json.JSONDecodeError:
        pass
    return [s.strip() for s in raw.split(",") if s.strip()]


def handler(event, context):
    action = event.get("action", "").lower()
    instance_ids = _get_instance_ids()

    if not instance_ids:
        return {"status": "skipped", "reason": "no instance ids"}

    ec2 = boto3.client("ec2")

    if action == "start":
        ec2.start_instances(InstanceIds=instance_ids)
        return {"status": "started", "instances": instance_ids}
    if action == "stop":
        ec2.stop_instances(InstanceIds=instance_ids)
        return {"status": "stopped", "instances": instance_ids}

    return {"status": "skipped", "reason": "unknown action", "action": action}
