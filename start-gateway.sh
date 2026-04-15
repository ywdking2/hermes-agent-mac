#!/bin/bash
cd /Users/wendiyang/Documents/hermes-agent
source venv/bin/activate
nohup python3 -u -m hermes_cli.main gateway run --replace \
  > ~/.hermes/logs/gateway.log \
  2> ~/.hermes/logs/gateway.error.log &
echo "Hermes gateway started (PID: $!)"
