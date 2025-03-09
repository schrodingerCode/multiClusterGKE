https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-multi-cluster-gateways?hl=fr#external-gateway

connect to clusters

gcloud container clusters get-credentials gke-eu-west1 --zone europe-west1 --project dav-training-lnx-34e2
kubectl apply  -f https://raw.githubusercontent.com/GoogleCloudPlatform/gke-networking-recipes/main/gateway/gke-gateway-controller/multi-cluster-gateway/store.yaml

gcloud container clusters get-credentials gke-us-central1 --zone us-central1 --project dav-training-lnx-34e2
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/gke-networking-recipes/main/gateway/gke-gateway-controller/multi-cluster-gateway/store.yaml


Install Services in K8s-exemple1 folder


    prerequesites : 
    >>activate some apis :
    gcloud services enable gkehub.googleapis.com
    gcloud services enable multiclusterservicediscovery.googleapis.com
    gcloud services enable multiclusteringress.googleapis.com

    >>GKE automatically installs ServiceExport when you enable MCS. Run this command:
    gcloud container fleet multi-cluster-services enable --project=dav-training-lnx-34e2

    >>The ServiceExport CRD is managed by the MCS Controller, which runs in the gke-mcs namespace. Check if it's running:
    kubectl get pods -n gke-mcs

Install Gateway 

    prerequisites : install gateway API ...
    https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways

    Install fleet ingress:
    gcloud container fleet ingress enable  (activant le gateway controlleur etc...)

    gcloud container clusters update gke-eu-west1 \
    --gateway-api=standard \
    --project dav-training-lnx-34e2 \
    --location europe-west1

Install Deployment: deployment.yaml

Adding Httproute  (referencing backendRefs : "Service backend")

Gateway  creates loadbalancer :
This Gateway configuration deploys external Application Load Balancer resources with the following namging convention: gkemcg1-NAMESPACE-GATEWAY_NAME-HASH.


Results 
> curl -H "host: store.example.com" http://34.36.5.115
{"cluster_name":"gke-us-central1",
"gce_instance_id":"2458721587245943502",
"gce_service_account":"564247751872-compute@developer.gserviceaccount.com",
"host_header":"store.example.com",
"pod_name":"store-55cbd5f8f7-sbppg",
"pod_name_emoji":"\ud83e\udddd\ud83c\udffe",
"project_id":"dav-training-lnx-34e2",
"timestamp":"2025-03-09T01:15:06",
"zone":"us-central1-f"}


curl -H "host: store.example.com" http://34.36.5.115/west
_header":"store.example.com",
"pod_name":"store-55cbd5f8f7-m565q",
"pod_name_emoji":"\ud83c\uddf8\ud83c\uddf0",
"project_id":"dav-training-lnx-34e2",
"timestamp":"2025-03-09T01:16:26","zone":
"europe-west1-c"}

>curl -H "host: store.example.com" http://34.36.5.115/central
{"cluster_name":"gke-us-central1",
"gce_instance_id":"2458721587245943502",
"gce_service_account":"564247751872-compute@developer.gserviceaccount.com",
"host_header":"store.example.com",
"pod_name":"store-55cbd5f8f7-sbppg",
"pod_name_emoji":"\ud83e\udddd\ud83c\udffe","project_id":"dav-training-lnx-34e2",
"timestamp":"2025-03-09T01:18:27",
"zone":"us-central1-f"}