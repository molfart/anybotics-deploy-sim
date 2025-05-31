# ANYbotics Tech Challenge – Deployment Simulation

This project provisions a simulated two-instance environment using Ansible and Docker Compose.

It automates:
- Docker setup on both nodes (A & B)
- Cross-node Docker access from A to B
- Application deployment: mendhak/http-https-echo on B, Nginx reverse proxy on A

All logic is contained in Ansible playbooks and launched via `start.sh`.

CI and structure are maintained to reflect real-world deployment best practices.