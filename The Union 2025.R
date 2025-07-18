library(ggplot2)
library(dplyr)

dfunion <- data.frame(
  Category = factor(c("15-second sampling duration", "30-second sampling duration"),
                    levels = c("15-second sampling duration", "30-second sampling duration")),
  Sensitivity = c(68.8, 94.4),
  CI_low = c(64.4, 90.6),
  CI_high = c(73.3, 98.3),
  TP = c(64, 17),
  FN = c(29, 1)
)

dfunion <- dfunion %>%
  mutate(UnionLabel = sprintf("%.0f/%.0f                  %.1f (%.1f–%.1f)",
                             TP, TP + FN, Sensitivity, CI_low, CI_high))

p_union <- ggplot(data = dfunion, aes(x = Sensitivity, y = Category)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.2) +
  geom_text(aes(x = 105, label = UnionLabel), hjust = 0, size = 5) +
  annotate("text", x = 105, y = 2.2,
           label = "TP / (TP + FN)    Sensitivity (95% CI)",
           hjust = 0, size = 5, fontface = "bold") +
  geom_vline(xintercept = 100, color = "gray80", size = 0.4) +
  scale_x_continuous(limits = c(50, 140), breaks = seq(0, 100, 25), expand = c(0, 0)) +
  labs(
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
    plot.margin = unit(c(1, 1, 1, 1), "cm")  # top, right, bottom, left
  )

# View plot
print(p_union)

# Save the result as a compact high-res image
ggsave("D:/Coding/union sens pluslife ts 15s 30s.png", plot = p_union, width = 14.0, height = 4.0, dpi = 300)

# Specificity plot
dfunion2 <- data.frame(
  Category = factor(c("15-second sampling duration", "30-second sampling duration"),
                    levels = c("15-second sampling duration", "30-second sampling duration")),
  Specificity = c(98.2, 99.2),
  CI_low = c(96.9, 97.6),
  CI_high = c(99.5, 100.7),
  TN = c(320, 118),
  FP = c(6, 1)
)









dfunion2 <- dfunion2 %>%
  mutate(Union2Label = sprintf("%.0f/%.0f                  %.1f (%.1f–%.1f)",
                             TN, TN + FP, Specificity, CI_low, CI_high))

p_union2 <- ggplot(data = dfunion2, aes(x = Specificity, y = Category)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.2) +
  geom_text(aes(x = 105, label = Union2Label), hjust = 0, size = 5) +
  annotate("text", x = 105, y = 2.2,
           label = "TN / (TN + FP)    Specificity (95% CI)",
           hjust = 0, size = 5, fontface = "bold") +
  geom_vline(xintercept = 100, color = "gray80", size = 0.4) +
  scale_x_continuous(limits = c(50, 140), breaks = seq(0, 100, 25), expand = c(0, 0)) +
  labs(
    x = "Specificity (% with 95% CI)",
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
    plot.margin = unit(c(1, 1, 1, 1), "cm")  # top, right, bottom, left
  )

# View plot
print(p_union2)

# Save the result as a compact high-res image
ggsave("D:/Coding/union2.png", plot = p_union2, width = 14.0, height = 4.0, dpi = 300)
