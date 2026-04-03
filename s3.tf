# s3 + bucket policy + permission in Ec2 role for instance profile 

# removed {
#   from = aws_s3_bucket.s3

#   lifecycle {
#     destroy = false
#   }
# }


# resource "aws_s3_bucket" "s3" {
#   bucket = "logshandsonrichanel"
  
#   lifecycle {
#     prevent_destroy = true
#   }

# }

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.s3.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }
# resource "aws_s3_bucket_policy" "s3" {
#   bucket = aws_s3_bucket.s3.id
#   policy = data.aws_iam_policy_document.bucket_policy.json
#   depends_on = [ aws_s3_bucket_public_access_block.example ]
# }