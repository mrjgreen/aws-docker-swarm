// Assume Role
resource "aws_iam_role" "notify" {
    name = "${var.name}"
    assume_role_policy = "${data.aws_iam_policy_document.notify_role.json}"
}

data "aws_iam_policy_document" "notify_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

// Add default permissions to allow lambda to Interrogate Autoscaling Group Instances
data "aws_iam_policy_document" "notify" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "notify-default" {
    name = "${var.name}-default"
    role = "${aws_iam_role.notify.id}"
    policy = "${data.aws_iam_policy_document.notify.json}"
}


// Add user supplied permissions, if any have been set
resource "aws_iam_role_policy" "notify-user" {
    name = "${ var.name }-user"
    role = "${aws_iam_role.notify.id}"
    policy = "${var.policy}"

    // Abuse the count to see if the user set a policy - check length and cap at 1. returns either 0 or 1
    count = "${min(length(var.policy), 1)}"
}
