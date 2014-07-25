#!/usr/bin/env Rscript
#-----------------------------------------
# Program name : runAnalysis.R
#  Course name : Getting and Cleaning Data
#      Project : 1
#  Institution : Johns Hopkins University
# Organization : Coursera
#-----------------------------------------
# 
# start with clean environment
rm(list = ls(all.names = TRUE))


# load libraries
suppressMessages(library(plyr))
suppressMessages(library(reshape2))
suppressMessages(library(stringr))


#---------------------
# function definitions
#---------------------
#
# function to translate the variable names in the dataset into
# something which is legal R syntax and clearer (camelCase)
# examples...
# "tBodyAcc-mean()-X"  ->  "timeBodyAccMeanX"
# "fBodyBodyAccJerkMag-std()" -> "freqBodyAccJerkMagStdDev"
transvar <- function(varname) {
    # ^t -> ^time
    var1 <- str_replace(varname, "^t", "time")
    # ^f -> ^freq
    var2 <- str_replace(var1, "^f", "freq")
    # mean() -> Mean
    var3 <- str_replace(var2, "mean\\(\\)", "Mean")
    # std() -> StdDev
    var4 <- str_replace(var3, "std\\(\\)", "StdDev")
    # BodyBody -> Body (fix error in original dataset)
    var5 <- str_replace(var4, "BodyBody", "Body")
    # remove all dashes
    var6 <- str_replace_all(var5, "-", "")
    return(var6)
}


# function to translate the legal variable names in the dataset
# into arithmetic averages (mean) for clarity in tidy dataset
# examples...
# "timeBodyAccMeanX" -> "avgTimeBodyAccMeanX"
# "freqBodyAccJerkMagStd" -> "avgFreqBodyAccJerkMagStd"
transavgvar <- function(varname) {
    # ^time -> avgTime
    var1 <- str_replace(varname, "^time", "avgTime")
    # ^freq -> avgFreq
    var2 <- str_replace(var1, "^freq", "avgFreq")
    return(var2)
}


# establish subdir for raw data extraction
cwd <- "."
if(!file.exists(paste(cwd, "data" , sep = "/"))) {
    dir.create("data")
}


# Human Activity Recognition Using Smartphones Data Set
#harURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# convert https to http so that download will work
#harURL <- gsub("^https://", "http://", harURL)


# download the Human Activity Recognition (HAR) dataset
#zipfile <- basename(harURL)
#cat("Downloading HAR Data zipfile ... ")
#download.file(harURL, destfile = zipfile, method = "curl", quiet = TRUE)
#cat("done\n\n")


# generate timestamp of when raw source data file was downloaded.
# useful to know if subsequent attempts at reproducability appear to be inconsistent.
#cat(paste("HAR Data zipfile downloaded on: ", date(), "\n\n", sep = ""))


# extract the HAR dataset into the data/ subdir for further processing
datadir <- paste(cwd, "data", sep = "/")

# Hardcode the zipfile, this assumes that it has been manually downloaded as per
# the project requirement rather than downloading automatically as the commented
# out code above does. Presumably this is preferred to avoid any security issues
# surrounding the downloading of content that is not trusted.
zipfile <- "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

cat(paste("Extract HAR Data zipfile to", datadir, "... ", sep = " "))
unzip(zipfile, files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE,
      exdir = datadir, unzip = "internal", setTimes = FALSE)
cat("done\n\n")


# the X_<test|train>.txt file contain the various study measurement values
# read the measurements from the test and training datasets into dataframes
zipdir <- paste(datadir, list.files(datadir), sep = "/")
test_measurements_df <- read.table(paste(zipdir, "test", "X_test.txt", sep = "/"))
train_measurements_df <- read.table(paste(zipdir, "train", "X_train.txt", sep = "/"))


# the features.txt file contain the various study measurement names
# add meaningful column headers to the test and training dataframes
# e.g. replace V1 with tBodyAcc-mean()-X, etc.
features_mapping_df <- read.table(paste(zipdir, "features.txt", sep = "/"))
features_v <- as.vector(features_mapping_df[,2])
colnames(test_measurements_df) <- features_v
colnames(train_measurements_df) <- features_v


# the y_<test|train>.txt file contains the numerical activity
# for the test and training datasets read the numerical activity
# into a dataframe and convert to a vector
y_test_df <- read.table(paste(zipdir, "test", "y_test.txt", sep = "/"))
y_test_v <- as.vector(y_test_df[,1])
y_train_df <- read.table(paste(zipdir, "train", "y_train.txt", sep = "/"))
y_train_v <- as.vector(y_train_df[,1])


# the activity_labels.txt file contains the activity mapping (digit -> label)
# e.g. 1 -> WALKING
# create digit and corresponding label vectors to be used to convert digit to label
activity_mapping_df <- read.table(paste(zipdir, "activity_labels.txt", sep = "/"))
activity_digit <- as.vector(activity_mapping_df[,1])
activity_label <- as.vector(activity_mapping_df[,2])


# for the test and training datasets create a vector in which the original activity
# represented by a digit 1->6 is replacd by the corresponding activity label e.g. WALKING
test_activities_v <- mapvalues(y_test_v, from = activity_digit, to = activity_label)
train_activities_v <- mapvalues(y_train_v, from = activity_digit, to = activity_label)


# for the test and training datasets create dataframe from activity vector
# rename variable to 'actvityLabel'
test_activities_df <- data.frame(test_activities_v)
colnames(test_activities_df) <- c("activityLabel")
train_activities_df <- data.frame(train_activities_v)
colnames(train_activities_df) <- c("activityLabel")


# the subject_<test|train>.txt file contains the study subject ID (1 -> 30)
# for the test and training datasets create dataframe from subject ID and
# add meaningful column header
test_subject_df <- read.table(paste(zipdir, "test", "subject_test.txt", sep = "/"))
colnames(test_subject_df) <- c("subjectID")
train_subject_df <- read.table(paste(zipdir, "train", "subject_train.txt", sep = "/"))
colnames(train_subject_df) <- c("subjectID")


# create a vector of dataset column headers which comprises of just those names
# containing the strings 'mean()' and 'std()'
# note: only need to consider one of the two datasets as they both have the same columns
mean_std_v <- grep(("std\\(\\)|mean\\(\\)"), names(test_measurements_df), value = TRUE)


# use the mean_std vector to create subsets of both measurement datasets
# which only contain mean() and std() measurements
test_measurements_mean_std_df <- test_measurements_df[mean_std_v]
train_measurements_mean_std_df <- train_measurements_df[mean_std_v]


# create a single test data set by combining the subject, activity and measurements dataframes
# for the test dataset
cat("Create a single test dataset ... ")
combined_test_df <- cbind(test_subject_df, test_activities_df, test_measurements_mean_std_df)
cat("done\n\n")


# as above but for the training datset
cat("Create a single train dataset ... ")
combined_train_df <- cbind(train_subject_df, train_activities_df, train_measurements_mean_std_df)
cat("done\n\n")


# combine the test and train datasets into a single dataset
cat("Combine the test and train datasets into a single dataset ... ")
combined_df <- rbind(combined_test_df, combined_train_df)
cat("done\n\n")


# order dataset by subject ID, then activity label
ordered_combined_df <- combined_df[order(combined_df$subjectID, combined_df$activityLabel),]


# rename the variables (camelCase)
# - replace t and f with time and freq respectively
# - remove the illegal () chars
names(ordered_combined_df) <- transvar(names(ordered_combined_df))


cat("Create a tidy dataset ... ")
# melt the dataframe using subjectID and activityLabel as the id variables
molten_df <- melt(ordered_combined_df,
                  id = c("subjectID", "activityLabel"),
                  variable.name = "Signal",
                  value.name = "Measurement")

# cast the molten dataframe to give the arithmetic average (i.e. mean)
# of each signal measurement for each subjectID/activityLabel combo
casted_df <- dcast(molten_df, subjectID + activityLabel ~ Signal,
                   fun.aggregate = mean,
                   value.var = "Measurement")

# rename the variables (camelCase)
# - replace time and freq with avgTime and avgFreq respectively
names(casted_df) <- transavgvar(names(casted_df))

cat("done\n\n")


# write tidy dataset to disk
file <- "HAR_tidy_data.txt"
cat(paste("Write tidy dataset to", file, "... "), sep = "")
write.table(casted_df, file = file, row.names = FALSE, sep = " ")
cat("done\n\n")
