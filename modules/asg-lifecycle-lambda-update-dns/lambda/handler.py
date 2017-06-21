from __future__ import print_function
import json
import os
from awsutils import R53RecordSet, get_ip_addresses_for_asg, update_dns_records

def parse_event(event):
    return json.loads(event['Records'][0]['Sns']['Message'])

def handler_update_dns(event, context):

    print('Received event: ' + json.dumps(event, indent=2))

    zone_id = os.environ["ZONE_ID"]

    record = R53RecordSet(
        os.environ["RECORD_NAME"],
        os.environ["RECORD_TYPE"],
        int(os.environ["RECORD_TTL"])
    )

    print("Operating on zone_id " + zone_id + " route 53 record: " + str(record))

    message = parse_event(event)

    autoScalingGroupName = message['AutoScalingGroupName']

    print('Finding Instance IPs for Auto Scaling Group: ' + autoScalingGroupName)

    addresses = get_ip_addresses_for_asg(autoScalingGroupName)

    print('Found Instance IPs: ' + ",".join(addresses))

    # We can't update the route 53 record set to an empty address list
    if len(addresses) > 0:

        print('Updating DNS entry for zone: ' + zone_id)

        response = update_dns_records(zone_id, record, addresses)
    else:
        print('No healthy instances found. Skipping DNS update.')

    print(response)

    print('Complete')
