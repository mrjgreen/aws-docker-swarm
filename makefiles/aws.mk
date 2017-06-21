MASG := `cat .terraform-output-cache | jq -r '."manager-autoscaling-group-name".value'`
ASG := `cat .terraform-output-cache | jq -r '."autoscaling-group-names".value[]' | xargs printf "%s,"`

INSTANCE_QUERY := '[PublicIpAddress,PrivateIpAddress,InstanceId,State.Name,Tags[?Key==`Name`].Value | [0],Tags[?Key==`SwarmRole`].Value | [0]]'

list-instances:
	@scripts/aws-list-asg-instances ${ASG} ${INSTANCE_QUERY} | sed 's/^/ec2-user@/'

list-manager-instances:
	@scripts/aws-list-asg-instances ${MASG} ${INSTANCE_QUERY} | sed 's/^/ec2-user@/'

access-manager-instance:
	@scripts/aws-list-asg-instances ${MASG} '[PublicIpAddress]' | sed 's/^/ec2-user@/' | head -n1

remove-instance:
	@scripts/drain-node ${ID}
	aws autoscaling set-instance-health --instance-id ${ID} --health-status Unhealthy --no-should-respect-grace-period


.PHONY: list-instances list-manager-instances access-manager-instance remove-instance
