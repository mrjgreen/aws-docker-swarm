resource "aws_lambda_function" "notify" {
  filename         = "${var.lambda["filename"]}"
  function_name    = "${var.name}"
  role             = "${aws_iam_role.notify.arn}"
  handler          = "${var.lambda["handler"]}"
  source_code_hash = "${base64sha256(file(var.lambda["filename"]))}"
  runtime          = "${var.lambda["runtime"]}"

  environment {
    variables = "${var.env_vars}"
  }

  tags {
    Name = "${var.name}"
    Application = "${var.application}"
    Provision = "terraform"
    ProvisionerSrc = "${var.provisionersrc}"
  }
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.notify.arn}"
}
