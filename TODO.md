# Todo list

## Kubernetes
- [ ] Create Kubernetes manifests for Gogs
- [ ] Create Kubernetes manifests for PostgreSQL
- [ ] Create Kubernetes manifests for Redis
- [ ] Create Kubernetes manifests for Splunk
- [ ] Create Kubernetes manifests for Jenkins
- [ ] Create Kubernetes manifests for SonarQube

## Remove
- Splunk - (I want use Icinga2 and Prometheus + Grafana)
- nginx - (replaced with ingress-nginx)
- otel-collector - (find solutiong to replace or remove otel to simplify stack)


# main task for this moment
- create manifest for gogs (think about persistency)
- find a way how to properly deploy database
- create solution/manifest for database
- connect database to the application (think about persistency and security)

