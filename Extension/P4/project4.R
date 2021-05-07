# Project 4
# UCLA Extension Data Science Intensive
# Kevin Wang

# Initialization ---------------------------------------------------------
library(ggplot2)
library(dplyr)
library(tidycensus)
library(tidyverse)
library(stringr)
library(viridis)
setwd("E:/Extension/DSI/P4")

# census_api_key("0c6c165f02f015e526c4c4777debb420fd24b225")
acs_var = load_variables(2019, "acs5", cache = TRUE)

# Part A ------------------------------------------------------------------

dt1 <- get_acs(geography = "county", variables = "B15003_022", summary_var = "B15003_001", geometry = FALSE)
dt2 <- get_acs(geography = "county", variables = "B19013_001")
dt2 <- rename(dt2, med_income = estimate)

dt3 <- merge(dt1,dt2, by = c("GEOID","NAME") )
dt3 <- subset(dt3, select=-c(variable.x,variable.y))
dt3 <- rename(dt3, bs_pop = estimate, bs_moe = moe.x, total_adults = summary_est, ta_moe = summary_moe,
              mi_moe = moe.y)

# Percent with college degree
dt3$pct_col <- dt3$bs_pop/dt3$total_adults

ggplot(dt3, aes(x=pct_col, y=log(med_income)) ) + geom_point() + 
  labs(x="% 25yrs+ with College Degree",y="log(Median Income)") +
  ggtitle("Correlation between College Degree and Income")

# Simple Regression
fit1 <- lm(log(med_income) ~ pct_col, dt3)
summary(fit1)

# pct_col is significant, Adj.R2 = 0.319
# As percentage of those with college degree goes up, then log(med_income) also goes up (as expected)
# Unsurprisingly, increasing education levels is related to increasing income

# Examine group of lower incomes
dt3[which(log(dt3$med_income)<10),]   # low med incomes are mostly from Puerto Rico

ggplot(dt3, aes(x=pct_col, y=log(med_income))) + geom_point(aes(color = str_detect(NAME,"Puerto Rico")) )+ 
  labs(x="% 25yrs+ with College Degree",y="log(Median Income)",color="Region") +
  ggtitle("Correlation between College Degree and Income") +
  scale_color_discrete(labels = c("States","PR"))


# Part B ------------------------------------------------------------------
library(readxl)
library(corrplot)

setwd("E:/Extension/DSI/P4/Data")

dmv_zip <- read_xlsx("dmv_zip.xlsx")

# Open metadata file to find cols of interest
edu <- read_xlsx("ACS_17_5YR_S1501.xlsx")
edu <- subset(edu, select = c(2,64,78,90,102,114,126,138,150,184,220,256,292))
colnames(edu) <- c("id","adultpop","L9pop","f912pop","HSpop", "somecolpop",
                   "assopop","bachpop","gradpop","a2534","a3544","a4564","a65")
edu[,3:9] <- sapply(edu[,3:9],as.numeric)

income <- read_xlsx("ACS_17_5YR_S1903.xlsx")
income <- subset(income, select = c(2,8))
colnames(income) <- c("id","income")
income$income <- as.numeric(gsub("-","NA",income$income))

str(edu); str(income); str(dmv_zip)

# Calculate CHCI
edu$CHCI <- (50*edu$L9pop + 100*edu$f912pop + 120*edu$HSpop + 130*edu$somecolpop + 
    140*edu$assopop + 190*edu$bachpop + 230*edu$gradpop) / 100

# Calculate age percents
edu$a2534p <- 100*edu$a2534/edu$adultpop
edu$a3544p <- 100*edu$a3544/edu$adultpop
edu$a4564p <- 100*edu$a4564/edu$adultpop
edu$a65p <- 100*edu$a65/edu$adultpop
edu$a2544p <- edu$a2534p+edu$a3544p

dfm <- left_join(dmv_zip,income,by="id")
dfm <- left_join(dfm,edu,by="id")

# Run regressions
corrplot(cor(dfm[,-1],use="complete.obs"),type="lower")

# Don't use all age groups
fit1 <- lm(p_beph ~ CHCI+income+a2534p+a3544p+a4564p+a65p, data=dfm)
summary(fit1)

fit2 <- lm(p_beph ~ CHCI+income+a2534p+a3544p+a4564p, data=dfm)
summary(fit2)

# Adj. R2 = 0.6011
# All factors significant, except age 45-64 distribution (only slightly)

fit3 <- lm(p_beph ~ CHCI+income+a2544p, data=dfm)
summary(fit3)

# Adj. R2 = 0.6005
# Higher income/chci, being 25-44 years old predicts higher p_beph

# Plots
plot(dfm$income,dfm$p_beph,ylim=c(0,25),xlab="Median Income",ylab="% EV")

ggplot(dfm, aes(x=income,y=p_beph)) + geom_point(color="blue") +
  ylim(0,25) + labs(x="Median Income",y="% EV") +
  ggtitle("Correlation between Median Household Income and EV Adoption %") +
  geom_smooth(method = "lm",aes(color="red")) +
  theme(legend.position = "none")


# Part C ------------------------------------------------------------------
library(rattle)
library(caret)
library(mice)

uciwd ="https://archive.ics.uci.edu/ml/machine-learning-databases/"
mldata = paste(uciwd,"breast-cancer-wisconsin/breast-cancer-wisconsin.data", sep="")
bcancer = read.csv(mldata, header=F) 
colnames(bcancer)=c("ID","clump_thick","cell_size","cell_shape", "marginal","epithelial","nuclei",
                    "chromatin","nucleoli","mitoses","class")

# Handle ?'s, set factors
bcancer$nuclei <- as.numeric(bcancer$nuclei)
bcancer$class <- factor(bcancer$class)

bcancer <- subset(bcancer, select=-ID)

# Impute
bcancer <- complete(mice(bcancer))

# rpart plot
treefit1 <- train(class~., data=bcancer, method = "rpart")
fancyRpartPlot(treefit1$finalModel)

# 10-fold Cross-validation
set.seed(99)
control <- trainControl(method="cv", number=10)

# LDA
set.seed(99)
lda_fit <- train(class~., data=bcancer, method="lda", trControl=control)

# Tree
set.seed(99)
tree_fit <- train(class~., data=bcancer, method="rpart", trControl=control)

# KNN
set.seed(99)
knn_fit <- train(class~., data=bcancer, method="knn", trControl=control)

# Bayesian GLM
set.seed(99)
glm_fit <- train(class~., data=bcancer, method="bayesglm", trControl=control)

# SVM
set.seed(99)
svm_fit <- train(class~., data=bcancer, method="svmRadial", trControl=control)

# Random Forest
set.seed(99)
rf_fit <- train(class~., data=bcancer, method="rf", trControl=control)

# XGBoost
set.seed(99)
xgbl_fit <- train(class~., data=bcancer, method="xgbLinear", trControl=control)

set.seed(99)
xgbt_fit <- train(class~., data=bcancer, method="xgbTree", trControl=control)

set.seed(99)
xgbd_fit <- train(class~., data=bcancer, method="xgbDART", trControl=control)

# Summarize results
results = resamples(list(lda=lda_fit, tree=tree_fit, knn=knn_fit, 
                         glm=glm_fit, svm=svm_fit, rf=rf_fit,
                         xgbL=xgbl_fit, xgbT=xgbt_fit, xgbD=xgbd_fit))
summary(results)

# The models with the best Kappas were:
# KNN, Random Forest, xgboost Tree, xgboost DART
# All 4 had Kappas approximately 0.934
# Although all models had good performance, and most of them were within 0.02
# of the highest Kappa model (xgboost Tree)

print(xgbt_fit)   # mean kappa = 0.9342948
print(xgbd_fit)   # mean kappa = 0.9341340
print(knn_fit)    # mean kappa = 0.9340036 
print(rf_fit)     # mean kappa = 0.9340214 







