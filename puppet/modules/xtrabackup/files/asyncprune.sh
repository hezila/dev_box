#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

prune_xtrabackups() {
  # Wait 48 hours after taking a successful backup before pruning
  local wait_to_prune=48

  local cluster
  local backup_root
  local current_timestamp
  local successful_backup_ts
  local tmpwatch_threshold
  local backup_success_file

  backup_root=$1
  cluster=$2
  current_timestamp="$(date +%s)"
  backup_success_file="$(find ${backup_root}/${cluster}/xtrabackup -maxdepth 1 -name "*xbstream.gz.success" | sort | tail -n 1 | head -n 1)"
  successful_backup_ts="$(stat -c '%Y' "$backup_success_file")"
  tmpwatch_threshold=$(( ($current_timestamp - $successful_backup_ts) / 3600 + $wait_to_prune ))
  tmpwatch -v -m "$tmpwatch_threshold" "${backup_root}/${cluster}/xtrabackup"
}

backup_root="$1"
cluster="$2"

prune_xtrabackups ${backup_root} ${cluster}
