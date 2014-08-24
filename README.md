
Smartphone Accelerometer Dataset README
======
---


August 24, 2014

this readme will describe what steps and assumptions were made in preparing the data

---

1. if the file does not exist Download the data from the link provided and save as a zip file named dataset.zip in the current workign directory and extract its contents
  1. assumes the files are unziped into a folder caleld "UCI HAR Dataset"
2. Read the featuers file that appears to be seperated by a space
  1. label the columns 
3. grep for all features we are interested in which include those that are the mean and standard deviation
  1. we want those features that are mean and standard deviation but not those that are the mean or standard deviation used in a calculation
4. build a vector of NA, NULL values where NA is the columns we do want and NULL are the columns we don't want
5. read in the activity labels from the file
6. read in the test measures from the file. using the vector of NA NULL values we read only the data we want
  1. apply the column names to the data.frame
7. read in the test subject data
8. read in the test activity data
  1. factor the activity data
  2. relable the factors using the activity names we read in in step 5
9. combine the test subjects and test activitys into a data.frame
10. combine the previous matrix along with the features to make one test data.frame
11. repeat steps 6-10 for the train data.
12. combine both train and test data.frames into a final dataset.
13. use the reshape2 library to reshape the data
14. melt the data by SubjectID and Activity
15. dcast the data usign SubjectID and Activity along all of the variables and extract the mean of each varaiable
16. print the results
17. write the results to a file seperated by comma
