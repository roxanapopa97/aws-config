resource "aws_config_conformance_pack" "example" {
  # Scop: 
  #   - Crearea unui conformance pack utilizand un template
  # Variabile de intrare:
  #   - Obligatorii: create_conformance_pack
  #   - Optionale: 
  #     - (obligatorii daca create_conformance_pack == true) conformance_pack_name, conformance_pack_template
  #     - (doar daca template-ul necesita parametrii) conformance_pack_input_parameters
  # Variabile de iesire: N/A 
  # Documentatie oficiala: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_conformance_pack
  count = var.create_conformance_pack ? 1 : 0 
  name  = var.conformance_pack_name

  dynamic "input_parameter" {
      for_each = var.conformance_pack_input_parameters
      content {
          parameter_name  = input_parameter.value["parameter_name"] 
          parameter_value = input_parameter.value["parameter_value"]
      }
  }

  template_body = var.conformance_pack_template
}
