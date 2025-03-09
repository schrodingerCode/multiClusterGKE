variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "dav-training-lnx-34e2"
}

variable "region_1" {
  description = "Primary region for the first cluster"
  type        = string
  default     = "us-central1"
}

variable "region_2" {
  description = "Secondary region for the second cluster"
  type        = string
  default     = "europe-west1"
}

variable "vpc_1_name" {
  description = "Name of the first VPC"
  type        = string
  default     = "vpc-1"
}

variable "vpc_2_name" {
  description = "Name of the second VPC"
  type        = string
  default     = "vpc-2"
}

variable "subnet_1_cidr" {
  description = "CIDR range for the first subnet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_2_cidr" {
  description = "CIDR range for the second subnet"
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_1_secondary_pods_cidr" {
  description = "CIDR range for Pods in subnet 1"
  type        = string
  default     = "10.50.0.0/16"
}

variable "subnet_1_secondary_services_cidr" {
  description = "CIDR range for Services in subnet 1"
  type        = string
  default     = "10.51.0.0/16"
}

variable "subnet_2_secondary_pods_cidr" {
  description = "CIDR range for Pods in subnet 2"
  type        = string
  default     = "10.60.0.0/16"
}

variable "subnet_2_secondary_services_cidr" {
  description = "CIDR range for Services in subnet 2"
  type        = string
  default     = "10.61.0.0/16"
}

variable "cluster_1_name" {
  description = "Name of the first GKE cluster"
  type        = string
  default     = "gke-us-central1"
}

variable "cluster_2_name" {
  description = "Name of the second GKE cluster"
  type        = string
  default     = "gke-eu-west1"
}

variable "fleet_name" {
  description = "Name of the GKE Fleet"
  type        = string
  default     = "gke-multi-region-fleet"
}
