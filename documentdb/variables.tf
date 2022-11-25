variable "environment" {
  description = "Environment variable identifying resource grouping"
  type        = string
}
variable "prefix" {
  description = "Prefix variable identifying resource grouping"
  type        = string
}

variable "identifier" {
  description = "AWS document DB identifier."
  type        = string
}

variable "instance_count" {
  description = "Number of document db instances."
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "The instance class to use. Eg. db.t3.medium, db.r4.large, ..."
  type        = string
}

variable "availability_zone" {
  description = "The EC2 Availability Zone that the DB instance is created in, random if not specified. Useful when Cross AZ data transfer is concern from cost perspective."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet ids cluster will be associated with."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 1
    error_message = "Two subnet needs to be specified at minimum."
  }
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "egress_rules" {
  description = "Outbound security group rules config in JSON"
  type        = list(map(string))
  default = [
    {
      from_port   = "0"
      to_port     = "0"
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = true
}

variable "preferred_maintenance_window" {
  description = "The window to perform maintenance in. Syntax: ddd:hh24:mi-ddd:hh24:mi. Eg: Mon:00:00-Mon:03:00."
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Default is 1."
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the docdb_backup_retention_period parameter."
  type        = string
  default     = "02:00-04:00"
}

variable "username" {
  description = "AWS document DB username"
  type        = string
}

variable "use_special" {
  description = "true/false if special characters are used. Defaults are: !@#$%&*()-_=+[]{}<>:?"
  type        = bool
  default     = true
}
variable "override_special" {
  description = "special characters to be used if secret_secret_use_special == true and only some are accepted."
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "Inbound security group rules config in JSON"
  type        = list(map(string))
}

variable "create_dns_record" {
  description = "true/false if read and write endpoint are created in R53 in some meaningful name"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Zone domain name where records are created"
  type        = string
  default     = null
}

variable "is_private_zone" {
  description = "true/false if R53 Zone is private"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mandatory tags to all documentdb resources."
  type        = map(string)
}
