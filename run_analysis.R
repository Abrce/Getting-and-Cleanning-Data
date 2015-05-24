## Import all files needed for creating the dataset ##
subject_test <- read.table("./test/subject_test.txt", quote="\"")
X_test <- read.table("./test/X_test.txt", quote="\"")
y_test <- read.table("./test/y_test.txt", quote="\"")
subject_train <- read.table("./train/subject_train.txt", quote="\"")
X_train <- read.table("./train/X_train.txt", quote="\"")
y_train <- read.table("./train/y_train.txt", quote="\"")
activity_labels <- read.table("./activity_labels.txt", quote="\"")
features <- read.table("./features.txt", quote="\"")

##Combine data from the subjects of TRAIN and TEST groups ##
dataset1 <- rbind(X_train, X_test)

## Create meanindex and stdindex with the position of measurements on the mean and standard deviation for each measurement respetively ## 
meanindex <- grep("mean", features[,2])
stdindex <- grep("std", features[,2])

## Select from dataset1 the columns in the positions indicated by meanindex and stdindex and creates means and stds subset respectively ##
means <- subset(dataset1, select = meanindex)
stds <- subset(dataset1, select = stdindex)

## Select from features the columns in the position indicated by meanindex and stdindex to get the names of the measurements 
meansnames <- features[meanindex,2]
stdsnames <- features[stdindex,2]

## Name the columns with the name of the variables## 
colnames(means) <- meansnames
colnames(stds) <- stdsnames

## Create the data frame subject with the information of subjects of both groups##
subject <- rbind(subject_train, subject_test) 
colnames(subject) <- "subject"

## Creates the dataframe Y that contains the numeric code of the activities of both groups##
Y <- rbind(y_train,y_test)
activity = t(Y)
for (i in 1:6){
  activity = gsub(i, activity_labels[i,2],activity)
}

## Create the dataframe groups with TRAIN and TEST groups for identification##
group <- data.frame() 
group[1:2947,1] <- "TRAIN"
group[2948:10299,1] <- "TEST"
colnames(group) = "group"

## Creates the dataset with the information ##
dataset <- cbind(subject, group, activity, means, stds)
                 
## creates a tidy data set with the average of each variable for each activity and each subject.##

datafinal <- aggregate(dataset[,4:82], by = dataset[c("subject","group","activity")], FUN=mean)

## Creates a txt file in the working directory
write.table(datafinal, "./datafinal.txt", row.names = FALSE)
