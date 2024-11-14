variable "code_bucket_prefix" {
  type    = string
  default = "tf-test-emails-code"
}

variable "lambda_name" {
  type    = string
  default = "quote_handler"
}

variable "python_runtime" {
  type    = string
  default = "python3.12"
}

# variable "email_address" {
#     type = string
#     default = file("${path.module}/email.txt")
# }