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