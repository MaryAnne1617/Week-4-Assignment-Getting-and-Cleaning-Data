#Download file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(x_train)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Assign Column names
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityid"
colnames(subject_train) <- "subjectid"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"

colnames(activityLabels) <- c('activityid','activitytype')

#Merge data
merge_train <-cbind(y_train, subject_train, x_train)
merge_test <-cbind(y_test, subject_test, x_test)
alldata <-rbind(merge_train, merge_test)

#Extracts only the measurements on the mean and std dev for each measurement
column_names <- colnames(alldata)
mean_n_stddev <- (grepl("activityid", column_names) | grepl("subjectid" , column_names) | grepl("mean", column_names) | grepl("std_dev", column_names))
subsetofmeanstd <- alldata[ ,mean_n_stddev ==TRUE]

#Uses descriptive activity names to name the activities in the data set
activitynames <-merge(subsetofmeanstd, activityLabels, by='activityid', all.x=TRUE)

secondtidydata <- aggregate(. ~subjectid + activityid, activitynames, mean)
secondtidydata <- secondtidydata[order(secondtidydata$subjectid, secondtidydata$activityid),]

write.table(secondtidydata, "secondtidydata.txt", row.name=FALSE)




