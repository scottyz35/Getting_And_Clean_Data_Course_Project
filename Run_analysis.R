#Load Train
setwd("train/")
X_train <- read.table("X_train.txt", header = FALSE)
Train_Activity <- read.table("Y_train.txt", header = FALSE)
Train_Subject <- read.table("Subject_train.txt", header = FALSE)
setwd("..")

#Load Test
setwd("test/")
X_test <- read.table("X_test.txt", header = FALSE)
Test_Activity <- read.table("Y_test.txt", header = FALSE)
Test_Subject <- read.table("Subject_test.txt", header = FALSE)
setwd("..")

#Load lookups
feature_labels <- read.delim("features.txt", sep = " ", header = FALSE)
activity_labels <- read.delim("activity_labels.txt", sep = " ", header=FALSE)

#Add subject and create Test/Train Variable
X_train <- cbind(Train_Subject, X_train)
X_test <- cbind(Test_Subject, X_test)
Train_Activity <- merge(Train_Activity, activity_labels)
Test_Activity <- merge(Test_Activity, activity_labels)
X_train$Train_Test <- "Train"
X_test$Train_Test <- "Test"

#rename column names
feature_labels$V2 <- as.character(feature_labels$V2)
feature_labels$V2 <- gsub("^t","Time_",feature_labels$V2)
feature_labels$V2 <- gsub("^f","FFT_",feature_labels$V2)
feature_labels$V2 <-sub("\\)","",feature_labels$V2)
feature_labels$V2 <-sub("\\(","",feature_labels$V2)
feature_labels$V2 <-sub("-","_",feature_labels$V2)
feature_labels$V2 <-sub("-","_",feature_labels$V2)
feature_labels$V2 <-sub(",","_",feature_labels$V2)

#Combind Activity, Test Test, Train into 1 data set and rename columns
Train <- cbind(Train_Activity, X_train)
Test <- cbind(Test_Activity, X_test)
TT <- rbind(Train, Test)
TT <- TT[,2:565]
colnames(TT) <- c("Activity", "Subject", as.character(feature_labels$V2), "Train_Test")
Step1_final<-TT

#Create Table of mean and standard deviation
TT_new <- cbind(apply(TT[,3:563], 2, mean), apply(TT[,3:563], 2, sd))
TT_new <- as.data.frame(TT_new)
colnames(TT_new) <- c( "Mean", "Standard Deviation")
Step2_final <- TT_new

#Create Table of mean and standard deviation for each activity and subject
Step5_final <- Final <- aggregate(TT[,3:ncol(TT)],
          by=list(Subject = TT$Subject, 
                  Activity = TT$Activity), mean)

