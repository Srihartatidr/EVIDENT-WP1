library(ggplot2)
library(dplyr)
library(ggtext)  # for rich text support

# 1. Data
df <- data.frame(
  Site = c("Puskesmas", "Puskesmas", "Lung hospital", "Lung hospital", "Lung clinic", "Lung clinic"),
  AgeGroup = c("Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+", "Aged 0-14", "Aged 15+"),
  Count = c(40, 245,21, 235, 231, 379)
)

# 2. Add percent per site, formatted label, and position
df <- df %>%
  group_by(Site) %>%
  arrange(Site, desc(AgeGroup)) %>%
  mutate(
    Percent = Count / sum(Count) * 100,
    Label = paste0(
      Count, "<br><span style='font-size:9pt;'>(", round(Percent, 1), "%)</span>"
    ),
    Position = cumsum(Count) - Count
  )

# 3. Create site total + overall percent
df_site_total <- df %>%
  group_by(Site) %>%
  summarise(Total = sum(Count)) %>%
  ungroup() %>%
  mutate(
    Percent = Total / sum(Total) * 100,
    Label = paste0(
      "<b>", Total, "</b><br><span style='font-size:9pt;'>(", round(Percent, 1), "%)</span>"
    )
  )

# 4. Plot with richtext
stacked <- ggplot(df, aes(x = Site, y = Count, fill = AgeGroup)) +
  geom_bar(stat = "identity", width = 0.9) +
  ggtext::geom_richtext(
    aes(y = Position + 2, label = Label),
    fill = NA, label.color = NA,
    hjust = 0,
    size = 4
  ) +
  ggtext::geom_richtext(
    data = df_site_total,
    aes(x = Site, y = Total + 10, label = Label),
    inherit.aes = FALSE,
    fill = NA, label.color = NA,
    hjust = 0,
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
    plot.title = element_text(face = "bold", size = 16),         # Bold title
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),  # Bold x-axis label
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),  # Bold y-axis label
    axis.text.x = element_text(face = "bold"),                   # Bold x-axis tick labels (count bars)
    axis.text.y = element_text(face = "bold"),                   # Bold y-axis tick labels (site names)
    axis.line.x = element_line(color = "black", size = 0.3),
    axis.line.y = element_line(color = "black", size = 0.3)
  ) +
  expand_limits(y = max(df_site_total$Total) + 30)

# 5. Save and show
ggsave("D:/Coding/stacked_bar_patient_distribution.png", plot = stacked,
       width = 12.0, height = 5.0, dpi = 300)

print(stacked)
