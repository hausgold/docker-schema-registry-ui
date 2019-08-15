#!/bin/bash

# Configure application defaults
export SCHEMAREGISTRY_URL=${SCHEMAREGISTRY_URL:-'http://schema-registry.local'}
export ALLOW_GLOBAL=${ALLOW_GLOBAL:-'1'}
export ALLOW_TRANSITIVE=${ALLOW_TRANSITIVE:-'1'}
export ALLOW_DELETION=${ALLOW_DELETION:-'1'}
export PORT=${PORT:-'80'}

# Start the bootstrapping
source /run.sh
