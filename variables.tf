variable "region" {
    type = string
    default = "eu-central-1"

    validation {
      condition = substr(var.region, 0, 3) == "eu-"
      error_message = "AWS Region must be an EUROPE, like \"eu-\"."
    }
}
  
 
### AIM Module  ### 
variable "name" {
  default = "myadmin"
  #type        = "string"
  description = "The name of the user"
}

variable "policy_arns" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
  #type        = string
  description = "ARN of policy to be associated with the created IAM user"
} 