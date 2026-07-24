# Methodology

## Existing Workflow

1. Six South Australian Government Private Rent Report workbooks provide Q4 observations for 2020–2025.
2. Selected sheets and fields were consolidated into `data/intermediate/combined-rental-data.xlsx`.
3. [`scripts/prepare-rental-data.R`](../scripts/prepare-rental-data.R) reads the wide-format staging workbook.
4. The script constructs combined headers, reshapes records from wide to long format, standardises selected labels and writes tidy tables.
5. The processed workbook contains Grand Total Tidy, Time Series Tidy and Bedroom Wise Tidy tables.
6. The [Quarto report](../analysis/rental-market-analysis.qmd) reads the processed workbook and produces the portfolio analysis.
7. The [Shiny application](../app/app.R) reads the same processed workbook for affordability, sharing and trend views.

## Representation of Years

The project uses the final quarter of each year as the selected observation representing that year. Results should not be interpreted as annual averages.

## Reproducibility Limitation

The inspected preparation script currently produces the core tidy transformations but does not reproduce all 42 aggregate rows appended to the current Grand Total Tidy sheet. The processed workbook contains 186 grand-total data rows, whereas the scripted core transformation accounts for 144 rows.

This limitation remains unresolved. The current processed workbook is therefore the authoritative input for the existing report and application until an approved analytical review reconciles the aggregate-row generation process.

See also:

- [Data dictionary](data-dictionary.md)
- [Data sources](data-sources.md)
- [Known inconsistencies](inconsistency-register.md)
- [Project README](../README.md)
