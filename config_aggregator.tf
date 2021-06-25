resource "aws_iam_role" "organization" {
  # Scop: 
  #   - Crearea unui IAM Role folosit pentru configurarea initiala a AWS Config
  # Variabile de intrare:
  #   - Obligatorii: create_aggregator
  #   - Optionale: config_aggregator_role_name
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
  count = var.create_aggregator ? 1 : 0 
  name  = var.config_aggregator_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "organization" {
  # Scop: 
  #   - Atasarea policy-ului AWS Managed AWSConfigRoleForOrganizations, rolului creat anterior
  # Variabile de intrare:
  #   - Obligatorii: create_aggregator
  #   - Optionale: N/A 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
  count      = var.create_aggregator ? 1 : 0
  role       = aws_iam_role.organization[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

resource "aws_config_configuration_aggregator" "organization" {
  # Scop: 
  #   - Crearea Config Aggregator-ului
  # Variabile de intrare:
  #   - Obligatorii: create_aggregator
  #   - Optionale: config_aggregator_name 
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator
  count      = var.create_aggregator ? 1 : 0
  depends_on = [aws_iam_role_policy_attachment.organization[0]]
  name       = var.config_aggregator_name
  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.organization[0].arn
  }
}
