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

temp_ref <- read_csv(
  "TempClass_reference - Sheet1.csv",
  show_col_types = FALSE
) %>%
  select(species, TempClass) %>%
  filter(!is.na(TempClass), TempClass != "") %>%
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
  as.Date(paste0(
    "20", substr(yymmdd, 1, 2), "-",
    substr(yymmdd, 3, 4), "-",
    substr(yymmdd, 5, 6)
  ))
}

df_s1 <- purrr::map_dfr(files_s1, \(f) {
  read_csv(f, show_col_types = FALSE) %>%
    mutate(
      Date = extract_date(f),
      Sample = "S1"
    )
})

totals_s1 <- df_s1 %>%
  filter(superkingdom %in% c("Bacteria", "Fungi")) %>%
  group_by(Sample, Date) %>%
  summarise(
    TotalReads = sum(total, na.rm = TRUE),
    .groups = "drop"
  )

df_conf_s1 <- df_s1 %>%
  inner_join(temp_ref, by = "species") %>%
  group_by(Sample, Date, species, TempClass, phylum) %>%
  summarise(
    ReadCount = sum(total, na.rm = TRUE),
    .groups = "drop"
  )

keep_species <- df_conf_s1 %>%
  group_by(species, TempClass, phylum) %>%
  summarise(
    MaxReads = max(ReadCount),
    .groups = "drop"
  ) %>%
  filter(MaxReads >= 50) %>%
  select(species, TempClass, phylum)

df_conf_s1 <- df_conf_s1 %>%
  semi_join(keep_species, by = c("species", "TempClass", "phylum"))

df_phylum_s1 <- df_conf_s1 %>%
  group_by(Sample, Date, phylum, TempClass) %>%
  summarise(
    ReadCount = sum(ReadCount),
    .groups = "drop"
  ) %>%
  left_join(totals_s1, by = c("Sample", "Date")) %>%
  mutate(
    Percent = 100 * ReadCount / TotalReads,
    PhylumLine = paste0(phylum, " (", TempClass, ")")
  )

week_labels <- tibble(
  Date = as.Date(c("2024-03-11", "2024-03-25", "2024-04-08", "2024-04-15")),
  WeekLabel = c("Week 1", "Week 3", "Week 5", "Week 6")
)

meso_lines <- df_phylum_s1 %>%
  filter(TempClass == "Mesophilic") %>%
  pull(PhylumLine) %>% unique() %>% sort()

thermo_lines <- df_phylum_s1 %>%
  filter(TempClass == "Thermophilic") %>%
  pull(PhylumLine) %>% unique() %>% sort()

blue_pal <- colorRampPalette(c("#a6cee3", "#1f78b4"))(length(meso_lines))
red_pal  <- colorRampPalette(c("#f4a582", "#b2182b"))(length(thermo_lines))

col_map <- c(
  setNames(blue_pal, meso_lines),
  setNames(red_pal, thermo_lines)
)

legend_order <- c(meso_lines, thermo_lines)

p_s1_phylum <- ggplot(
  df_phylum_s1,
  aes(x = Date, y = Percent, color = PhylumLine, group = PhylumLine)
) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.4) +
  scale_color_manual(
    values = col_map,
    breaks = legend_order,
    labels = gsub(" \\(.*\\)", "", legend_order)
  ) +
  scale_x_date(
    breaks = week_labels$Date,
    labels = week_labels$WeekLabel
  ) +
  labs(
    x = NULL,
    y = "% read in the total read"
  ) +
  my_theme +
  theme(
    legend.position = "right",
    legend.text = element_text(size = 9)
  )

p_s1_phylum

ggsave(
  "Figure3C_Sample1_Phylum_Threshold50_PERCENT.png",
  p_s1_phylum,
  width = 9,
  height = 5,
  dpi = 300
)

