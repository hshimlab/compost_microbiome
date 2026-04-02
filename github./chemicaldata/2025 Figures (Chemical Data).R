library(tidyverse)
library(patchwork)
library(cowplot)

df <- read_csv("chemicaldata.csv")
df$Sample <- factor(df$Sample)

after running lines 1, 2, 3, 5, 6 each at a time, run this for NPK:
  
  
my_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    axis.title = element_text(size = 12, color = "black"),
    axis.text = element_text(size = 10, color = "black", face = "bold"), 
    strip.text = element_text(size = 12, color = "black"),
    plot.title = element_text(hjust = 0.5, color = "black"),
    panel.grid.major = element_line(color = "grey90", size = 0.3),
    panel.grid.minor = element_blank()
  )

p_nitrogen <- ggplot(df, aes(x = Week, y = Nitrogen, color = Sample)) +
  geom_line(size = 1) +
  ggtitle("Nitrogen") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(
    values = c("#b2182b", "#f4a582"),
    labels = c("Sample 1", "Sample 2")
  ) +
  scale_x_continuous(
    breaks = c(1, 3, 5, 6),  
    labels = c("Week 1", "Week 3", "Week 5", "Week 6")
  ) +
  my_theme +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

p_phosphorus <- ggplot(df, aes(x = Week, y = Phosphorus, color = Sample)) +
  geom_line(size = 1) +
  ggtitle("Phosphorus") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(
    values = c("#2166ac", "#92c5de"),
    labels = c("Sample 1", "Sample 2")
  ) +
  scale_x_continuous(
    breaks = c(1, 3, 5, 6),
    labels = c("Week 1", "Week 3", "Week 5", "Week 6")  
  ) +
  my_theme +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

p_potassium <- ggplot(df, aes(x = Week, y = Potassium, color = Sample)) +
  geom_line(size = 1) +
  ggtitle("Potassium") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(
    values = c("#1b7837", "#a6dba0"),
    labels = c("Sample 1", "Sample 2")
  ) +
  scale_x_continuous(
    breaks = c(1, 3, 5, 6),
    labels = c("Week 1", "Week 3", "Week 5", "Week 6")  
  ) +
  my_theme +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

figure1 <- p_nitrogen + p_phosphorus + p_potassium +
  plot_layout(ncol = 3) & 
  theme(axis.title.y = element_blank())


figure1 <- cowplot::ggdraw(figure1) +
  cowplot::draw_label(
    "Percentage",
    x = 0.01, y = 0.5,
    vjust = 0.5, angle = 90,
    size = 11,
    fontface = "bold"
  )

figure1

ggsave("figure1.png", figure1, width = 8, height = 4, dpi = 300)




10/27/25 edit: zincpH graph:

my_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    axis.title = element_text(size = 12, color = "black"),
    axis.text = element_text(size = 10, color = "black", face = "bold"),
    strip.text = element_text(size = 12, color = "black"),
    plot.title = element_text(hjust = 0.5, color = "black"),
    panel.grid.major = element_line(color = "grey90", size = 0.3),
    panel.grid.minor = element_blank()
  )

p_zinc <- ggplot(df, aes(x = Week, y = Zinc, color = Sample)) +
  geom_line(size = 1) +
  ggtitle("Zinc") +
  labs(x = NULL, y = "ppm") +
  scale_color_manual(
    values = c("#6a51a3", "#9e9ac8"),
    labels = c("Sample 1", "Sample 2")
  ) +
  scale_x_continuous(
    breaks = c(1, 3, 5, 6),
    labels = c("Week 1", "Week 3", "Week 5", "Week 6")
  ) +
  my_theme +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_text(face = "bold")
  )

p_ph <- ggplot(df, aes(x = Week, y = pH, color = Sample)) +
  geom_line(size = 1) +
  ggtitle("pH") +
  labs(x = NULL, y = "pH") +
  scale_color_manual(
    values = c("#e6550d", "#fdae6b"),
    labels = c("Sample 1", "Sample 2")
  ) +
  scale_x_continuous(
    breaks = c(1, 3, 5, 6),
    labels = c("Week 1", "Week 3", "Week 5", "Week 6")
  ) +
  my_theme +
  theme(
    plot.title = element_text(hjust = 0.5),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_text(face = "bold")
  )

figure2 <- (plot_spacer() + p_zinc + p_ph + plot_spacer()) +
  plot_layout(ncol = 4, widths = c(0.5, 1, 1, 0.5)) 

figure2

ggsave("figure2.png", figure2, width = 8, height = 4, dpi = 300)

summary(df)
sd(df$Nitrogen, na.rm = TRUE)
sd(df$Phosphorus, na.rm = TRUE)
sd(df$Potassium, na.rm = TRUE)
sd(df$Zinc, na.rm = TRUE)
sd(df$pH, na.rm = TRUE)
