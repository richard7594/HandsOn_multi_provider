data "aws_iam_policy_document" "bucket_policy" {

  statement {
    effect    = "Allow"
    resources = ["${aws_s3_bucket.s3.arn}/*"]
    actions   = ["s3:PutObject"]
    principals {
      type        = "AWS"
      identifiers = ["*"] # the only values for principals in a bucket policy are iam role and iam user arn, not a global service here
    }                     # Think about how to fectch iam role instance profile instead of "*" and add condition to specifie my vpc endpoint only
  }

}
