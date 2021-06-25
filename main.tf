# Config setup
resource "aws_iam_role" "setup" {
  # Scop: 
  #   - Crearea unui IAM Role folosit pentru configurarea initiala a AWS Config
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: aws_config_role_name 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
  count = var.setup_config ? 1 : 0
  name  = var.aws_config_role_name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "policy" {
  # Scop: 
  #   - Atasarea policy-ului AWS Managed AWSConfigRole, rolului creat anterior
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: N/A 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
  count      = var.setup_config ? 1 : 0
  role       = aws_iam_role.setup[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy" "bucket_policy" {
  # Scop: 
  #   - Atasarea unui inline policy pentru permisiuni asupra bucket-ului de colectare a log-urilor
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: aws_config_role_policy_name 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
  count = var.setup_config ? 1 : 0
  name  = var.aws_config_role_policy_name
  role  = aws_iam_role.setup[0].id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket[0].arn}",
        "${aws_s3_bucket.bucket[0].arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "bucket" {
  # Scop: 
  #   - Crearea unui S3 bucket pentru configurarea initiala a AWS Config
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: aws_config_bucket_name 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
  count  = var.setup_config ? 1 : 0
  bucket = var.aws_config_bucket_name
}

resource "aws_config_delivery_channel" "channel" {
  # Scop: 
  #   - Crearea unui delivery channel pentru configurarea initiala a AWS Config
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: aws_config_delivery_channel_name
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel
  count          = var.setup_config ? 1 : 0
  name           = var.aws_config_delivery_channel_name
  s3_bucket_name = aws_s3_bucket.bucket[0].bucket
}

resource "aws_config_configuration_recorder" "recorder" {
  # Scop: 
  #   - Crearea unui configuration recorder pentru configurarea initiala a AWS Config
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: aws_config_configuration_recorder_name 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder
  count    = var.setup_config ? 1 : 0
  name     = var.aws_config_configuration_recorder_name
  role_arn = aws_iam_role.setup[0].arn
}

resource "aws_config_configuration_recorder_status" "status" {
  # Scop: 
  #   - Setarea pe enabled a configuration recorder-ului creat anteriora
  # Variabile de intrare:
  #   - Obligatorii: setup_config
  #   - Optionale: N/A 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status
  count      = var.setup_config ? 1 : 0
  name       = aws_config_configuration_recorder.recorder[0].name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.channel[0]]
}
