# Infrastructure-as-Code

This repository contains the Ansible playbooks and roles used to manage the Talos-backed Kubernetes cluster, Unraid host, and surrounding services.

## Bootstrapping a server
Create temporary inventory file with hardcoded host options, i.e.

```yaml
# ./inventory-bootstrap.yml
all:
  hosts:
    looner-proxmox:
      ansible_host: 192.168.212.8506
      ansible_user: root
```

Host name should match the host name in the main inventory file. Run these commands to bootstrap the server:

```shell
# Install Ansible roles and collections
ansible-galaxy collection install --requirements-file ./requirements.txt
ansible-galaxy role install --role-file ./requirements.yml

# Perform initial installation: Tailscale, Docker, NFS, Samba, etc.
ansible-playbook --ask-pass --user=root --inventory=./inventory-bootstrap.yml ./looner-proxmox.yml

# Add Ansible user
ansible all --inventory 192.168.88.218, --become --user root --ask-pass --module-name user --args "name=ans groups=sudo append=yes state=present"

# Add sudo group to enable Ansible user to become with no password
ansible all --inventory 192.168.88.218, --become --user root --ask-pass --module-name copy --args "dest=/etc/sudoers.d/sudo_group content='%sudo ALL=(ALL) NOPASSWD: ALL' validate='visudo -cf %s'"
```

Remove the temporary inventory file when complete.

## SigNoz on Talos + Unraid
The `ansible/playbooks/signoz` playbook installs SigNoz in the Talos-managed Kubernetes cluster and provisions an OpenTelemetry edge collector on the Unraid bare-metal host. The design favors:

- **Helm-managed SigNoz core**: the official chart sets up ClickHouse, alerting, query service, OTLP collector, and a bundled node agent for in-cluster workloads.
- **Kubernetes host visibility**: a custom DaemonSet (`talos-host-collector`) ships host metrics, kubelet stats, container logs, and cluster metadata through an OpenTelemetry Collector sidecar to the SigNoz gateway.
- **External ingestion**: a NodePort service exposes the OTLP HTTP/GRPC endpoints so non-cluster workloads (Unraid Docker and Talos VMs) can send telemetry without needing an ingress controller.
- **Unraid/docker connector**: an edge OpenTelemetry Collector runs via Docker Compose on the Unraid host, forwarding container logs, host metrics, and traces to the cluster collector.

### Deploying SigNoz into Kubernetes
Requirements: a kubeconfig that reaches the Talos cluster and Helm support via `kubernetes.core.helm`.

```bash
cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook playbooks/signoz/main.yml \
  --limit localhost \
  --extra-vars "k8s_namespace_name=o11y signoz_cluster_name=talos-home signoz_clickhouse_size=20Gi"
```

Key resources installed in `o11y`:
- Helm release `signoz/signoz` with persistent ClickHouse storage and OTLP agent enabled.
- NodePort service `signoz-otel-collector-nodeport` exposing ports `32417` (gRPC) and `32418` (HTTP) for OTLP ingest.
- DaemonSet `talos-host-collector` with RBAC to gather kubelet stats, host metrics, container logs, and Kubernetes metadata before exporting to the in-cluster SigNoz collector.

### Wiring Unraid and other Docker hosts
Define an `unraid` inventory group pointing at the Unraid/bare-metal Docker host. Override the OTLP endpoints if the Talos nodes are reachable at different addresses/ports.

```yaml
all:
  children:
    unraid:
      hosts:
        nas:
          ansible_host: 192.168.1.50
          ansible_user: ans
```

Run only the Unraid portion of the playbook after updating the Talos node IP:

```bash
cd ansible
ansible-playbook playbooks/signoz/main.yml \
  --limit unraid \
  --extra-vars "signoz_otlp_http_endpoint=http://192.168.1.90:32418 signoz_otlp_grpc_endpoint=192.168.1.90:32417"
```

This renders `/opt/signoz-collector/docker-compose.yml` on Unraid and brings up `signoz-edge-collector`, mounting the Docker socket and container logs for metrics/log ingestion.

### Talos VM and Kubernetes connectors
- The DaemonSet runs on every Talos node (including control-plane nodes via tolerations) and uses host networking for kubelet stats scraping. Container and host logs are collected from `/var/log/containers`.
- The bundled SigNoz otel-agent inside the Helm release listens for OTLP traffic in the cluster to capture workload traces/metrics automatically.
- External workloads (e.g., additional Talos VMs or bare containers) can point to the NodePort endpoints to send OTLP HTTP/GRPC traffic directly.

### Operations notes
- Adjust `signoz_clickhouse_size`, `signoz_otlp_grpc_nodeport`, and `signoz_otlp_http_nodeport` vars in `playbooks/signoz/main.yml` to fit storage or networking constraints (e.g., when MetalLB is present you can swap NodePort for LoadBalancer).
- The edge collector templates set `tls.insecure=true` for simplicity inside the LAN; front with TLS/ingress if exposing beyond trusted networks.
- The Unraid collector labels telemetry with `signoz.edge=unraid` to simplify filtering dashboards and alerts.

### Validation checklist
1. Confirm SigNoz pods are healthy: `kubectl -n o11y get pods`
2. Verify NodePort endpoints: `kubectl -n o11y get svc signoz-otel-collector-nodeport`
3. Check host collector readiness: `kubectl -n o11y get ds talos-host-collector -o wide`
4. On Unraid, ensure the collector is running: `docker ps | grep signoz-edge-collector`
5. Send a test trace with `otel-cli` or curl against the OTLP HTTP endpoint to see it appear in SigNoz.
