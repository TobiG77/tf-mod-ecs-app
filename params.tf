# variable that are deliberately kept empty to force conscious context switches

variable "stage" {
  description = "The stack stage, i.e. [ dev, prod ]"
}

variable "region" {}
variable "application_name" {}
variable "application_port" {}
variable "target_group_arn" {}

variable "cpu" {}
variable "memory" {}
