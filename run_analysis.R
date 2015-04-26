
activity_labels<-read.table("activity_labels.txt", col.names=c("activity_code","activity_name"))
features<-read.table("features.txt", col.names=c("feature_code", "feature"))
std_features<-features[grep("std\\(\\)", features$feature),] #Finds the features that have "std()" in the feature name.
mean_features<-features[grep("mean", features$feature),] #Finds the features that have "mean()" in the feature name.
#This excludes the additional vectors obtained by averaging the signals in a signal window sample used 
#on the angle() variable: gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean as 
#these are not means of measured data but metaanalysis.
rel_features<-rbind(std_features,mean_features) #Merges the above into relevant features.
rel_features<-rel_features[order(rel_features$feature_code),] #Reorders in order of feature code.

#Pulls in the test data with appropriate column names, then pares it down to the columns of interest- 
#the standard deviations and means. Also adds a named factor level based on activity names to help label rows.
subject_test<-read.table("./test/subject_test.txt", col.names="subjectnumber")
y_test<-read.table("./test/y_test.txt", col.names="activitycode")
x_test<-read.table("./test/x_test.txt",  col.names=features$feature)
rel_x_test<-x_test[,rel_features$feature_code]
test<-cbind(y_test, subject_test, rel_x_test)
test_merged<-merge(test, activity_labels)
test_final<-cbind(test_merged$activity_name, test_merged[,c(2:81)])
names(test_final)[1]<-"activityname"

#Pulls in the train data with appropriate column names, then pares it down to the columns of interest- 
#the standard deviations and means. Also adds a named factor level based on activity names to help label rows.
subject_train<-read.table("./train/subject_train.txt", col.names="subjectnumber")
y_train<-read.table("./train/y_train.txt", col.names="activitycode")
x_train<-read.table("./train/x_train.txt",  col.names=features$feature)
rel_x_train<-x_train[,rel_features$feature_code]
train<-cbind(y_train, subject_train, rel_x_train)
train_merged<-merge(train, activity_labels)
train_final<-cbind(train_merged$activity_name, train_merged[,c(2:81)])
names(train_final)[1]<-"activityname"

#Merges the rows.
data<-rbind(test_final,train_final)
data<-data[order(data[,1], as.numeric(data[,2])),]

#Systematically renames the variables in the dataset to be more clear.
names(data)<-sub("^t", "timeof", names(data))
names(data)<-sub("^f", "frequencyof", names(data))
names(data)<-sub("X$", "xaxiscomponent",names(data))
names(data)<-sub("Y$", "yaxiscomponent", names(data))
names(data)<-sub("Z$", "zaxiscomponent", names(data))
names(data)<-sub("Mag","magnitude", names(data))
names(data)<-sub("std","standarddeviation", names(data))
names(data)<-sub("Freq","frequency",names(data))
names(data)<-sub("BodyAccJerk","linearacceleration",names(data))
names(data)<-sub("BodyGyroJerk","angularvelocity",names(data))
names(data)<-sub("BodyAcc","estimatedbodyacceleration",names(data))
names(data)<-sub("GravityAcc","estimatedgravityacceleration",names(data))
names(data)<-sub("BodyBodyGyro","bodybodygyroscopicmovement",names(data))
names(data)<-sub("BodyGyro", "bodygyroscopicmovement",names(data))
names(data)<-sub("GravityAcc","estimatedgravityacceleration",names(data))
names(data)<-gsub("\\.","",names(data))
names(data)<-tolower(names(data))

#Cleans up the workspace so only the raw data object remains, on which all further work will be done.
objects<-ls()
rm(list=objects[which(objects[]!="data")])
rm(objects)
#Melts the data into a tall skinny table of variables and their values by activityname and subject number.
library(reshape2)
melted<-melt(data,c(1,2))
#Casts the data into a wide table with the average of each variable over each combination of activity and subject
tidy<-dcast(melted, activityname + subjectnumber ~ variable, mean, na.rm=TRUE)
names(tidy)[c(3:81)]<-paste0("average",names(tidy)[c(3:81)])
write.table(tidy, file="Tidy HAR data averages.txt", row.names=FALSE)

