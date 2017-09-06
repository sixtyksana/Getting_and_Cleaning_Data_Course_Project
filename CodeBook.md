# Introduction

The script "run_analysis.R" slove the five problems of "Getting and Cleaning Data Course Project"

* Step1: Read data using read.table, note: that the IS function is created when the Inertial_Signals data is read, the data under the InertialSignals folder is read in batches. and then the data is merged using rbind
* Step2: Extract only the measurements on the mean and standard deviation for each measurement
* Step3: Use descriptive activity names to name the activities in the data set
* Step4: Appropriately label the data set with descriptive variable names
* Step5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. The output file is called `averages_data.txt`, and uploaded to this repository.


# Variables

* initial data: `x_train`, `y_train`, `x_test`, `y_test`, `subject_train` and `subject_test`
* function    : IS -- load InertialSignals folder data
* merge       : `data.X`, `data.y`, `data.subject` and data.Inertial_Signals
* `features` contains the correct names for the `x_data` dataset, which are applied to the column names stored in `mean_std`, a numeric vector used to extract the desired data.
* A similar approach is taken with activity names through the `activities` variable.
* `all_data` merges `data.X`, `data.y` and `data.subject` in a big dataset.
* Finally, `averages_data` contains the relevant averages which will be later stored in a `.txt` file. `ddply()` from the plyr package is used to apply `colMeans()` and ease the development.