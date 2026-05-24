
# Health Data Analytics with SAS: Drug A Fasting Blood Sugar Study

## Project Overview
This SAS project analyzes whether Drug A affects fasting blood sugar levels after 10 weeks. Patients were assigned to Low Drug A, High Drug A, or Placebo groups. The analysis includes data preparation, merging, missing value handling, stratified sampling, descriptive statistics, normality assessment, and non-parametric hypothesis testing.

## Research Question
Is there a significant difference in fasting blood sugar levels among Low Drug A, High Drug A, and Placebo groups after 10 weeks?

## Methods
- Imported two CSV files into SAS
- Sorted and merged datasets by Patient ID
- Removed missing values and invalid treatment group values
- Used stratified random sampling with equal allocation
- Generated descriptive statistics by group
- Checked normality using PROC UNIVARIATE
- Selected Kruskal-Wallis test due to non-normal data
- Used PROC NPAR1WAY for non-parametric group comparison

## Statistical Test
The data violated normality assumptions, so one-way ANOVA was not appropriate. A Kruskal-Wallis test was used as the non-parametric alternative.

## Results
- Chi-square: 3.3251
- Degrees of freedom: 2
- p-value: 0.1897

Because p > 0.05, the null hypothesis was not rejected. There was no statistically significant difference in fasting blood sugar levels among the three groups.

## Conclusion
Drug A did not show a statistically significant effect compared with placebo in reducing fasting blood sugar after 10 weeks.

## Tools Used
- SAS
- PROC IMPORT
- PROC SORT
- PROC SURVEYSELECT
- PROC MEANS
- PROC UNIVARIATE
- PROC NPAR1WAY

## Files
- `SAS Project DV.sas` — SAS analysis script
- `Health Data Analytics with SAS Project_Divya Verma.pdf` — project presentation
- `final_sample_srs_stratified.sas7bdat` — final stratified SAS dataset

## Author
Divya Verma  
MS Health Informatics  
Rutgers University
