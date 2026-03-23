
data "aws_iam_policy_document" "role" {

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

data "aws_iam_policy_document" "s3" {

  statement {

    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::handson-aws-group/logs/*"]
  }
}

resource "aws_iam_role" "instance" {

  name               = "instance"
  assume_role_policy = data.aws_iam_policy_document.role.json

}

resource "aws_iam_role_policy" "s3" {
  role   = aws_iam_role.instance.name
  policy = data.aws_iam_policy_document.s3.json
}




resource "aws_iam_instance_profile" "ec2" {
  role = aws_iam_role.instance.name
}