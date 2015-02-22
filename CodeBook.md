### Introduction

This is the Code Book for my Project for Getting and Cleaning Data.


### Data Description

The data for this Project was collected from the URL made available on the Getting and Cleaning Data course website:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


The data in this data set represent data collected from the accelerometers from the Samsung Galaxy S smartphone. The data is part of the  Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors. 

### Variable Description

The variables in second, independent tidy data set that I created from the original smartphone dataset are:
* subject (the subject id)
* activity_code (the numeric activity id)
* activity_name (the descriptive activity name matching the code/id)
* mean_of<_measurement name> (name with the average of each measurement - there are 66 measurements that we are interested in and they were subset from the original smartphone dataset)


### Data Transformations/ Data Clean up
See specifics in run_analysis.R code comments

