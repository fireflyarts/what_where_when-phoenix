#!/bin/bash

PROD_APP_NAME="great-slategray-oxpecker"

OUT_DIR="$(git rev-parse --show-toplevel)/priv/repo/backups"
OUTFILE="what_where_when_data-$(date +%Y-%m-%d_%H-%M).sql"

set -x

mkdir -p "$OUT_DIR"

pg_dump -v \
  --no-owner --no-acl \
  --exclude-table-data=people_tokens \
  "$(gigalixir pg -a "$PROD_APP_NAME" | jq -r '.[].url')" > "${OUT_DIR}/${OUTFILE}"
