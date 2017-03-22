library(plyr)
library(dplyr)
library(magrittr)

rm(list=ls())

name <- 'gettingcleaningdata.zip'

## Download and unzip the dataset
if (!file.exists(name)){
    url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
    download.file(url, name)
}

if (!file.exists('UCI HAR Dataset')) { 
    unzip(name) 
}

##Read in training and testing datasets
train_x <- read.table('UCI HAR Dataset/train/X_train.txt')
train_y <- read.table('UCI HAR Dataset/train/Y_train.txt')
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test_x <- read.table('UCI HAR Dataset/test/X_test.txt')
test_y <- read.table('UCI HAR Dataset/test/Y_test.txt')
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table('UCI HAR Dataset/features.txt')
labels <- read.table('UCI HAR Dataset/activity_labels.txt')

##Merge training and testing x, give feature names
x <- rbind(train_x, test_x)
features[,2] <- as.character(features[,2])
features.names <- features[,2]
names(x) <- features.names
#Subset to mean and std
x <- x[,grep('*-mean*|*-std*', names(x))]

##Merge training and testing y, give activity names
y <- rbind(train_y, test_y)
names(y) <- c('Activity')
labels[,1] <- as.numeric(labels[,1])
labels[,2] <- as.character(labels[,2])
y$Activity <- mapvalues(unlist(y$Activity), from = labels[,1], to = labels[,2])

##Merge training and testing subjects
subjects <- rbind(train_subjects, test_subjects)
names(subjects) <- c('subject')

##Merge training and testing subjects
dt <- cbind(subjects, y, x)

##Summarize means by subject and activity in tidy text file
summary <- dt %>% group_by(subject, Activity) %>% summarize_each(funs(mean))
write.table(summary, "tidy.txt", row.names = FALSE, quote = FALSE)

