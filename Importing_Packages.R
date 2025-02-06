# Import packets needed for the analysis and load them
pacotes <- c("raster","tmap","tidyverse","broom","knitr",
             "kableExtra","RColorBrewer", "janitor", "tigris", "ggplot2","plotly",
             "osmdata", "sf", "ggmap", "leaflet", "measurements","skimr",
             "showtext", "dplyr", "DescTools", "PerformanceAnalytics", "psych",
             "pracma","nlme", "jtools", "cowplot","nlme","lmtest","fastDummies",
             "msm","lmeInfo","jtools", "car","reshape2", "beepr","ggplot2",
             "dplyr", "sf", "dplyr", "PerformanceAnalytics", "beepr" )
install.packages(pacotes)
lapply(pacotes, library, character.only = TRUE)