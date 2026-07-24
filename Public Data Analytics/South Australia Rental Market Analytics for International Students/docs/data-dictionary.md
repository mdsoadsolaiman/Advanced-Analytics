# Data Dictionary

The processed workbook contains three tidy tables. Variables appear where applicable to each table:

- `Grand Total Tidy`
- `Time Series Tidy`
- `Bedroom Wise Tidy`

| Variable | Existing meaning |
|---|---|
| `year` | Year associated with the selected source observation, covering 2020–2025 |
| `area_group` | Geographic grouping used by the source data, including Metro, Rest of State and aggregate categories where present |
| `region` | South Australian government region recorded in the time-series and bedroom-wise tables |
| `dwelling_type` | Dwelling category used in the processed data, principally Flat or House |
| `bedroom_type` | Bedroom-size category associated with the dwelling observation |
| `measure` | Type of time-series measure, such as Flat Median, House Median, Total Count or Total Median |
| `value` | Value recorded for a time-series measure |
| `median ($)` | Median weekly rent in Australian dollars in the grand-total and bedroom-wise tables |

The selected annual observations come from the final quarter of each source year.

See also:

- [Methodology](methodology.md)
- [Data sources](data-sources.md)
- [Known inconsistencies](inconsistency-register.md)
- [Project README](../README.md)
