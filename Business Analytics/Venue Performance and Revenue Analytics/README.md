# La Commission de Netball — Venue Performance and Revenue Analytics

## Home-Court Advantage, Spectator Demand and Venue-Income Decision Support

La Commission de Netball is evaluating whether lessons from Australia’s Super Netball competition can support the design and financial planning of a proposed French national competition. This advisory case study considers whether home-court advantage, team performance and spectator attendance are associated with venue-income outcomes, with the aim of informing league structure, venue planning and future data collection. The evidence is descriptive: it does not estimate profitability or establish causation.

## Executive Brief

**Situation.** La Commission de Netball is considering how an emerging French national competition might learn from Super Netball, an established market with recognisable teams, home venues and spectator demand.

**Decision.** Commission leadership needs to determine whether home-team identity, local support and competitive performance deserve strategic emphasis in league and venue planning.

**Approach.** The R workflow cleans malformed and duplicated records, reshapes 14 rounds of match data, engineers performance measures, compares team distributions and explores attendance, performance and venue-income relationships.

**Evidence.** Teams recorded more wins at home and a higher median goal ratio in home matches. Attendance had only a weak positive visual relationship with venue income and no clear visual relationship with final competition points. Final points had a strong positive visual relationship with income per spectator in this dataset.

**Management implication.** Home identity and team performance are credible planning considerations, but the current evidence does not justify profitability claims, causal conclusions or investment approval based on any single indicator.

## Client and Strategic Context

This case study is framed as an advisory analysis for La Commission de Netball. The Commission is assessing how the structure and commercial characteristics of Australia’s Super Netball competition could inform a proposed French national league.

Super Netball is a useful benchmark because it provides established home teams, repeated match activity, spectator attendance and venue-income observations. These measures allow Commission leadership to investigate whether local identity and competitive performance align with stronger venue outcomes.

The intended audience is Commission leadership rather than technical analysts. Accordingly, the project translates the R workflow into decision evidence, commercial cautions and future information requirements.

## League and Team Context

The dataset covers eight Super Netball teams:

- Fever
- Firebirds
- GIANTS
- Lightning
- Magpies
- Swifts
- Thunderbirds
- Vixens

The source combines team-season information with round-level match records. Team-season fields describe the team, its state and total venue income, while the 14 round fields record home or away status, team score, opponent score and attendance.

## Management Decision

La Commission de Netball is assessing whether a future French competition should place strategic emphasis on:

- local home-team identity;
- spectator-development initiatives;
- competitive balance;
- venue-revenue monitoring;
- team-performance indicators; and
- improved commercial data collection.

The current evidence can support planning hypotheses and KPI design. It is not sufficient for final venue investment, team funding or profitability approval.

## Business Questions

1. Do teams demonstrate a measurable descriptive advantage when playing at home?
2. Is stronger team performance associated with higher venue income?
3. Does greater home attendance correspond with greater venue income?
4. Does team performance appear to influence income generated per spectator?
5. Which indicators should the Commission monitor in a future French league?
6. What additional revenue and cost data are needed before profitability can be assessed?

## Dataset

The included dataset is [data/netball_0.csv](data/netball_0.csv).

- It contains 10 source rows and 17 source columns before cleaning.
- Each source row represents a team-season record.
- Fourteen round columns contain home or away status, team score, opponent score and attendance.
- Venue income includes ticket sales, food, merchandise, sponsorship, broadcast rights, donations, grants and other income collected during the season.
- The income measure excludes expenses.
- The data combines real Super Netball match information with synthetic additions created for educational and analytical purposes.
- The CSV is included for full reproducibility.

## Data Quality and Preparation

The completed workflow:

- removes a duplicated team record;
- removes a non-data/test row;
- corrects three malformed attendance or score values;
- removes currency symbols and separators and corrects the income sign;
- reshapes the 14 round columns from wide to long format;
- extracts home/away status, score, opponent score and attendance;
- standardises variable names and types;
- checks for missing values; and
- engineers match result, league points and goal ratio.

These operations preserve the analytical pipeline documented in the R Markdown.

## Analytical Framework

### Competitive Performance

Team-level boxplots compare score and goal-ratio distributions. Score represents goals recorded by the team, while goal ratio incorporates opponent performance by dividing team score by opponent score.

### Home-Court Advantage

Home and away win counts are compared alongside the distribution of goal ratios by venue status. Together, these measures provide descriptive evidence about whether teams perform differently at home.

### Spectator Demand

Home-match attendance is aggregated by team. This creates a season-level spectator measure that can be compared with competitive and income outcomes.

### Venue-Income Relationships

The analysis combines total home attendance, final competition points, venue income and income per spectator. Scatterplots with fitted linear trends provide exploratory comparisons of:

- home attendance and venue income;
- home attendance and final points; and
- final points and income per spectator.

## Key Findings

- More wins were recorded at home than away.
- Median goal ratio was higher for home matches.
- Total home attendance showed only a weak positive visual relationship with venue income.
- Home attendance showed no clear visual relationship with final competition points.
- Final competition points showed a strong positive visual relationship with income per spectator in this dataset.

These findings describe the observed sample. They do not show that home status, attendance or performance causes a financial outcome.

## Interpretation for La Commission de Netball

Home identity may matter when designing a French competition because the analysed teams recorded stronger descriptive outcomes at home. This supports treating local affiliation and home scheduling as league-design considerations.

Attendance growth alone is unlikely to explain venue-income performance. The weak visual attendance-income relationship indicates that pricing, sponsorship, merchandise, broadcast arrangements and other income streams may materially affect venue outcomes.

Competitive performance may influence the commercial value generated per spectator, given the positive visual relationship between final points and income per spectator. Stronger teams may therefore support commercial outcomes, but the current data cannot determine direction, causation or the contribution of individual revenue streams.

Income per spectator must not be interpreted as profit. Commission leadership should monitor performance, demand and commercial outcomes together rather than using a single metric to assess team or venue viability.

## Strategic Recommendations

### League Design

- Treat home-team identity and local support as planning considerations when selecting markets and scheduling matches.
- Monitor whether the descriptive home advantage persists across multiple seasons before using it in competition-policy decisions.

### Venue Strategy

- Record ticket, food, merchandise, sponsorship and other income separately.
- Compare spectator demand with venue capacity and pricing before drawing conclusions about revenue performance.

### Performance Monitoring

- Monitor final points, win rates, goal ratios, attendance and income per spectator together.
- Use a balanced KPI set so that strong performance or attendance does not mask weak commercial outcomes.

### Data Strategy

- Collect multiple seasons to distinguish persistent patterns from one-season effects.
- Add expenses, ticket prices, venue capacity, marketing expenditure, opponent strength and broadcast data.
- Preserve match-level revenue fields so that attendance and income can be compared at the same unit of analysis.

The data recommendations extend the evidence required for future decisions; they are not claims produced by the current dataset.

## Financial Interpretation

Venue income is a gross income measure, not profit. It combines ticket sales, food, merchandise, sponsorship, broadcast rights, donations, grants and other receipts while excluding expenses.

Consequently, the current analysis cannot estimate:

- operating margin;
- break-even attendance;
- return on investment;
- venue profitability; or
- the financial viability of a proposed French competition.

Attendance also cannot be converted into financial value without ticket prices, spectator spending and the allocation of other income streams. Any investment case would require itemised revenue, operating expenses, capital costs and venue-capacity information.

## Risks and Limitations

- The analysis covers a small number of teams.
- Only a limited season window is represented.
- The dataset contains synthetic additions.
- Venue income combines multiple streams.
- Expenses are absent.
- Venue capacity is not controlled.
- Ticket price is not controlled.
- Market size is not controlled.
- Opponent strength is not controlled.
- The fitted lines are exploratory visual summaries.
- No formal causal inference is performed.
- No external validation is available.
- Team-level relationships may be sensitive to individual teams.

## Skills Demonstrated

### R and Data Engineering

- R
- R Markdown
- `tidyverse`
- Data cleaning
- Data validation
- Wide-to-long reshaping
- Feature engineering

### Analysis and Visualisation

- Grouped aggregation
- Descriptive statistics
- Boxplots
- Scatterplots
- Linear trend analysis
- Comparative analysis

### Business Analytics

- Decision framing
- KPI interpretation
- Commercial reasoning
- Limitation assessment
- Stakeholder reporting
- Recommendation development

## Technology

- R
- R Markdown
- `tidyverse`
- `inspectdf`
- `knitr`

## Repository Structure

```text
Venue_Performance_And_Revenue_Analytics/
├── README.md
├── analysis/
│   └── venue-performance-and-home-court-advantage.Rmd
└── data/
    └── netball_0.csv
```

## Reproducibility

1. Clone the repository.
2. Confirm `data/netball_0.csv` is present.
3. Install the required packages:

   ```r
   install.packages(c("tidyverse", "inspectdf", "rmarkdown", "knitr"))
   ```

4. From the repository root, render the R Markdown:

   ```r
   rmarkdown::render(
     "analysis/venue-performance-and-home-court-advantage.Rmd"
   )
   ```

5. Review the generated report and its code, tables and figures.

## Portfolio Context

This project originated from university coursework and has been professionally reorganised as a business analytics portfolio case study.
