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
file_paths <- list.files(path = "./PhaMer_identification", pattern = "\\.tsv$", full.names = TRUE)

# 2. Read all files into a list of data frames using lapply()
list_of_dfs <- lapply(file_paths, function(x) {
  read.delim(file = x, sep = '\t', header = TRUE)
})

# 3. Name the data frames in the list
# list_of_dfs$filename.tsv
names(list_of_dfs) <- basename(file_paths)
names(list_of_dfs)

# --- Code Execution ---

# check dimensions
for (i in 1:8) {
  print(names(list_of_dfs[i]))
  virus = sum(list_of_dfs[[i]] == "virus")
  print(virus)
  non_virus = sum(list_of_dfs[[i]] == "non-virus")
  print(non_virus)
  filtered = sum(list_of_dfs[[i]] == "filtered")
  print(filtered)
  print(dim(list_of_dfs[[i]])[1])
  print(dim(list_of_dfs[[i]])[1] - virus - non_virus - filtered)
}

#Visualize virus length with boxplot
name = names(list_of_dfs)
list_of_dfs_virus = c()
for (i in 1:8) {
  df <- list_of_dfs[[i]]
  list_of_dfs_virus[[length(list_of_dfs_virus) + 1]] <- df[df$Pred=="virus",]
}

column_2_purrr_list <- map(list_of_dfs_virus, 2)

data <- data.frame(
  name=c( rep("W1_S1",dim(list_of_dfs_virus[[1]])[1]), rep("W1_S2",dim(list_of_dfs_virus[[2]])[1]), rep("W3_S1",dim(list_of_dfs_virus[[3]])[1]), rep("W3_S2",dim(list_of_dfs_virus[[4]])[1]), rep("W5_S1", dim(list_of_dfs_virus[[5]])[1]), rep("W5_S2", dim(list_of_dfs_virus[[6]])[1]), rep("W6_S1", dim(list_of_dfs_virus[[7]])[1]), rep("W6_S2", dim(list_of_dfs_virus[[8]])[1])  ),
  value=c( column_2_purrr_list[[1]],column_2_purrr_list[[2]],column_2_purrr_list[[3]],column_2_purrr_list[[4]],column_2_purrr_list[[5]],column_2_purrr_list[[6]],column_2_purrr_list[[7]],column_2_purrr_list[[8]] )
)

#summary(column_2_purrr_list[[8]])

png(filename = "PhaMer_identification_nolimit.png", width = 1200, height = 600, units = "px")

data %>%
  ggplot( aes(x=name, y=value, fill=name) ) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
  theme_bw() +
  theme(
    legend.position="none",
    text = element_text(size=18)
  ) +
  ggtitle("") +
  xlab("") +
  ylab("")
  #ylim(0,50000)

dev.off()

#near-complete genomes
df <- list_of_dfs_virus[[8]]
max_row <- df[df$Length > 40000, ] #df[df$Length == max(df$Length), ]
print(max_row)