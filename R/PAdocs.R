# GLOBAL VARIABLE
PKG_GLOBAL_ENV <- new.env(parent = emptyenv())

# reference: https://www.soa.org/globalassets/assets/files/edu/2019/2019-12-exam-pa-syllabus.pdf
PKG_GLOBAL_ENV$PA_PKGS <- c(
    "boot", "broom",
    "caret", "cluster", "coefplot",
    "data.table", "devtools", "dplyr",
    "e1071",
    "gbm", "ggplot2", "glmnet", "gridExtra",
    "ISLR",
    "MASS",
    "pdp", "pls", "plyr", "pROC",
    "randomForest", "rpart", "rpart.plot",
    # tidyverse includes packages on the next line
    "ggplot2", "dplyr", "tidyr", "readr", "purrr", "tibble", "stringr", "forcats",
    "xgboost"
)

PKG_GLOBAL_ENV$PKG_FREEZE_DATE <- "2019-12-01"

# pkgdown override navbar
PKG_GLOBAL_ENV$PKGDOWN_OVERRIDE_NAVBAR <- list(
    structure = list(
        left = c(
            "home",
            "packages",
            "intro",
            "reference",
            "articles",
            "tutorials"
        ),
        right = c("github")
    ),
    components = list(
        packages = list(
            text = "R Packages",
            icon = "fas fa-archive fa-lg",
            menu = list(
                list(
                    text = "",
                    href = ""
                )
            )
        )
    )
)

# data.table "no visible binding" R CMD check issue
utils::globalVariables(c(".", "package", "version", "date", "available"))
