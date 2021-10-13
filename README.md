# Sequencing data progress for plants

The below information will soon be written into a pipeline, and maybe a visualisation.

## Eudicots

```bash
# public releases
ls /lustre/scratch116/tol/projects/darwin/data/dicots/*/assembly/release/reference -ld
# curated
ls /lustre/scratch116/tol/projects/darwin/data/dicots/*/assembly/curated/* -ld
# draft
ls /lustre/scratch116/tol/projects/darwin/data/dicots/*/assembly/draft/* -ld
# species with genomic data
ls -d /lustre/scratch116/tol/projects/darwin/data/dicots/*/genomic_data/
# samples with genomic data 
ls -d /lustre/scratch116/tol/projects/darwin/data/dicots/*/genomic_data/*/
# sequencing types
ls -d /lustre/scratch116/tol/projects/darwin/data/dicots/*/genomic_data/*/*/ | awk '{print $11}' | cut -d/ -f12 | sort | uniq -c
```

## Monocots

```bash
# public releases
ls /lustre/scratch116/tol/projects/darwin/data/monocots/*/assembly/release/reference -ld
# curated
ls /lustre/scratch116/tol/projects/darwin/data/monocots/*/assembly/curated/* -ld
# draft
ls /lustre/scratch116/tol/projects/darwin/data/monocots/*/assembly/draft/* -ld
# species with genomic data
ls -d /lustre/scratch116/tol/projects/darwin/data/monocots/*/genomic_data/
# samples with genomic data 
ls -d /lustre/scratch116/tol/projects/darwin/data/monocots/*/genomic_data/*/
# sequencing types
ls -d /lustre/scratch116/tol/projects/darwin/data/monocots/*/genomic_data/*/*/ | awk '{print $11}' | cut -d/ -f12 | sort | uniq -c
```

## Other vascular plants

```bash
# public releases
ls /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/assembly/release/reference -ld
# curated
ls /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/assembly/curated/* -ld
# draft
ls /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/assembly/draft/* -ld
# species with genomic data
ls -d /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/genomic_data/
# samples with genomic data 
ls -d /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/genomic_data/*/
# sequencing types
ls -d /lustre/scratch116/tol/projects/darwin/data/vascular-plants/*/genomic_data/*/*/ | awk '{print $11}' | cut -d/ -f12 | sort | uniq -c
```

# Bryophytes

```bash
# public releases
ls /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/assembly/release/reference -ld
# curated
ls /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/assembly/curated/* -ld
# draft
ls /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/assembly/draft/* -ld
# species with genomic data
ls -d /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/genomic_data/
# samples with genomic data 
ls -d /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/genomic_data/*/
# sequencing types
ls -d /lustre/scratch116/tol/projects/darwin/data/non-vascular-plants/*/genomic_data/*/*/ | awk '{print $11}' | cut -d/ -f12 | sort | uniq -c
```