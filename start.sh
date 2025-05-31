#!/bin/bash
set -e

if ! command -v docker compose &> /dev/null; then
  echo "Docker-compose is required but not installed. Aborting."
  exit 1
fi

echo "Starting ANYbotics Deployment Simulation Setup..."

docker-compose -f docker/dev/docker-compose.yml run --rm dev \
  ansible-playbook ansible/playbooks/base_setup.yml \

# Run ansible-playbook commands here once playbooks are ready

echo "Setup complete."