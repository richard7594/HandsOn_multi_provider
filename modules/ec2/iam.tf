
data "aws_iam_policy_document" "role" { # trusted policy

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

  }
}

data "aws_iam_policy_document" "s3" { # permission policy

  statement {

    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::handson-aws-group/logs/*"]
  }
}


data "aws_iam_policy_document" "secret" {
  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:PutSecretValue"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3_permission" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = [var.bucket_arn]
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

# get secret
resource "aws_iam_role_policy" "secret" {
  role   = aws_iam_role.instance.name
  policy = data.aws_iam_policy_document.secret.json
}

# allow ssm session manager on instance 
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"

}

resource "aws_iam_role_policy_attachment" "rds" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy" "s3_permission" {
  role   = aws_iam_role.instance.name
  policy = data.aws_iam_policy_document.s3_permission.json

}

resource "aws_iam_instance_profile" "ec2" {
  role = aws_iam_role.instance.name
}