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

open "http://localhost:9090/query?\
g0.expr=rate(container_cpu_usage_seconds_total{image!=\"\"}[1m])&\
g0.show_tree=0&g0.tab=graph&g0.range_input=30m&g0.res_type=auto&\
g0.res_density=medium&g0.display_mode=lines&g0.show_exemplars=0" \
|| echo "Warning: Failed to open browser. Please visit http://localhost:9090 manually."

echo "Setup complete."
exit 0
