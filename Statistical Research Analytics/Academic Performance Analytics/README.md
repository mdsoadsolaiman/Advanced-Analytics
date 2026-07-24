# Academic Performance Analytics

## Executive Summary

Academic Performance Analytics is an end-to-end statistical analytics project based on records from 2,392 high school students. It examines factors associated with GPA and grade outcomes using variables covering demographics, study behaviour, attendance, tutoring, parental involvement, and extracurricular participation.

The workflow progresses from exploratory analysis to statistical inference and regression modelling. Each stage builds on the evidence developed previously, producing a reproducible analysis that distinguishes observed associations from causal claims and in-sample model fit from future predictive performance.

## Why This Project Matters

Educational institutions collect substantial amounts of student information, but raw records alone provide limited support for decision-making. Statistical analysis can transform these records into structured evidence by identifying meaningful patterns, evaluating uncertainty, and clarifying which characteristics are associated with academic performance.

This evidence can help prioritise areas for further investigation and support more informed discussion of student outcomes. It cannot, by itself, identify causes or prove that a particular educational intervention will be effective.

## Project Scenario

This project is framed around the following educational analytics scenario.

A secondary education provider wants to better understand the characteristics associated with student academic performance. Historical records are available for student demographics, study habits, attendance, tutoring, parental support, extracurricular participation, GPA, and grade classification.

The analytical objective is to convert these records into evidence by describing the student population, investigating performance differences between groups, assessing whether selected relationships are statistically supported, and developing models that quantify associations with GPA.

## Project Objectives

- Understand the characteristics of the student population.
- Examine the distribution of GPA and grade outcomes.
- Explore how academic performance varies across student groups.
- Evaluate whether observed differences and associations are statistically supported.
- Compare the in-sample explanatory strength of individual predictors.
- Develop a multivariable regression model for GPA.
- Assess model assumptions and diagnostic evidence.
- Communicate findings responsibly and reproducibly.

## Analytical Questions

1. What are the main characteristics of the student population, and how are academic outcomes distributed?
2. How do GPA and grade outcomes vary across demographic, behavioural, and educational groups?
3. Which observed group differences and categorical relationships are statistically supported?
4. How are weekly study time and absences individually associated with GPA?
5. Which combination of available student characteristics provides the strongest in-sample explanation of variation in GPA?

## End-to-End Analytics Workflow

```text
Educational Dataset
(2,392 High School Students)
              │
              ▼
Stage 1 — Exploratory Analysis
Understand the student population,
distributions, patterns, and
initial relationships
              │
              ▼
Stage 2 — Statistical Inference
Evaluate whether observed group
differences and categorical associations
are supported by statistical evidence
              │
              ▼
Stage 3 — Regression Modelling
Quantify associations with GPA,
compare models, and assess diagnostics
              │
              ▼
Evidence-Based Educational Insights
```

The sequence is analytically important. Exploration establishes the dataset context and identifies patterns that warrant further investigation. Inference evaluates uncertainty around selected differences and associations. Regression then examines several relationships jointly and compares the explanatory performance of alternative models. Each stage therefore provides the foundation for the next.

## Key Findings

- Academic performance varies across several student characteristics in the analysed sample.
- Students receiving tutoring exhibited different GPA and grade distributions, although the observed comparison does not establish causation.
- Some group differences were statistically supported, while others did not provide sufficient evidence against their respective null hypotheses.
- Attendance had a substantially stronger individual association with GPA than weekly study time.
- The multiple regression explained more in-sample GPA variation than either simple regression model.
- Statistical significance and practical importance were considered separately.
- All findings represent associations within observational data rather than causal effects.

## Analytical Stages

### Stage 1 — Exploratory Data Analysis

**Purpose:** Establish a reliable understanding of the student population and academic outcome distributions before formal testing or modelling.

**Analytical focus:** Variable classification, tutoring participation, GPA distribution, grade outcomes, GPA comparisons across tutoring groups, and the suitability of a Normal approximation.

**Main methods:** Summary statistics, frequency and proportion tables, histograms, boxplots, bar charts, Q-Q plots, Normal-model probability calculations, and empirical percentile comparisons.

**Key outputs:** Descriptive profiles of GPA and tutoring participation; comparisons of tutoring and grade outcomes; Normality evidence; and model-based versus empirical probability and percentile estimates.

**Connection to the next stage:** The observed distributions and group differences identify relationships that require formal uncertainty assessment.

**Repository location:** [`stage-1-exploratory-analysis/`](stage-1-exploratory-analysis/)

**HTML report:** [Exploratory Analysis](stage-1-exploratory-analysis/exploratory-analysis.html)

### Stage 2 — Statistical Inference

**Purpose:** Determine whether selected group differences and categorical relationships are supported statistically rather than relying only on visual or numerical comparisons.

**Analytical focus:** Parental support and GPA, ethnicity and GPA, gender and GPA, and parental education in relation to grade classification.

**Main methods:** One-way ANOVA, Tukey HSD comparisons, a pooled two-sample t-test, a chi-squared test, assumption assessment, and a 90% confidence framework.

**Key outputs:** Group summaries, diagnostic evidence, test statistics, confidence intervals, post-hoc comparisons, and qualified interpretations of significant and non-significant findings.

**Connection to the next stage:** The inferential results clarify the difference between unadjusted comparisons and relationships that should be examined jointly in a multivariable model.

**Repository location:** [`stage-2-statistical-inference/`](stage-2-statistical-inference/)

**HTML report:** [Statistical Inference](stage-2-statistical-inference/statistical-inference.html)

### Stage 3 — Regression Modelling

**Purpose:** Quantify associations with GPA, compare individual predictors, and evaluate several student characteristics simultaneously.

**Analytical focus:** Weekly study time and GPA, absences and GPA, comparison of the two simple models, and a multiple regression containing behavioural and support variables.

**Main methods:** Simple and multiple linear regression, coefficient interpretation, in-sample model comparison, residual analysis, Q-Q assessment, scale-location diagnostics, leverage and Cook's-distance diagnostics, and observed-versus-fitted analysis.

**Key outputs:** Study-time and absence models, a multiple regression model, conditional coefficient estimates, model-fit comparisons, and regression diagnostic evidence.

**Connection to the next stage:** This stage completes the current workflow by integrating several relationships into an adjusted model. It also identifies the need for out-of-sample validation as future work.

**Repository location:** [`stage-3-regression-modelling/`](stage-3-regression-modelling/)

**HTML report:** [Regression Modelling](stage-3-regression-modelling/regression-modelling.html)

## Dataset

The dataset contains 2,392 observations, with one record per high school student. Its variables cover:

- demographic characteristics, including age, gender, and ethnicity;
- behavioural characteristics, including weekly study time and extracurricular participation;
- attendance;
- tutoring, parental education, and parental support;
- GPA; and
- grade classification.

**GPA** is the primary continuous academic outcome and the response variable in the regression models. **GradeClass** is the categorical academic outcome used in exploratory and inferential analysis. **StudentID** is an identifier rather than an analytical variable.

See the [data dictionary](docs/data-dictionary.md) for variable definitions and category descriptions.

## Repository Structure

```text
Academic-Performance-Analytics/
├── README.md
├── academic-performance-analytics.Rproj
├── _quarto.yml
├── appendices/
│   └── README.md
├── data/
│   └── student-performance-data.csv
├── docs/
│   ├── data-dictionary.md
│   └── methodology.md
├── stage-1-exploratory-analysis/
│   ├── exploratory-analysis.qmd
│   └── exploratory-analysis.html
├── stage-2-statistical-inference/
│   ├── statistical-inference.qmd
│   └── statistical-inference.html
└── stage-3-regression-modelling/
    ├── regression-modelling.qmd
    └── regression-modelling.html
```

- `data/` contains the analysis-ready dataset used across all stages.
- `stage-1-exploratory-analysis/` contains the exploratory source and rendered report.
- `stage-2-statistical-inference/` contains the inference source and rendered report.
- `stage-3-regression-modelling/` contains the regression source and rendered report.
- `docs/` contains supporting dataset and methodology documentation.
- `appendices/` is reserved for supplementary technical material.
- `_quarto.yml` defines project-root execution for reproducible relative paths.
- `academic-performance-analytics.Rproj` is the RStudio project entry point.

## Tools and Technologies

- R
- Quarto
- tidyverse
- readr
- dplyr
- ggplot2
- knitr
- kableExtra
- broom
- scales

## Skills Demonstrated

| Analytical Capability | Demonstrated Skills |
|---|---|
| Data Exploration | Variable classification, summary statistics, frequency analysis, distribution assessment, and group comparisons |
| Statistical Inference | Hypothesis formulation, two-sample t-tests, one-way ANOVA, Tukey HSD comparisons, chi-squared testing, and confidence-interval interpretation |
| Regression Analysis | Simple and multiple linear regression, conditional coefficient interpretation, model comparison, and in-sample fit assessment |
| Statistical Validation | Assumption checking, Q-Q assessment, residual analysis, scale-location diagnostics, leverage assessment, and Cook's-distance interpretation |
| Data Visualisation | Histograms, boxplots, bar charts, scatterplots, fitted regression lines, and diagnostic plots |
| Reproducible Analytics | Relative paths, shared Quarto configuration, structured R projects, portable HTML reports, and independently renderable stages |
| Technical Communication | Executive summaries, staged analytical reporting, qualified interpretation, transparent limitations, and distinction between association and causation |

## Reproducibility

Clone the repository and enter its root directory:

```bash
git clone <repository-url>
cd Academic-Performance-Analytics
```

Open `academic-performance-analytics.Rproj` in RStudio. The shared Quarto configuration executes reports from the repository root, allowing every stage to use the same relative dataset path.

Render any report independently:

```bash
quarto render stage-1-exploratory-analysis/exploratory-analysis.qmd
quarto render stage-2-statistical-inference/statistical-inference.qmd
quarto render stage-3-regression-modelling/regression-modelling.qmd
```

Install the required R packages before rendering.

## Limitations

- The data are observational, so the reported relationships describe associations rather than causal effects.
- The sampling design is undocumented, limiting assessment of independence and generalisability.
- Potential confounding may contribute to observed group differences and regression relationships.
- Regression performance is evaluated on the observations used to fit the models.
- No train/test split, cross-validation, or external validation was performed.
- GPA is bounded between 0 and 4, while the reported linear regression models are unbounded.
- Formal effect-size measures were not included for the inferential comparisons.

## Future Work

- Evaluate regression performance with train/test splits and cross-validation.
- Validate findings using an additional educational dataset.
- Develop carefully selected classification models for grade outcomes.
- Investigate nonlinear terms and interactions where analytically justified.
- Compare linear regression with alternative models for bounded outcomes.
- Add practical effect-size analysis to complement statistical significance.

## Conclusion

This repository demonstrates a complete statistical analytics workflow, progressing from data exploration through statistical inference to regression modelling. It combines reproducible analysis, transparent reporting, and responsible interpretation of observational evidence in a structure designed for both technical and non-technical review.

## License

A LICENSE file will be added separately.
