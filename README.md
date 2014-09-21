#gettingcleaningdata

##README for Getting and Cleaning Data course project


The Getting and Cleaning Data project repo contains the following files:

- 'README.md': Contains information about the project files and the script used to create the TidyMeanData.text tidy data file.
- 'run_analysis.R': R script to generate the TidyMeanData.txt dataset using the method described below.
- 'CodeBook.md': Codebook describing the data transformation undertaken to produce the dataset, as well as the dataset and variables contained within it.

##TidyMeanData.txt

This datafile is created from the Human Activity Recognition Using Smartphones Dataset
Version 1.0 using the run_analysis.R script.

The file can be read in to R using:

```

data <- read.table("TidyMeanData.txt", header = TRUE)
```

If the TidyMeanData.txt file is not in the working directory then the filepath will also need to be specified.

##run_analysis.R

The run_analysis.R script takes the Human Activity Recognition Using Smartphones Dataset and uses it to produce a tidy dataset containing the calculated variables specified for the project.

####Before running the script

In addition to the base R package this script makes used of the dplyr package for manipulating data tables. If the dplyr package is not already installed this should be done before running the script using:

```

install.packages('dplyr')
```

The script makes use of the constructs *if(!file.exists(filename))* and *if(!exists(variablename))* to check for the existance in the working directory of the required files and data tables. This avoids duplication in carrying out steps if the code has already been run, but files should be moved or renamed if the code is changed or if running against an updated source dataset. The approach is used in the course lectures and was recommended by Trent Baur in the discussion forum:

https://class.coursera.org/getdata-007/forum/thread?thread_id=179

#####Obtaining the source data

* Download of the data file

After loading the dplyr library the script checks whether the project data zip file has already been downloaded into the working directory. If not it is downloaded from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Download is carried out using *download.file* with the "curl" method and saved in the working directory as ProjectData.zip. The date of download is saved as dateDownloaded. The datafile for the project submission was downloaded on 14th September 2014.

As described above, if the datafile already exists the download step is skipped.

The script then tests whether the directory created by unzipping the data file exists in the working directory. If so this step is skipped, otherwise the file is unzipped using the unzip function. The source file names and directory structures are assumed to be the unchanged from those created at unzip.

* Step 0 - Create test and train datasets

The script first uses the downloaded and unzipped data files to create a single data file for each of the test and train datasets.

First of all the features.txt file containing the variable names is read in from the UCI HAR Dataset directory in the working directory and stored as 'features' using the *read.table* function. The script first tests whether 'features' already exists from a previous run of the script and if so it does not execute this step.

features is a data table with two columns but we only want the second column which is the feature names, so this is stored as featnames.

The remainder of this step is then repeated for both the test and train data sets to read in the data files from the "./UCI HAR Dataset/test/" (train) directory relative to the working directory:

- Check whether the xtest (train) datatable already exists. If not use *read.table* to read in from X_test.txt (train) using featnames as the column names to name the variables. The option *check.names = FALSE* is used to avoid R trying to "correct" the variable names.
- Check whether the ytest (train) datatable already exists. If not use *read.table* to read in from y_test.txt (train) using "activity" as the column name.
- Check whether the subjtest (train) datatable already exists. If not use *read.table* to read in from subject_test.txt (train) using "subject" as the column name.

These three data tables are then combined into a single testdata (train) using the *cbind* function with subjtest (train) as the first column of subject IDs, ytest (train) as the second column of activity IDs and xtest (train) as the remaining columns of feature variables. Column names were assigned when reading in the data.

* Step one - Merge the training and test datasets to create one dataset

The test and train datasets include measurements on the same variables in the same format, but since the subjects were partitioned into test and train groups there is no overlap between them. The two can therefore by merged simply using *rbind* to append the testdata table to the trialdata table as additional rows into a single alldata table. Note that since testdata and trialdata are individually sorted on ascending subject ID, the alldata table will not be sorted on subject ID but we will undertake further transformations so the table is not sorted at this stage.

* Step two - Extract only the measurements on the mean and standard deviation for each measurement

This is interpreted as keeping all variables whose names include mean or std, including meanfreq which is a weighted mean over frequency components, but excluding the angle variables since they are a calculation on the mean not an actual mean value. The dplyr *select* function to select from the alldata table the initial subject and activity ID columns as well as to keep variable names which contain mean or std. A minus sign before contain is used to drop variables whose names contain angle.

This smaller dataset with 81 columns is stored as the selectdata table.

* Step three - Use descriptive activity names to name the activities in the data set

At this stage the activities undertaken by the subjects are referenced with the integers 1 to 6. To make the dataset easier to understand these are replaced with the activity lables as set out in activity_labels.txt. This is achieved by converting the activity column to factors and then using a character vector of the activity labels to assign the factor levels:

- 1: walking
- 2: walkingupstairs
- 3: walkingdownstairs
- 4: sitting
- 5: standing
- 6: laying

In contrast to the names in activity_labels.txt these names are in lower case and exclude underscores in line with the principles set out below.

The variable names are tidied using the principles set out in the first course lecture from week 4: Editing text variables, i.e.

1. Names should be all lower case where possible
2. Descriptive
3. Not duplicated
4. Not have underscores, dots or whitespace

* Step four - Appropriately label the data set with descriptive variable names

As in step three, the variable names are amended in line with the four specified principles.

The *gsub* (for multiple replacements) and *sub* (for single replacement) functions are used to remove extraneous hyphens and brackets by finding them and replacing with "". Note that the bracket symbol needs to be "escaped" with the backslash to denote the actual symbol rather than its use in a regular expression.

The *sub* function is then used to replace t and f at the start of the variable name (identified with ^) with the longer form time and freq. This is only done where they appear at the start of the name to avoid replacing e.g. the 't' in std.

The *sub* function is used to remove the duplication "BodyBody" by replacing it with a single "body" and to expand the abbreviation "acc", "std" and "mag" respectively to the clearer "accel", "stdev" and "magnitude".

Finally, the character strings are set to all lower case in line with the first principle above using the *tolower* function.

* Step five - From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

Tidy data is defined in line with the principles set out in the Getting and Cleaning Data course lectures and in the paper on Tidy Data by Hadley Wickham:

http://vita.had.co.nz/papers/tidy-data.pdf

1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

First, the dplyr functions *group_by* and *summarise_each* are used to calculate the averages (the mean) of each of the 79 feature variables in the selectdata set, for each activity and each subject. This is stored as a second data table, avgdata.

*group_by* is used to group the data by subject and then by activity. The data are now sorted in ascending order of subject. The *summarise_each* function is then used to apply the mean function to all of the non-grouped variables, i.e all except subject and activity. The *group_by* and *summarise_each* functions are "chained" together using *%>%* for conciseness (this avoids needing to respecify the data table being used).

To make clear that these variables are now means rather than the variables in the original dataset all column names except activity and subject are prefixed with avg to indicate an average value. They are temporarily assigned to avgnames and avg is pasted before the names using *paste0* to paste with no separator. Using the range [3:81] excludes the activity and subject columns.

This dataset meets the tidy data principles because each of the 81 variables forms a column and each observation (each activity for each subject, 6 x 30) forms a row. The data only contains observations from the phone for these activities and participants in line with the third principle.

Finally, this second tidy dataset is written to a text file using *write.table* with *row.names = FALSE* as specified in the instructions. The column names are assigned using *col.names* with the avgnames variable.

This dataset can be read back in to R using *read.table* with the option *header = TRUE* to ensure that the column names are picked up and not used as the first row of data.