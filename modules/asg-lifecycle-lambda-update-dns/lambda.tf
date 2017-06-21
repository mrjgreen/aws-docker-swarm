data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/lambda"
    output_path = "${path.module}/lambda.zip"
}

data "aws_iam_policy_document" "notify" {
  statement {
    actions = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${var.zone_id}"]
  }
}

module "asg-lifecycle" {
  source = "../asg-lifecycle-lambda"

  name = "${ var.name }"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  # variables
  group_names = "${ var.group_names }"
  lambda = {
    filename         = "${data.archive_file.lambda_zip.output_path}"
    handler          = "handler.handler_update_dns"
    runtime          = "python2.7"
  }
  policy = "${data.aws_iam_policy_document.notify.json}"
  delay_termination = "${var.record["ttl"] + 120}"
  env_vars = {
    ZONE_ID = "${var.zone_id}"
    RECORD_TTL = "${var.record["ttl"]}"
    RECORD_NAME = "${var.record["name"]}"
    RECORD_TYPE = "${var.record["type"]}"
  }
}
