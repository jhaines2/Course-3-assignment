# Readme for Course 3 Assignment Repo
 
This repo contains two files:
1. An R script named “data_analysis.R” which contains code to produce the summary output required for the assignment
2. A markdown file named “codebook.md” which describes the variables, data, summaries and work performed to clean the data
 
To use the R script you should load into R, ensure you have the UCI HAR Dataset saved in the working directory, and then run using source (“run_analysis.R”).  The output of the script is a .txt file ("summary_data.txt") saved in the working directory, containing the summary analysis required for the assignment.
 
The R script works by reading the required HCML data files into R, applying combining the test and training data into a single table, extracting the required fields (the mean and standard deviation of each measurement), applying various transformations to tidy the data such as giving the columns descriptive names, and summarising the resulting data by calculating the average of each field, grouped by individual and activity.
