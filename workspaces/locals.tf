locals {
    common_name = "${var.project}-${terraform.workspace}"
    common_tags = {
        Project = var.project
        Terraform = "true"
    }
}