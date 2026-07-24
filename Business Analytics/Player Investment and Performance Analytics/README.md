# Carnac Menhirs Player Investment and Performance Analytics

## Salary, Attendance and Goal-Shooting Decision Support

### Executive Brief

**Stakeholder.** The management committee and treasurer of Carnac Menhirs, a proposed team in a French professional netball league.

**Decision problem.** Management must decide how player-performance evidence should inform recruitment and salary allocation. The standard budget is approximately AUD 120,000 per player, with up to AUD 500,000 available for an exceptional recruit.

**Analytical approach.** The completed R workflow cleans 14,000 de-identified player-season records, profiles salary and age by position, isolates a reproducible sample of 1,350 Goal Shooters, applies Box-Cox transformations, fits the completed linear model and reports 97% confidence and prediction intervals.

**Main findings.** Salary had no clear relationship with experience across positions. In the Goal Shooter sample, salary was positively associated with average attendance and shooting accuracy. These observational relationships do not establish causation.

**Model evidence.** The transformed model estimated a positive salary coefficient of 0.000803225 per AUD 1,000 on the transformed-accuracy scale (\(p<2\times10^{-16}\)). Its in-sample \(R^2\) and adjusted \(R^2\) were both 0.996. These statistics support a strong positive in-sample salary-accuracy association; they do not establish causation or guarantee reliable operational forecasts.

**Model-boundary result.** For the illustrative AUD 330,000 salary scenario, the fitted model produced a 100.2% point prediction. The 97% prediction interval extended from approximately 99.6% to 101.0% (100.8% in the rounded model table). These are genuine mathematical outputs, but accuracy above 100% is physically impossible. The boundary violation identifies a model-specification limitation near the upper response limit; it does not by itself show that salary lacks predictive information within the analysed sample.

**Major limitation.** Residual diagnostics show remaining curvature, changing variance and tail departures. Independence is also uncertain because the same player may appear in several seasons under different identifiers.

**Management implication.** The model is useful for scenario comparison and candidate screening, but it does not identify an optimal salary, forecast commercial return or justify a contract by itself.

### Business Context

Carnac Menhirs must allocate salary expenditure across seven playing positions. Goal Shooter is the position most directly focused on scoring. Management expects successful players may support scoring and spectator interest, while the proposed league's venue income-sharing arrangement makes attendance commercially relevant.

The dataset can examine salary, attendance and performance associations. It cannot calculate match revenue, profitability or return on investment because it contains no ticket prices, revenue-sharing percentages, commercial income or operating costs.

### Decision Problem

The committee is considering:

- a standard salary budget of approximately AUD 120,000 per player;
- salaries up to AUD 500,000 for an exceptional recruit;
- the sporting evidence supporting Goal Shooter recruitment;
- model-based scenarios accompanied by 97% intervals; and
- the additional evidence required before making a major financial commitment.

The analysis supports screening and scenario evaluation. It does not establish a recommended maximum salary.

### Business Questions

- How do player age and salary vary across playing positions?
- Is salary associated with playing experience or average attendance?
- Among Goal Shooters, how is salary associated with attendance and shooting accuracy?
- What does the completed transformed linear model predict across illustrative salary scenarios?
- What do the model diagnostics imply for the reliability of 97% intervals?
- Which conclusions are useful for recruitment, and which require financial data not present in the dataset?

### Dataset

The included file, [`data/nbplayers_1.csv`](data/nbplayers_1.csv), contains 14,000 de-identified player-season records and nine source variables:

- player-season identifier;
- date of birth and height;
- first-class playing experience;
- purchasing-power-adjusted salary in Australian dollars;
- playing position;
- goals and misses; and
- standardised average attendance.

A player may appear in multiple seasons under different identifiers. Four invalid records are removed by the documented cleaning workflow, leaving 13,996 analysis-ready records.

### Analytical Approach

The report:

1. applies the original reproducible random permutation and record identifiers;
2. validates identifiers, dates and numeric extremes;
3. removes four identified invalid records and corrects a negative height;
4. derives player age and expresses salary in AUD thousands;
5. profiles players across the seven positions;
6. draws the original reproducible sample of 1,350 Goal Shooters;
7. derives shooting accuracy;
8. applies Box-Cox transformations to attendance and accuracy;
9. fits the completed transformed-accuracy linear model;
10. evaluates residual diagnostics; and
11. reports point predictions and 97% confidence and prediction intervals.

### Key Findings

- Player height was approximately symmetric, with skewness of -0.00285.
- Average attendance was moderately right-skewed, with skewness of 0.4299.
- Age distributions were similar across positions, with median age around 28.
- Salary distributions were broadly similar, with marginally higher medians for Goal Attack and Goal Shooter.
- Salary showed no clear relationship with experience across positions.
- Goal Shooter salary was positively associated with attendance and shooting accuracy in the analysed sample.
- The attendance Box-Cox lambda was 0.8275; the accuracy lambda was 3.85.
- The fitted transformed-accuracy equation was approximately \(\hat{y}=-0.2632+0.0008032x\). The salary coefficient was positive and statistically significant (\(p<2\times10^{-16}\)); \(R^2\) and adjusted \(R^2\) were both 0.996, and the residual standard error was 0.002789.
- At AUD 300,000, the point prediction was 97.7%; the 97% confidence interval was approximately 97.6%-97.8%, and the 97% prediction interval was approximately 97.0%-98.3%.
- At AUD 330,000, the point prediction was 100.2%; the 97% confidence interval was approximately 100.1%-100.3% at summary precision (exact model output: 100.1156%-100.2470%), and the 97% prediction interval was approximately 99.6%-101.0% (exact model output: 99.5697%-100.7826%).

### Boundary Violation at AUD 330,000

AUD 330,000 was one of thirteen illustrative scenarios spanning AUD 120,000 to AUD 480,000. For the illustrative AUD 330,000 salary scenario, the fitted model produced a 100.2% point prediction, highlighting that the linear model exceeds the natural 0%-100% shooting-accuracy boundary.

The corresponding 97% prediction interval extended from approximately 99.6% to 101.0% when described at the report's summary precision; the rounded model table reports an upper endpoint of 100.8%. These are genuine mathematical model outputs. They are not physically achievable performance forecasts.

The fitted model indicates a positive association between Goal Shooter salary and shooting accuracy within the analysed sample. However, predictions at higher salary scenarios exceed the natural 100% boundary. This indicates a limitation of the transformed linear model specification rather than evidence that more than 100% accuracy is possible or that salary has no predictive relationship.

Salary may provide explanatory information within the analysed sample, but the completed model is not reliable for high-salary operational decisions and should not be used as the sole basis for player investment. AUD 330,000 is not an optimal salary, a recommended salary, a maximum justified salary or evidence of financial return.

### Decision Implications

- Use the model to compare illustrative scenarios and identify candidates for further assessment.
- Interpret the narrow model-based intervals in light of the imperfect diagnostic results.
- Do not treat attendance as revenue or shooting accuracy as commercial return.
- Do not infer that a higher salary causes better attendance or accuracy.
- Require player-specific evidence and financial data before approving an exceptional salary.

### Recommendations

- Use the completed model as one input to recruitment screening, not as the sole basis for a contract.
- Evaluate shortlisted Goal Shooters using health, availability, experience, team fit and additional match-performance measures.
- Collect attendance-linked revenue, venue-sharing, sponsorship and cost data before making a major salary commitment.
- Validate the findings on additional seasons and use player-level identifiers where possible.
- Consider a bounded-response modelling approach before operational forecasting near 100% accuracy.

### Model Risks and Limitations

- The analysis is observational and does not establish causation.
- The residuals-versus-fitted plot retains curvature.
- Residual spread changes across fitted values.
- The Q-Q plot shows departures in both tails.
- Independence is uncertain because a player may appear in multiple seasons under different identifiers.
- The 97% intervals are model-based and rely on assumptions that are imperfectly satisfied.
- The Goal Shooter sample does not represent every playing position.
- Accuracy is bounded between 0% and 100%, but the linear model is not.
- Average attendance is not revenue.
- The dataset cannot support profitability or return-on-investment analysis.
- No external validation was performed.

### Skills Demonstrated

- R data cleaning and validation
- Reproducible sampling
- Feature engineering
- Exploratory data analysis
- Faceted data visualisation
- Box-Cox transformation
- Linear regression
- Residual diagnostics
- Confidence and prediction intervals
- Model-risk communication
- Business decision support

### Technology

- R and R Markdown
- `tidyverse`
- `moments`
- `caret`
- `tidymodels`
- `knitr`

### Repository Structure

```text
Player_Investment_And_Performance_Analytics/
├── README.md
├── analysis/
│   ├── player-salary-and-attendance-analysis.Rmd
│   └── player-salary-and-attendance-analysis.html
└── data/
    └── nbplayers_1.csv
```

### Reproducibility

1. Clone the repository.
2. Confirm `data/nbplayers_1.csv` is present.
3. Install the required packages:

   ```r
   install.packages(c(
     "tidyverse",
     "moments",
     "caret",
     "tidymodels",
     "rmarkdown",
     "knitr"
   ))
   ```

4. From the repository root, render the R Markdown:

   ```r
   rmarkdown::render(
     "analysis/player-salary-and-attendance-analysis.Rmd"
   )
   ```

5. Open `analysis/player-salary-and-attendance-analysis.html`.

### Portfolio Context

This project originated from university coursework and has been professionally reorganised as a business analytics portfolio case study.
