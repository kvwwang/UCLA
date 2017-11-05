File "proj1-1.R" includes the code for the first 3 parts dealing with the network data set. File "proj1-2.R" contains the code for parts 4-5 (Boston Housing problems). The code was written using RStudio in R. Additional comments included in code file.

First, load in data if necessary into data, data2, data3
-Run parts of code separately 
-The random seed is set before each sampling instance

Problem 2
=========
Part 2a: 
-For 10-fold cross validation, change seed 10 times to run it 10 different times with different training/test set partitions

Part 2b:
-Need to install package randomForest

Part 2c: 
-Need to install package neuralnet

Problem 3
=========
Once again, change seed manually 10 times for 10-fold cross validation

Clear workspace after to have a clean slate for problems 4-5.

Problem 4
=========
-install package "plyr" to rename feature names
--can also use data from library "MASS"

Problem 5
=========
-install package "glmnet" to use Ridge/Lasso regression
-in the function used to produce the fit object "fit_r," one of the glmnet() parameters is alpha. It should be changed between 0 and 1 to switch between ridge and lasso penalties manually

