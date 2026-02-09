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
file_paths <- list.files(path = "./Cherry_host", pattern = "\\.tsv$", full.names = TRUE)

# 2. Read all files into a list of data frames using lapply()
list_of_dfs <- lapply(file_paths, function(x) {
  read.delim(file = x, sep = '\t', header = TRUE)
})

# 3. Name the data frames in the list
# list_of_dfs$filename.tsv
names(list_of_dfs) <- basename(file_paths)
names(list_of_dfs)

# --- Code Execution ---

unique_host = c()
unique_host_lineage = c()

for (i in 1:8) {
  df <- list_of_dfs[[i]]
  unique_host[[length(unique_host) + 1]] <- unique(df$Host,)
  unique_host_lineage[[length(unique_host_lineage) + 1]] <- unique(df$Host_NCBI_lineage,)
  print(i)
  print(sum(str_count(df$Host, "Vibrio"), na.rm = TRUE))
}

 # count genus in list_of_dfs[[1]]
df_host <- list_of_dfs[[1]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[1]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[1]][j], sum(df_host==unique_host[[1]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[2]]
df_host <- list_of_dfs[[2]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[2]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[2]][j], sum(df_host==unique_host[[2]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[3]]
df_host <- list_of_dfs[[3]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[3]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[3]][j], sum(df_host==unique_host[[3]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[4]]
df_host <- list_of_dfs[[4]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[4]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[4]][j], sum(df_host==unique_host[[4]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[5]]
df_host <- list_of_dfs[[5]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[5]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[5]][j], sum(df_host==unique_host[[5]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[6]]
df_host <- list_of_dfs[[6]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[6]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[6]][j], sum(df_host==unique_host[[6]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[7]]
df_host <- list_of_dfs[[7]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[7]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[7]][j], sum(df_host==unique_host[[7]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]

# count genus in list_of_dfs[[8]]
df_host <- list_of_dfs[[8]]$Host
df_host_count = data.frame(Host = character(), Count = integer(), stringsAsFactors = FALSE)

for (j in 1:length(unique_host[[8]])) {
  df_host_count[nrow(df_host_count) + 1, ] <- c(unique_host[[8]][j], sum(df_host==unique_host[[8]][j]))
}

df_host_count_sorted <- df_host_count[order(as.numeric(df_host_count$Count), decreasing=TRUE), ]