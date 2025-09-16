# ===================== Packages =====================
# install.packages("haven")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("binom")   # for confidence intervals

library(haven)
library(dplyr)
library(binom)   # for confidence intervals
library(ggplot2)

# ===================== Load data =====================
df_raw <- read_dta("D:/EVIDENT WP1 Data/250901_pl ss adult.dta")

df <- df_raw %>%
  filter(!is.na(semi_quant), semi_quant %in% 1:5)

# Map 1..5 to Trace..High (ordered)
semiq_levels <- 1:5
semiq_labels <- c("Trace","Very Low","Low","Medium","High")

df <- df %>%
  mutate(
    semiquant = factor(semi_quant, levels = semiq_levels, labels = semiq_labels, ordered = TRUE)
  )

# ===================== Summaries & CIs =====================
# If 'res_sput_pluslife' is labelled, ensure numeric first:
# df <- df %>% mutate(res_sput_pluslife = as.numeric(res_sput_pluslife))

results <- df %>%
  group_by(semiquant) %>%
  summarise(
    N = n(),
    n_pos = sum(res_sput_pluslife == 1, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    sens = 100 * n_pos / N
  ) %>%
  rowwise() %>%
  mutate(
    ci_df = list(binom.confint(n_pos, N, method = "wilson"))
  ) %>%
  mutate(
    lo = 100 * ci_df$lower,
    hi = 100 * ci_df$upper
  ) %>%
  ungroup() %>%
  mutate(
    ci_label = sprintf("%.1f (%.1f, %.1f)", sens, lo, hi),
    nn_label = sprintf("%d / %d", n_pos, N)
  )

# ===================== Forest plot =====================
p <- ggplot(results, aes(x = sens, y = semiquant)) +
  # CI bars + points
  geom_errorbarh(aes(xmin = lo, xmax = hi), height = 0.18) +
  geom_point(size = 2.6) +
  
  # vertical guides
  geom_vline(xintercept = c(0,25,50,75,100),
             linetype = "dashed", linewidth = 0.3, color = "grey70") +
  
  # right-hand side labels
  geom_text(aes(x = 102, label = ci_label), hjust = 0, size = 3.6) +
  geom_text(aes(x = 120, label = nn_label), hjust = 0, size = 3.6) +
  
  # column headers above labels
  annotate("text", x = 102, y = length(levels(results$semiquant)) + 1,
           label = "Sensitivity (95% CI)", hjust = 0, fontface = "bold", size = 3.6) +
  annotate("text", x = 120, y = length(levels(results$semiquant)) + 1,
           label = "n/N", hjust = 0, fontface = "bold", size = 3.6) +
  
  # axes
  scale_x_continuous(limits = c(0,130), breaks = seq(0,100,25)) +
  labs(
    title = "Sputum Swab MiniDock MTB testing",
    x = "Sensitivity, % (95% CI)",
    y = "Semi-quantitative result\nsputum-based Xpert testing"   # <-- two-line y-axis title
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(size = 14, face = "plain"),
    axis.title.x = element_text(size = 12, face = "plain"),
    axis.title.y = element_text(size = 12, face = "plain", margin = margin(r = 10)),
    axis.line.x  = element_line(color = "black", linewidth = 1),
    axis.line.y  = element_line(color = "black", linewidth = 1),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank(),
    plot.margin        = margin(20, 100, 20, 20)
  ) +
  coord_cartesian(clip = "off")   # keep labels outside plot region

print(p)

ggsave("D:/Coding/Figures/forest_semiquant_plss.png",
       p, width = 15, height = 3.5, dpi = 300)
