# codebook * run_analysis

This briefly describes the changes the origin data set:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Original Dataset included the following data:

* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

## Code transformations to create tidy data set

1. Corresponding 'X' and 'y' labeled sets merged together (train + test), features labeled according to 'features.txt'
2. Activity Labels transformed in data sets (num to character) according to 'activity_labels.txt' mappings
3. Dataset is reduced to include just Mean, Standard Deviation (STD) readings, Activity and Subject ID
4. Labels (from 'features.txt') transformed be more readable and useful
  * () and - cleaned up
  * t = Time
  * f= Frequency
  * Acc = Acceleration
  * Gyro = Gyroscope
  * Mag = Magnitude
5. Data reduced to avearge of each reading by activity per subject.