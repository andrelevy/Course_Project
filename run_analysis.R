# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

rm(list=ls())

library(data.table)
library(plyr)
library(dplyr)

# reads the activity labels for train data into a dataframe
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")

#reads in all 561 features
features<-read.table("./UCI HAR Dataset/features.txt")

# selects only those rows/features with "mean" OR "std" in string of V2
features2<-features[grep("mean|std", features$V2),]

# grepl (logical) returns a logical vector with TRUE for columns to be selected
features_l<-grepl("mean|std", features$V2)

# produces vector with the 561 column widths
cols<-c(rep(16,561))

#produces vector with column width of selected columns or zero for unselected
sel_cols<-cols*features_l

# transforms all zeros into -16, to exclude that column
sel_cols[sel_cols==0] <- -16

#####TRAIN DATA
# reads the subject labels for train data
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

# reads the activity labels for train data into a dataframe
activities_train<-read.table("./UCI HAR Dataset/train/y_train.txt")

# of the 561 columns reads only those with 'mean' and 'std' and gives label of feature
# will have 7352 lines of data
train_data<-read.fwf("./UCI HAR Dataset/train/X_train.txt", sel_cols, 
                     col.names=features2$V2)

#create group col with train descriptor
train_data["group"]<- rep("train",nrow(train_data))

#create col and label activities with descriptors and add to train_data
train_data["activity"] <- mapvalues(activities_train$V1, from = activities$V1, to = as.character(activities$V2))

#create subject col
train_data["subject"] <- subject_train$V1

#####TEST DATA
# reads the subject labels for test data
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

# reads the activity labels for test data into a dataframe
activities_test<-read.table("./UCI HAR Dataset/test/y_test.txt")

# of the 561 columns reads only those with 'mean' and 'std' and gives label of feature
# will have 7352 lines of data
test_data<-read.fwf("./UCI HAR Dataset/test/X_test.txt", sel_cols, 
                    col.names=features2$V2)

#create group col with train descriptor
test_data["group"]<- rep("test",nrow(test_data))

#create col and label activities with descriptors and add to train_data
test_data["activity"] <- mapvalues(activities_test$V1, from = activities$V1, to = as.character(activities$V2))

#create subject col
test_data["subject"] <- subject_test$V1


#####Merging data frames
#confirm col names are identical
identical(names(test_data),names(train_data))

total <- rbind(test_data, train_data)

# Create second tidy dataset with the average of each variable for each activity and each subject.

total2 <- total %>% group_by(subject,activity,group) %>% summarise_each(funs(mean))

write.table(total2,file="data.sum.txt", row.name=FALSE)