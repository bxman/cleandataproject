run_analysis <- function() {
        ## function loads, merges and outputs a tidy dataset of summary (mean) data from samsung device
        ## measured mean and STD values. 
        
        ## requires library(dplr); library(data.table)
        ## Warnings suppressed due to RStudio noisy output.
        suppressWarnings(library(dplyr))
        suppressWarnings(library(data.table))
        
        ## assumes WD contains the directory of UCI dataset
        ## writes out tidy data to .txt file "tidy.txt"
        
        get_data = function() {
                # download and extract data if needed
                if (!file.exists("UCI HAR Dataset")) {
                        URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                        zFile="UCI_HAR_data.zip"
                        download.file(URL, destfile=zFile, method="curl")
                        unzip(zFile)
                }
        }
        
        merge_data = function() {
                ## Merges the training and the test sets to create one data set.
                
                
                ## test subject ID numbers: numeric ID of study participant
                subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
                subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
                merged_subject <- rbind(subject_train, subject_test)
                
                ## high level activity catagory data, see: UCI HAR Dataset/activity_labels.txt
                activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
                activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
                merged_activity <- rbind(activity_train, activity_test)
                
                ## detailed (561 cols) feature data, see: UCI HAR Dataset/features.txt
                features_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
                features_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
                merged_features <- rbind(features_train, features_test)
                
                ## Uses descriptive activity names to name the activities in the data set
                ## transfroms from numberic code to character descriptions
                activites_names <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
                for (i in 1:nrow(activites_names)) {
                        merged_activity[,1] <- sapply(merged_activity[,1], function(x) ifelse(x==i,as.character(activites_names[i,2]),x))
                }
                
                feature_names <- read.table("UCI HAR Dataset/features.txt")
                feature_labels <- t(feature_names[2]) ## flip from long column to list
                colnames(merged_features) <- feature_labels
                
                data <- cbind(merged_subject, merged_activity, merged_features)
                return(data)
        }
        
        select_data = function (data) {
                ## Extracts only the measurements on the mean and standard deviation for each measurement. 
                
                column_index <- grep(".*mean.*|.*std.*", names(data), ignore.case=TRUE)
                data <- data[column_index]
                return(data)
        }
        
        useful_labels = function (data) {
                ## Appropriately labels the data set with descriptive variable names. 
                
                ## clean up labels of Col 1,2 after binding
                names(data)[1] = "Subject"
                names(data)[2] = "Activity"
                
                ## clean up for readability
                colnames(data) <- gsub("[/(/)]","",colnames(data))
                colnames(data) <- gsub("-","_",colnames(data))
                
                ## expand to useful text
                ## t = Time, f= Frequency, Acc = Acceleration, Gyro = Gyroscope, Mag = Magnitude
                colnames(data) <- gsub("^t","Time",colnames(data))
                colnames(data) <- gsub("^f","Frequency",colnames(data))
                colnames(data) <- gsub("Freq","Frequency",colnames(data))
                colnames(data) <- gsub("Acc","Acceleration",colnames(data))
                colnames(data) <- gsub("Gyro","Gyroscope",colnames(data))
                colnames(data) <- gsub("Mag","Magnitude",colnames(data))
                
                return(data)
        }
        
        ## download, extract data if needed
        get_data()
        ## load and merge initial data sets
        data <- merge_data()
        ## select mean and STD datasets with Subject and activity
        my_data <- cbind(data[,1], data[,2], select_data(data))
        ## clean up column/varialble headings
        ready_to_tidy <- useful_labels(my_data)
        ## Build independent tidy data set with the average of each variable for each activity and each subject.
        tidy <- aggregate(. ~ Subject + Activity, ready_to_tidy, mean)
        tidy <- tidy[order(tidy$Subject, tidy$Activity),]
        ## write tidy.txt out to disk 
        write.table(tidy, file = "tidy.txt", row.name=FALSE)
}