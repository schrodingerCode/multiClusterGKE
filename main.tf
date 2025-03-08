provider "google" {
  project = var.project_id
}

# Create VPC 1
resource "google_compute_network" "vpc_1" {
  name                    = var.vpc_1_name
  auto_create_subnetworks = false
}

# Create VPC 2
resource "google_compute_network" "vpc_2" {
  name                    = var.vpc_2_name
  auto_create_subnetworks = false
}

# Create Subnet 1 with secondary ranges
resource "google_compute_subnetwork" "subnet_1" {
  name          = "${var.vpc_1_name}-subnet"
  network       = google_compute_network.vpc_1.id
  ip_cidr_range = var.subnet_1_cidr
  region        = var.region_1

  secondary_ip_range {
    range_name    = "pods-range-1"
    ip_cidr_range = var.subnet_1_secondary_pods_cidr
  }

  secondary_ip_range {
    range_name    = "services-range-1"
    ip_cidr_range = var.subnet_1_secondary_services_cidr
  }
}

# Create Subnet 2 with secondary ranges
resource "google_compute_subnetwork" "subnet_2" {
  name          = "${var.vpc_2_name}-subnet"
  network       = google_compute_network.vpc_2.id
  ip_cidr_range = var.subnet_2_cidr
  region        = var.region_2

  secondary_ip_range {
    range_name    = "pods-range-2"
    ip_cidr_range = var.subnet_2_secondary_pods_cidr
  }

  secondary_ip_range {
    range_name    = "services-range-2"
    ip_cidr_range = var.subnet_2_secondary_services_cidr
  }
}

# GKE Cluster 1 in VPC 1
resource "google_container_cluster" "gke_cluster_1" {
  name     = var.cluster_1_name
  location = var.region_1

  network    = google_compute_network.vpc_1.id
  subnetwork = google_compute_subnetwork.subnet_1.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range-1"
    services_secondary_range_name = "services-range-1"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false  # 🔹 Allows destruction

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

# GKE Cluster 2 in VPC 2
resource "google_container_cluster" "gke_cluster_2" {
  name     = var.cluster_2_name
  location = var.region_2

  network    = google_compute_network.vpc_2.id
  subnetwork = google_compute_subnetwork.subnet_2.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range-2"
    services_secondary_range_name = "services-range-2"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false  # 🔹 Allows destruction

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}


# Node Pool for Cluster 1
resource "google_container_node_pool" "node_pool_1" {
  name       = "${var.cluster_1_name}-node-pool" 
  cluster    = google_container_cluster.gke_cluster_1.id
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    preemptible  = true
  }
}

# Node Pool for Cluster 2
resource "google_container_node_pool" "node_pool_2" {
  name       = "${var.cluster_2_name}-node-pool"
  cluster    = google_container_cluster.gke_cluster_2.id
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    preemptible  = true
  }
}

# Create GKE Fleet
resource "google_gke_hub_membership" "fleet_member_1" {
  membership_id = "${var.cluster_1_name}-fleet"
  project       = var.project_id
  location      = "global"
  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.gke_cluster_1.id
    }
  }
}

resource "google_gke_hub_membership" "fleet_member_2" {
  membership_id = "${var.cluster_2_name}-fleet"
  project       = var.project_id
  location      = "global"
  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.gke_cluster_2.id
    }
  }
}
