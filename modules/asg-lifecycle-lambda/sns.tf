resource "aws_sns_topic" "notify" {
  name = "${var.name}"
}

resource "aws_autoscaling_notification" "notify" {
  group_names = ["${var.group_names}"]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = "${aws_sns_topic.notify.arn}"
}

resource "aws_autoscaling_lifecycle_hook" "notify-termination-delay" {
  count                  = "${length(var.group_names)}"
  name                   =  "${ format("%s-swarm-asg-lc-hook-%d", var.application, count.index) }"
  autoscaling_group_name = "${element(var.group_names, count.index)}"
  default_result         = "CONTINUE"
  heartbeat_timeout      = "${var.delay_termination}"
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_target_arn = "${aws_sns_topic.notify.arn}"
  role_arn                = "${aws_iam_role.notify-hook.arn}"
}

resource "aws_sns_topic_subscription" "notify" {
  topic_arn = "${aws_sns_topic.notify.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.notify.arn}"
}


resource "aws_iam_role" "notify-hook" {
    name = "${var.name}-notify-hook"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "autoscaling.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "notify-hook" {
    name = "${var.name}-notify-hook"
    role = "${aws_iam_role.notify-hook.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "${aws_sns_topic.notify.arn}"
    }
  ]
}
EOF
}
