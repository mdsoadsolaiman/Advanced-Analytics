# South Australia Rental Market Analytics for International Students

Rental Affordability, Geographic Differences and Housing-Type Trends

## Project Overview

This public-data analytics project examines South Australian rental patterns from 2020 to 2025. It combines a reproducible R workflow, a Quarto report and an interactive Shiny application to present changes in median weekly rent across geographic areas, dwelling types and bedroom categories.

The project is designed primarily for international students comparing rental locations, housing options and affordability scenarios in South Australia. Click the here to see the project: https://sa-rental-market.netlify.app 

Project resources:

- [Rendered analytics report](https://sa-rental-market.netlify.app)
- [Quarto report source](analysis/rental-market-analysis.qmd)
- [Interactive Shiny application](https://drsoso.shinyapps.io/my_shiny_app/)
- [Data dictionary](docs/data-dictionary.md)
- [Methodology](docs/methodology.md)

## Why This Project Matters for International Students

Newly arrived and prospective international students may need to compare unfamiliar rental markets while balancing location, dwelling type, household size and weekly income. This project organises public rental information into an accessible analytical guide and an interactive decision-support application.

## Target Audience

- International students considering study in South Australia
- Newly arrived students comparing rental locations
- Prospective students evaluating dwelling and sharing options
- Readers interested in South Australian public rental data

## Analytical Objectives

- Examine selected rental observations from 2020 to 2025
- Compare Metro Adelaide with the Rest of State
- Compare flats and houses
- Examine differences across regions and bedroom categories
- Present affordability scenarios for international students

## Analytical Questions

- How did selected median weekly rents change from 2020 to 2025?
- How did Metro Adelaide and Rest of State observations differ?
- How did rental values differ between flats and houses?
- How did bedroom category and region affect the observed rental comparisons?
- How do the reported rents compare with adjustable weekly-income scenarios?

## Data Source

The analysis uses the South Australian Government Private Rent Report. Six source workbooks represent the final quarter of each year from 2020 through 2025.

The selected Q4 observations are used as representative observations for each year; they are not annual averages.

## Data Preparation

The six source workbooks were consolidated into a wide-format intermediate workbook and transformed into three tidy analytical tables:

- Grand Total Tidy
- Time Series Tidy
- Bedroom Wise Tidy

The current [preparation script](scripts/prepare-rental-data.R) documents the wide-to-long workflow. It does not yet reproduce every appended aggregate row in the present processed workbook; this is recorded in the [methodology](docs/methodology.md) and [inconsistency register](docs/inconsistency-register.md).

## Interactive Rental Affordability Application

The [`app/`](app/) folder contains the SA Rental Affordability Calculator. It includes:

- An affordability calculator
- A sharing calculator
- A rent trend explorer

Hosted application: [SA Rental Affordability Calculator](https://drsoso.shinyapps.io/my_shiny_app/)

## Key Findings

- The statewide total series used by the project rises in every selected Q4 observation from 2020 to 2025.
- Metro Adelaide records a higher total median rent than the Rest of State in each selected year.
- Houses are generally more expensive than flats in the aggregate dwelling-type comparisons.
- Rental observations vary materially across regions, dwelling types and bedroom categories.
- Sharing scenarios reduce the calculated rent per person under the occupancy assumptions used in the project.

Disputed values and interpretations are deliberately excluded from this section and recorded under **Inconsistencies Under Review**.

## Repository Structure

```text
.
├── README.md
├── LICENSE
├── .gitignore
├── _quarto.yml
├── styles.css
├── analysis/       Quarto source and rendered HTML report
├── app/            Shiny application
├── scripts/        Data-preparation script
├── data/
│   ├── raw/        Six annual source workbooks
│   ├── intermediate/
│   └── processed/
├── docs/           Data, methodology, source and issue documentation
└── archive/        Local academic development records
```

## Tools and Technologies

- R
- Quarto
- Shiny and bslib
- readxl and writexl
- dplyr, tidyr and stringr
- ggplot2, plotly, patchwork and scales
- sf and ozmaps
- knitr and kableExtra

## Skills Demonstrated

- Public-data preparation
- Wide-to-long transformation
- Exploratory data analysis
- Geographic and categorical comparison
- Data visualisation
- Interactive application development
- Reproducible reporting
- Audience-focused analytical communication

## Reproducibility

Run commands from the repository root.

1. Install the packages imported by the scripts, report and application.
2. Run `scripts/prepare-rental-data.R` only after reviewing the documented aggregate-row limitation.
3. Render the report with:

   ```bash
   quarto render analysis/rental-market-analysis.qmd
   ```

4. Launch the Shiny application from the repository root:

   ```bash
   Rscript -e "shiny::runApp('app')"
   ```

No package installation is performed automatically as part of this repository workflow beyond the existing unmodified preparation script.

## Limitations

- The analysis uses one selected quarter to represent each year.
- The dataset describes rental observations and does not establish causal explanations.
- Affordability outputs depend on the income, threshold and occupancy assumptions encoded in the existing analysis.
- The current preparation script does not reproduce every aggregate row appended to the processed workbook.
- Several numerical and interpretive inconsistencies remain intentionally unresolved pending approval.

## Inconsistencies Under Review

The project preserves the original analytical work. Known differences involving reported values, growth rates, row counts, affordability assumptions and interpretation are documented in the [inconsistency register](docs/inconsistency-register.md). None has been silently corrected.

## Future Work

- Resolve documented inconsistencies through an approved analytical review
- Complete end-to-end data-pipeline validation
- Add dependency management
- Review accessibility and deployment documentation
- Assess additional affordability inputs such as bonds, utilities and transport

## Author

Md Soad Solaiman

## License

Original project code is provided under the [MIT License](LICENSE). Government datasets and other third-party source materials are not covered by that code licence and remain subject to their respective terms.
