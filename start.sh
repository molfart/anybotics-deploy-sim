#!/bin/bash
set -e

if ! command -v docker compose &> /dev/null; then
  echo "Docker compose is required but not installed. Aborting."
  exit 1
fi

# Option for a clean build and ansible provisioning
if [[ "$1" == "clean" ]]; then
  echo "Performing clean rebuild..."
  docker compose down --volumes --remove-orphans
  docker compose build
fi

echo "Starting ANYbotics Deployment Simulation Setup..."

echo "Bringing up simulation containers (node_a, node_b)..."
docker compose up -d

# Wait briefly to ensure containers are ready
sleep 2

echo "Starting development environment container and running ansible-playbook"
docker compose exec dev ansible-playbook ansible/playbooks/base_setup.yml


# Run ansible-playbook commands here once playbooks are ready

echo "Setup complete."
exit 0
