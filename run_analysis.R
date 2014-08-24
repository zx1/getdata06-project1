runanalysis = function()
{
    fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    filename = "dataset.zip"
    
    if(!file.exists(filename))
    {
        print("Downloading File...")
        setInternet2(use=TRUE)
        download.file(fileURL, destfile=filename, mode="wb")
        
        unzip(filename)
    }
    
    # Features appears to be space delimited # name
    print("read features")
    features = read.table("UCI HAR Dataset/features.txt", sep=" ", header=F)
    colnames(features) = c("Index", "FeatureName")
    
    # Logical indicating features we are interested in mean() and std()
    lfeatures = grepl("mean\\(\\)", features$FeatureName) | grepl("std\\(\\)", features$FeatureName)
    
    featurecol = sapply(lfeatures, function(x){ if( x == TRUE ) NA else "NULL" })
    
    print("read Activity Levels")
    actlevels = read.table("UCI HAR Dataset/activity_labels.txt")
    
    # --- Read in test data ---
    print("read test measures")
    testmeasures = read.table("UCI HAR Dataset/test/x_test.txt", colClasses=featurecol)
    colnames(testmeasures) = features[c(which(lfeatures)),2]
    #print(nrow(testmeasures))

    print("read test subject")
    testsubjects = read.table("UCI HAR Dataset/test/subject_test.txt")
    #print(nrow(testsubjects))

    print("read test activity")
    testactivities = read.table("UCI HAR Dataset/test/y_test.txt")
    testact = factor(testactivities[,1])
    levels(testact) = actlevels[,2]
    #print(head(testact))
 
    print("combine test subjects and activities")
    test1 = cbind(testsubjects,testact)
    colnames(test1) = c("SubjectID", "Activity")
    
    print("combine test subjects and activities and measures")
    testdata = cbind(test1, testmeasures)
    
    #print(head(testdata))
    
    # --- Read in train data ---
    print("read train measures")
    trainmeasures = read.table("UCI HAR Dataset/train/x_train.txt", colClasses=featurecol)
    colnames(trainmeasures) = features[c(which(lfeatures)),2]
    #print(nrow(trainmeasures))
    
    print("read train subject")
    trainsubjects = read.table("UCI HAR Dataset/train/subject_train.txt")
    #print(nrow(trainsubjects))
    
    print("read train activity")
    trainactivities = read.table("UCI HAR Dataset/train/y_train.txt")
    trainact = factor(trainactivities[,1])
    levels(trainact) = actlevels[,2]
    #print(nrow(trainactivities))
    #print(head(trainact))
    
    print("combine train subjects and activities")
    train1 = cbind(trainsubjects,trainact)
    colnames(train1) = c("SubjectID", "Activity")
    
    print("combine train subjects and activities and measures")
    traindata = cbind(train1, trainmeasures)
    #print(head(traindata))
    
    #combine both data sets
    print("combine both data sets")
    dataset = rbind(traindata, testdata)
    #print(nrow(dataset))
    #print(head(dataset))
    
    print("reshape the data")
    library(reshape2)
    ds = melt(dataset, id=c("SubjectID","Activity"))
    ds = dcast(ds, SubjectID + Activity ~ variable, mean)
    print(ds)

    print("Write results to file")
    write.table(ds, file="WearablesData.txt", sep=",", row.name=FALSE)

    print("done")
}