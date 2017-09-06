# run_analysis.R
rm(list = ls())
dataName <- "getdata_dataset.zip"

# Download and unzip the dataset
if (!file.exists(dataName)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, dataName, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(dataName) 
}

## =============================================================================
## Step 1 Merges the training and the test sets to create one data set.
# load data
IS <- function(tt) {
    ## load test or train Inertial_Signals data
    ## tt is test or train
    path    <- paste("UCI HAR Dataset/", tt, "/Inertial Signals/", sep = "")
    fileList <- dir(path)
    ISData <- data.frame()
    for (file in fileList) {
        fileData <- read.table(paste(path, file, sep = ""))
        # print(dim(fileData))
        ISData   <- rbind(ISData, fileData)
    }
    return(ISData)
}


subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test       <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test       <- read.table("UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train       <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train       <- read.table("UCI HAR Dataset/train/y_train.txt")

# rbind data AND create data.subject, data.X, data.y data set
data.subject <- rbind(subject_test, subject_train)
data.X       <- rbind(X_test, X_train)
data.y       <- rbind(y_test, y_train)

# rbind data AND create data.Inertial_Signals data set
data.Inertial_Signals <- rbind(IS("test"), IS("train"))


## =============================================================================
## Step 2 Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
# str(features)
# get only columns with mean() or std() in their names
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
data.X <- data.X[, mean_std]

# correct the column names
names(data.X) <- features[mean_std, 2]


## =============================================================================
# Step 3 Use descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

# update values with correct activity names
data.y[, 1] <- activities[data.y[, 1], 2]

# correct column name
names(data.y) <- "activity"


## =============================================================================
# Step 4 Appropriately label the data set with descriptive variable names

# correct column name
names(data.subject) <- "subject"

# bind all the data in a single data set
all_data <- cbind(data.X, data.y, data.subject)


## =============================================================================
# Step 5 Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
library(plyr)
averages_data <- ddply(
    all_data, 
    .(subject, activity), 
    function(x) colMeans(x[, 1:66])
)

write.table(averages_data, "averages_data.txt", row.name=FALSE)