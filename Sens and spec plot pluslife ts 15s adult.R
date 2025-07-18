# install.packages("patchwork")  # if not already installed
library(ggplot2)
library(dplyr)
library(patchwork)

df <- data.frame(
  Category = factor(c("Culture", "Xpert sputum", "Composite", "Treatment decision"),
                    levels = c("Culture", "Xpert sputum", "Composite", "Treatment decision")),
  Sensitivity = c(68.8, 64.5, 59.8, 41.0),
  Sens_low = c(64.0, 59.5, 54.7, 35.5),
  Sens_high = c(73.7, 69.5, 64.9, 46.5),
  Specificity = c(97.7, 99.2, 99.6, 100),
  Spec_low = c(96.1, 98.2, 98.9, 100),
  Spec_high = c(99.3, 100, 100.2, 100)
)

df <- df %>%
  mutate(y_pos = c(2.25, 2.0, 1.75, 1.5))

# Sensitivity plot
p1 <- ggplot(df, aes(x = Sensitivity, y = y_pos)) +
  geom_point( size = 0.3) +
  geom_errorbarh(aes(xmin = Sens_low, xmax = Sens_high), height = 0.03, linewidth = 0.3) +
  geom_rect(aes(xmin = 100, xmax = Inf, ymin = -Inf, ymax = Inf),
            fill = "white", color = NA) +  # ⬅️ mask area beyond 100
  geom_text(aes(x = 135, label = sprintf("%.1f (%.1f–%.1f)", Sensitivity, Sens_low, Sens_high)),
            hjust = 1, size = 1.7) +
  geom_vline(xintercept = 100, color = "gray80", size = 0.2, linetype = "solid") +
  scale_x_continuous(limits = c(0, 135), breaks = seq(0, 100, by = 25)) +
  scale_y_continuous(breaks = df$y_pos, labels = df$Category, expand = c(0.01, 0.01)) +
  labs(x = "Sensitivity (%)", y = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major.x = element_line(color = "gray80", size = 0.2),  # ✅ show x-grid
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(size = 5, face = "bold", margin = margin(r=-2), hjust = 1),
    axis.ticks.length = unit(1, "pt"), 
    axis.text.x = element_text(size = 5, face = "bold"),
    axis.title.x = element_text(size = 5, margin = margin(t = 10)),
    axis.line.x = element_line(color = "gray60", size = 0.3),
    plot.title = element_text(size = 5, hjust = 0.5),
    plot.margin = margin(2, 2, 2, 2)
  )

# Specificity plot
p2 <- ggplot(df, aes(x = Specificity, y = y_pos)) +
  geom_point( size = 0.3) +
  geom_errorbarh(aes(xmin = Spec_low, xmax = Spec_high), height = 0.03, linewidth = 0.3) +
  geom_rect(aes(xmin = 100, xmax = Inf, ymin = -Inf, ymax = Inf),
            fill = "white", color = NA) +  # ⬅️ mask area beyond 100
  geom_text(aes(x = 142, label = sprintf("%.1f (%.1f–%.1f)", Specificity, Spec_low, Spec_high)),
            hjust = 1, size = 1.7) +
  geom_vline(xintercept = 100, color = "gray80", size = 0.2, linetype = "solid") +
  scale_x_continuous(limits = c(0, 142), breaks = seq(0, 100, by = 25)) +
  scale_y_continuous(breaks = df$y_pos, labels = NULL) +
  labs(x = "Specificity (%)", y = NULL) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.major.x = element_line(color = "gray80", size = 0.2),  # ✅ show x-grid
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(size = 5, face = "bold", margin = margin(r = -2), hjust = 1),
    axis.ticks.length = unit(1, "pt"), 
    axis.ticks.y = element_blank(),
    axis.text.x = element_text(size = 5, face = "bold"),
    axis.title.x = element_text(size = 5, margin = margin(t = 10)),
    axis.line.x = element_line(color = "gray60", size = 0.3),
    plot.title = element_text(size = 5, hjust = 0.5),
    plot.margin = margin(2, 2, 2, 2)
  )

# combine the plot
combined_plot <- p1 + p2 + plot_layout(ncol = 2)

# Show the plot
print(combined_plot)

# Save the result as a compact high-res image
ggsave("D:/Coding/compact_forestplot.png", plot = combined_plot, width = 5.0, height = 2.5, dpi = 300)
