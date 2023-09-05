resource "aws_s3_bucket" "website_bucket" {
  bucket = "nimble85.my-website-bucket"  # Set a unique name for your bucket
  #acl    = "public-read"  # Set the ACL to allow public read access

  #website {
  #  index_document = "index.html"  # Set the main index file
  #}
    tags = {
        Name        = "Web site"
        Environment = "Prod"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl_website_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}


resource "null_resource" "copy_index_file" {
  provisioner "local-exec" {
    command = "aws s3 cp ./modules/s3buckets/index.html s3://my-website-bucket/ && aws s3 cp ./modules/s3buckets/error.html s3://my-website-bucket/"
  }
  depends_on = [ aws_s3_bucket.website_bucket ]
}