install.packages("BiocManager")
BiocManager::install("Seurat")


library(Seurat)
library(optparse)
library(ggplot2)

# Set up argument parsing
option_list = list(
  make_option(c("-d", "--data_path"), type = "character", default = NULL, 
              help = "Directory path to the Seurat data", metavar = "character"),
  make_option(c("-o", "--output_dir"), type = "character", default = NULL,
              help = "Directory path for output files", metavar = "character")
)


# Get the command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check if arguments are provided and update paths
if (length(args) >= 2) {
  data_path <- args[1]
  output_dir <- args[2]
}

# Print the arguments for debugging
print(paste("Data path:", data_path))
print(paste("Output directory:", output_dir))

# Load the data
seurat.data <- Read10X(data.dir = data_path)

# Create a Seurat object
seurat.obj <- CreateSeuratObject(counts = seurat.data, project = "SampleProject")

# Identify mitochondrial genes (adjust based on your dataset)
mito.genes <- grep("^MT-", rownames(seurat.obj), value = TRUE)

# Calculate the percentage of mitochondrial gene expression
seurat.obj[['percent.mt']] <- PercentageFeatureSet(seurat.obj, features = mito.genes)

# Basic filtering
seurat.obj <- subset(seurat.obj, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

# Normalization
seurat.obj <- NormalizeData(seurat.obj)

# Find highly variable features
seurat.obj <- FindVariableFeatures(seurat.obj, selection.method = "vst", nfeatures = 2000)

# Scale the data
seurat.obj <- ScaleData(seurat.obj)

# Perform PCA
seurat.obj <- RunPCA(seurat.obj, features = VariableFeatures(object = seurat.obj))

# Clustering
seurat.obj <- FindNeighbors(seurat.obj, dims = 1:10)
seurat.obj <- FindClusters(seurat.obj, resolution = 0.5)

# Perform t-SNE
seurat.obj <- RunTSNE(seurat.obj, dims = 1:10)

# Perform UMAP
seurat.obj <- RunUMAP(seurat.obj, dims = 1:10)

# Visualization and saving plots

# Plot t-SNE and save
tsne.plot <- DimPlot(seurat.obj, reduction = "tsne")
ggsave(file.path(output_dir, "tSNE_plot.pdf"), tsne.plot)

# Plot UMAP and save
umap.plot <- DimPlot(seurat.obj, reduction = "umap")
ggsave(file.path(output_dir, "UMAP_plot.pdf"), umap.plot)

# Get top 10 or 20 variable genes
top.genes <- head(VariableFeatures(seurat.obj), 20)

# Generate a Dot Plot for the top variable genes
dot.plot <- DotPlot(seurat.obj, features = top.genes) + RotatedAxis()

# Save the Dot Plot
ggsave(file.path(output_dir, "DotPlot.pdf"), plot = dot.plot, width = 10, height = 4)

# Generate a Violin Plot for each of the top variable genes
for (gene in top.genes) {
  violin.plot <- VlnPlot(seurat.obj, features = gene, ncol = 1)
  # Save the Violin Plot
  ggsave(file.path(output_dir, paste0("ViolinPlot_", gene, ".pdf")), plot = violin.plot, width = 3, height = 4)
}

# Generate a Dot Plot for the top variable genes
dot.plot <- DotPlot(seurat.obj, features = top.genes) + RotatedAxis()

# Save the Dot Plot
ggsave(file.path(output_dir, "DotPlot.pdf"), plot = dot.plot, width = 10, height = 4)

# Plot PCA and save
pca.plot <- DimPlot(seurat.obj, reduction = "pca")
ggsave(file.path(output_dir, "PCA_plot.pdf"), pca.plot)

# Heatmap of top variable genes
heatmap.plot <- DoHeatmap(seurat.obj, features = top.genes)
ggsave(file.path(output_dir, "Heatmap.pdf"), heatmap.plot)

# Ridge plot for gene expression across clusters
ridge.plot <- RidgePlot(seurat.obj, features = top.genes, ncol = 2)
ggsave(file.path(output_dir, "RidgePlot.pdf"), ridge.plot)

# Feature plot for a specific gene
# Replace 'GeneName' with the gene you are interested in
feature.plot <- FeaturePlot(seurat.obj, features = top.genes)
ggsave(file.path(output_dir, "FeaturePlot_GeneName.pdf"), feature.plot)

# Optionally, you can also save the Seurat object for future use
saveRDS(seurat.obj, file.path(output_dir, "seurat_object.rds"))

