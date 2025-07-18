library(ggplot2)
library(dplyr)

# Load the data
dfsens <- data.frame (
  Category = factor(c("Culture", "Xpert sputum", "Composite", "Treatment decision"),
                    levels = c("Culture", "Xpert sputum", "Composite", "Treatment decision")),
  Sensitivity = c(68.8, 64.5, 59.8, 41.0),
  CI_low = c(64.0, 59.5, 54.7, 35.5),
  CI_high = c(73.7, 69.5, 64.9, 46.5)
)

# Create label column
dfsens <- dfsens %>%
  mutate(Label = sprintf("%.2f (%.2f, %.2f)", Sensitivity, CI_low, CI_high))

# Plot
p1 <- ggplot(dfsens, aes(x = Sensitivity, y = Category)) +
  geom_point() +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.2) +
  geom_text(aes(x = 105, label = Label), hjust = 1, size = 5) +  # Right-align at fixed position
  scale_x_continuous(limits = c(0, 110), expand = c(0, 0)) +
  labs(
    title = "Sensitivity of Pluslife tongue swab (15 second sampling duration) in adult,\nacross reference standards categories",
    x = "Sensitivity, % (95% CI)",
    y = NULL
  ) +
  theme_minimal(base_size = 15) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    panel.grid.major.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.x = element_line(color = "black", linewidth = 0.5),  # ✅ horizontal x-axis line
    axis.text.y = element_text(size = 15),
    axis.title.x = element_text(size = 15, margin = margin(t = 15)), # Increase 
    axis.text.x = element_text(size = 15) # x-axis tick values (e.g., 0, 25, 50)
  )

# Save the result as a compact high-res image
ggsave("D:/Coding/sens pluslife ts 15s adult.png", plot = p1, width = 10.0, height = 4.0, dpi = 300)