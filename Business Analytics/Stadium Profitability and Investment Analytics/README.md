## Project Directory



*Click the links in the projects*



|Category|Project|Primary Focus|
|-|-|-|
|Business Analytics|[Stadium Profitability and Investment Analytics](https://stadium-profitability-and-investment.netlify.app)|Stadium profitability, utilisation and investment analysis|



\### Repository Structure



```text

Stadium\_Profitability\_And\_Investment\_Analytics/

├── README.md

├── analysis/

│   ├── stadium-profitability-prediction.Rmd

│   └── stadium-profitability-prediction.html

└── data/

&#x20;   └── stades\_2.csv

```



\### Reproducibility



1\. Clone the repository.

2\. Confirm `data/stades\_2.csv` is present.

3\. Install the required packages:



&#x20;  ```r

&#x20;  install.packages(c(

&#x20;    "tidyverse",

&#x20;    "tidymodels",

&#x20;    "yardstick",

&#x20;    "rpart.plot",

&#x20;    "vip",

&#x20;    "car",

&#x20;    "rmarkdown",

&#x20;    "knitr"

&#x20;  ))

&#x20;  ```



4\. From the repository root, render:



&#x20;  ```r

&#x20;  rmarkdown::render(

&#x20;    "analysis/stadium-profitability-prediction.Rmd",

&#x20;    output\_format = "html\_document"

&#x20;  )

&#x20;  ```

