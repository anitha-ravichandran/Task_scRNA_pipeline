# Task_scRNA_pipeline
## Introduction:
This pipeline is designed for single-cell RNA (scRNA) analysis, integrating tools like Cell Ranger and R packages for comprehensive data processing and visualization.

## Requirements
- Cell Ranger: Download from [10x Genomics](https://www.10xgenomics.com/support/software/cell-ranger)
- R Programming Language: Download from [R Project](https://www.r-project.org/)

## Cell Ranger installation:
### Using wget and curl
```bash
wget -O cellranger-7.2.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.2.0.tar.gz?Expires=1704177197&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=H3hwGFmhMOCBlNCMGdhvHXVlazpH~x1iTpsIGGNP3HQOCDaidzehwd8a9smg5pi0cGSD0a9iJPo~pprbxBhEu7c31ILC831gFxFIUU59Y--hp6Fyi5qLnP3wLpeHkFsudmrNMbo1coAWtot4Idxna6UU7xqoUGoWdaJrXbdVe16rjd4ITWMADItxABIsYu9QZ8q4ZC1CHGBN3nnl3aO6SfgpPE42awfJizALuw8WJ3k~sAOCLkoR2tg1Zz~JwS8k8zTzCW-EzeoAR6E-mpRI19oG6IUZ7dpTieRilGDwzqH95mH~kzS3ULsWJHpqqJqLZ7XXkE3Y0tUV0no8zJOujw__"
curl -o cellranger-7.2.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.2.0.tar.gz?Expires=1704177197&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=H3hwGFmhMOCBlNCMGdhvHXVlazpH~x1iTpsIGGNP3HQOCDaidzehwd8a9smg5pi0cGSD0a9iJPo~pprbxBhEu7c31ILC831gFxFIUU59Y--hp6Fyi5qLnP3wLpeHkFsudmrNMbo1coAWtot4Idxna6UU7xqoUGoWdaJrXbdVe16rjd4ITWMADItxABIsYu9QZ8q4ZC1CHGBN3nnl3aO6SfgpPE42awfJizALuw8WJ3k~sAOCLkoR2tg1Zz~JwS8k8zTzCW-EzeoAR6E-mpRI19oG6IUZ7dpTieRilGDwzqH95mH~kzS3ULsWJHpqqJqLZ7XXkE3Y0tUV0no8zJOujw__"
```
## R installation
```bash
sudo apt update
sudo apt -y install software-properties-common
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
```
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
```
```bash
sudo apt update
sudo apt install r-base
```
```bash
R --version
```
## Clone the Repository
```bash
git clone https://github.com/anitha-ravichandran/Task_scRNA_pipeline.git
```
## Run the bash script
Before running the bash script set the required path for Cell Ranger, input and output files.
```bash
chmod +x run.sh
./run.sh
```
## Output Folders and Files
Upon completion of the analysis, the specified output folder will contain the following files and folders:

### count_out: 
This folder is crucial for downstream analysis and contains the following compressed files:
outs/outs/filtered_feature_bc_matrix
- `barcodes.tsv.gz`: Contains the barcodes for each cell. Barcodes are unique identifiers for individual cells in the dataset.
- `features.tsv.gz`: Lists the features (such as genes) detected in the analysis. This file is essential for identifying what genes or elements were analyzed in each cell.
- `matrix.mtx.gz`: A sparse matrix file in Matrix Market format, representing the gene expression data. It matches the features with their corresponding barcodes and quantifies the expression level.

### `ref_out`
This folder contains the output from the reference preparation step and includes the following key components:
- `fasta`: This directory holds the FASTA files that contain the reference sequences used in the analysis.
- `genes`: This directory may include files related to gene annotations, such as GTF files, crucial for mapping reads to the reference genome.
- `reference.json`: A JSON file that contains metadata and configuration details related to the reference used in the analysis.
- `star`: This directory includes the output from the STAR aligner, which is used for aligning RNA sequences to the reference genome. It may contain indexed files and other data necessary for the alignment process.
- 
### Plots 
- Violin Plots: Show gene expression distribution across different cells.
- Dot Plot: Compare gene expression levels across different cell types.
- Feature Plot: Visualize spatial patterns of gene expression.
- Heatmap: Illustrate gene expression patterns across multiple cells.
- PCA Plot: Provide a view of data structure based on gene expression.
- Ridge Plot: Present smoothed distributions of gene expression.
- tSNE Plot: Depict high-dimensional data in a two-dimensional space.
- UMAP Plot: Visualize cellular distribution in a two-dimensional embedding.

Note: Each file and folder contains specific data visualizations and analysis results pertinent to the scRNA-seq data processed.














