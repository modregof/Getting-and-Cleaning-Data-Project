## 1. Merges the training and the test sets to create one data set.
features <- read.table("features.txt")
training_set <- read.table("./train/X_train.txt")
testing_set <- read.table("./test/X_test.txt")
library(dplyr)
complete_set <- rbind(training_set, testing_set)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
names(complete_set) <- features [,2]
library(stringr)

selected_set1 <- complete_set[,str_detect(names(complete_set), "mean()")]
selected_set2 <- complete_set[,str_detect(names(complete_set), "std()")]
selected_set <- cbind(selected_set1 ,selected_set2)

## 3. Uses descriptive activity names to name the activities in the data set

test_l<-read.table("./test/y_test.txt")
test_s<-read.table("./test/subject_test.txt")
test_ls <- cbind(test_l, test_s)
train_l<-read.table("./train/y_train.txt")
train_s<-read.table("./train/subject_train.txt")
train_ls <- cbind(train_l, train_s)
complete_ls <- rbind(train_ls, test_ls)

## 4. Appropriately labels the data set with descriptive variable names. 
names(complete_ls) <- c("id_activity", "id_subject")

labeled_set <- cbind(complete_ls, selected_set)

## 3. Uses descriptive activity names to name the activities in the data set
activity_l<-read.table("./activity_labels.txt")
names(activity_l) <- c("id_activity", "n_activity")
activity_set <- merge(activity_l, labeled_set)



## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(reshape2)
melted_set <- melt(activity_set,id=c("n_activity","id_subject"),measure.vars=c(4:82))
aggregated_data <- group_by(melted_set, id_subject, n_activity, variable) %>% summarize(mean = mean(value))
aggregated_data<-rename(aggregated_data, measures = variable)

## Write data set in the working directory
write.table(aggregated_data, "samsung_measures.txt", row.name=FALSE)
