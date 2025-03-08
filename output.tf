output "vpc_1_name" {
  value = google_compute_network.vpc_1.name
}

output "vpc_2_name" {
  value = google_compute_network.vpc_2.name
}

output "cluster_1_info" {
  value = {
    name   = google_container_cluster.gke_cluster_1.name
    region = google_container_cluster.gke_cluster_1.location
  }
}

output "cluster_2_info" {
  value = {
    name   = google_container_cluster.gke_cluster_2.name
    region = google_container_cluster.gke_cluster_2.location
  }
}

output "fleet_name" {
  value = var.fleet_name
}
