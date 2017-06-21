import os
from handler import handler_update_dns

test_event = {
    "Records": [{
        "Sns": {
            "SignatureVersion": "1",
            "Timestamp": "2017-06-18T08:35:30.177Z",
            "Signature": "",
            "SigningCertUrl": "",
            "MessageId": "12345",
            "Message": "{\"Progress\":50,\"AccountId\":\"000\",\"Description\":\"Launching a new EC2 instance: i-513730e9847\",\"RequestId\":\"7825fe9b-16c6-4cb5-8c39-2c3ab805c775\",\"EndTime\":\"2017-06-18T08:35:30.133Z\",\"AutoScalingGroupARN\":\"arn:aws:autoscaling:eu-west-1:\",\"ActivityId\":\"7825fe9b-16c6-4cb5-8c39-2c3ab805c775\",\"StartTime\":\"2017-06-18T08:34:57.791Z\",\"Service\":\"AWS Auto Scaling\",\"Time\":\"2017-06-18T08:35:30.133Z\",\"EC2InstanceId\":\"i-0e984513737fc1eff\",\"StatusCode\":\"InProgress\",\"StatusMessage\":\"\",\"Details\":{\"Subnet ID\":\"subnet-fae4ffa2\",\"Availability Zone\":\"eu-west-1b\"},\"AutoScalingGroupName\":\"Test-swarm\",\"Cause\":\"At 2017-06-18T08:34:35Z a user request update of AutoScalingGroup constraints to min: 1, max: 5, desired: 3 changing the desired capacity from 2 to 3. At 2017-06-18T08:34:56Z an instance was started in response to a difference between desired and actual capacity, increasing the capacity from 2 to 3.\",\"Event\":\"autoscaling:EC2_INSTANCE_LAUNCH\"}",
            "MessageAttributes": {},
            "Type": "Notification",
            "UnsubscribeUrl": "",
            "TopicArn": "arn:aws:sns:eu-west-1:00000:Test-swarm-asg-notify-dns",
            "Subject": "Auto Scaling: launch for group \"Test-swarm\""
        }
    }]
}

os.environ["ZONE_ID"] = "foo"
os.environ["RECORD_NAME"] = "foo"
os.environ["RECORD_TYPE"] = "A"
os.environ["RECORD_TTL"] = "200"

handler_update_dns(test_event, {})
