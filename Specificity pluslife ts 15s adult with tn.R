library(ggplot2)
library(dplyr)

dfspec <- data.frame(
  Category = factor(c("Culture", "Xpert sputum", "Composite", "Treatment decision"),
                    levels = c("Culture", "Xpert sputum", "Composite", "Treatment decision")),
  Specificity = c(97.7, 99.2, 99.6, 100),
  CI_low = c(96.1, 98.3, 98.9, 100),
  CI_high = c(99.3, 100.1, 100.2, 100),
  TN = c(252, 244, 239, 165),
  FP = c(6, 2, 1, 0)
)

dfspectn <- dfspec %>%
  mutate(SpecLabel = sprintf("%.0f/%.0f                %.1f (%.1f–%.1f)",
                             TN, TN + FP, Specificity, CI_low, CI_high))

p_spec <- ggplot(data = dfspectn, aes(x = Specificity, y = Category)) +
  geom_point(size = 3) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.2) +
  geom_text(aes(x = 108, label = SpecLabel), hjust = 0, size = 5) +
  annotate("text", x = 108, y = 4.2,
           label = "TN / (TN + FP)    Specificity (95% CI)",
           hjust = 0, size = 5, fontface = "bold") +
  geom_vline(xintercept = 100, color = "gray80", size = 0.4) +
  scale_x_continuous(limits = c(0, 155), breaks = seq(0, 100, 25), expand = c(0, 0)) +
  labs(
    title = "Specificity of Pluslife tongue swab (15-second sampling) in adults,\n by reference standard categories",
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
    plot.margin = margin(2, 2, 2, 2)
  )

# View plot
print(p_spec)

# Save the result as a compact high-res image
ggsave("D:/Coding/spec pluslife ts 15s adult with tp.png", plot = p1, width = 15.0, height = 8.0, dpi = 300)
