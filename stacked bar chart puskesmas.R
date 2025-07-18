library(ggplot2)
library(dplyr)
library(ggtext)  # for rich text support

# 1. Data
df <- data.frame(
  Site = c("PKM Ahmad Yani", "PKM Ahmad Yani", "PKM Astana Anyar", "PKM Astana Anyar", "PKM Cigadung", "PKM Cigadung", "PKM Cijagra Baru", "PKM Cijagra Baru", "PKM Cijagra Lama", "PKM Cijagra Lama", "PKM Cipaku", "PKM Cipaku", "PKM Ciumbuleuit", "PKM Ciumbuleuit", "PKM Gumuruh", "PKM Gumuruh", "PKM Neglasari", "PKM Neglasari", "PKM Pagarsih", "PKM Pagarsih", "PKM Pelindung Hewan", "PKM Pelindung Hewan", "PKM Suryalaya", "PKM Suryalaya"),
  AgeGroup = c("Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+"),
  Count = c(3, 39, 3, 11, 3, 3, 0, 1, 2, 12, 0, 4, 3, 15, 3, 8, 5, 28, 0, 17, 10, 64, 0, 7)
)

# 2. Compute midpoint for centered label
df <- df %>%
  group_by(Site) %>%
  arrange(Site, desc(AgeGroup)) %>%
  mutate(
    Label = paste0(Count),
    Midpoint = cumsum(Count) - Count / 2
  )

# 3. Compute max site total for y-axis expansion
df_site_total <- df %>%
  group_by(Site) %>%
  summarise(Total = sum(Count), .groups = "drop")

# 4. Plot
stacked <- ggplot(df, aes(x = Site, y = Count, fill = AgeGroup)) +
  geom_bar(stat = "identity", width = 0.9) +
  ggtext::geom_richtext(
    data = df %>% filter(Count > 0),
    aes(x = Site, y = Midpoint, label = Label, fill = AgeGroup),
    inherit.aes = FALSE,
    fill = NA, label.color = NA,
    hjust = 0.5,
    size = 4
  ) +
  coord_flip() +
  scale_fill_manual(
    values = c("Aged 15+" = "#A2B5CD", "Aged 0-14" = "#CD8C95")
  ) +
  labs(
    title = "Distribution of Patient Recruitment by Age Group and Recruitment Sites",
    x = "Recruitment Sites",
    y = "Number of Patients Enrolled",
    fill = "Age Group (in years)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    axis.text.x = element_text(face = "bold"),
    axis.text.y = element_text(face = "bold"),
    axis.line.x = element_line(color = "black", size = 0.3),
    axis.line.y = element_line(color = "black", size = 0.3)
  ) +
  expand_limits(y = max(df_site_total$Total) + 10)

# 5. Save and show
ggsave("D:/Coding/stacked_bar_patient_distribution.png", plot = stacked,
       width = 12.0, height = 5.0, dpi = 300)

print(stacked)
