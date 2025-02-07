# Data Analysis of Internet Speeds

## **Project Overview**
This project analyzes internet download speeds across São Paulo city in Brazil, using spatial using spatial and statistical techniques. The primary goal is to understand the distribution of speeds, detect potential issues in coverage, and provide insights into network performance. The data used in this analysis comes from IBGE and Ookla databases, publicly available on the internet.

## **Workflow and Exectution Order**
To reproduce this analysis, follow the execution order of the scripts:

1. **`Importing_SaoPaulo_shape.R`** - Imports the shapefile of São Paulo and preparaes spatial data 
2. **`Importing_Tiles_Ookla.R`** - Loads and processes tile-based internet speed test data and other features.
3. **`Importing_Sites_Anatel.R`** - Incorporates network site data from Anatel Database for comparison.
4. **`Analyzing_Data.R`** - Conducts statistical analysis and visualizations

## **Key Decisions and Methodology**
- Used **ggplot2** and **sf** for spatial visualizations
- Analyzed internet speed across tiles to identify variability in performance
- Examined relationships between download speed and number of testes performed in tile.
- Evaluated data distribution using histograms and boxplots.

## **Data Visualization** 
The following charts illustrate the data distribution and key insights from the analysis.

### **1. Internet Speed Distribution Across São Paulo**
This map displays the geographical distribution of average download speeds across the city. Darker areas indicate higher speeds.

![Internet Speed Distribution](./images/Average%20Download%20Speeds%20Across%20São%20Paulo.png)

---

### **2. Boxplot of Download Speeds**
The boxplot highlights the distribution of download speeds, identifying outliers and general variability.

![Boxplot of Download Speeds](./images/Boxplot%20of%20Download%20Speeds.png)

---

### **3. Histogram of Download Speeds**
This histogram provides an overview of how download speeds are distributed across all observations.

![Histogram of Download Speeds](./images/Distribution%20of%20Download%20Speeds%20in%20São%20Paulo.png)

---

### **4. Download Speed vs. Number of Tests**
This scatter plot investigates the relationship between download speed and the number of tests performed in each tile.

![Download Speed vs Tests](./images/Download%20Speed%20vs%20Number%20of%20Tests.png)

## **Conclusion and Insights**
- The distribution of download speeds is **right-skewed**, with a concentration of lower speeds.
- There are **outliers** with significantly higher speeds, as seen in the boxplot.
- The **spatial distribution** of internet speeds reveals areas with consistently higher or lower speeds.
- The **scatter plot** indicates that locations with more tests do not necessarily have better speeds.

This project provides a foundational understanding of internet speeds in São Paulo, and further work can explore potential correlations with demographic or infrastructure data.

## **Authors & Acknowledgments**
- Developed by: **Rafael Viegas de Carvalho**
- Data Sources: **IBGE, Ookla**
- Visualization Tools: **R (ggplot2, sf, dplyr)**
