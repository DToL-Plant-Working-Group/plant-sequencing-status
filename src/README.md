# Pipeline

Short and sweet, run with:

```bash
bash update.bash
```

This fetches the latest assembly/genomic-data listings, regenerates the
genome size tables, rewrites `../README.md`, and — if anything changed —
makes a local commit. It does **not** push; review with `git show` and
push by hand.

## Genome sizes

The genome sizes are taken from the genomescope estimates and also the
length of the assemblies themselves. `update.bash` runs
`genome_size_assemblies.bash` and `genome_size_genomescope_all.bash`, then
`format_genome_sizes.R` to merge everything into a formatted dataset.
(`genome_size_genomescope.bash` is not part of the pipeline — its output
isn't consumed anywhere.)

`format_genome_sizes.R` also merges in a C-value database snapshot. It
auto-picks the most recently modified `../data/dtol_cval_database_*.csv`
file, so when a new snapshot is downloaded by hand, just drop it in
`data/` with a dated filename matching that pattern — no script changes
needed.

## Automated weekly run

`cron_run.bash` submits `update.bash` as an LSF job (so the Lustre
metadata scan runs on a compute node, not the login node) and is meant to
be triggered by cron. Installed crontab entry:

```
0 3 * * 1 /bin/bash -l -c '.../src/cron_run.bash' >> .../logs/cron.log 2>&1
```

Logs land in `../logs/` (gitignored): one `update_*.log` per run from
`update.bash` itself, plus LSF's `lsf_<jobid>.{out,err}`.
