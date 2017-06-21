data "aws_iam_policy_document" "endpoint" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_vpc_endpoint" "endpoint" {
    vpc_id = "${var.vpc_id}"
    service_name = "com.amazonaws.${var.region}.s3"
    route_table_ids = ["${var.route_table_ids}"]
    policy = "${data.aws_iam_policy_document.endpoint.json}"
}
