## Next few lines import the 8 relevant files for the project
features <- read.table("UCI HAR Dataset/features.txt", header=F, 
                       sep="", fill=T)
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=F, 
                       sep="", fill=T)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F,
                           sep="", fill=T)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F, 
                     sep="", fill = T)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=F, 
                     sep="", fill=T)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F,
                           sep="", fill=T)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F, 
                     sep="", fill = T)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=F, 
                     sep="", fill=T)

## Merging datasets, item 1 of the project
X <- rbind(X_train,X_test)

## The next few lines will reduce the columns for both X to the colums
##     including the strings "mean()" or "std()", item 2 of the project
relevantFeatures1 <- grep("mean()",features$V2, fixed = T) ## finds the ones 
                                                           ## containing "mean()"
relevantFeatures2 <- grep("std()",features$V2, fixed = T)  ## finds the ones 
                                                           ## containing "std()"
relevantFeatures <- c(relevantFeatures1,relevantFeatures2) ## combines both
relevantFeatures <- sort(relevantFeatures)                 ## sort the columns
X <- X[,relevantFeatures] ## reduces X to only the relevant features

## The next few lines will add a column with the name of the activity to X
##     item 3 of the project
y <- rbind(y_train,y_test)
for (i in 1:length(y$V1)){
    aux<- as.character(activity_labels[activity_labels$V1 == y$V1[i],2])
    y$activity[i] <- aux
}
X<-cbind(y$activity,X)

## The next few lines will add the column of the suject to X
subject <- rbind(subject_train,subject_test)
X <- cbind(subject,X)

## The next few lines will rename the columns of X, item 4 of the project
newNames <-as.character(features[features$V1 %in% relevantFeatures,2])
newNames <- c("subject","activity",newNames)
a<-names(X)
names(X)[names(X)==a] <- newNames

## The next line will get the final result, which is a table of values 
##     averaged by subject and activity
result <- X %>% group_by(subject,activity) %>% summarise_each(funs(mean))

## Write the result out
write.table(result, file = "resulItem5.txt", row.names = FALSE)
