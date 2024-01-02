#!/bin/bash

# Define variables
GENOME_NAME="mm10"
FASTA_PATH="/home/altschul/Music/scRNA/Reference/ensemble/mouse.fa"	## Change the path of the fasta file located in your system 
GTF_PATH="/home/altschul/Music/scRNA/Reference/ensemble/mouse.gtf"	## Change the path of the gtf file located in your system 
CELLRANGER_PATH="/home/altschul/Music/scRNA/cellranger-7.2.0/bin"	## Give the path where the cell ranger located  ex: path/of/the cellranger/bin
FASTQ_PATH="/home/altschul/Music/scRNA/data"				## Change the path of the fastq or fastq.gz file located in your system 
SAMPLE_NAME="SampleName"						## Give the prefix of your name ex: SampleName_S1_001.fq as SampleName
THREADS=20								## Change the threads and memory based on computer requirements
MEMORY=50
OUTPUT_ID="my_sample"

BASE_OUTPUT_DIR="/home/altschul/Music/output" 				## Change the output folder path where the folder has been created already

## After cloning the repository, you will find this R script along with .sh file . Make sure to adjust this path according to your local clone's location.
R_SCRIPT_PATH="/home/altschul/Music/trajectory_analysis.R"			


# Create subdirectories for reference and count outputs
REFERENCE_OUTPUT_DIR="$BASE_OUTPUT_DIR/ref_out"
COUNT_OUTPUT_DIR="$BASE_OUTPUT_DIR/count_out"
mkdir -p $REFERENCE_OUTPUT_DIR
mkdir -p $COUNT_OUTPUT_DIR

# Step 1: Create reference
echo "Creating reference..."
$CELLRANGER_PATH/cellranger mkref --genome=$GENOME_NAME \
                                  --fasta=$FASTA_PATH \
                                  --genes=$GTF_PATH \
                                  --nthreads=$THREADS \
                                  --output-dir=$REFERENCE_OUTPUT_DIR

# Check if mkref was successful
if [ $? -ne 0 ]; then
    echo "Error in creating reference. Exiting."
    exit 1
fi

REFERENCE_PATH="$REFERENCE_OUTPUT_DIR"

# Step 2: Run cellranger count
echo "Running cellranger count..."

$CELLRANGER_PATH/cellranger count --id=$OUTPUT_ID \
                                  --transcriptome=$REFERENCE_PATH \
                                  --fastqs=$FASTQ_PATH \
                                  --sample=$SAMPLE_NAME \
                                  --localcores=$THREADS \
                                  --localmem=$MEMORY \
                                  --output-dir=$COUNT_OUTPUT_DIR

# Check if count was successful
if [ $? -ne 0 ]; then
    echo "Error in cellranger count. Exiting."
    exit 1
fi

# Install R packages
echo "Installing R packages..."
Rscript -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
Rscript -e "install.packages('optparse', repos='http://cran.rstudio.com/')"


# Step 3: Run Seurat analysis in R
echo "Path being passed to R script: $COUNT_OUTPUT_DIR/outs/filtered_feature_bc_matrix"
Rscript "$R_SCRIPT_PATH" "$COUNT_OUTPUT_DIR/outs/filtered_feature_bc_matrix" "$BASE_OUTPUT_DIR"


echo "Pipeline completed successfully."
