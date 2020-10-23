
library(dplyr)

# download data from the website
filename <- "getdata_projectfiles_UCI_HAR_Dataset.zip"

file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file, filename, method="curl")

unzip(filename) 

# read all data
feature <- read.table("UCI HAR Dataset/features.txt")
colnames(feature)<-c('index','features')
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activity)<-c('index','activity')

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test)<-'subject'
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(x_test)<-feature$features
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
colnames(y_test)<-'index'

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train)<-'subject'
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
colnames(x_train)<-feature$features
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
colnames(y_train)<-'index'

# combine train and test data sets together
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
combined_data <- cbind(Subject, Y, X)

# get the tidy data from combined_data
tidydata <- combined_data %>% select(subject, index, contains("mean"), contains("std"))
tidydata$index <- activity[tidydata$index, 2]

# rename all variable names
names(tidydata)[2] = "activity"
names(tidydata)<-gsub("Acc", ".accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", ".gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", ".magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean", ".mean", names(tidydata))
names(tidydata)<-gsub("Mean", ".mean", names(tidydata))
names(tidydata)<-gsub("-std", ".std", names(tidydata))
names(tidydata)<-gsub("-freq", ".frequency", names(tidydata))
names(tidydata)<-gsub("Freq", ".frequency", names(tidydata))
names(tidydata)<-gsub("\\(\\)", "", names(tidydata))


final_data <- tidydata %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(final_data, "final_data.txt", sep='\t', quote=F, row.name=FALSE)


