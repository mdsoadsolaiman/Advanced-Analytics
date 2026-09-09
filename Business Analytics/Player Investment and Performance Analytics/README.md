## Project Directory



*Click the links in the projects*



|Category|Project|Primary Focus|
|-|-|-|
|Business Analytics|[Venue Performance and Revenue Analytics](https://venue-performance-analysis.netlify.app)|Venue performance, attendance and revenue decision support|



\### Repository Structure



```text

Player\_Investment\_And\_Performance\_Analytics/

├── README.md

├── analysis/

│   ├── player-salary-and-attendance-analysis.Rmd

│   └── player-salary-and-attendance-analysis.html

└── data/

&#x20;   └── nbplayers\_1.csv

```



\### Reproducibility



1\. Clone the repository.

2\. Confirm `data/nbplayers\_1.csv` is present.

3\. Install the required packages:



&#x20;  ```r

&#x20;  install.packages(c(

&#x20;    "tidyverse",

&#x20;    "moments",

&#x20;    "caret",

&#x20;    "tidymodels",

&#x20;    "rmarkdown",

&#x20;    "knitr"

&#x20;  ))

&#x20;  ```



4\. From the repository root, render the R Markdown:



&#x20;  ```r

&#x20;  rmarkdown::render(

&#x20;    "analysis/player-salary-and-attendance-analysis.Rmd"

&#x20;  )

&#x20;  ```



