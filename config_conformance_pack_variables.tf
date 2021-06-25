variable "create_conformance_pack" {
  description = "(Required) Set to true if a conformance pack should be deployed"
  type        = bool
}

variable "conformance_pack_name" {
  description = "(Required if create_conformance_pack == true) Name of the conformance pack"
  type        = string
  default     = null
}

variable "conformance_pack_input_parameters" {
  description = "(Required if create_conformance_pack == true) List of map of conformance pack input parameters"
  type        = list(map(string))
  default     = []
}

variable "conformance_pack_template" {
  description = "(Required if create_conformance_pack == true) Conformance pack template"
  type        = string
  default     = null
}