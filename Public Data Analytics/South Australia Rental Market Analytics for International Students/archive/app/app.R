# ─────────────────────────────────────────────────────────────────────────────
# SA Rental Affordability Calculator
# South Australia Rental Market Analytics for International Students
# Author: Md Soad Solaiman
# ─────────────────────────────────────────────────────────────────────────────

library(shiny)
library(bslib)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(plotly)

# ── Data ─────────────────────────────────────────────────────────────────────
time_series_tidy <- read_excel("../data/processed/rental-data-tidy.xlsx", sheet = "Time Series Tidy")
bedroom_tidy     <- read_excel("../data/processed/rental-data-tidy.xlsx", sheet = "Bedroom Wise Tidy")
bedroom_tidy     <- bedroom_tidy %>%
  mutate(bedroom_type = recode(bedroom_type, "4 Bedrooms" = "4 bedrooms"))

C_FLAT_AFFD  <- "#2A9D8F"   # teal         — Flat Affordable
C_FLAT_STR   <- "#E9C46A"   # orche            — Flat Stress
C_FLAT_SEV   <- "#E76F51"   # deep coral    — Flat Severe
C_HOUSE_AFFD <- "#27AE60"   # strong green        — House Affordable
C_HOUSE_STR  <- "#E67E22"   # amber/orange        — House Stress
C_HOUSE_SEV  <- "#C0392B"   # bold red            — House Severe
C_FLAT       <- "#2980B9"   # used in trend chart
C_HOUSE      <- "#E8665A"   # used in trend chart
C_WARN       <- "#E67E22"
C_SEVERE     <- "#C0392B"
C_STRIP      <- "#2C3E50"
C_BG         <- "#F5F7FA"
C_PANEL      <- "#FFFFFF"



# ── Region labels ─────────────────────────────────────────────────────────────
REGION_LABELS <- c(
  "Eastern Adelaide"    = "Eastern Adelaide",
  "Western Adelaide"    = "Western Adelaide",
  "Southern Adelaide"   = "Southern Adelaide",
  "Northern Adelaide"   = "Northern Adelaide",
  "Adelaide Hills"      = "Adelaide Hills",
  "Barossa"             = "Barossa",
  "Fleurieu and KI"     = "Fleurieu & KI",
  "Limestone Coast"     = "Limestone Coast",
  "Murray and Mallee"   = "Murray & Mallee",
  "Yorke and Mid North" = "Yorke & Mid North",
  "Far North"           = "Far North",
  "Eyre and Western"    = "Eyre & Western"
)

# ── Pre-processed data ────────────────────────────────────────────────────────
rent_2025 <- time_series_tidy %>%
  mutate(year = as.numeric(year), value = as.numeric(value)) %>%
  filter(year == 2025, measure %in% c("Flat Median", "House Median")) %>%
  mutate(
    dwelling_type = recode(measure, "Flat Median" = "Flat", "House Median" = "House"),
    region_label  = recode(region, !!!REGION_LABELS),
    area_group    = factor(area_group, levels = c("Metro", "Rest of State"))
  ) %>%
  select(region, region_label, area_group, dwelling_type, rent = value)

trend_data <- time_series_tidy %>%
  mutate(year = as.numeric(year), value = as.numeric(value)) %>%
  filter(measure %in% c("Flat Median", "House Median")) %>%
  mutate(
    dwelling_type = recode(measure, "Flat Median" = "Flat", "House Median" = "House"),
    region_label  = recode(region, !!!REGION_LABELS)
  ) %>%
  select(year, region, region_label, area_group, dwelling_type, rent = value)

sharing_data <- bedroom_tidy %>%
  mutate(year = as.numeric(year), `median ($)` = as.numeric(`median ($)`)) %>%
  filter(
    year == 2025,
    bedroom_type  %in% c("2 bedroom", "3 bedroom", "4 bedrooms"),
    dwelling_type %in% c("Flat", "House"),
    region        %in% names(REGION_LABELS)
  ) %>%
  mutate(
    n_sharers    = as.numeric(sub(" bedroom.*", "", bedroom_type)),
    cost_pp      = round(`median ($)` / n_sharers, 0),
    region_label = recode(region, !!!REGION_LABELS),
    area_group   = factor(area_group, levels = c("Metro", "Rest of State"))
  ) %>%
  select(region, region_label, area_group, dwelling_type, bedroom_type,
         n_sharers, total_rent = `median ($)`, cost_pp)

# ── Shared theme ──────────────────────────────────────────────────────────────
theme_app <- function(flip = TRUE) {
  base <- theme_minimal(base_size = 12) +
    theme(
      plot.background    = element_rect(fill = C_BG,    color = NA),
      panel.background   = element_rect(fill = C_PANEL, color = NA),
      plot.title         = element_text(face = "bold", size = 13, color = "#1A252F",
                                        hjust = 0, margin = margin(b = 4)),
      plot.subtitle      = element_text(size = 9.5, color = "gray45",
                                        hjust = 0, margin = margin(b = 10)),
      plot.caption       = element_text(size = 8, color = "gray55", hjust = 1),
      plot.margin        = margin(14, 20, 10, 14),
      strip.background   = element_rect(fill = C_STRIP, color = NA),
      strip.text         = element_text(color = "white", face = "bold", size = 11,
                                        margin = margin(5, 0, 5, 0)),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(size = 9.5, color = "gray30"),
      axis.title         = element_text(face = "bold", color = "gray35", size = 10),
      legend.position    = "top",
      legend.text        = element_text(size = 10),
      legend.key.width   = unit(1.0, "cm"),
      legend.key.height  = unit(0.45, "cm")
    )
  if (flip) {
    base <- base + theme(
      panel.grid.major.x = element_line(color = "gray90", linewidth = 0.4),
      panel.grid.major.y = element_blank(),
      axis.text.y        = element_text(face = "bold")
    )
  } else {
    base <- base + theme(
      panel.grid.major.y = element_line(color = "gray90", linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      axis.text.x        = element_text(face = "bold")
    )
  }
  base
}


# ══════════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════════
ui <- page_navbar(
  title = tags$span(
    tags$b("SA Rental Affordability Calculator"),
    tags$span(" · South Australia Rental Market Analytics for International Students",
              style = "font-size:12px; color:#aaa; margin-left:8px;")
  ),
  theme = bs_theme(
    bootswatch   = "flatly",
    primary      = "#1A6EA8",
    base_font    = font_google("Source Serif 4"),
    heading_font = font_google("Playfair Display"),
    code_font    = font_google("DM Mono")
  ),
  bg = "#1A252F", inverse = TRUE, fluid = TRUE,
  
  # ══ TAB 1 — Affordability ══════════════════════════════════════════════════
  nav_panel("🏠 Affordability Calculator",
            layout_sidebar(
              sidebar = sidebar(
                width = 275, bg = "#EEF2F7",
                tags$p(tags$b("YOUR INCOME"),
                       style="font-size:11px;letter-spacing:1.5px;color:#546E7A;margin-bottom:2px;"),
                sliderInput("income","Weekly income (AUD)",
                            min=200, max=2000, value=800, step=50, pre="$", sep=","),
                tags$p("Student visa: 24 hrs × ~$33/hr ≈ $800",
                       style="font-size:11px;color:#999;margin-top:-8px;"),
                hr(),
                tags$p(tags$b("FILTERS"),
                       style="font-size:11px;letter-spacing:1.5px;color:#546E7A;margin-bottom:2px;"),
                checkboxGroupInput("area_filter","Area group",
                                   choices=c("Metro","Rest of State"),
                                   selected=c("Metro","Rest of State")),
                checkboxGroupInput("dwelling_filter","Dwelling type",
                                   choices=c("Flat","House"),
                                   selected=c("Flat","House")),
                checkboxInput("show_stress","Show 30% stress line", value=TRUE),
                checkboxInput("show_severe","Show 50% severe line", value=TRUE),
                checkboxInput("sort_pct",  "Sort by % of income",   value=TRUE),
                hr(),
                # Clear colour legend
                tags$p(tags$b("COLOUR KEY"), style="font-size:11px;letter-spacing:1px;color:#546E7A;"),
                tags$table(style="font-size:11px;line-height:2;",
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#2980B9;border-radius:2px;margin-right:5px;")),
                             tags$td("Flat — Affordable (<30%)")
                           ),
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#8E44AD;border-radius:2px;margin-right:5px;")),
                             tags$td("Flat — Stress (30–49%)")
                           ),
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#1A252F;border-radius:2px;margin-right:5px;")),
                             tags$td("Flat — Severe (≥50%)")
                           ),
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#27AE60;border-radius:2px;margin-right:5px;")),
                             tags$td("House — Affordable (<30%)")
                           ),
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#E67E22;border-radius:2px;margin-right:5px;")),
                             tags$td("House — Stress (30–49%)")
                           ),
                           tags$tr(
                             tags$td(tags$span(style="display:inline-block;width:14px;height:14px;
                               background:#C0392B;border-radius:2px;margin-right:5px;")),
                             tags$td("House — Severe (≥50%)")
                           )
                )
              ),
              fillable = FALSE,
              # Value boxes
              layout_columns(
                col_widths=c(3,3,3,3), gap="10px",
                value_box("Weekly income",      textOutput("vb_income",  inline=TRUE),
                          showcase=bsicons::bs_icon("wallet2"),           theme="primary"),
                value_box("30% stress line",    textOutput("vb_stress",  inline=TRUE),
                          showcase=bsicons::bs_icon("exclamation-triangle"), theme="warning"),
                value_box("50% severe line",    textOutput("vb_severe",  inline=TRUE),
                          showcase=bsicons::bs_icon("x-octagon"),         theme="danger"),
                value_box("Affordable options", textOutput("vb_safe",    inline=TRUE),
                          showcase=bsicons::bs_icon("check2-circle"),     theme="success")
              ),
              tags$br(),
              card(
                full_screen = TRUE,
                card_header(
                  tags$b("Rent as % of Weekly Income — All SA Regions (2025)"),
                  tags$span("Hover for details · Drag slider to update in real time",
                            style="float:right;font-size:11px;color:#999;")
                ),
                plotlyOutput("afford_plot", height="530px")
              ),
              tags$br(),
              uiOutput("afford_summary")
            )
  ),
  
  # ══ TAB 2 — Sharing Calculator ═════════════════════════════════════════════
  nav_panel("👥 Sharing Calculator",
            layout_sidebar(
              sidebar = sidebar(
                width = 275, bg = "#EEF2F7",
                tags$p(tags$b("YOUR SETUP"),
                       style="font-size:11px;letter-spacing:1.5px;color:#546E7A;margin-bottom:2px;"),
                sliderInput("income2","Weekly income (AUD)",
                            min=200, max=2000, value=800, step=50, pre="$", sep=","),
                selectInput("bedroom_sel","Bedroom size",
                            choices=c("2 bedroom","3 bedroom","4 bedrooms"),
                            selected="3 bedroom"),
                checkboxGroupInput("dwelling_sel","Dwelling type",
                                   choices=c("Flat","House"), selected=c("Flat","House")),
                checkboxGroupInput("area_sel","Area group",
                                   choices=c("Metro","Rest of State"),
                                   selected=c("Metro","Rest of State")),
                hr(),
                tags$p("Rent ÷ number of bedrooms = cost per person. Amber dashed line = your 30% stress threshold.",
                       style="font-size:11px;color:#666;line-height:1.7;")
              ),
              fillable = FALSE,
              # Top row: 3 cards + top-4 ranking
              layout_columns(
                col_widths = c(4,4,4), gap="10px",
                value_box("Sharing with",          textOutput("vb_sharers",  inline=TRUE),
                          showcase=bsicons::bs_icon("people"),           theme="primary"),
                value_box("Stress threshold/person", textOutput("vb_stress2", inline=TRUE),
                          showcase=bsicons::bs_icon("exclamation-triangle"), theme="warning"),
                value_box("Cheapest option",       textOutput("vb_cheapest", inline=TRUE),
                          showcase=bsicons::bs_icon("piggy-bank"),       theme="success")
              ),
              tags$br(),
              # Top-4 cheapest options ranking
              card(
                card_header(tags$b("🏆 Top 4 Cheapest Options — Per Person Per Week")),
                uiOutput("top4_cards")
              ),
              tags$br(),
              card(
                full_screen = TRUE,
                card_header(
                  tags$b("Weekly Rent Per Person When Sharing — 2025"),
                  tags$span("% of income shown at bar end · Hover for full details",
                            style="float:right;font-size:11px;color:#999;")
                ),
                plotlyOutput("sharing_plot", height="500px")
              )
            )
  ),
  
  # ══ TAB 3 — Rent Trend Explorer ════════════════════════════════════════════
  nav_panel("📈 Rent Trend Explorer",
            layout_sidebar(
              sidebar = sidebar(
                width = 275, bg = "#EEF2F7",
                tags$p(tags$b("SELECT REGION"),
                       style="font-size:11px;letter-spacing:1.5px;color:#546E7A;margin-bottom:2px;"),
                selectInput("region_sel", NULL,
                            choices  = setNames(names(REGION_LABELS), REGION_LABELS),
                            selected = "Northern Adelaide"),
                checkboxGroupInput("dwelling_trend","Dwelling type",
                                   choices=c("Flat","House"), selected=c("Flat","House")),
                sliderInput("income3","Weekly income (AUD)",
                            min=200, max=2000, value=800, step=50, pre="$", sep=","),
                hr(),
                tags$p(tags$b("KEY STATS"), style="font-size:11px;letter-spacing:1px;color:#546E7A;"),
                tableOutput("trend_stats")
              ),
              fillable = FALSE,
              card(
                full_screen = TRUE,
                card_header(tags$b("Year-by-Year Median Rent — Grouped Bar Chart")),
                plotlyOutput("trend_plot", height="460px")
              )
            )
  ),
  
  # ══ TAB 4 — About ══════════════════════════════════════════════════════════
  nav_panel("ℹ️ About",
            card(card_body(
              tags$h4("SA Rental Affordability Calculator",
                      style="font-family:'Playfair Display';"),
              tags$p(tags$b("Project:"), " South Australia Rental Market Analytics for International Students"),
              tags$p(tags$b("Author:"), " Md Soad Solaiman"),
              tags$hr(),
              tags$h6("Data Source"),
              tags$p("Government of South Australia (2025). Private Rent Report.",
                     tags$a(" data.sa.gov.au",
                            href="https://data.sa.gov.au/data/dataset/private-rent-report",
                            target="_blank")),
              tags$h6("Notes"),
              tags$ul(
                tags$li("All rent figures are median weekly rent in AUD."),
                tags$li("Data uses the last quarter of each year (2020–2025)."),
                tags$li("Student income $800/week = 24 hrs/week × ~$33/hr."),
                tags$li("Housing stress: >30% of income on rent. Severe: >50%."),
                tags$li("Sharing cost = total rent ÷ number of bedrooms.")
              )
            ))
  )
)


# ══════════════════════════════════════════════════════════════════════════════
# SERVER
# ══════════════════════════════════════════════════════════════════════════════
server <- function(input, output, session) {
  
  thresh30  <- reactive(round(input$income  * 0.30, 0))
  thresh50  <- reactive(round(input$income  * 0.50, 0))
  thresh30b <- reactive(round(input$income2 * 0.30, 0))
  
  # ── TAB 1 ─────────────────────────────────────────────────────────────────
  afford_data <- reactive({
    rent_2025 %>%
      filter(area_group    %in% input$area_filter,
             dwelling_type %in% input$dwelling_filter) %>%
      mutate(
        rent_pct  = round(rent / input$income * 100, 1),
        pct_label = paste0(rent_pct, "%"),
        status = case_when(
          rent_pct >= 50 ~ "Severe",
          rent_pct >= 30 ~ "Stress",
          TRUE           ~ "Affordable"
        ),
        # Six distinct colours: dwelling × status
        bar_col = case_when(
          dwelling_type == "Flat"  & status == "Affordable" ~ C_FLAT_AFFD,
          dwelling_type == "Flat"  & status == "Stress"     ~ C_FLAT_STR,
          dwelling_type == "Flat"  & status == "Severe"     ~ C_FLAT_SEV,
          dwelling_type == "House" & status == "Affordable" ~ C_HOUSE_AFFD,
          dwelling_type == "House" & status == "Stress"     ~ C_HOUSE_STR,
          dwelling_type == "House" & status == "Severe"     ~ C_HOUSE_SEV
        ),
        col_key = case_when(
          dwelling_type == "Flat"  & status == "Affordable" ~ "Flat — Affordable",
          dwelling_type == "Flat"  & status == "Stress"     ~ "Flat — Stress",
          dwelling_type == "Flat"  & status == "Severe"     ~ "Flat — Severe",
          dwelling_type == "House" & status == "Affordable" ~ "House — Affordable",
          dwelling_type == "House" & status == "Stress"     ~ "House — Stress",
          dwelling_type == "House" & status == "Severe"     ~ "House — Severe"
        )
      )
  })
  
  output$vb_income <- renderText(paste0("$", format(input$income, big.mark=",")))
  output$vb_stress <- renderText(paste0("$", thresh30(), " /week"))
  output$vb_severe <- renderText(paste0("$", thresh50(), " /week"))
  output$vb_safe   <- renderText({
    n <- afford_data() %>% filter(status == "Affordable") %>% nrow()
    paste0(n, " combos")
  })
  
  output$afford_plot <- renderPlotly({
    df <- afford_data()
    req(nrow(df) > 0)
    
    col_vals <- c(
      "Flat — Affordable"  = C_FLAT_AFFD,
      "Flat — Stress"      = C_FLAT_STR,
      "Flat — Severe"      = C_FLAT_SEV,
      "House — Affordable" = C_HOUSE_AFFD,
      "House — Stress"     = C_HOUSE_STR,
      "House — Severe"     = C_HOUSE_SEV
    )
    
    if (input$sort_pct) {
      # Sort by average rent_pct of the two dwellings per region
      region_order <- df %>%
        group_by(area_group, region_label) %>%
        summarise(avg_pct = mean(rent_pct), .groups="drop") %>%
        arrange(area_group, avg_pct) %>%
        pull(region_label)
      df <- df %>%
        mutate(region_label = factor(region_label, levels = unique(region_order)))
    }
    
    p <- ggplot(df, aes(
      x    = rent_pct,
      y    = region_label,
      fill = col_key,
      text = paste0(
        "<b>", region_label, "</b>\n",
        "Dwelling: ", dwelling_type, "\n",
        "Rent: $", rent, "/week\n",
        "% of income: ", rent_pct, "%\n",
        "Status: ", status
      )
    )) +
      geom_col(position = position_dodge2(width = 0.75, preserve = "single"),
               width = 0.65) +
      geom_text(aes(label = pct_label, group = col_key),
                position = position_dodge2(width = 0.75, preserve = "single"),
                hjust = -0.1, size = 2.85, fontface = "bold", color = "gray20",
                show.legend = FALSE) +
      scale_fill_manual(values = col_vals, name = NULL,
                        breaks = names(col_vals)[names(col_vals) %in% unique(df$col_key)],
                        drop   = TRUE) +
      { if (input$show_stress)
        geom_vline(xintercept=30, linetype="dashed", color=C_WARN,   linewidth=1.0) } +
      { if (input$show_severe)
        geom_vline(xintercept=50, linetype="dashed", color=C_SEVERE, linewidth=1.0) } +
      facet_wrap(~ area_group, scales="free_y", ncol=2) +
      scale_x_continuous(
        breaks = seq(0, 120, 20), limits = c(0, 118),
        labels = function(x) paste0(x, "%"),
        expand = expansion(mult=c(0, 0.01))
      ) +
      labs(
        title    = paste0("Rent as % of $", format(input$income, big.mark=","), " weekly income"),
        subtitle = paste0(
          "Amber dashed = 30% stress ($", thresh30(), "/wk)  \u00b7  ",
          "Red dashed = 50% severe ($", thresh50(), "/wk)  \u00b7  ",
          "Green = Flat affordable  \u00b7  Blue = House affordable"
        ),
        x = "Rent as % of weekly income",
        y = NULL
      ) +
      theme_app(flip = TRUE) +
      theme(
        legend.position   = "top",
        legend.key.width  = unit(0.9, "cm"),
        legend.key.height = unit(0.4, "cm"),
        legend.text       = element_text(size = 9),
        axis.text.y       = element_text(size = 9, face="bold"),
        strip.text        = element_text(size=11)
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(
        legend = list(orientation="h", x=0, y=1.14,
                      font=list(size=10), traceorder="normal"),
        margin = list(l=5, r=10, t=80, b=30)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  output$afford_summary <- renderUI({
    df  <- afford_data()
    n_ok  <- df %>% filter(status == "Affordable") %>% nrow()
    n_str <- df %>% filter(status == "Stress")     %>% nrow()
    n_sev <- df %>% filter(status == "Severe")     %>% nrow()
    best  <- df %>% arrange(rent_pct) %>% slice(1)
    bg    <- if (n_ok == 0) "#FDEDEC" else if (n_ok < 4) "#FEF9E7" else "#EAFAF1"
    div(style=paste0("background:",bg,";border-radius:6px;padding:14px 20px;",
                     "border:1px solid #ddd;font-size:14px;line-height:2;"),
        tags$b(paste0("Summary at $", format(input$income, big.mark=","), "/week")),
        tags$br(),
        paste0("✅  Affordable (< 30%): ", n_ok,  " options"), tags$br(),
        paste0("🟡  Stress (30–49%): ",   n_str, " options"), tags$br(),
        paste0("🔴  Severe (≥ 50%): ",    n_sev, " options"), tags$br(),
        if (nrow(best) > 0)
          tags$i(paste0("Best value: ", best$region_label, " — ",
                        best$dwelling_type, " at $", best$rent,
                        "/wk (", best$rent_pct, "% of income)"))
    )
  })
  
  # ── TAB 2 ─────────────────────────────────────────────────────────────────
  sharing_filtered <- reactive({
    sharing_data %>%
      filter(bedroom_type  == input$bedroom_sel,
             dwelling_type %in% input$dwelling_sel,
             area_group    %in% input$area_sel) %>%
      mutate(
        pct_pp    = round(cost_pp / input$income2 * 100, 1),
        pct_label = paste0(pct_pp, "%"),
        status    = case_when(
          pct_pp >= 50 ~ "Severe",
          pct_pp >= 30 ~ "Stress",
          TRUE         ~ "Affordable"
        ),
        col_key = case_when(
          dwelling_type == "Flat"  & status == "Affordable" ~ "Flat — Affordable",
          dwelling_type == "Flat"  & status == "Stress"     ~ "Flat — Stress",
          dwelling_type == "Flat"  & status == "Severe"     ~ "Flat — Severe",
          dwelling_type == "House" & status == "Affordable" ~ "House — Affordable",
          dwelling_type == "House" & status == "Stress"     ~ "House — Stress",
          dwelling_type == "House" & status == "Severe"     ~ "House — Severe"
        )
      ) %>%
      arrange(area_group, cost_pp)
  })
  
  output$vb_sharers  <- renderText({
    n <- as.numeric(sub(" bedroom.*","", input$bedroom_sel))
    paste0(n, " people")
  })
  output$vb_stress2  <- renderText(paste0("$", thresh30b(), " /person/week"))
  output$vb_cheapest <- renderText({
    df <- sharing_filtered()
    if (nrow(df) == 0) return("N/A")
    r  <- df %>% arrange(cost_pp) %>% slice(1)
    paste0("$", r$cost_pp, "/wk — ", r$region_label)
  })
  
  # Top-4 cheapest options
  output$top4_cards <- renderUI({
    df <- sharing_filtered()
    if (nrow(df) == 0) return(tags$p("No data."))
    top4 <- df %>% arrange(cost_pp) %>% slice_head(n = 4)
    medals <- c("🥇", "🥈", "🥉", "4️⃣")
    status_col <- c("Affordable"="#27AE60", "Stress"="#E67E22", "Severe"="#C0392B")
    cards <- lapply(seq_len(nrow(top4)), function(i) {
      r   <- top4[i, ]
      col <- status_col[r$status]
      div(
        style = paste0(
          "flex:1; min-width:160px; background:#fff; border-radius:8px;",
          "border-left:5px solid ", col, ";",
          "padding:14px 16px; box-shadow:0 1px 6px rgba(0,0,0,0.08);",
          "margin:4px;"
        ),
        tags$div(style="font-size:22px; line-height:1;", medals[i]),
        tags$div(style="font-size:13px; font-weight:700; margin-top:6px; color:#1A252F;",
                 r$region_label),
        tags$div(style="font-size:11px; color:#555; margin-top:2px;",
                 r$dwelling_type, " · ", r$bedroom_type),
        tags$div(style=paste0("font-size:22px; font-weight:900; color:", col,
                              "; margin-top:6px; font-family:'Playfair Display';"),
                 paste0("$", r$cost_pp, "/wk")),
        tags$div(style="font-size:11px; color:#888; margin-top:2px;",
                 paste0(r$pct_pp, "% of income · Total $", r$total_rent, "/wk"))
      )
    })
    div(style="display:flex; flex-wrap:wrap; gap:8px; padding:4px 0;", cards)
  })
  
  output$sharing_plot <- renderPlotly({
    df <- sharing_filtered()
    req(nrow(df) > 0)
    thr <- thresh30b()
    
    col_vals2 <- c(
      "Flat — Affordable"  = C_FLAT_AFFD,
      "Flat — Stress"      = C_FLAT_STR,
      "Flat — Severe"      = C_FLAT_SEV,
      "House — Affordable" = C_HOUSE_AFFD,
      "House — Stress"     = C_HOUSE_STR,
      "House — Severe"     = C_HOUSE_SEV
    )
    
    # Order regions by average cost_pp within each area_group (cheapest at top)
    region_order <- df %>%
      group_by(area_group, region_label) %>%
      summarise(avg_cpp = mean(cost_pp), .groups = "drop") %>%
      arrange(area_group, avg_cpp) %>%
      pull(region_label)
    
    df <- df %>%
      mutate(region_label = factor(region_label, levels = unique(region_order)))
    
    p <- ggplot(df, aes(
      x    = cost_pp,
      y    = region_label,
      fill = col_key,
      text = paste0(
        "<b>", region_label, " — ", dwelling_type, "</b>\n",
        "Total rent: $", total_rent, "/week\n",
        "Per person: $", cost_pp, "/week\n",
        "% of income: ", pct_pp, "% (", status, ")"
      )
    )) +
      # Threshold line
      geom_vline(xintercept = thr, linetype = "dashed",
                 color = C_WARN, linewidth = 1.0) +
      
      # Bars — same position_dodge as affordability chart
      geom_col(position = position_dodge(width = 0.72), width = 0.65) +
      
      # % label at end of bar
      geom_text(aes(label = pct_label, group = col_key),
                position = position_dodge(width = 0.72),
                hjust = -0.1, size = 2.85, fontface = "bold", color = "gray20",
                show.legend = FALSE) +
      
      scale_fill_manual(
        values = col_vals2, name = NULL,
        breaks = names(col_vals2)[names(col_vals2) %in% unique(df$col_key)],
        drop   = TRUE
      ) +
      scale_x_continuous(
        labels = dollar_format(prefix = "$"),
        limits = c(0, max(df$cost_pp) * 1.22),
        expand = expansion(mult = c(0, 0.01))
      ) +
      facet_wrap(~ area_group, scales = "free_y", ncol = 2) +
      labs(
        title    = paste0(input$bedroom_sel, " — per person cost when sharing (2025)"),
        subtitle = paste0(
          "Income $", format(input$income2, big.mark = ","),
          "/week  \u00b7  Amber dashed = $", thr, " stress threshold (30% of income)"
        ),
        x = "Weekly rent per person ($)", y = NULL
      ) +
      theme_app(flip = TRUE) +
      theme(
        axis.text.y      = element_text(size = 9, face = "bold"),
        legend.text      = element_text(size = 9),
        legend.key.width = unit(0.9, "cm")
      )
    
    ggplotly(p, tooltip = "text") %>%
      layout(
        legend = list(orientation = "h", x = 0, y = 1.12,
                      font = list(size = 10), traceorder = "normal"),
        margin = list(l = 5, r = 10, t = 80, b = 30)
      ) %>%
      config(displayModeBar = FALSE)
  })
  
  # ── TAB 3 ─────────────────────────────────────────────────────────────────
  trend_filtered <- reactive({
    trend_data %>%
      filter(region == input$region_sel, dwelling_type %in% input$dwelling_trend)
  })
  
  output$trend_plot <- renderPlotly({
    df <- trend_filtered()
    req(nrow(df) > 0)
    
    inc      <- input$income3
    s30      <- round(inc * 0.30, 0)
    s50      <- round(inc * 0.50, 0)
    reg_name <- REGION_LABELS[input$region_sel]
    
    df <- df %>%
      group_by(dwelling_type) %>%
      arrange(year) %>%
      mutate(yoy = round((rent - lag(rent)) / lag(rent) * 100, 1)) %>%
      ungroup() %>%
      mutate(
        pct_inc   = round(rent / inc * 100, 0),
        col_key2  = dwelling_type,
        yoy_label = ifelse(is.na(yoy), "Base", paste0("+", yoy, "%")),
        tip = paste0(
          "<b>", dwelling_type, " — ", year, "</b>\n",
          "Rent: $", rent, "/week\n",
          "% of $", format(inc, big.mark=","), " income: ", pct_inc, "%\n",
          ifelse(!is.na(yoy), paste0("YoY growth: +", yoy, "%"), "Baseline year")
        )
      )
    
    # Flat = blue (#4A9FD5), House = salmon-red (#E8665A) — matching R charts
    TREND_FLAT  <- "#4A9FD5"
    TREND_HOUSE <- "#E8665A"
    
    p <- ggplot(df, aes(
      x    = factor(year),
      y    = rent,
      fill = col_key2,
      text = tip
    )) +
      geom_hline(yintercept=s30, linetype="dashed", color=C_WARN,   linewidth=0.9) +
      geom_hline(yintercept=s50, linetype="dashed", color=C_SEVERE, linewidth=0.9) +
      
      geom_col(position=position_dodge(width=0.72), width=0.62, alpha=0.93) +
      
      
      # YoY % growth label above bar (gray, bold) — blank for 2020 baseline
      geom_text(aes(label=yoy_label, group=col_key2),
                position=position_dodge(width=0.72),
                vjust=-0.45, size=2.65, fontface="bold", color="gray25",
                show.legend=FALSE) +
      
      scale_fill_manual(
        values = c("Flat"=TREND_FLAT, "House"=TREND_HOUSE),
        name   = "Dwelling type"
      ) +
      scale_y_continuous(
        labels = dollar_format(prefix="$"),
        expand = expansion(mult=c(0, 0.18))
      ) +
      labs(
        title=NULL, subtitle=NULL,
        caption="Source: SA Government Private Rent Report",
        x="Year", y="Median weekly rent ($/week)"
      ) +
      theme_app(flip=FALSE) +
      theme(plot.margin=margin(8,16,8,10))
    
    ggplotly(p, tooltip="text") %>%
      layout(
        title  = list(
          text = paste0(
            "<b>", reg_name, " \u2014 Median Weekly Rent 2020\u20132025</b><br>",
            "<span style='font-size:11px;color:gray;'>",
            "Blue = Flat \u00b7 Orange = House \u00b7 ",
            "% above bars = year-on-year growth \u00b7 ",
            "Amber dashed = 30% stress ($", s30, "/wk) \u00b7 ",
            "Red dashed = 50% severe ($", s50, "/wk)",
            "</span>"
          ),
          x    = 0,
          xref = "paper",
          font = list(size = 14),
          pad  = list(b = 10)
        ),
        legend = list(
          orientation = "h",
          x = 1, xanchor = "right",
          y = 1.18, yanchor = "top",
          font = list(size = 11),
          bgcolor = "rgba(255,255,255,0.8)"
        ),
        margin = list(l=5, r=10, t=90, b=30),
        # Add threshold labels as plotly annotations (works on discrete x axis)
        annotations = list(
          list(
            x=0, xref="paper", y=s30, yref="y",
            text=paste0("  30%  ($", s30, "/wk)"),
            xanchor="left", yanchor="bottom",
            showarrow=FALSE,
            font=list(size=10, color=C_WARN),
            bgcolor="rgba(255,255,255,0.7)"
          ),
          list(
            x=0, xref="paper", y=s50, yref="y",
            text=paste0("  50%  ($", s50, "/wk)"),
            xanchor="left", yanchor="bottom",
            showarrow=FALSE,
            font=list(size=10, color=C_SEVERE),
            bgcolor="rgba(255,255,255,0.7)"
          )
        )
      ) %>%
      config(displayModeBar=FALSE)
  })
  
  output$trend_stats <- renderTable({
    df  <- trend_filtered()
    req(nrow(df) > 0)
    inc <- input$income3
    df %>%
      group_by(Dwelling = dwelling_type) %>%
      summarise(
        `2020`    = paste0("$", rent[year==2020]),
        `2025`    = paste0("$", rent[year==2025]),
        `Growth`  = paste0("+", round((rent[year==2025]-rent[year==2020])/
                                        rent[year==2020]*100, 1), "%"),
        `+$/wk`   = paste0("+$", rent[year==2025]-rent[year==2020]),
        `% inc`   = paste0(round(rent[year==2025]/inc*100, 0), "%"),
        .groups = "drop"
      )
  }, striped=TRUE, bordered=TRUE, hover=TRUE, width="100%", spacing="s")
}

shinyApp(ui = ui, server = server)
