# ===================== Packages =====================
# install.packages(c("haven","dplyr","tidyr","stringr",
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
  "Culture MGIT"                                               = "culture_result3",
  "Maximal Reference Standard"                                 = "mrs_tb",
  "Maximal Reference Standard (Trace as positive)"             = "mrssens_tb",
  "Composite Reference Standard"                               = "conserv_tb"
)

# Axis settings (PERCENT SCALE)
xlim_sens     <- c(30, 100)   # Sensitivity axis: 30–100%
xlim_spec     <- c(95, 100)   # Specificity axis: 93–100%
tick_by_sens  <- 10           # tick every 10 percentage points
tick_by_spec  <- 1            # tick every 1 percentage point

# WHO TPP lines in PERCENT (set to NA to hide)
tpp_sens <- NA_real_  # e.g., 75
tpp_spec <- NA_real_  # e.g., 98

# Grid styling (lighter lines)
grid_col_default   <- "grey92"
grid_alpha_default <- 0.22
grid_size_default  <- 0.30

# ===================== Load data ====================
stopifnot(file.exists(infile))
df <- read_dta(infile)

# ===================== Accuracy helper ==============
acc_one_rs <- function(data, index_col, rs_col, rs_name) {
  dd <- data %>%
    select(all_of(c(index_col, rs_col))) %>%
    rename(index = !!index_col, rs = !!rs_col) %>%
    filter(index %in% c(0, 1), rs %in% c(0, 1))  # keep only 0/1 rows
  
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

# ===================== Compute metrics (convert to %) ===============
acc_tbl <- map2_dfr(unname(rs_map), names(rs_map),
                    ~acc_one_rs(df, index_col, .x, .y)) %>%
  mutate(
    # fixed order top→bottom across both panels
    rs_name = fct_rev(factor(rs_name, levels = names(rs_map))),
    # convert to percent for plotting and labels
    sens_pct      = sens      * 100,
    sens_lcl_pct  = sens_lcl  * 100,
    sens_ucl_pct  = sens_ucl  * 100,
    spec_pct      = spec      * 100,
    spec_lcl_pct  = spec_lcl  * 100,
    spec_ucl_pct  = spec_ucl  * 100,
    sens_label = ifelse(!is.na(sens_pct),
                        sprintf("%.1f [%.1f, %.1f]; %d/%d", sens_pct, sens_lcl_pct, sens_ucl_pct, tp, n_pos),
                        sprintf("NE; %d/%d", tp, n_pos)),
    spec_label = ifelse(!is.na(spec_pct),
                        sprintf("%.1f [%.1f, %.1f]; %d/%d", spec_pct, spec_lcl_pct, spec_ucl_pct, tn, n_neg),
                        sprintf("NE; %d/%d", tn, n_neg))
  )

# (Optional) print tidy table (now percent-based labels)
acc_tbl %>%
  transmute(
    `Reference standard`         = rs_name,
    `Sensitivity (95% CI) [n/N]` = sens_label,
    `Specificity (95% CI) [n/N]` = spec_label
  ) %>%
  arrange(`Reference standard`) %>%
  print(n = Inf)

# ===================== Plot helper (tick lines; percent scale) ============
make_panel <- function(dat, xlab, xlim, tick_by = 10, tpp = NA_real_,
                       grid_col = grid_col_default,
                       grid_size = grid_size_default,
                       grid_alpha = grid_alpha_default) {
  
  # Tick positions from limits & spacing (percent units)
  brks <- seq(xlim[1], xlim[2], by = tick_by)
  if (tail(brks, 1) < xlim[2]) brks <- c(brks, xlim[2])
  
  ggplot(dat, aes(x = est, y = rs_name)) +
    # vertical line at EVERY x tick
    geom_vline(xintercept = brks,
               colour = grid_col, linewidth = grid_size, alpha = grid_alpha) +
    # forest elements
    geom_errorbarh(aes(xmin = lcl, xmax = ucl), height = 0.15, linewidth = 0.6) +
    geom_point(shape = 15, size = 2.6) +
    # labels just to the right of CI
    geom_text(aes(x = pmin(ucl, xlim[2]) + diff(xlim) * 0.03, label = label),
              hjust = 0, size = 3.2) +
    # optional WHO TPP line (pass percent values, e.g., 75 or 98)
    { if (!is.na(tpp)) geom_vline(xintercept = tpp, linetype = "dashed",
                                  colour = "blue", linewidth = 0.6) } +
    scale_x_continuous(
      limits = c(xlim[1], xlim[2] + diff(xlim) * 0.20),  # extra room on right for labels
      breaks = seq(xlim[1], xlim[2], by = tick_by),
      expand = expansion(mult = c(0, 0))
    ) +
    labs(x = xlab, y = NULL) +
    coord_cartesian(clip = "off") +
    theme_classic(base_size = 11) +
    theme(
      axis.ticks.y = element_blank(),
      axis.title.y = element_blank()
    )
}

# Build panel data frames (use percent columns)
sens_df <- acc_tbl %>%
  transmute(rs_name, est = sens_pct, lcl = sens_lcl_pct, ucl = sens_ucl_pct, label = sens_label)
spec_df <- acc_tbl %>%
  transmute(rs_name, est = spec_pct, lcl = spec_lcl_pct, ucl = spec_ucl_pct, label = spec_label)

# ===================== Draw figures ==================
# Sensitivity panel (percent)
p_sens <- make_panel(
  sens_df, "Sensitivity, % (95% CI)", xlim_sens,
  tick_by   = tick_by_sens,
  grid_col  = "grey1",    # keep your choice; use "grey92" for lighter lines
  grid_size = 0.30,
  grid_alpha= 0.22
)

# Specificity panel (percent)
p_spec <- make_panel(
  spec_df, "Specificity, % (95% CI)", xlim_spec,
  tick_by   = tick_by_spec,
  grid_col  = "grey1",    # keep your choice; use "grey95" for lighter lines
  grid_size = 0.25,
  grid_alpha= 0.18
) + theme(axis.text.y = element_blank())  # hide duplicate RS labels on right

p_combined3 <- (p_sens | p_spec) +
  plot_layout(widths = c(1, 1)) +
  plot_annotation(
    title = "Diagnostic accuracy of sputum swab MiniDock MTB across reference standards",
    subtitle = "95% Wilson CIs; labels show n/N",
    theme = theme(plot.title = element_text(face = "bold", size = 13))
  )

# ---- Save ----
ggsave("D:/Coding/Figures/forest_accuracy5_plss.png",
       p_combined3, width = 20, height = 4, dpi = 300)

# Optional: export the numeric table
# write_csv(acc_tbl, "D:/Coding/Figures/diagnostic_accuracy_res_sput_pluslife.csv")
