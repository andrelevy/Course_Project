# Course_Project
Course Project for the Data Cleaning course

run_analysis.R assumes it is in the same folder as the "UCI HAR Dataset"" folder

It reads in the activity_labels, and features files as dataframes. grep is applied to 
features dataframe to select only those features that contain mean or std in name. 

These resulting objects will be used later to code final table.

grepl in combination with a vector containing fixed column widths is used to read in only data
regarding desired features.

The the train and test data the script performs the the following steps:

1. reads the data file by selecting desired columns and labeling columns with appropriate features.
2. Read the subject and activity files. Adds these columns to data.frame, and replaces activity code with descriptor.

Train and test are merged.
A second data set is created, with the average of each variable for each activity and each subject, and written into a file.
