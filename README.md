# ANYbotics Tech Challenge – Deployment Simulation

This project provisions a simulated two-instance environment using Ansible and Docker Compose.

It automates:
- Docker setup on both nodes (A & B)
- Cross-node Docker access from A to B
- Application deployment: mendhak/http-https-echo on B, Nginx reverse proxy on A

All logic is contained in Ansible playbooks and launched via `start.sh`.

CI and structure are maintained to reflect real-world deployment best practices.

Inside the container, you can run all commands as usual (e.g., Ansible, Molecule, Python).


## Requirements

To run `start.sh`, you need the following tools installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose v2](https://docs.docker.com/compose/)


## Quickstart

1. **Clone the repository:**
   ```bash
   git clone https://github.com/molfart/anybotics-deploy-sim.git
   cd anybotics-deploy-sim
   ```

2. **Run the setup script:**
   ```bash
   ./start.sh
   ```

## Project Structure

- `ansible/` – Inventory, playbooks, and roles for automation
- `docker/dev/` – Development environment setup
- `.github/workflows/` – CI/CD pipeline definitions
- `start.sh` – Entry point for provisioning and deployment
- `requirements.txt` – Python dependencies for Ansible/Molecule/etc.
- `docs/` – Documentation and architecture diagrams **TODO**



## What happens when you run `start.sh`?

1. Starts the dev container (via Docker Compose)
2. Runs Ansible to:
   - Install Docker and Docker Compose on both node_a and node_b
   - Start Docker daemon inside both containers
   - Enable TCP access from node_a to node_b

## Architecture Overview

This setup simulates a minimal distributed deployment with two nodes:

- **node_a**: Acts as the controller node.
  - Installs Docker and runs a container with **Nginx**.
  - Nginx is configured as a reverse proxy to forward requests to the echo service on node_b.
  - Has full Docker API access to node_b via TCP (port 2375).
  - Runs a cAdvisor container to expose real-time resource metrics of running containers.

- **node_b**: The target node.
  - Hosts a container running `mendhak/http-https-echo`.
  - The container exposes port `8080`.
  - Runs a cAdvisor container to expose real-time resource metrics of running containers.

- **prometheus**: Scrapes metrics from both node_a and node_b. Provides a web UI at localhost:9090 to explore container resource usage across the system.

- **cadvisor_dev**: Collects metrics about containers running on host environment itself.

All containers are started via Docker Compose through Ansible. The controller node interacts with the remote daemon using `docker -H tcp://node_b:2375`.

## Docker & Docker Compose Best Practices

This project follows modern best practices for containerized deployments, including:

- **Separation of concerns**:
  Each node has a dedicated purpose (controller vs service node).
- **Externalization of configuration**:
  Compose files are separate and modular.
- **Docker Compose v2 syntax**:
  Modern `docker compose` CLI is used without deprecated `version:` key.
- **Slim but usable base images**:
  Uses `ubuntu:24.04` to maintain a balance between usability (for Ansible, networking, debugging) and image size.
- **Persistent and observable Docker daemons**:
  Logs routed to files via `nohup`, TCP daemon made accessible on a defined port.
- **Network awareness**:
  Use of `network_mode: host` to allow inter-node communication in a controlled environment.
- **Explicit port mapping and exposure**:
  Services expose only the ports that are required for inter-container communication, avoiding unnecessary exposure to the host.
- Integrated lightweight monitoring with cAdvisor and Prometheus to track runtime metrics and ensure transparency of container workloads.

## Ansible Best Practices

- Idempotency: Playbooks are written to be repeatable without side effects, using conditions like `creates:` to avoid redundant actions.
- Modular Roles: Each logical group of tasks (e.g., Docker setup, application deployment) is encapsulated in a dedicated role.
- Explicit Conditions: Tasks include `when` clauses and checks to reduce unnecessary execution and improve reliability.
- Shell/Command Usage Justification: `shell` or `command` is only used when no better Ansible module is available, with fallback to safe patterns like `creates`.
- Use of `wait_for`: Ensures dependent services like Docker are up before proceeding, increasing playbook robustness.
- End-to-End Testing: Service availability is verified using Ansible's `uri` module to test connectivity between nodes and validate that deployed applications respond correctly.

## Observability with Prometheus & cAdvisor

This setup includes a lightweight observability stack using Prometheus and cAdvisor.

- **cAdvisor** runs on both `node_a` and `node_b` and collects metrics on container resource usage.
- **Prometheus** is deployed in the dev container and scrapes metrics from both nodes.
- The Prometheus web interface is accessible at localhost:9090.

### Example: View Container CPU Usage

To view CPU usage for running containers, use the following Prometheus query:

```
rate(container_cpu_usage_seconds_total{image!=""}[1m])
```

This provides a per-second CPU usage rate for each container over the last minute.

## Manual verification (optional)

To verify that node_a controls node_b:

```bash
docker compose exec dev bash
docker -H tcp://node_b:2375 ps

## Continuous Integration

This project uses GitHub Actions for:
- YAML linting
- Shell script linting
- Markdown link checking
- Ansible playbook syntax checking
- Execution of `start.sh` inside the dev container as part of the CI pipeline

See `.github/workflows/lint.yml` for details.

---

**For any questions or contributions, please open an issue or pull request.**
