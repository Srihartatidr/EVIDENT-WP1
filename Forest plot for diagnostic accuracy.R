# ===================== Packages =====================
# install.packages(c("haven","readxl","dplyr","tidyr","stringr",
#                    "ggplot2","patchwork","binom","readr","purrr","forcats"))
library(haven)      # read .dta
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(patchwork)
library(binom)
library(readr)
library(purrr)
library(forcats)

# ===================== Config =======================
infile    <- "D:/EVIDENT WP1 Data/250827_pl ss all.dta"
index_col <- "res_sput_pluslife"

# Reference standards (display name = column name)
rs_map <- c(
  "Culture only"                      = "culture_result3",
  "MRS"                               = "mrs_tb",
  "MRS (sensitivity RS)"              = "mrssens_tb",
  "Conservative RS"                   = "conserv_tb",
  "Conservative RS (sensitivity RS)"  = "conservsens_tb"
)

# Axis settings (edit if you want different ranges)
xlim_sens <- c(0.30, 1.00)  # Sensitivity axis: 30%..100%
xlim_spec <- c(0.95, 1.00)  # Specificity axis: 95%..100%
tick_by   <- 0.10           # major tick every 10 percentage points

# WHO TPP lines (set to NA to hide)
tpp_sens <- NA_real_  # e.g., 0.75
tpp_spec <- NA_real_  # e.g., 0.98

# ===================== Load data ====================
stopifnot(file.exists(infile))
df <- read_dta(infile)

# ===================== Accuracy helper ==============
acc_one_rs <- function(data, index_col, rs_col, rs_name) {
  dd <- data %>%
    select(all_of(c(index_col, rs_col))) %>%
    rename(index = !!index_col, rs = !!rs_col) %>%
    # use only clean 0/1 rows (999, NA, etc. dropped)
    filter(index %in% c(0, 1), rs %in% c(0, 1))
  
  tp <- sum(dd$index == 1 & dd$rs == 1)
  fn <- sum(dd$index == 0 & dd$rs == 1)
  tn <- sum(dd$index == 0 & dd$rs == 0)
  fp <- sum(dd$index == 1 & dd$rs == 0)
  
  n_pos <- tp + fn   # denominator for sensitivity
  n_neg <- tn + fp   # denominator for specificity
  
  sens <- if (n_pos > 0) tp / n_pos else NA_real_
  spec <- if (n_neg > 0) tn / n_neg else NA_real_
  
  sens_ci <- if (!is.na(sens)) binom.confint(tp, n_pos, methods = "wilson") else NULL
  spec_ci <- if (!is.na(spec)) binom.confint(tn, n_neg, methods = "wilson") else NULL
  
  tibble(
    rs_name = rs_name,
    tp = tp, fn = fn, tn = tn, fp = fp,
    n_pos = n_pos, n_neg = n_neg,
    sens = sens,
    sens_lcl = if (!is.null(sens_ci)) sens_ci$lower else NA_real_,
    sens_ucl = if (!is.null(sens_ci)) sens_ci$upper else NA_real_,
    spec = spec,
    spec_lcl = if (!is.null(spec_ci)) spec_ci$lower else NA_real_,
    spec_ucl = if (!is.null(spec_ci)) spec_ci$upper else NA_real_
  )
}

# ===================== Compute metrics ===============
acc_tbl <- map2_dfr(unname(rs_map), names(rs_map),
                    ~acc_one_rs(df, index_col, .x, .y)) %>%
  # fixed order top→bottom across both panels
  mutate(rs_name = fct_rev(factor(rs_name, levels = names(rs_map)))) %>%
  mutate(
    sens_label = ifelse(!is.na(sens),
                        sprintf("%.2f [%.2f, %.2f]; %d/%d", sens, sens_lcl, sens_ucl, tp, n_pos),
                        sprintf("NE; %d/%d", tp, n_pos)),
    spec_label = ifelse(!is.na(spec),
                        sprintf("%.2f [%.2f, %.2f]; %d/%d", spec, spec_lcl, spec_ucl, tn, n_neg),
                        sprintf("NE; %d/%d", tn, n_neg))
  )

# Tidy console table (percent style if you prefer)
acc_tbl %>%
  transmute(
    `Reference standard` = rs_name,
    `Sensitivity (95% CI) [n/N]` = sens_label,
    `Specificity (95% CI) [n/N]` = spec_label
  ) %>%
  arrange(`Reference standard`) %>%
  print(n = Inf)

# ===================== Plotting helpers ==============
make_panel <- function(dat, xlab, xlim, tick_by = 0.10, tpp = NA_real_) {
  # dat: columns rs_name, est, lcl, ucl, label
  p <- ggplot(dat, aes(x = est, y = rs_name)) +
    geom_errorbarh(aes(xmin = lcl, xmax = ucl), height = 0.15, linewidth = 0.6) +
    geom_point(shape = 15, size = 2.6) +
    # put the numeric label slightly to the right of the CI
    geom_text(aes(x = pmin(ucl, xlim[2]) + diff(xlim) * 0.03, label = label),
              hjust = 0, size = 3.2) +
    { if (!is.na(tpp)) geom_vline(xintercept = tpp, linetype = "dashed",
                                  colour = "blue", linewidth = 0.6) } +
    scale_x_continuous(limits = c(xlim[1], xlim[2] + diff(xlim) * 0.20),
                       breaks = seq(xlim[1], xlim[2], by = tick_by)) +
    labs(x = xlab, y = NULL) +
    coord_cartesian(clip = "off") +
    theme_classic(base_size = 11) +
    theme(
      axis.ticks.y = element_blank(),
      axis.title.y = element_blank()
    )
  # header for the WHO TPP (optional)
  if (!is.na(tpp)) {
    p <- p + annotate("text", x = tpp, y = length(levels(dat$rs_name)) + 1,
                      label = paste0("WHO TPP (", round(tpp*100), "%)"),
                      colour = "blue", fontface = "bold", size = 3, vjust = -0.5)
  }
  p
}

# Build panel data frames
sens_df <- acc_tbl %>% transmute(rs_name, est = sens, lcl = sens_lcl, ucl = sens_ucl, label = sens_label)
spec_df <- acc_tbl %>% transmute(rs_name, est = spec, lcl = spec_lcl, ucl = spec_ucl, label = spec_label)

# ===================== Draw figures ==================
p_sens <- make_panel(sens_df, "Sensitivity", xlim_sens, tick_by, tpp = tpp_sens)
p_spec <- make_panel(spec_df, "Specificity", xlim_spec, tick_by, tpp = tpp_spec) +
  theme(axis.text.y = element_blank())  # hide duplicate RS labels on right

p_combined <- (p_sens | p_spec) + plot_layout(widths = c(1, 1))

# # Optional: save outputs
ggsave("D:/Coding/Figures/forest_accuracy_plss.png",
       p_combined, width = 20, height = 4, dpi = 300)
# write_csv(acc_tbl, "diagnostic_accuracy_res_sput_pluslife.csv")



