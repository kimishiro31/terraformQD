resource "aws_s3_bucket" "elb-bucket-prj2023" {
  bucket        = "elb-bucket-prj2023"
  force_destroy = true


  tags = merge(var.default_tags, {
    Name = "lb-log-bucket-prj2023"
  })
}


resource "aws_s3_bucket_ownership_controls" "elb-bucket-prj2023" {
  bucket = aws_s3_bucket.elb-bucket-prj2023.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "elb-bucket-prj2023" {
  depends_on = [aws_s3_bucket_ownership_controls.elb-bucket-prj2023]

  bucket = aws_s3_bucket.elb-bucket-prj2023.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "elb-bucket-prj2023" {
  bucket                  = aws_s3_bucket.elb-bucket-prj2023.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "elb-bucket-prj2023" {
  bucket = aws_s3_bucket.elb-bucket-prj2023.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::127311923021:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::elb-bucket-prj2023/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_versioning" "elb-bucket-prj2023" {
  bucket = aws_s3_bucket.elb-bucket-prj2023.id

  versioning_configuration {
    status = "Enabled"
  }
}