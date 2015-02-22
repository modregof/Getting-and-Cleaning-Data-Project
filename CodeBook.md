# Code Book

This document describes the code inside `run_analysis.R`.

The code is splitted (by comments) in some sections:

 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names. 
 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## 1. Merges the training and the test sets to create one data set.

Firstly downloads and extracts  the files in the working directory from (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

>features <- read.table("features.txt")

>training_set <- read.table("./train/X_train.txt")

>testing_set <- read.table("./test/X_test.txt")

After reading the corresponding files in the training and testing set, merges both sets in the 'complete_set' with rbind. This function doesn´t change the order of the rows.

>complete_set <- rbind(training_set, testing_set)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Uses features.txt to fill the headers/names of the data set

>names(complete_set) <- features [,2]

And with the function str_detect, referenced only the columns containing std() and mean()

>selected_set1 <- complete_set[,str_detect(names(complete_set), "mean()")]

>selected_set2 <- complete_set[,str_detect(names(complete_set), "std()")]

In selected_set obtained the chosen data:

>selected_set <- cbind(selected_set1 ,selected_set2)

## 3. Uses descriptive activity names to name the activities in the data set

Uses files 'y_test' and 'subject_test' to obtain the identificator of activity , and subject (necessary for question 5) for the test measures

>test_l<-read.table("./test/y_test.txt")

>test_s<-read.table("./test/subject_test.txt")

>test_ls <- cbind(test_l, test_s)

The same for the training measures

>train_l<-read.table("./train/y_train.txt")

>train_s<-read.table("./train/subject_train.txt")

>train_ls <- cbind(train_l, train_s)

>complete_ls <- rbind(train_ls, test_ls)

## 4. Appropriately labels the data set with descriptive variable names.

>names(complete_ls) <- c("id_activity", "id_subject")

>labeled_set <- cbind(complete_ls, selected_set)

## 3 (bis). Includes the identificators of activity and subject in the data set 

Used function merge. It is not neccesary by.x and by.y becouse the variable id_activity has the same name in both files

>activity_l<-read.table("./activity_labels.txt")

>names(activity_l) <- c("id_activity", "n_activity")

>activity_set <- merge(activity_l, labeled_set)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

A data set is created in a long version using the function melt because is easier to manipulate and aggregate:

>melted_set <- melt(activity_set,id=c("n_activity","id_subject"),measure.vars=c(4:82))

Aggregated using the function group by and summarize with mean to calculate the average:

>aggregated_data <- group_by(melted_set, id_subject, n_activity, variable) %>% summarize(mean = mean(value))

Writes `aggregated_data` data frame to the ouputfile samsung_measures
