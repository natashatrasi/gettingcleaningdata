# Codebook for Getting and Cleaning Data course project

## Source Data

The original data is taken from Human Activity Recognition Using Smartphones Dataset
Version 1.0 <sup>[1]</sup>. This consists of measurements from experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. The features in this data come from the accelerometer and gyroscope 3-axial (x, y, z) signals. Each person performed six activities wearing a smartphone on the waist. The source data consists of two sets: training data using measurements from 70% of the volunteers and test data from the remaining 30% of the volunteers. The source data consists of measurements for a range of variables which have been normalised within the bounds [-1,1].

## Tidy Data

The tidy data in the file TidyMeanData.txt contains data for all 30 volunteers (both the trial and test data sets). It contains the average (mean) of all variables which represent the mean or standard deviation of a measurement for each volunteer performing each of the six activities. It contains 180 rows, one for each activity undertaken by each volunteer (6 x 30).

## Process to produce the tidy data

* The source data and related files were downloaded as a zip file from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

* A test data set and a trial data set were produced in the same way by combining the x, y and subject data so that each row contained measurements for all of the variables (features) for a specified volunteer (subject) and activity. Feature names were used as column names to label the variables.

* The test data is appended to the trial data to create a single data set covering all participants performing all activities.

* A subset of the dataset was created containing only the 79 variables of interest, i.e. those which represented a mean or standard deviation of a measurement (based on feature names which contain mean or std). The angle variables were excluded since these are a calculation using the mean rather than a mean value.

* The activity (1-6) was transformed into a factor with 6 levels (walking, walking upstairs, walking downstairs, standing, sitting and laying.)
See README.md for more details of the script used to produce the tidy data set.

* Names for variables in the subset were tidied to remove non-character symbols or duplication and to expand abbreviations for clarity. All variable names are in lower case for ease of referencing.

* Finally, the mean for each of the 79 variables in the subset was calculated for each activity and each subject. The column names are prefixed with avg to indicate that they represent an average of the original variable. The outputted tidy dataset, TidyMeanData.txt, consists of columns for the subject ID, activity name and then these 79 mean values with one row for each subject and each activity.

## Data Dictionary

###Subject and activity
subject: anonymised identifier for the person undertaking the activities. Integer in the range 1-30.

activity: activity being undertaken

- walking
- walking_upstairs
- walking_downstairs
- standing
- sitting
- laying

###Measurement variables
Remaining variables represent mean values of experimental measurements, normalised in the source data to be between -1 and +1. As normalised values there are no units associated with these variables.

Variable names use the following naming conventions:

- avg: the mean of the original normalised variable (applies to all the following variables)
- time: a measurement in the time domain
- freq: a measurement in the frequency domain
- body: a reading relating to the body of the participant
- gravity: a reading relating to the gravitational effect
- accel: an acceleration signal as measured by the accelerometer
- gyro: a gyroscopic signal as measured by the gyroscope
- jerk: a jerk of the body. Can be linear acceleration (accel jerk) or angular velocity (gyro jerk)
- magnitude: relates to the magnitude (absolute size) of the signal
- mean: the mean of the measurements
- meanfreq: mean as weighted average of frequency components
- stdev: standard deviation of the measurements
- x: signal in the x-axis relative to the phone (final character in the variable name)
- y: signal in the y-axis relative to the phone (final character in the variable name)
- z: signal in the z-axis relative to the phone (final character in the variable name)


####Averages (means) of means

Calculated averages (means) for each subject and activity from variables based on readings from the accelerometer or gyroscope in the x-, y- and z-axes (denoted by final character x, y or z) relative to the phone.

Average of mean body acceleration in the time domain:

- avgtimebodyaccelmeanx
- avgtimebodyaccelmeany
- avgtimebodyaccelmeanz

Average of mean gravitational acceleration in the time domain:

- avgtimegravityaccelmeanx
- avgtimegravityaccelmeany
- avgtimegravityaccelmeanz

Average of mean jerk of the body (linear acceleration) in the time domain:

- avgtimebodyacceljerkmeanx
- avgtimebodyacceljerkmeany
- avgtimebodyacceljerkmeanz

Average of the mean gyroscopic signal of the body in the time domain:

- avgtimebodygyromeanx
- avgtimebodygyromeany
- avgtimebodygyromeanz

Average of the mean jerk of the body (angular velocity) in the time domain:

- avgtimebodygyrojerkmeanx
- avgtimebodygyrojerkmeany
- avgtimebodygyrojerkmeanz

Average of the mean magnitude in the time domain:

- avgtimebodyaccelmagnitudemean: body acceleration
- avgtimegravityaccelmagnitudemean: gravitational acceleration
- avgtimebodyacceljerkmagnitudemean: jerk of the body (linear acceleration)
- avgtimebodygyromagnitudemean: body gyroscopic signal
- avgtimebodygyrojerkmagnitudemean: jerk of the body (angular velocity)

Average of the mean acceleration of the body in the frequency domain:

- avgfreqbodyaccelmeanx
- avgfreqbodyaccelmeany
- avgfreqbodyaccelmeanz
    
Average of the mean frequency (weighted average of the frequency components) of the body acceleration in the frequency domain:

- avgfreqbodyaccelmeanfreqx
- avgfreqbodyaccelmeanfreqy
- avgfreqbodyaccelmeanfreqz
    
Average of the mean jerk of the body (angular velocity) in the frequency domain:

- avgfreqbodyacceljerkmeanx
- avgfreqbodyacceljerkmeany
- avgfreqbodyacceljerkmeanz
    
Average of the mean frequency (weighted average of the frequency components) of the jerk of the body (angular velocity) in the frequency domain:

- avgfreqbodyacceljerkmeanfreqx
- avgfreqbodyacceljerkmeanfreqy
- avgfreqbodyacceljerkmeanfreqz

Average of the mean gyroscopic signal of the body and mean frequency of this signal in the frequency domain:

- avgfreqbodygyromeanx
- avgfreqbodygyromeany
- avgfreqbodygyromeanz
- avgfreqbodygyromeanfreqx
- avgfreqbodygyromeanfreqy
- avgfreqbodygyromeanfreqz
    
Average of the mean magnitude in the frequency domain:

- avgfreqbodyaccelmagnitudemean: body acceleration
- avgfreqbodyaccelmagnitudemeanfreq: mean frequency of body acceleration
- avgfreqbodyacceljerkmagnitudemean: jerk of the body (linear acceleration)
- avgfreqbodyacceljerkmagnitudemeanfreq: mean frequency of the jerk of the body
- avgfreqbodygyromagnitudemean: body gyroscopic signal
- avgfreqbodygyromagnitudemeanfreq: mean frequency of the body gyroscopic signal
- avgfreqbodygyrojerkmagnitudemean: jerk of the body (angular velocity)
- avgfreqbodygyrojerkmagnitudemeanfreq: mean frequency of the jerk of the body           

####Averages (means) of standard deviations

Average of the standard deviation of the same features:
Body acceleration in the time domain:

- avgtimebodyaccelstdevx
- avgtimebodyaccelstdevy
- avgtimebodyaccelstdevz

Gravitational acceleration in the time domain:

- avgtimegravityaccelstdevx
- avgtimegravityaccelstdevy
- avgtimegravityaccelstdevz

Jerk of the body (linear acceleration) in the time domain:

- avgtimebodyacceljerkstdevx
- avgtimebodyacceljerkstdevy
- avgtimebodyacceljerkstdevz

Gyroscopic signal of the body in the time domain:

- avgtimebodygyrostdevx
- avgtimebodygyrostdevy
- avgtimebodygyrostdevz
    
Jerk of the body (angular velocity) in the time domain:

- avgtimebodygyrojerkstdevx
- avgtimebodygyrojerkstdevy
- avgtimebodygyrojerkstdevz
    
Average of the standard deviation of magnitude in the time domain:

- avgtimebodyaccelmagnitudestdev: body accleration
- avgtimegravityaccelmagnitudestdev: gravitational acceleration
- avgtimebodyacceljerkmagnitudestdev: jerk of the body (linear acceleration)
- avgtimebodygyromagnitudestdev: body gyroscopic signal
- avgtimebodygyrojerkmagnitudestdev: jerk fo the body (angular velocity)

Average of the standard deviation of body acceleration in the frequency domain:

- avgfreqbodyaccelstdevx
- avgfreqbodyaccelstdevy
- avgfreqbodyaccelstdevz

Average of the standard deviation of jerk of the body (linear acceleration) in the frequency domain:

- avgfreqbodyacceljerkstdevx
- avgfreqbodyacceljerkstdevy
- avgfreqbodyacceljerkstdevz
    
Average of the standard deviation of the body gyroscopic signal in the frequency domain:

- avgfreqbodygyrostdevx
- avgfreqbodygyrostdevy
- avgfreqbodygyrostdevz
    
Average of the standard deviation of magnitude in the frequency domain:

- avgfreqbodyaccelmagnitudestdev: body acceleration
- avgfreqbodyacceljerkmagnitudestdev: jerk of the body (linear acceleration)
- avgfreqbodygyromagnitudestdev: body gyroscopic signal
- avgfreqbodygyrojerkmagnitudestdev: jerk of the body (angular velocity)

##References

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012