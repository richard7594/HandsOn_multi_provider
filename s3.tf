# s3 + bucket policy + permission in Ec2 role for instance profile 

resource "aws_s3_bucket" "s3" {
  bucket = "logs"

}

data "aws_iam_policy_document" "bucket_policy" {

  statement {
    effect    = "Allow"
    resources = [aws_s3_bucket.s3.arn, "${aws_s3_bucket.s3.arn}/*"]
    actions   = ["S3:PutOject"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}


resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}