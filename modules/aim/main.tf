### Create admin user with admin access  ###
resource "aws_iam_user" "user" {
  name = var.name
}

resource "aws_iam_user_policy_attachment" "attach-user" {
  user       = "${aws_iam_user.user.name}"
  policy_arn = var.policy_arns
}

### Creating task users ###
### 1. Create User, with permissions to only create, least and read S3 buckets, and delete Lambda functions. Assign permissions using managed policy.
resource "aws_iam_user" "user_1" {
  name = "user_1"
}

resource "aws_iam_policy" "s3_policy" {
  name        = "s3_policy"
  description = "Permissions to manage S3 buckets"

  # Define your S3 policy document here
  policy = file("./modules/aim/s3_policy.json") 
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "Permissions to delete Lambda functions"

  # Define your Lambda policy document here
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "LambdaPermissions",
      "Effect": "Allow",
      "Action": [
        "lambda:DeleteFunction"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "s3_attachment" {
  policy_arn = aws_iam_policy.s3_policy.arn
  user       = aws_iam_user.user_1.name
}

resource "aws_iam_user_policy_attachment" "lambda_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  user       = aws_iam_user.user_1.name
}

########## 2. Task 
# 2. Create Role with permissions to create, list and read Lambda functions, and delete s3 buckets. Assign permissions using inline policy.
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy_2" {
  name        = "lambda_policy_2"
  description = "Permissions to manage Lambda functions"

  # Define your Lambda policy document here
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "LambdaPermissions",
        Effect = "Allow",
        Action = [
          "lambda:CreateFunction",
          "lambda:ListFunctions",
          "lambda:GetFunction",
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_policy" "s3_policy_2" {
  name        = "s3_policy_2"
  description = "Permissions to delete S3 buckets"

  # Define your S3 policy document here
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3Permissions",
        Effect = "Allow",
        Action = [
          "s3:DeleteBucket",
          "s3:DeleteBucketPolicy",
          "s3:DeleteBucketWebsite",
          "s3:DeleteBucketAnalyticsConfiguration",
          "s3:DeleteBucketCors",
          "s3:DeleteBucketLifecycle",
          "s3:DeleteBucketIntelligentTieringConfiguration",
          "s3:DeleteBucketInventoryConfiguration",
          "s3:DeleteBucketReplication",
          "s3:DeleteBucketTagging",
          "s3:DeleteBucketEncryption",
          "s3:DeleteBucketVersioning",
          "s3:DeleteBucketMetricsConfiguration",
          "s3:DeleteBucketOwnershipControls",
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  policy_arn = aws_iam_policy.lambda_policy_2.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "s3_attachment" {
  policy_arn = aws_iam_policy.s3_policy_2.arn
  role       = aws_iam_role.lambda_role.name
}

### 3. Task
### 3. Make user from point 1 be able to use role from 2.
resource "aws_iam_user_policy_attachment" "lambda_attachment_user" {
  policy_arn = aws_iam_policy.lambda_policy_2.arn
  user       = aws_iam_user.user_1.name
}

### 4. Task
### 4. Check all assigned pemissions, and that there are no more permissions than described in points 1 and 2.
resource "null_resource" "check_assigned_permitions" {
  provisioner "local-exec" {
    command = "aws iam list-attached-role-policies --role-name lambda_role  && aws iam list-role-policies --role-name lambda_role"
  }
  depends_on = [ aws_iam_role.lambda_role ]
}

### 5. Tsk
### create policy to deny delete resources with specific names, with specific name across few regions;
resource "aws_iam_policy" "denny_policy" {
  name        = "denny_policy"
  description = "Permissions to denny delete resources"

  # Define your S3 policy document here
  policy = file("./modules/aim/denny_policy.json") 
}