## Read in the raw data, assuming the full UCI dataset has been placed in the working directory 
wd <- paste(getwd(),"/UCI HAR Dataset/",sep="")
x_test <- read.table( paste(wd,"/test/X_test.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
y_test <- read.table( paste(wd,"/test/y_test.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
subject_test <- read.table( paste(wd,"/test/subject_test.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
x_train <- read.table( paste(wd,"/train/X_train.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
y_train <- read.table( paste(wd,"/train/y_train.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
subject_train <- read.table( paste(wd,"/train/subject_train.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
activity_labels <- read.table( paste(wd,"/activity_labels.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)
features <- read.table( paste(wd,"/features.txt",sep=""), header = FALSE, stringsAsFactors = FALSE)

## combine the test and training data into a single data frame
data_combined <- cbind( rbind(subject_test, subject_train), rbind(y_test,y_train), rbind(x_test,x_train) )

## label each column - labels for the measurement data are drawn from the 'features.txt' table
labels <- c("SubjectNumber","ActivityNumber",features[,2])
names(data_combined) <- labels

## extract only measurements on the mean and stdev of each measurement
meanstd <- grep("mean(?!Freq)|std", features$V2, perl = TRUE)
data_combined <- data_combined[, c(1, 2, 2+meanstd)]

## add descriptive names for the activity field by pulling in the looking up the descriptive names from 'activity_labels.txt'
library(dplyr)
names(activity_labels) <- c("ActivityNumber","ActivityName")
data_combined <- data_combined %>% 
  left_join(activity_labels,by = "ActivityNumber") %>% 
  select(SubjectNumber, ActivityName, everything(), -ActivityNumber)

## use the sub function to alter variable names to make them descriptive and understandable
names(data_combined) <- sub("^t","Time",names(data_combined))
names(data_combined) <- sub("^f","Freq",names(data_combined))
names(data_combined) <- sub("Acc-|Acc","Acceleration",names(data_combined))
names(data_combined) <- sub("Gyro-|Gyro","Gyroscope",names(data_combined))
names(data_combined) <- sub("Mag-|Mag","Magnitude",names(data_combined))
names(data_combined) <- sub("X$","Xaxis",names(data_combined))
names(data_combined) <- sub("Y$","Yaxis",names(data_combined))
names(data_combined) <- sub("Z$","Zaxis",names(data_combined))
names(data_combined) <- sub("mean()","Mean",names(data_combined))
names(data_combined) <- sub("std()","Stdev",names(data_combined))

## create a data set with the average of each variable for each activity and each subject and write this to a .txt file
data_summary <- data_combined %>%
  group_by(SubjectNumber,ActivityName) %>%
  summarise_all(mean)
  write.table(data_summary, file = "summary_data.txt", row.name=FALSE)
