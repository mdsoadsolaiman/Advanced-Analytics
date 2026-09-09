## Project Directory



Click the links in the projects



|Category|Project|Primary Focus|
|-|-|-|
|Business Analytics|[Venue Performance and Revenue Analytics](https://venue-performance-analysis.netlify.app)|Venue performance, attendance and revenue decision support|



\## Repository Structure



```text

Venue\_Performance\_And\_Revenue\_Analytics/

├── README.md

├── analysis/

│   └── venue-performance-and-home-court-advantage.Rmd

└── data/

&#x20;   └── netball\_0.csv

```



\## Reproducibility



1\. Clone the repository.

2\. Confirm `data/netball\_0.csv` is present.

3\. Install the required packages:



&#x20;  ```r

&#x20;  install.packages(c("tidyverse", "inspectdf", "rmarkdown", "knitr"))

&#x20;  ```



4\. From the repository root, render the R Markdown:



&#x20;  ```r

&#x20;  rmarkdown::render(

&#x20;    "analysis/venue-performance-and-home-court-advantage.Rmd"

&#x20;  )

&#x20;  ```



