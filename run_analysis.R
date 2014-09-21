## run_analysis.R

## A script for the Getting and Cleaning Data course project

## Creates the TidyMeanData.txt data file which contains means by subject and activity
## of mean and standard deviation variables from the 'Human Activity Recognition
## Using Smartphones' Dataset

## See README.md for further details of what this script does and why

######################################################################################

## The script uses functions from the dplyr library for manipulating data tables so
## ensure this is loaded

library(dplyr)

## Step: initial set-up - only needed if data not already downloaded and unzipped

## Test if data zip file already downloaded into the working directory
## If not, download from specified url (fileUrl), otherwise skip
## Save as 'ProjectData.zip' in working directory
## Save the date and time of download as 'dateDownloaded'

if (!file.exists("ProjectData.zip")) {
    fileUrl <- 
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "ProjectData.zip", method = "curl")
    dateDownloaded <- date()
}

## If ./UCI HAR Dataset folder does not exist then unzip downloaded zip file into the
## working directory, otherwise skip
## Unzipping ProjectData puts data files in ./UCI HAR Dataset folder in working directory

if (!file.exists("UCI HAR Dataset")) {
    unzip("ProjectData.zip")
}

######################################################################################

## Step 0 - Create test and train datasets

## Read in the feature labels from features.txt using read.table and store table as
## 'features'
## Keep only the second column of names, stored as 'featnames'

if(!exists("features")) {
features <- read.table("./UCI HAR Dataset/features.txt")
featnames <- features[,2]
}

## If datafiles not already read into specified objects then
## read in the test data files from the test directory using read.table

## Use feature names ('featnames') as the column labels for the x_ test data
## Do not use check names or this will change the variable names

if(!exists("xtest")) {
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = featnames,
                    check.names = FALSE)
}

## Label the activity IDs using column name 'activity'
if(!exists("ytest")) {
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")
}

## Label the subject IDs using column name 'subject'
if(!exists("subjtest")) {
subjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
}

## Create a single 'testdata' set using cbind to combine with subject as first column
## followed by activity (ytest) and then the factor data (xtest)

testdata <- cbind(subjtest, ytest, xtest)

## Repeat for the train data files from the train directory

if(!exists("xtrain")) {
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = featnames,
                     check.names = FALSE)
}
if(!exists("ytrain")) {
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")
}
if(!exists("subjtrain")) {
subjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
}

## Create a single 'traindata' set using cbind to combine with subject as first column
## followed by activity (ytrain) and then the factor data (xtrain)

traindata <- cbind(subjtrain, ytrain, xtrain)

#####################################################################################

## Step 1 - Merge data sets

## Each dataset has observations for a separate group of subjects so the train and test
## sets can simply be concatenated with rbind and saved as a new datatable 'alldata'
## NB: Subjects will not be in ascending order

alldata <- rbind(traindata, testdata)

#####################################################################################

## Step 2 - Keep variables where name includes mean or std

## Use dplyr select function to keep variable names which include mean or std
## But exclude the angle columns since they are a calculation on the mean
## not an actual mean value
## Store as a new, smaller datatable 'selectdata'

selectdata <- select(alldata, subject, activity, contains("mean"), contains("std"),
                  -contains("angle"))

#####################################################################################

## Step 3 - Use descriptive activity names for the activities

## Convert activity column to factors
## Add levels based on activity_labels.txt but lower case and without underscores

selectdata$activity <- as.factor(selectdata$activity)
levels(selectdata$activity) <- c("walking", "walkingupstairs", "walkingdownstairs",
                              "sitting", "standing", "laying")

#####################################################################################

## Step 4 - Label the dataset with descriptive variable names and tidy up

## Remove dashes using gsub and brackets using sub - need to "escape" brackets

names(selectdata) <- gsub("-", "", names(selectdata))
names(selectdata) <- sub("\\()", "", names(selectdata))

## Replace t with Time and f with Freq at the beginning of the name

names(selectdata) <- sub("^t", "time", names(selectdata))
names(selectdata) <- sub("^f", "freq", names(selectdata))

## Remove duplicate Body

names(selectdata) <- sub("BodyBody", "body", names(selectdata))

## Clarify with longer abbreviations accel, stdev and full magnitude

names(selectdata) <- sub("Acc", "accel", names(selectdata))
names(selectdata) <- sub("std", "stdev", names(selectdata))
names(selectdata) <- sub("Mag", "magnitude", names(selectdata))

## Set names to all lower case

names(selectdata) <- tolower(names(selectdata))

#####################################################################################

## Step 5 - Create an independent tidy data set with the average of each variable for
## each activity and each subject using dplyr functions group_by and summarise_each

## Group by subject and activity then calculate the mean for each variable
## store new datatable as 'avgdata'

avgdata <- selectdata %>%
    group_by(subject, activity) %>% 
    summarise_each(funs(mean))

## Add avg as prefix to all variable names except subject and activity to show that
## the values are now the average for each subject and activity
## Temporarily assign names to 'avgnames', paste avg as prefix to all but first two
## columns
## Reassign values to names of 'avgdata' columns

avgnames <- names(avgdata)
avgnames[3:81] <- paste0("avg", avgnames[3:81])
names(avgdata) <- avgnames

## Write data to a text file using write.table with row.name = FALSE and using
## 'avgnames' as column names

write.table(avgdata, file = "TidyMeanData.txt", row.names = FALSE, 
            col.names = avgnames)