#!/bin/bash

if [ -z "${FLUME_AGENT_NAME}" ]; then
  echo "FLUME_AGENT_NAME is not set. Please set the environment variable and try again."
  exit 1
fi

if [ -z "${FLUME_CONF_DIR}" ]; then
  echo "FLUME_CONF_DIR is not set. Please set the environment variable and try again."
  exit 1
fi

# Check if /mnt/flume/flume.conf exists
if [ -f "/mnt/flume/flume.conf" ]; then
  echo "Found flume.conf in /mnt/flume. Copying to ${FLUME_CONF_DIR} ..."
  cp "/mnt/flume/flume.conf" "${FLUME_CONF_DIR}/flume.conf"
else
  echo "No flume.conf found in /mnt/flume. Using the default flume.conf in ${FLUME_CONF_DIR}."
fi

echo "Starting flume agent: ${FLUME_AGENT_NAME}"
FLUME_CONF_DIR="/opt/flume/conf"

flume-ng agent \
  -c "${FLUME_CONF_DIR}" \
  -f "${FLUME_CONF_DIR}/flume.conf" \
  -n "${FLUME_AGENT_NAME}" \
  -Dflume.root.logger=INFO,console \
  "$@"
