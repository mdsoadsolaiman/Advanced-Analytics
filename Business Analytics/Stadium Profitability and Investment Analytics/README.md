# Carnac Menhirs Stadium Profitability Decision Support

## Classification Modelling and Operational Scenario Analysis

### Executive Brief

**Stakeholder.** The managing committee of Carnac Menhirs, which has acquired La Stade des Menhirs as the proposed home venue for a new professional netball team.

**Decision problem.** Management needs to assess first-season profitability risk and determine whether changing the planned café format warrants a detailed commercial business case.

**Analytical approach.** The completed R workflow defines binary profitability, fits a classification tree, develops a logistic model with second-order interactions, applies backward selection and evaluates the selected model on 7,000 held-out records.

**Event definition.** `profit = "yes"` is the profitable or positive class. The model uses `.pred_yes`, the predicted probability of profit, and a conventional 0.50 threshold for class predictions.

**Held-out performance.** Accuracy is 69.01%, profitable-class sensitivity is 78.44%, not-profitable specificity is 55.25%, profitable-class precision is 71.91%, balanced accuracy is 66.85%, and ROC AUC is 75.28%.

**Scenario evidence.** The current kiosk scenario has a 41.78% predicted probability of profit and is classified as not profitable. A vending machine lowers the probability to 31.66% and remains not profitable. A bar raises it to 54.41% and is classified as profitable.

**Management implication.** The bar scenario produced the highest predicted probability among the tested café formats, conditional on the fitted model and all other inputs being held constant. This is not evidence that a bar causes profitability and does not include conversion or operating costs.

### Business Context

Carnac Menhirs has assembled a seven-player team with 40 combined years of experience. The club has acquired an older stadium in poor condition, has 1,500 paying members, no recent premiership history and a planned kiosk.

The committee wants an accessible assessment of first-season profit risk and a practical operational scenario for further evaluation. The analysis compares comparable club-season records; it does not estimate the causal effect or net financial return of a café conversion.

### Decision Problem

Management must determine:

- whether the current stadium configuration is classified as profitable;
- which club and venue factors contribute to the modelled outcome;
- how reliably the model distinguishes profitable and not-profitable records;
- whether an alternative café format improves predicted probability; and
- what additional cost and operating evidence is required before implementation.

### Business Questions

- How should binary profitability be defined?
- Which predictors drive the classification tree?
- Which main effects and interactions remain in the selected logistic model?
- What are the held-out confusion-matrix counts and explicitly oriented metrics?
- How well does profitable-class probability rank held-out records?
- How do kiosk, vending-machine and bar scenarios compare?

### Dataset

The included file, [`data/stades_2.csv`](data/stades_2.csv), contains 25,000 club-season records and seven source variables:

| Variable | Business meaning |
|---|---|
| `Revenue` | Season revenue, measured in thousands |
| `Costs` | Season costs, measured in thousands |
| `a d'e` | Average years of player experience |
| `MEMBERS` | Paying club members |
| `COUPE` | Premiership in the previous 10 years |
| `Cond` | Stadium condition |
| `Cafe` | Bar, kiosk or vending-machine format |

Profit is `yes` when revenue exceeds costs and `no` otherwise. Revenue and costs are removed from the predictors to prevent direct outcome leakage. The full dataset contains 14,981 profitable and 10,019 not-profitable records.

### Analytical Approach

1. Reproducibly reorder and standardise all 25,000 records.
2. Derive binary profitability and remove revenue and costs from the predictors.
3. Fit and inspect a classification tree.
4. Split the data into 18,000 training and 7,000 testing records.
5. Fit baseline and interaction logistic models.
6. Preserve the completed backward-selection workflow and model hierarchy.
7. Evaluate held-out classes with `yardstick`, explicitly treating `yes` as the event.
8. Calculate ROC AUC from `.pred_yes`.
9. Compare kiosk, vending-machine and bar scenarios.

### Model Structure

- The full-data classification tree has four splits and five terminal nodes.
- Split variables are premiership history, membership, café format and membership.
- Variable importance ranks premiership history first, membership second and café format third.
- The selected logistic model retains average experience, membership, premiership history, café format, `members:coupe` and `members:cafe`.
- The completed workflow uses a 93% significance level. This is unconventional relative to 95%, and backward selection is sample-sensitive.
- Statistical significance does not necessarily imply operational importance.

### Corrected Held-Out Evaluation

The confusion matrix uses predicted classes in rows and truth classes in columns:

| Outcome | Count |
|---|---:|
| True positive | 3,259 |
| True negative | 1,572 |
| False positive | 1,273 |
| False negative | 896 |

With profitable records defined as the event:

| Metric | Result |
|---|---:|
| Accuracy | 69.01% |
| Sensitivity/recall | 78.44% |
| Specificity | 55.25% |
| Precision | 71.91% |
| Balanced accuracy | 66.85% |
| ROC AUC | 75.28% |

The former 21.56% figure labelled as sensitivity was the false-negative rate, calculated as \(896/(3259+896)\). The predictions did not change; the metric definition and label were corrected.

### ROC and Threshold

The authoritative ROC specification uses:

- truth: `profit`;
- event: `yes`, the second factor level;
- probability: `.pred_yes`; and
- AUC: 0.7528, or 75.28%.

The 0.50 classification threshold is a conventional default, not a business optimum. Lowering it would generally identify more profitable stadiums but increase false positives. Raising it would generally reduce false positives but miss more profitable stadiums. The held-out test set was not used to optimise a replacement threshold.

### Stadium Scenarios

All scenarios hold average experience, membership, stadium condition and premiership history constant:

| Scenario | Profit probability | Logistic class | Tree class |
|---|---:|---|---|
| Current kiosk | 41.78% | Not profitable | Not profitable |
| Vending machine | 31.66% | Not profitable | Not profitable |
| Bar | 54.41% | Profitable | Profitable |

These are conditional scenario comparisons, not intervention-effect estimates or guaranteed financial outcomes. Binary profitability also does not quantify the size of a profit or loss.

### Decision Implications

- The current kiosk configuration remains below the 0.50 classification threshold.
- The bar has the highest predicted probability among the tested café formats.
- Specificity is lower than sensitivity, so false-positive classifications are a material risk.
- A predicted profitable class does not establish positive net value after conversion and operating costs.
- Scenario probabilities should inform a costed feasibility study, not immediate implementation.

### Recommendations

- Develop a costed business case for the bar scenario.
- Include conversion, staffing, licensing, stock, wastage and operating costs.
- Monitor membership, café transactions, average spend and contribution margin.
- Review probabilities and error costs alongside predicted classes.
- Refit and validate the model using actual first-season data.

### Risks and Limitations

- The analysis is observational and does not establish causation.
- Comparable source clubs may differ from the French operating environment.
- The 0.50 threshold is conventional rather than economically optimised.
- The 93% model-selection level is unconventional.
- Backward selection is sample-sensitive.
- The model has useful but imperfect discrimination.
- The binary outcome does not estimate profit magnitude.
- Intervention and operating costs are absent.
- No external validation or repeated cross-validation was performed.
- Scenarios change one input while holding all others constant.

### Skills Demonstrated

- R data preparation and feature engineering
- Classification trees and variable importance
- Logistic regression and interaction analysis
- Backward model selection
- Held-out model evaluation
- Confusion-matrix interpretation
- Sensitivity, specificity, precision and balanced accuracy
- ROC/AUC analysis
- Operational scenario comparison
- Model-risk communication

### Technology

- R and R Markdown
- `tidyverse`
- `tidymodels`
- `yardstick`
- `rpart.plot`
- `vip`
- `car`
- `knitr`

### Repository Structure

```text
Stadium_Profitability_And_Investment_Analytics/
├── README.md
├── analysis/
│   ├── stadium-profitability-prediction.Rmd
│   └── stadium-profitability-prediction.html
└── data/
    └── stades_2.csv
```

### Reproducibility

1. Clone the repository.
2. Confirm `data/stades_2.csv` is present.
3. Install the required packages:

   ```r
   install.packages(c(
     "tidyverse",
     "tidymodels",
     "yardstick",
     "rpart.plot",
     "vip",
     "car",
     "rmarkdown",
     "knitr"
   ))
   ```

4. From the repository root, render:

   ```r
   rmarkdown::render(
     "analysis/stadium-profitability-prediction.Rmd",
     output_format = "html_document"
   )
   ```

5. Open `analysis/stadium-profitability-prediction.html`.

### Portfolio Context

This project originated from university coursework and has been professionally reorganised as a business analytics portfolio case study.
