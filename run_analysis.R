##download and unzip dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "./data/Dataset.zip")
##unzip to /data
unzip(zipfile = "./data/Dataset.zip",exdir="./data")

##reading tables
x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")

##reading feature vector
features<-read.table('./data/UCI HAR Dataset/features.txt')

##reading activity labels
activityLabels=read.table('./data/UCI HAR Dataset/activity_labels.txt')

##assign column names
colnames(x_train)<-features[,2]
colnames(y_train)<-"activityId"
colnames(subject_train)<-"subjectId"

colnames(x_test)<-features[,2]
colnames(y_test)<-"activityId"
colnames(subject_test)<-"subjectId"

colnames(activityLabels)<-c('activityId','activityType')

##merge data
mrg_train<-cbind(y_train,subject_train,x_train)
mrg_test<-cbind(y_test,subject_test,x_test)
mrgAll<-rbind(mrg_train,mrg_test)

##mean and std dev measurement extraction
colNames<-colnames(mrgAll)
mean_and_std<-(grepl("activityId",colNames)|grepl("subjectId",colNames)|grepl("mean..",colNames)|grepl("std..",colNames))
                   
##subset from merged
meanAndStd<-mrgAll[,mean_and_std==TRUE]

##name activities in dataset
setActivityNames<-merge(meanAndStd,activityLabels,by='activityId',all.x=TRUE)

##second tidy dataset
secTidySet<-aggregate(.~subjectId+activityId,setActivityNames,mean)
secTidySet<-secTidySet[order(secTidySet$subjectId,secTidySet$activityId),]

write.table(secTidySet,"secTidySet.txt",row.name=FALSE)







