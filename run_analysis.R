## run_analysis.R

## Download and unzip the data
prepData <- function() {
    ## Create a data directory in the current working directory
    if(!file.exists("data)")) { 
        dir.create("data")
    }
    
    ## Download zip file from the web
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile="./data/smartphonedata.zip", method="curl")
    dateDownloaded <- date()
    ## Unzip the zip file into the data directory 
    unzip("./data/smartphonedata.zip", exdir="./data/")
    ## NOTE: All zipped files will be extracted to a new directory named UCI HAR Dataset   
}

## Merges the training and the test sets from the downloaded and unzipped project data set
mergeTestTrainDataSets <- function() {
    ## Append the TEST subject values (identifier for subject - contained in subject_test.txt)
    ## with the activity label (code for subject's activity during sensor readings - contained in y_text.txt)
    ## with the sensor values (readings for sensors - contained in X_test.txt)
    ## Note that we must provide labels for the columns (data provided in non-labeled text files) 
    subject_label_name <- c('subject')
    subjectDataTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names=subject_label_name)
    activity_label_name <- c('activity_label')
    activityDataTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names=activity_label_name)
    ## Labels for sensor values (561 different sensor readings) are in separate text file
    ## Read in the second column to get the label names and use to label the sensor values
    sensorLabelData <- read.table("./data/UCI HAR Dataset/features.txt")
    sensor_label_names <- sensorLabelData$V2
    sensorDataTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names=sensor_label_names)
    
    ## NOTE: It seems that some of the characters in the sensor labels are not allowed as data frame column names.
    ## These invalid characters are -, (, and ). They convert to periods (.).
    
    ## Combine the TEST subject, activity label and sensor value data frames into one data frame
    combinedDataTest <- cbind(subjectDataTest, activityDataTest, sensorDataTest)
    
    ## Repeat the same steps for the TRAIN subject, activity label and sensor value data 
    subjectDataTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names=subject_label_name)
    activityDataTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names=activity_label_name)
    sensorDataTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", col.names=sensor_label_names)
    combinedDataTrain <- cbind(subjectDataTrain, activityDataTrain, sensorDataTrain)
    
    ## Merging the TEST and TRAIN datasets vertically
    ## (adding TRAIN rows to end of TEST rows in one data frame)
    verticalMergedData <- rbind(combinedDataTest, combinedDataTrain)
    return (verticalMergedData)
}

## Extract only the measurements on the mean and standard deviation for each measurement.
getSubsetData <- function(dfToSubset) {
    ## get column names of the dataframe to subset
    colNames <- names(dfToSubset)
    ## get a vector of only the mean column labels
    mean_label_names <- if(length (i <- grep("mean\\.", colNames))) colNames[i]
    ## get a vector of only the standard deviation column labels
    std_label_names <- if(length (i <- grep("std", colNames))) colNames[i]
    subject_label_name <- c('subject')
    activity_label_name <- c('activity_label')
    ## We only want the subject, activity code/label, mean measurements and standard deviation measurements.
    subset_column_names <- c(subject_label_name, activity_label_name, mean_label_names, std_label_names)
    subsetData <- dfToSubset[subset_column_names]  
    
    ## add descriptive activity lables to subset of data 
    attach(subsetData)
    subsetData$activity[activity_label == 1] <-"WALKING"
    subsetData$activity[activity_label == 2] <-"WALKING_UPSTAIRS"
    subsetData$activity[activity_label == 3] <-"WALKING_DOWNSTAIRS"
    subsetData$activity[activity_label == 4] <-"SITTING"
    subsetData$activity[activity_label == 5] <-"STANDING"
    subsetData$activity[activity_label == 6] <-"LAYING"
    detach(subsetData)
    
    return(subsetData)
}

## Create a dataset with only the measurements for one given subject.
createSubjectActivityDataset<- function(dfOrig, subject_id) {
    tempDF <- data.frame()
    for(j in 1:6) {
        subjectActivityDataset <- subset(dfOrig, dfOrig$subject == subject_id & dfOrig$activity_label == j)
        
        ## stick the subject id, activity code, activity name in the right row/col 
        tempDF[j,1] <- subject_id
        tempDF[j,2] <- j
        tempDF[j,3] <- subjectActivityDataset[1,69]
        #check for NaN on mean - the subject may not have values for each of the activities  
        for (k in 3:68) {
            the_mean <- mean(subjectActivityDataset[[k]])
            ## now we have mean - stick it in the DF at the right row and col
            tempDF[j,k+1] <- the_mean
        }
    }  
    tail <- colnames(subjectActivityDataset)[3:68]
    for (counter in 1:length(tail)) {
        tail[counter] <- paste("mean_of", tail[counter], sep="_")
    }
    names(tempDF) <- c("subject", "activity_code", "activity_name",tail)
    return (tempDF)
}


createNewTidy <- function(dfOrig) {
    ## Create a second, independent, tidy data set with the average of each variable 
    ## for each activity for each of the 30 subjects.
    tidyDF <- data.frame()
    for (theSubjectId in 1:30) { 
        tidyDF <- rbind(tidyDF, createSubjectActivityDataset(dfOrig, theSubjectId))
    }
    
    return(tidyDF)
}

prepData()
myData <- mergeTestTrainDataSets()
mySubset <- getSubsetData(myData)
myTidyData <- createNewTidy(myData)
write.table(myTidyData, "tidy.txt", sep=",", row.name=FALSE)

