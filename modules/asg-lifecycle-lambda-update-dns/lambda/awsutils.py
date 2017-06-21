import boto3

autoscaling = boto3.client('autoscaling')
ec2 = boto3.client('ec2')
route53 = boto3.client('route53')

class R53RecordSet:
    def __init__(self, name, type, ttl):
        self.name = name
        self.type = type
        self.ttl = ttl

    def __str__(self):
        return "Name: %s, Type: %s, TTL: %s, " % (self.name, self.type, self.ttl)

def asg_instance_in_service(instance):
    # http://docs.aws.amazon.com/autoscaling/latest/userguide/AutoScalingGroupLifecycle.html
    state = instance['LifecycleState']
    allowedStates = ['InService', 'Pending', 'Pending:Wait', 'Pending:Proceed']
    return state in allowedStates

def ec2_instance_up(instance):
    # http://docs.aws.amazon.com/autoscaling/latest/userguide/AutoScalingGroupLifecycle.html
    state = instance['State']['Name']
    allowedStates = ['running', 'pending']
    return state in allowedStates

def get_instance_ids_from_asg(name):
    group = autoscaling.describe_auto_scaling_groups(AutoScalingGroupNames = [name])
    instances = group['AutoScalingGroups'][0]['Instances']
    return [i['InstanceId'] for i in instances if asg_instance_in_service(i)]

def get_instance_details(instance_ids):
    reservations = ec2.describe_instances(InstanceIds = instance_ids)
    return [i for r in reservations['Reservations'] for i in r["Instances"]]

def get_ip_addresses_for_asg(name):
    ids = get_instance_ids_from_asg(name)
    instances = get_instance_details(ids)
    return [i['PublicIpAddress'] for i in instances]

def update_dns_records(hosted_zone_id, record, ips):
    return route53.change_resource_record_sets(
        HostedZoneId=hosted_zone_id,
        ChangeBatch={
            'Comment': 'Updated by lambda on autoscaling lifecycle event',
            'Changes': [{
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': record.name,
                    'Type': record.type,
                    'TTL': record.ttl,
                    'ResourceRecords': [{'Value': ip} for ip in ips]
                }
            }]
        }
    )
