module "gke_gc0_europe-west1" {
  providers = {
    kubernetes = kubernetes.gke_gc0_europe-west1
  }

  source = "github.com/kbst/terraform-kubestack//google/cluster?ref=v0.19.1-beta.0"

  configuration = {
    apps = {
      base_domain                = var.base_domain
      cluster_initial_node_count = 1
      cluster_machine_type       = "e2-standard-8"
      cluster_max_node_count     = 3
      cluster_min_master_version = "1.25"
      cluster_min_node_count     = 1
      cluster_node_locations     = "europe-west1-b,europe-west1-c,europe-west1-d"
      name_prefix                = "gc0"
      project_id                 = "kubecon-eu-2024"
      region                     = "europe-west1"
    }
  }
}

module "small_node_pool" {
  source = "github.com/kbst/terraform-kubestack//google/_modules/gke/node_pool?ref=v0.19.1-beta.0"

  project  = module.gke_gc0_europe-west1.current_config.project_id
  location = module.gke_gc0_europe-west1.current_config["region"]
  location_policy = null 

  cluster_name = module.gke_gc0_europe-west1.current_metadata["name"]
  pool_name    = "small-nodes"

  service_account_email                 = "${substr(module.gke_gc0_europe-west1.current_metadata["name"], 0, 30)}@${module.gke_gc0_europe-west1.current_config.project_id}.iam.gserviceaccount.com"
  disable_per_node_pool_service_account = true

  metadata_tags   = module.gke_gc0_europe-west1.current_metadata["tags"]
  metadata_labels = module.gke_gc0_europe-west1.current_metadata["labels"]

  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 5

  disk_type = "pd-standard"
  disk_size_gb = 100

  extra_oauth_scopes = []

  machine_type = "e2-standard-4"
  image_type = "cos_containerd"

  # Whether to use preemptible nodes for this node pool
  preemptible = false

  node_workload_metadata_config = "GKE_METADATA"
}

module "medium_node_pool" {
  source = "github.com/kbst/terraform-kubestack//google/_modules/gke/node_pool?ref=v0.19.1-beta.0"

  project  = module.gke_gc0_europe-west1.current_config.project_id
  location = module.gke_gc0_europe-west1.current_config["region"]
  location_policy = null 

  cluster_name = module.gke_gc0_europe-west1.current_metadata["name"]
  pool_name    = "medium-nodes"

  service_account_email                 = "${substr(module.gke_gc0_europe-west1.current_metadata["name"], 0, 30)}@${module.gke_gc0_europe-west1.current_config.project_id}.iam.gserviceaccount.com"
  disable_per_node_pool_service_account = true

  metadata_tags   = module.gke_gc0_europe-west1.current_metadata["tags"]
  metadata_labels = module.gke_gc0_europe-west1.current_metadata["labels"]

  initial_node_count = 1
  min_node_count     = 1
  max_node_count     = 5

  disk_type = "pd-standard"
  disk_size_gb = 100

  extra_oauth_scopes = []

  machine_type = "e2-standard-8"
  image_type = "cos_containerd"

  # Whether to use preemptible nodes for this node pool
  preemptible = false

  node_workload_metadata_config = "GKE_METADATA"
}

