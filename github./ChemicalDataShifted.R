library(tidyverse)
library(patchwork)
library(cowplot)


shiftdata <- read_csv("chemicaldata(shifted).csv")
shiftdata$Sample <- factor(shiftdata$Sample, labels = c("1", "2"))


After running 1, 2, 3, 6, 7, first, each at a time, run this for NPK:
  

my_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    legend.title = element_blank(),
    legend.justification = "center",
    legend.box.just = "center",
    axis.title = element_text(size = 12, color = "black"),
    axis.text  = element_text(size = 10, color = "black", face = "bold"),
    strip.text = element_text(size = 12, color = "black"),
    plot.title = element_text(hjust = 0.5, color = "black"),
    panel.grid.major = element_line(color = "grey90", size = 0.3),
    panel.grid.minor = element_blank()
  )

p_nitrogen <- ggplot(shiftdata, aes(x = Week, y = Nitrogen, color = factor(Sample))) +
  geom_line(size = 1) +
  ggtitle("Nitrogen") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c("#b2182b", "#f4a582"),
                     labels = c("Sample 1", "Sample 2")) +
  scale_x_continuous(breaks = c(1,3,5,6),
                     labels = c("Week 1","Week 3","Week 5","Week 6")) +
  my_theme +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

p_phosphorus <- ggplot(shiftdata, aes(x = Week, y = Phosphorus, color = factor(Sample))) +
  geom_line(size = 1) +
  ggtitle("Phosphorus") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c("#2166ac", "#92c5de"),
                     labels = c("Sample 1", "Sample 2")) +
  scale_x_continuous(breaks = c(1,3,5,6),
                     labels = c("Week 1","Week 3","Week 5","Week 6")) +
  my_theme +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

p_potassium <- ggplot(shiftdata, aes(x = Week, y = Potassium, color = factor(Sample))) +
  geom_line(size = 1) +
  ggtitle("Potassium") +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c("#1b7837", "#a6dba0"),
                     labels = c("Sample 1", "Sample 2")) +
  scale_x_continuous(breaks = c(1,3,5,6),
                     labels = c("Week 1","Week 3","Week 5","Week 6")) +
  my_theme +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_blank()
  )

figure1 <- (p_nitrogen + p_phosphorus + p_potassium) +
  plot_layout(ncol = 3) &
  theme(legend.position = "top")

figure1 <- cowplot::ggdraw(figure1) +
  cowplot::draw_label(
    "Percentage",
    x = 0.01, y = 0.5,
    vjust = 0.5, angle = 90,
    size = 11, fontface = "bold"
  )

figure1

ggsave("figure1.png", figure1, width = 8, height = 4, dpi = 300)




10/27/25 edit: zincpH graph:
  


my_theme <- theme_minimal(base_size = 12) +
  theme(
    legend.title = element_blank(),
    axis.title = element_text(size = 12, color = "black"),
    axis.text  = element_text(size = 10, color = "black", face = "bold"),
    strip.text = element_text(size = 12, color = "black"),
    plot.title = element_text(hjust = 0.5, color = "black"),
    panel.grid.major = element_line(color = "grey90", size = 0.3),
    panel.grid.minor = element_blank()
  )

p_zinc <- ggplot(shiftdata, aes(x = Week, y = Zinc, color = Sample)) +
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
    legend.position = "top",
    legend.justification = "center",
    legend.direction = "horizontal",
    legend.box.just = "center",
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_text(face = "bold")
  )

p_ph <- ggplot(shiftdata, aes(x = Week, y = pH, color = Sample)) +
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
    legend.position = "top",
    legend.justification = "center",
    legend.direction = "horizontal",
    legend.box.just = "center",
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 7),
    axis.title.y = element_text(face = "bold")
  )

figure_shifted <- (plot_spacer() + p_zinc + p_ph + plot_spacer()) +
  plot_layout(ncol = 4, widths = c(0.5, 1, 1, 0.5))

figure_shifted

ggsave("figure_shifted.png", figure_shifted, width = 8, height = 4, dpi = 300)

summary(shiftdata)
sd(shiftdata$Nitrogen, na.rm = TRUE)
sd(shiftdata$Phosphorus, na.rm = TRUE)
sd(shiftdata$Potassium, na.rm = TRUE)
sd(shiftdata$Zinc, na.rm = TRUE)
sd(shiftdata$pH, na.rm = TRUE)
