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
file_paths <- list.files(path = "./PhaTYP_lifestyle", pattern = "\\.tsv$", full.names = TRUE)

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
  virulent = sum(list_of_dfs[[i]] == "virulent")
  print(virulent)
  temperate = sum(list_of_dfs[[i]] == "temperate")
  print(temperate)
  empty = sum(list_of_dfs[[i]] == "-")
  print(empty)
  filtered = sum(list_of_dfs[[i]] == "filtered")
  print(filtered)
  print(dim(list_of_dfs[[i]])[1])
  print(dim(list_of_dfs[[i]])[1] - virulent - temperate - empty - filtered)
}

#Visualize virus length with boxplot

list_of_dfs_virulent = c()
for (i in 1:8) {
  df <- list_of_dfs[[i]]
  list_of_dfs_virulent[[length(list_of_dfs_virulent) + 1]] <- df[df$TYPE=="virulent",]
}

list_of_dfs_temperate = c()
for (i in 1:8) {
  df <- list_of_dfs[[i]]
  list_of_dfs_temperate[[length(list_of_dfs_temperate) + 1]] <- df[df$TYPE=="temperate",]
}


column_2_purrr_list_temperate <- map(list_of_dfs_temperate, 2)

data <- data.frame(
  name=c( rep("W1_S1",dim(list_of_dfs_temperate[[1]])[1]), rep("W1_S2",dim(list_of_dfs_temperate[[2]])[1]), rep("W3_S1",dim(list_of_dfs_temperate[[3]])[1]), rep("W3_S2",dim(list_of_dfs_temperate[[4]])[1]), rep("W5_S1", dim(list_of_dfs_temperate[[5]])[1]), rep("W5_S2", dim(list_of_dfs_temperate[[6]])[1]), rep("W6_S1", dim(list_of_dfs_temperate[[7]])[1]), rep("W6_S2", dim(list_of_dfs_temperate[[8]])[1])  ),
  value=c( column_2_purrr_list_temperate[[1]],column_2_purrr_list_temperate[[2]],column_2_purrr_list_temperate[[3]],column_2_purrr_list_temperate[[4]],column_2_purrr_list_temperate[[5]],column_2_purrr_list_temperate[[6]],column_2_purrr_list_temperate[[7]],column_2_purrr_list_temperate[[8]] )
)

#summary(column_2_purrr_list_temperate[[8]])

png(filename = "PhaTYP_temperate.png", width = 800, height = 600, units = "px")

data %>%
  ggplot( aes(x=name, y=value, fill=name) ) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
  theme_bw() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("") +
  xlab("") +
  ylab("") +
  ylim(0,50000)

dev.off()


column_2_purrr_list_virulent <- map(list_of_dfs_virulent, 2)

data <- data.frame(
  name=c( rep("W1_S1",dim(list_of_dfs_virulent[[1]])[1]), rep("W1_S2",dim(list_of_dfs_virulent[[2]])[1]), rep("W3_S1",dim(list_of_dfs_virulent[[3]])[1]), rep("W3_S2",dim(list_of_dfs_virulent[[4]])[1]), rep("W5_S1", dim(list_of_dfs_virulent[[5]])[1]), rep("W5_S2", dim(list_of_dfs_virulent[[6]])[1]), rep("W6_S1", dim(list_of_dfs_virulent[[7]])[1]), rep("W6_S2", dim(list_of_dfs_virulent[[8]])[1])  ),
  value=c( column_2_purrr_list_virulent[[1]],column_2_purrr_list_virulent[[2]],column_2_purrr_list_virulent[[3]],column_2_purrr_list_virulent[[4]],column_2_purrr_list_virulent[[5]],column_2_purrr_list_virulent[[6]],column_2_purrr_list_virulent[[7]],column_2_purrr_list_virulent[[8]] )
)

#summary(column_2_purrr_list_virulent[[8]])

png(filename = "PhaTYP_virulent.png", width = 800, height = 600, units = "px")

data %>%
  ggplot( aes(x=name, y=value, fill=name) ) +
  geom_boxplot() +
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
  theme_bw() +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("") +
  xlab("") +
  ylab("") +
  ylim(0,50000)

dev.off()

png(filename = "PhaTYP_W6_S2.png", width = 600, height = 600, units = "px")

data <- data.frame(
  type = c( rep("temperate", length(column_2_purrr_list_temperate[[8]])), rep("virulent", length(column_2_purrr_list_virulent[[8]])) ),
  value = c( column_2_purrr_list_temperate[[8]], column_2_purrr_list_virulent[[8]] )
)

data %>%
  ggplot( aes(x=value, fill=type)) +
  geom_histogram( color="#e9ecef", alpha=0.6, position = 'identity',binwidth = 1000) +
  scale_fill_manual(values=c("#69b3a2", "#404080")) +
  theme_minimal(base_size = 22) +
  labs(fill="") +
  xlab("Length") +
  ylab("") +
  xlim(0,50000)

dev.off()