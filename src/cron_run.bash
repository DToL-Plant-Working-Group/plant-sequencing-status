#!/bin/bash
# Entry point for cron. Submits the update as an LSF job so the Lustre
# metadata scan runs on a compute node rather than the farm22 login node,
# and isn't lost if the login node is rebooted/drained for maintenance.

source /etc/profile.d/lsf.sh 2>/dev/null || true

REPO_DIR="/lustre/scratch122/tol/teams/blaxter/users/mb39/plant-sequencing-status"
LOG_DIR="$REPO_DIR/logs"
mkdir -p "$LOG_DIR"

bsub -K \
    -q normal \
    -M 4000 -R "select[mem>4000] rusage[mem=4000]" \
    -o "$LOG_DIR/lsf_%J.out" \
    -e "$LOG_DIR/lsf_%J.err" \
    bash "$REPO_DIR/src/update.bash"
