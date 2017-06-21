###########################################
# The Auto Scaling Group & Launch Config
###########################################
resource "aws_autoscaling_group" "asg" {
  name = "${var.name}"

  health_check_grace_period = 60
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${ aws_launch_configuration.asg.name }"
  desired_capacity = "${ var.size }"
  max_size = "${ var.size }"
  min_size = "0"
  vpc_zone_identifier = [ "${ var.subnet-ids }" ]

  # Important note: whenever using a launch configuration with an auto scaling
  # group, you must set create_before_destroy = true. However, as soon as you
  # set create_before_destroy = true in one resource, you must also set it in
  # every resource that it depends on, or you'll get an error about cyclic
  # dependencies (especially when removing resources). For more info, see:
  #
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key = "Application"
    value = "${var.application}"
    propagate_at_launch = true
  }

  tag {
    key = "Provisioner"
    value = "terraform"
    propagate_at_launch = true
  }

  tag {
    key = "ProvisionerSrc"
    value = "${var.provisionersrc}"
    propagate_at_launch = true
  }

  tag {
    key = "SwarmRole"
    value = "${var.role}"
    propagate_at_launch = true
  }
}

# Set up the launch config which will initialise the ECS instances on boot
resource "aws_launch_configuration" "asg" {
  name_prefix = "${var.name}-"

  # Set this to depend on the IAM role, else we might end up with instances running
  # that can't access the resources they need
  depends_on = [
    "aws_iam_role_policy.asg"
  ]

  iam_instance_profile = "${ aws_iam_instance_profile.asg.id }"
  image_id = "${ var.ami-id }"
  instance_type = "${ var.instance-type }"
  key_name = "${ var.key-name }"

  # Storage
  root_block_device {
    volume_size = "${ var.volume_size }"
    volume_type = "gp2"
  }

  security_groups = [
    "${ var.security-group-ids }"
  ]

  user_data = "${ data.template_file.user-data.rendered }"


  # Important note: whenever using a launch configuration with an auto scaling
  # group, you must set create_before_destroy = true. However, as soon as you
  # set create_before_destroy = true in one resource, you must also set it in
  # every resource that it depends on, or you'll get an error about cyclic
  # dependencies (especially when removing resources). For more info, see:
  #
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }
}
