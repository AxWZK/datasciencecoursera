#------ created by AxWZK
#------ 20-FEB-2015
#------
#------ Coursera Get & Clean Data course project -----
#
#------ run_analysis.R 
# Step 1. Merges the training and the test sets to create one data set.
# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# Step 3. Uses descriptive activity names to name the activities in the data set
# Step 4. Appropriately labels the data set with descriptive variable names. 
# Step 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.
#------

#------- The Setup -------
##-- Define files, libraries, and working directories
library(dplyr)
setwd("/home/axwzk314/R/datasciencecoursera/GetAndCleanData")
if (!file.exists("data")) { dir.create("data")}

##--- Fetching my raw materials
projectdataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(projectdataURL, 
              destfile="Project_Dataset.zip", 
              method="curl")

unzip("Project_Dataset.zip", exdir="./data")

#------- Step 1 -------
# --- Data Set for tagging and labeling
dat.features <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
dat.activity <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)

# --- Test Data Set
dat.test <- cbind(read.table("./data/UCI HAR Dataset/test/subject_test.txt"),
                  read.table("./data/UCI HAR Dataset/test/y_test.txt"), 
                  read.table("./data/UCI HAR Dataset/test/X_test.txt", fill=TRUE))

# --- Train Data Set
dat.train <- cbind(read.table("./data/UCI HAR Dataset/train/subject_train.txt"), 
                   read.table("./data/UCI HAR Dataset/train/y_train.txt"),
                   read.table("./data/UCI HAR Dataset/train/X_train.txt", fill=TRUE))

# --- Final assembly of big massive data set of awesomeness
dat.all<- rbind(dat.test, dat.train)

#------- Step 4 ------- (yes, its out of order but it made more sense here)
colnames(dat.all)<-make.names(c("SUBJECT_ID",
                                "ACTIVITY",
                                dat.features$V2))

#------- Step 2 -------
dat.tidy <- cbind(dat.all[1:2], 
                  dat.all[suppressWarnings(grepl("mean|std", names(dat.all)))])

#------- Step 3 -------
for(items in dat.activity$V1){
  dat.thin$ACTIVITY[ dat.thin$ACTIVITY==items ] = dat.activity$V2[items]
}

#------- Step 5 -------
dat.tidy <- summarise_each(group_by(dat.thin, 
                                    SUBJECT_ID, 
                                    ACTIVITY), 
                           funs(mean))

#-------  Spitting out my answer -------
write.table(dat.tidy, 
            file="tidy_data.txt", 
            row.name=FALSE)

###### scratchpad ######

