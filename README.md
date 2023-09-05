# aws
aws by terraform code

In module AIM you can find solutions for this tasks:

1. Create User, with permissions to only create, least and read S3 buckets, and delete Lambda functions. Assign permissions using managed policy.
2. Create Role with permissions to create, list and read Lambda functions, and delete s3 buckets. Assign permissions using inline policy.
3. Make user from point 1 be able to use role from 2.
4. Check all assigned pemissions, and that there are no more permissions than described in points 1 and 2.
5. \* Implement all above with terraform, including tests of permissions.
6. Create policy to deny delete resources with specific names, with specific name across few regions.

In module NETWORK ....  
