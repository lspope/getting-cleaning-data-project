# getting-cleaning-data-project
### Introduction

This readme file provides information on my Course Project submission for Getting and Cleaning Data. This file explains all scripts used for this submission, how they work, and how they are connected.


### Script(s)

The main script is run_analysis.R.  It peforms the following actions:

1. Merges the training and the test sets from the project data set (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in order to create one data set.
    +  Function prepData() is the function that downloads and unzips the data to use.
    +  Function mergeTestTrainDataSets() is the function that prepares and merges the test and train data sets.


2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    + Function getSubsetData() is the function that extraction only mean and standard deviation columns from the merged data set. It also includes descriptive activity names that match the numeric activity codes.


3. Uses descriptive activity names to name the activities in the data set
    + Function getSubsetData() is the function that extraction only mean and standard deviation columns from the merged data set. It also includes descriptive activity names that match the numeric activity codes.


4. Appropriately labels the data set with descriptive variable names.
    + Function mergeTestTrainDataSets() uses descriptive variable names.


5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    + Function createNewTidy() created this tidy data set. 
    + This function uses another function named createSubjectActivityDataset() in order to create each dataset with only the measurements for each given subject.



### Steps
1. run the script run_analysis.R
    + The script file calls all needed functions and will write out the tidy dataset in a txt file named tidy.txt

