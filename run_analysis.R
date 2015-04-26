
activity_labels<-read.table("activity_labels.txt", col.names=c("activity_code","activity_name"))
features<-read.table("features.txt", col.names=c("feature_code", "feature"))
std_features<-features[grep("std\\(\\)", features$feature),] #Finds the features that have "std()" in the feature name.
mean_features<-features[grep("mean\\(\\)", features$feature),] #Finds the features that have "mean()" in the feature name.
#This excludes the 
rel_features<-rbind(std_features,mean_features) #Merges the above into relevant features.
rel_features<-rel_features[order(rel_features$feature_code),] #Reorders in order of feature code.
features$feature<-sub("\\(\\)", "", features$feature) #Makes the features into readable column names.
features$feature<-sub("\\-","_", features$feature) #Makes the features into readable column names.

#Pulls in the test data with appropriate column names, then pares it down to the columns of interest- 
#the standard deviations and means. Also adds a named factor level based on activity names to help label rows.
subject_test<-read.table("./test/subject_test.txt", col.names="subject_number")
y_test<-read.table("./test/y_test.txt", col.names="activity_code")
x_test<-read.table("./test/x_test.txt",  col.names=features$feature)
rel_x_test<-x_test[,rel_features$feature_code]
test<-cbind(y_test, subject_test, rel_x_test)
test_merged<-merge(test, activity_labels)
test_final<-cbind(test_merged$activity_name, test_merged[,c(2:68)])
names(test_final)[1]<-"activity_name"

#Pulls in the train data with appropriate column names, then pares it down to the columns of interest- 
#the standard deviations and means. Also adds a named factor level based on activity names to help label rows.
subject_train<-read.table("./train/subject_train.txt", col.names="subject_number")
y_train<-read.table("./train/y_train.txt", col.names="activity_code")
x_train<-read.table("./train/x_train.txt",  col.names=features$feature)
rel_x_train<-x_train[,rel_features$feature_code]
train<-cbind(y_train, subject_train, rel_x_train)
train_merged<-merge(train, activity_labels)
train_final<-cbind(train_merged$activity_name, train_merged[,c(2:68)])
names(train_final)[1]<-"activity_name"

#Merges the rows.
data<-rbind(test_final,train_final)
data<-data[order(data[,1], as.numeric(data[,2])),]
#Cleans up the workspace so only the raw data object remains, on which all further work will be done.
objects<-ls()
rm(list=objects[which(objects[]!="data")])
rm(objects)
# 
uniq_id<-paste(data[,1],data[,2])
predata<-cbind(uniq_id, data[,c(3:68)])
library(reshape2)
melted<-melt(predata,1)
averages<-dcast(melted, uniq_id ~ variable, mean, na.rm= TRUE)

write.table(tidy, file="Tidy HAR data averages.txt", row.names=FALSE)