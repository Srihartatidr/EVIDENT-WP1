library(ggplot2)
library(dplyr)

dfsens <- data.frame(
  Category = factor(c("Culture", "Xpert sputum", "Composite", "Treatment decision"),
                    levels = c("Culture", "Xpert sputum", "Composite", "Treatment decision")),
  Sensitivity = c(68.8, 64.5, 59.8, 41.0),
  CI_low = c(64.0, 59.5, 54.7, 35.5),
  CI_high = c(73.7, 69.5, 64.9, 46.5),
  TP = c(64, 69, 70, 57),
  FN = c(29, 38, 47, 82)
)

dfsens <- dfsens %>%
  mutate(SensLabel = sprintf("%.0f/%.0f                %.1f (%.1f–%.1f)",
                             TP, TP + FN, Sensitivity, CI_low, CI_high))

p_sens <- ggplot(data = dfsens, aes(x = Sensitivity, y = Category)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.2) +
  geom_text(aes(x = 108, label = SensLabel), hjust = 0, size = 5) +
  annotate("text", x = 108, y = 4.2,
           label = "TP / (TP + FN)    Sensitivity (95% CI)",
           hjust = 0, size = 5, fontface = "bold") +
  geom_vline(xintercept = 100, color = "gray80", size = 0.4) +
  scale_x_continuous(limits = c(0, 155), breaks = seq(0, 100, 25), expand = c(0, 0)) +
  labs(
    title = "Sensitivity of Pluslife tongue swab (15-second sampling) in adults,\n by reference standard categories",
    x = "Sensitivity (% with 95% CI)",
    y = NULL
  ) +
  theme_minimal(base_size = 15) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    panel.grid.major.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.x = element_line(color = "black", linewidth = 0.5),
    axis.text.y = element_text(size = 15),
    axis.text.x = element_text(size = 15),
    axis.title.x = element_text(size = 15, margin = margin(t = 15)),
    plot.margin = margin(2, 2, 2, 2)
  )

# View plot
print(p_sens)

# Save the result as a compact high-res image
ggsave("D:/Coding/sens pluslife ts 15s adult with tp.png", plot = p1, width = 15.0, height = 8.0, dpi = 300)