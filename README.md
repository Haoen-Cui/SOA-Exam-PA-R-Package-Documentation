[![Build Status](https://travis-ci.org/Haoen-Cui/SOA-Exam-PA-R-Package-Documentation.svg?branch=master)](https://travis-ci.org/Haoen-Cui/SOA-Exam-PA-R-Package-Documentation)
<!-- Place this tag in your head or just before your close body tag. -->
<script async defer src="https://buttons.github.io/buttons.js"></script>
<!-- Place this tag where you want the button to render. -->
<a class="github-button" href="https://github.com/haoen-cui/SOA-Exam-PA-R-Package-Documentation" data-color-scheme="no-preference: light; light: light; dark: dark;" data-size="large" data-show-count="true" aria-label="Star haoen-cui/SOA-Exam-PA-R-Package-Documentation on GitHub">Star</a>

# SOA Exam PA - `R` Package Documentation

This project is to generate a website hosting `R` package documentations for the [SOA PA Exam](https://www.soa.org/education/exam-req/edu-exam-pa-detail/).

- Please visit the [GitHub Page](https://haoen-cui.github.io/SOA-Exam-PA-R-Package-Documentation/) for documentations
- Please consider starring this repo if you find it helpful
- Please raise an [issue](https://github.com/Haoen-Cui/SOA-Exam-PA-R-Package-Documentation/issues) if you have any suggestions, comments, and concerns

# Development Log

This repo contains an `R` package named `PAdocs` which finds the appropriate versions of the `R` packages given date of syllabus update
```
> get_pkg_version()
         package  version       date
 1:         boot   1.3-23 2019-07-05
 2:        broom    0.5.2 2019-04-07
 3:        caret   6.0-84 2019-04-27
 4:      cluster    2.1.0 2019-06-19
 5:     coefplot    1.2.6 2018-02-07
 6:   data.table   1.12.6 2019-10-18
 7:     devtools    2.2.1 2019-09-24
 8:        dplyr    0.8.3 2019-07-04
 9:        e1071    1.7-3 2019-11-26
10:          gbm    2.1.5 2019-01-14
11:      ggplot2    3.2.1 2019-08-10
12:       glmnet    3.0-1 2019-11-15
13:    gridExtra      2.3 2017-09-09
14:         ISLR      1.2 2017-10-20
15:         MASS 7.3-51.4 2019-03-31
16:          pdp    0.7.0 2018-08-27
17:          pls    2.7-2 2019-10-01
18:         plyr    1.8.4 2016-06-08
19:         pROC   1.15.3 2019-07-21
20: randomForest   4.6-14 2018-03-25
21:        rpart   4.1-15 2019-04-12
22:   rpart.plot    3.0.8 2019-08-22
23:        tidyr    1.0.0 2019-09-11
24:        readr    1.3.1 2018-12-21
25:        purrr    0.3.3 2019-10-18
26:       tibble    2.1.3 2019-06-06
27:      stringr    1.4.0 2019-02-10
28:      forcats    0.4.0 2019-02-17
29:      xgboost 0.90.0.2 2019-08-01
```
We fetch the packages from the [CRAN mirror on GitHub](https://github.com/cran) and then build documentations using [`pkgdown`](https://pkgdown.r-lib.org/index.html).

The meta data for the `PAdocs` package is set in the [`R/PAdocs.R`](https://github.com/Haoen-Cui/SOA-Exam-PA-R-Package-Documentation/blob/master/R/PAdocs.R) file.
