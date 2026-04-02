setwd("/Users/angelmontes/Downloads/mesophilic_thermophilic")

library(tidyverse)

my_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.title = element_blank(),
    axis.title = element_text(size = 12, color = "black"),
    axis.text  = element_text(size = 10, color = "black", face = "bold"),
    strip.text = element_text(size = 12, color = "black"),
    plot.title = element_text(hjust = 0.5, color = "black"),
    panel.grid.major = element_line(color = "grey90", linewidth = 0.3),
    panel.grid.minor = element_blank()
  )

temp_ref <- read_csv("TempClass_reference - Sheet1.csv",
                     show_col_types = FALSE) %>%
  select(species, TempClass) %>%
  mutate(
    species = as.character(species),
    TempClass = as.character(TempClass)
  )

files_s1 <- list.files(
  path = "kraken sample 1",
  pattern = "\\.csv$",
  full.names = TRUE
)

extract_date <- function(x) {
  yymmdd <- stringr::str_match(basename(x), "-(\\d{6})_")[, 2]
  as.Date(paste0("20", substr(yymmdd, 1, 2), "-",
                 substr(yymmdd, 3, 4), "-",
                 substr(yymmdd, 5, 6)))
}

df_s1 <- purrr::map_dfr(files_s1, \(f) {
  read_csv(f, show_col_types = FALSE) %>%
    mutate(
      SourceFile = basename(f),
      Date = extract_date(f),
      Sample = "S1"
    )
})

df_sum_s1 <- df_s1 %>%
  left_join(temp_ref, by = "species") %>%
  filter(!is.na(TempClass)) %>%   
  group_by(Sample, Date, TempClass) %>%
  summarise(ReadCount = sum(total, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    TempClass = factor(TempClass, levels = c("Mesophilic", "Thermophilic"))
  )

week_labels <- tibble(
  Date = as.Date(c("2024-03-11", "2024-03-25", "2024-04-08", "2024-04-15")),
  Week = factor(c("Week 1", "Week 3", "Week 5", "Week 6"),
                levels = c("Week 1", "Week 3", "Week 5", "Week 6"))
)

df_sum_s1 <- df_sum_s1 %>%
  left_join(week_labels, by = "Date")

p_s1 <- ggplot(df_sum_s1,
               aes(x = Week, y = ReadCount, color = TempClass, group = TempClass)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2.6) +
  scale_color_manual(values = c("Mesophilic" = "#1f78b4",
                                "Thermophilic" = "#b2182b")) +
  labs(
    title = "Sample 1: Temporal changes in mesophilic vs thermophilic species",
    x = "Composting week",
    y = "% read in the total read"
  ) +
  my_theme +
  theme(
    legend.position = "top",
    legend.text = element_text(size = 12)
  )

p_s1

files_s1

ggsave("Figure3C_Sample1_Meso_vs_Thermo.png", p_s1, width = 7, height = 5, dpi = 300)

