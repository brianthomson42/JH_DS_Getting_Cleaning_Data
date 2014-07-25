##Codebook for Data Science Getting and Cleaning project

###Introduction
This codebook provides information on the structure, contents, and layout of the "Tidy" data file produced by this project plus some basic information on the raw data from which the tidy data was constructed.


###Data Collection

This project uses data that was already collected and made available in convenient online zipfile format via a previous study. See Citation #1 and follow on links for details of the said study. In summary the data was collected from 30 human volunteers wearing smartphones which measured a variety of sensor signals while each individual conducted six different daily life actvities such as walking, standing, etc.
The embedded gyroscope and accelerometer within each phone was able to capture 3-axial angular velocity and linear acceleration measurements at the rate of 50Hz. i.e. 50 measurements per second. The original dataset was randomly split into individual test and training datesets for model development purposes.


###Raw Data
The data from the original study is available online in zip file format from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The contents of the extracted zip file are as follows...

UCI HAR Dataset:
activity_labels.txt
features_info.txt
features.txt
README.txt
test/
train/

UCI HAR Dataset/test:
Inertial Signals/
subject_test.txt
X_test.txt
y_test.txt

UCI HAR Dataset/test/Inertial Signals:
body_acc_x_test.txt
body_acc_y_test.txt
body_acc_z_test.txt
body_gyro_x_test.txt
body_gyro_y_test.txt
body_gyro_z_test.txt
total_acc_x_test.txt
total_acc_y_test.txt
total_acc_z_test.txt

UCI HAR Dataset/train:
Inertial Signals/
subject_train.txt
X_train.txt
y_train.txt

UCI HAR Dataset/train/Inertial Signals:
body_acc_x_train.txt
body_acc_y_train.txt
body_acc_z_train.txt
body_gyro_x_train.txt
body_gyro_y_train.txt
body_gyro_z_train.txt
total_acc_x_train.txt
total_acc_y_train.txt
total_acc_z_train.txt


The data is essentially split into test and training datasets.
Each representing an approximate 30/70 split of the observations.
Each dataset comprises of 3 files of interest...
* subject.txt : list of subject IDs (digit 1 -> 30)
* X_<test|train>.txt : variety of signal measurement values (
* y_<test|train>.txt : list of activities (digit 1 -> 6)
Each row represents one observation.

There are also 2 files containing data which is common to both datasets...
* activity_labels.txt : mapping of activity digit to human readable label
* features.txt : list of the names of the signal measurements which the X.txt files correspond to. (In this author's opinion 'names of signal measurements' more accurately representents the entitiy than 'features' which is the term used in the original study.)

The data in the files in the Inertial Signals directories for both the test and training datesets was ignored as it is repeated in amalgamated format within the X_<test|train>.txt files.


###Data Transformation

The run_analysis.R script provides the self-contained computation required to read the data from the original zip file and process it accordingly in order to produce a single tidy dataset from which further exploratory data analysis can be conducted.

The structure of the script is described by the following high-level processing steps...
1. Download the zip file. [NOTE: Deactivated to avoid dealing with a potentially untrusted data source]
2. Extract the zip file contents into the local file system.
3. For the test and training datasets.
  3.1 Combine the subject, activity and measurements into a single dataframe.
    3.1.1 Include the application of a filter to retain only mean() and std() calculated measurements.
  3.2 Add appropriate variable (i.e. column header) names to the single dataframe.
    3.2.1 Remap activity digit to human readable activity label.
4. Combine the resultant test and training dataframes into a single combined dataframe.
5. Order the combined dataframe by subject ID and activity label.
6. Rename the variables measurement variables.
  6.1 Remove illegal chars from R variable names.
  6.2 Convert names to camelCase for readability.
7. Tidy the data. (using reshape2 library)
  7.1 Melt the dataframe.
    7.1.1 Use sujectID and activityLabel as IDs and rest of variables as Signal and Measurment.
  7.2 Cast the dataframe.
    7.2.1 Give the mean of each measurement value for each subjectID/activityLabel combination.
  7.3 Rename the measurement variable names by prefixing with 'avg' (for average).
8. Write tidy data to file on disk.

Notes:-
1. Steps 3 and 4 take two dataframes of 2947 observations of 561 variables and 7352 observations of 561 variables respectiviely and combine it into a single dataframe. Of the 561 variables, 66 remained after only considering those signals which were the mean or standard deviation of the measurement. i.e. those with 'mean()' or 'std()' in the signal name. It is important to understand that other signal names with the string 'mean' in them were discounted as they were not related to an actual measurement using the 'mean()' or 'std()' function calls. With the aforementioned combination/filtering processes complete the dataframe dimensions including two ID variables is 10299 observations of 68 variables.
2. Step 7 tidies the data such that each observation (subject/activity/set-of-measurements combination) forms a row, each variable signal measurement forms a column, and each type of observational unit, i.e. the study results form a table. These constitute the tenets of "Tidy Data". The tidy dataset is 180 observations ( 30 subjects x 6 activities per subject) of 68 variables (2 ID variables + 66 measurement variables).
3. The Data Tidy paper (see Citation #2) was a valuable reference in understanding the principles of "Tidy Data".
4. The Introduction to Reshape2 tutorial (see Citation #3) was a valuable reference for the mechanics of transforming the data into tidy data.
5. There were no missing data in the original dataset.


###Tidy Data

Presented in the HAR_tidy_data.txt file. This file is created by the run_analaysis.R script in the same directory as the R script itself. The file itself is in ASCII format. It comprises of 181 lines including the header. Each line has 68 fields. The field separator is a single space.

all of the std() and mean() measurements from features.txt

The table below shows all of the variables in the Tidy Dataset.
The subjectId is an interger values between 1 and 30.
The activity label is a Factor with vales of LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS.
The avgTime* and avgFreq* mean and standard deviation measurement results are all of type double. Taking both positive and negative values. The size of each calculated value is calculated to 15 decimal places. This has not been truncated from what R calculated. See the README.txt and features_info.txt files within the original zipfile for further details on the various sensor measurements from which the calculated values in the table below were derived.

| Name | Type |
| :--- | :--- |
| subjectID | integer |
| activityLabel | Factor w/ 6 levels |
| avgTimeBodyAccMeanX | double |
| avgTimeBodyAccMeanY | double |
| avgTimeBodyAccMeanZ | double |
| avgTimeBodyAccStdDevX | double |
| avgTimeBodyAccStdDevY | double |
| avgTimeBodyAccStdDevZ | double |
| avgTimeGravityAccMeanX | double |
| avgTimeGravityAccMeanY | double |
| avgTimeGravityAccMeanZ | double |
| avgTimeGravityAccStdDevX | double |
| avgTimeGravityAccStdDevY | double |
| avgTimeGravityAccStdDevZ | double |
| avgTimeBodyAccJerkMeanX | double |
| avgTimeBodyAccJerkMeanY | double |
| avgTimeBodyAccJerkMeanZ | double |
| avgTimeBodyAccJerkStdDevX | double |
| avgTimeBodyAccJerkStdDevY | double |
| avgTimeBodyAccJerkStdDevZ | double |
| avgTimeBodyGyroMeanX | double |
| avgTimeBodyGyroMeanY | double |
| avgTimeBodyGyroMeanZ | double |
| avgTimeBodyGyroStdDevX | double |
| avgTimeBodyGyroStdDevY | double |
| avgTimeBodyGyroStdDevZ | double |
| avgTimeBodyGyroJerkMeanX | double |
| avgTimeBodyGyroJerkMeanY | double |
| avgTimeBodyGyroJerkMeanZ | double |
| avgTimeBodyGyroJerkStdDevX | double |
| avgTimeBodyGyroJerkStdDevY | double |
| avgTimeBodyGyroJerkStdDevZ | double |
| avgTimeBodyAccMagMean | double |
| avgTimeBodyAccMagStdDev | double |
| avgTimeGravityAccMagMean | double |
| avgTimeGravityAccMagStdDev | double |
| avgTimeBodyAccJerkMagMean | double |
| avgTimeBodyAccJerkMagStdDev | double |
| avgTimeBodyGyroMagMean | double |
| avgTimeBodyGyroMagStdDev | double |
| avgTimeBodyGyroJerkMagMean | double |
| avgTimeBodyGyroJerkMagStdDev | double |
| avgFreqBodyAccMeanX | double |
| avgFreqBodyAccMeanY | double |
| avgFreqBodyAccMeanZ | double |
| avgFreqBodyAccStdDevX | double |
| avgFreqBodyAccStdDevY | double |
| avgFreqBodyAccStdDevZ | double |
| avgFreqBodyAccJerkMeanX | double |
| avgFreqBodyAccJerkMeanY | double |
| avgFreqBodyAccJerkMeanZ | double |
| avgFreqBodyAccJerkStdDevX | double |
| avgFreqBodyAccJerkStdDevY | double |
| avgFreqBodyAccJerkStdDevZ | double |
| avgFreqBodyGyroMeanX | double |
| avgFreqBodyGyroMeanY | double |
| avgFreqBodyGyroMeanZ | double |
| avgFreqBodyGyroStdDevX | double |
| avgFreqBodyGyroStdDevY | double |
| avgFreqBodyGyroStdDevZ | double |
| avgFreqBodyAccMagMean | double |
| avgFreqBodyAccMagStdDev | double |
| avgFreqBodyAccJerkMagMean | double |
| avgFreqBodyAccJerkMagStdDev | double |
| avgFreqBodyGyroMagMean | double |
| avgFreqBodyGyroMagStdDev | double |
| avgFreqBodyGyroJerkMagMean | double |
| avgFreqBodyGyroJerkMagStdDev  | double |


###Bibliographic Citations
1. Human Activity Recognition Using Smartphones Data Set (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
2. Data Tidy by Hadley Wickham in the Journel of Statistical Software (http://vita.had.co.nz/papers/tidy-data.pdf)
3. An Introduction to Reshape2 by Sean C. Anderson (http://seananderson.ca/2013/10/19/reshape.html)
