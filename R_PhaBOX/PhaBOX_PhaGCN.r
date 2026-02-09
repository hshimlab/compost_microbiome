# Description: Visualize PhaBOX data (PhaMer identification)
# Author: Hyunjin Shim
# Version: 2026-01-04

# Environment Setup
rm(list = ls()) # Clear the workspace

# Load necessary libraries
#install.packages("tidyverse")
#install.packages("hrbrthemes")
#install.packages("viridis")
library(tidyverse)
#library(hrbrthemes)
library(viridis)
library(ggplot2) 

# Define Parameters (if any variables need easy modification at the top)

# 1. Get a list of all TSV file paths in your directory
file_paths <- list.files(path = "./PhaGCN_taxonomy", pattern = "\\.tsv$", full.names = TRUE)

# 2. Read all files into a list of data frames using lapply()
list_of_dfs <- lapply(file_paths, function(x) {
  read.delim(file = x, sep = '\t', header = TRUE)
})

# 3. Name the data frames in the list
# list_of_dfs$filename.tsv
names(list_of_dfs) <- basename(file_paths)
names(list_of_dfs)

# --- Code Execution ---

#Visualize virus length with boxplot
name = names(list_of_dfs)
unique_tax = c()
unique_genus = c()

for (i in 1:7) {
  df <- list_of_dfs[[i]]
  unique_tax[[length(unique_tax) + 1]] <- unique(df$Lineage,)
  unique_genus[[length(unique_genus) + 1]] <- unique(df$Genus,)
}

# count genus in list_of_dfs[[1]]
df_genus <- list_of_dfs[[1]]$Genus
df_genus_count = data.frame(Genus = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_genus[[1]])) {
  df_genus_count[nrow(df_genus_count) + 1, ] <- c(unique_genus[[1]][j], sum(df_genus==unique_genus[[1]][j]))
}

df_genus_count_sorted <- df_genus_count[order(as.numeric(df_genus_count$Count), decreasing=TRUE), ]
