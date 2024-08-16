# Default lambda
data "archive_file" "lambda_zip_default" {
  type        = "zip"
  source_dir  = "${path.module}/microservices/default/"
  output_path = "${path.module}/microservices/zip/default.zip"
}

resource "aws_lambda_function" "microservices_function_default" {
  filename         = data.archive_file.lambda_zip_default.output_path
  function_name    = "microservices_function_default"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip_default.output_base64sha256
  runtime          = "python3.8"
  timeout          = "600"
}
