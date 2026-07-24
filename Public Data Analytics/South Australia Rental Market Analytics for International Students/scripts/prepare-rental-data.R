library(readxl)

file_path <- "data/intermediate/combined-rental-data.xlsx"

bedroom_wise <- read_excel(file_path, sheet = "Bedroom wise", col_names = FALSE)
grand_total  <- read_excel(file_path, sheet = "Grand total", col_names = FALSE)
time_series  <- read_excel(file_path, sheet = "Time Series", col_names = FALSE)

head(bedroom_wise)
head(grand_total)
head(time_series)

library(dplyr)
library(tidyr)
library(stringr)


# create column names from first 2 rows
header1 <- as.character(unlist(time_series[1, ]))
header2 <- as.character(unlist(time_series[2, ]))

col_names <- ifelse(
  is.na(header2) | header2 == "",
  header1,
  paste(header1, header2, sep = "_")
)

col_names <- make.names(col_names, unique = TRUE)

# remove header rows and assign names
time_series_clean <- time_series[-c(1, 2), ]
names(time_series_clean) <- col_names

# reset row numbers
time_series_clean <- time_series_clean %>% 
  mutate(across(everything(), as.character))

# view result
View(time_series_clean)
head(time_series_clean)

library(dplyr)
library(tidyr)

time_series_long <- time_series_clean %>%
  rename(
    area_group = 1,
    region = 2
  ) %>%
  pivot_longer(
    cols = -c(area_group, region),
    names_to = "variable",
    values_to = "value"
  )

head(time_series_long)
View(time_series_long)


time_series_long2 <- time_series_clean %>%
  rename(
    area_group = 1,
    region = 2
  ) %>%
  pivot_longer(
    cols = -c(area_group, region),
    names_to = "variable",
    values_to = "value"
  ) %>%
  separate(
    variable,
    into = c("year", "measure"),
    sep = "_",
    extra = "merge"
  ) %>%
  mutate(
    year = sub("^X", "", year)
  )

head(time_series_long2)



time_series_tidy <- time_series_clean %>%
  rename(
    area_group = 1,
    region = 2
  ) %>%
  pivot_longer(
    cols = -c(area_group, region),
    names_to = "variable",
    values_to = "value"
  ) %>%
  separate(
    variable,
    into = c("year", "measure"),
    sep = "_",
    extra = "merge"
  ) %>%
  mutate(
    year = sub("^X", "", year),
    measure = str_replace_all(measure, "\\.", " "),
    measure = str_replace_all(measure, "Units", ""),
    measure = str_squish(measure),
    measure = case_when(
      measure == "Flats Median"  ~ "Flat Median",
      measure == "Houses Median" ~ "House Median",
      TRUE ~ measure
    )
  )

head(time_series_tidy)
View(time_series_tidy)


time_series_tidy <- time_series_tidy %>%
  select(year, area_group, region, measure, value)


head(time_series_tidy)
View(time_series_tidy)


install.packages("writexl")
library(writexl)

write_xlsx(
  time_series_tidy,
  "data/processed/time-series-tidy.xlsx"
)



library(dplyr)
library(tidyr)
library(stringr)
library(writexl)

# -----------------------------
# BEDROOM WISE
# -----------------------------

# row 1 = year
# row 2 = dwelling type
# row 3 = bedroom category
# row 4 = metric
# row 5 onward = data

h1_bw <- as.character(unlist(bedroom_wise[1, ]))
h2_bw <- as.character(unlist(bedroom_wise[2, ]))
h3_bw <- as.character(unlist(bedroom_wise[3, ]))
h4_bw <- as.character(unlist(bedroom_wise[4, ]))

bw_names <- ifelse(
  seq_along(h1_bw) <= 2,
  c("area_group", "region")[seq_along(h1_bw)],
  paste(h1_bw, h2_bw, h3_bw, h4_bw, sep = "_")
)

bw_names <- make.names(bw_names, unique = TRUE)

bedroom_wise_tidy <- bedroom_wise[-c(1, 2, 3, 4), ]
names(bedroom_wise_tidy) <- bw_names

bedroom_wise_tidy <- bedroom_wise_tidy %>%
  pivot_longer(
    cols = -c(area_group, region),
    names_to = "variable",
    values_to = "value"
  ) %>%
  separate(
    variable,
    into = c("year", "dwelling_type", "bedroom_type", "measure"),
    sep = "_",
    extra = "merge"
  ) %>%
  mutate(
    year = sub("^X", "", year),
    dwelling_type = str_replace_all(dwelling_type, "\\.", " "),
    bedroom_type  = str_replace_all(bedroom_type, "\\.", " "),
    measure       = str_replace_all(measure, "\\.", " "),
    
    dwelling_type = str_squish(dwelling_type),
    bedroom_type  = str_squish(bedroom_type),
    measure       = str_squish(measure),
    
    dwelling_type = case_when(
      dwelling_type == "Flat" ~ "Flat",
      dwelling_type == "House" ~ "House",
      TRUE ~ dwelling_type
    ),
    
    bedroom_type = case_when(
      str_detect(str_to_lower(bedroom_type), "dwelling") ~ NA_character_,
      TRUE ~ bedroom_type
    ),
    
    bedroom_type = str_replace_all(bedroom_type, regex("^1\\s*be.*", ignore_case = TRUE), "1 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^2\\s*be.*", ignore_case = TRUE), "2 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^3\\s*be.*", ignore_case = TRUE), "3 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^4\\+\\s*b.*", ignore_case = TRUE), "4+ bedroom"),
    
    measure = str_replace_all(measure, regex("Area Group", ignore_case = TRUE), ""),
    measure = str_replace_all(measure, regex("Region", ignore_case = TRUE), ""),
    measure = str_replace_all(measure, regex("Median", ignore_case = TRUE), "Median"),
    measure = str_squish(measure),
    
    year = as.numeric(year),
    value = as.numeric(value)
  ) %>%
  select(year, area_group, region, dwelling_type, bedroom_type, measure, value)

# -----------------------------
# GRAND TOTAL
# -----------------------------

# row 1 = year
# row 2 = dwelling type
# row 3 = bedroom category
# row 4 = measure
# row 5 onward = data

h1_gt <- as.character(unlist(grand_total[1, ]))
h2_gt <- as.character(unlist(grand_total[2, ]))
h3_gt <- as.character(unlist(grand_total[3, ]))
h4_gt <- as.character(unlist(grand_total[4, ]))

gt_names <- ifelse(
  seq_along(h1_gt) == 1,
  "area_group",
  paste(h1_gt, h2_gt, h3_gt, h4_gt, sep = "_")
)

gt_names <- make.names(gt_names, unique = TRUE)

grand_total_tidy <- grand_total[-c(1, 2, 3, 4), ]
names(grand_total_tidy) <- gt_names

grand_total_tidy <- grand_total_tidy %>%
  pivot_longer(
    cols = -area_group,
    names_to = "variable",
    values_to = "value"
  ) %>%
  separate(
    variable,
    into = c("year", "dwelling_type", "bedroom_type", "measure"),
    sep = "_",
    extra = "merge"
  ) %>%
  mutate(
    year = sub("^X", "", year),
    dwelling_type = str_replace_all(dwelling_type, "\\.", " "),
    bedroom_type  = str_replace_all(bedroom_type, "\\.", " "),
    measure       = str_replace_all(measure, "\\.", " "),
    
    dwelling_type = str_squish(dwelling_type),
    bedroom_type  = str_squish(bedroom_type),
    measure       = str_squish(measure),
    
    dwelling_type = case_when(
      dwelling_type == "Flat" ~ "Flat",
      dwelling_type == "House" ~ "House",
      TRUE ~ dwelling_type
    ),
    
    bedroom_type = str_replace_all(bedroom_type, regex("^1\\s*be.*", ignore_case = TRUE), "1 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^2\\s*be.*", ignore_case = TRUE), "2 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^3\\s*be.*", ignore_case = TRUE), "3 bedroom"),
    bedroom_type = str_replace_all(bedroom_type, regex("^4\\+\\s*b.*", ignore_case = TRUE), "4+ bedroom"),
    
    measure = str_replace_all(measure, regex("Price", ignore_case = TRUE), ""),
    measure = str_replace_all(measure, regex("Median", ignore_case = TRUE), "Median"),
    measure = str_squish(measure),
    
    year = as.numeric(year),
    value = as.numeric(value)
  ) %>%
  select(year, area_group, dwelling_type, bedroom_type, measure, value)

# -----------------------------
# CHECK
# -----------------------------

head(bedroom_wise_tidy)
head(grand_total_tidy)

View(bedroom_wise_tidy)
View(grand_total_tidy)




bedroom_wise_tidy <- bedroom_wise_tidy %>%
  select(-measure) %>%
  rename(`median ($)` = value)

grand_total_tidy <- grand_total_tidy %>%
  select(-measure) %>%
  rename(`median ($)` = value)

head(bedroom_wise_tidy)
head(grand_total_tidy)


library(writexl)

library(writexl)

write_xlsx(
  list(
    "Time Series Tidy" = time_series_tidy,
    "Bedroom Wise Tidy" = bedroom_wise_tidy,
    "Grand Total Tidy" = grand_total_tidy
  ),
  "data/processed/rental-data-tidy.xlsx"
)
