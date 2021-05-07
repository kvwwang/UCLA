# Project 5
# UCLA Extension Data Science Intensive
# Kevin Wang

# Initialization ---------------------------------------------------------
library(readxl)
library(MASS)
library(corrplot)
library(caret)
library(pROC)
library(dplyr)
library(tidyr)
library(ROCR)
setwd("E:/Extension/DSI/P5")

# Part A ------------------------------------------------------------------
blood_train <- read_xlsx("blood_traindata.xlsx")
blood_test <- read_xlsx("blood_testdata.xlsx")

blood_train$ID <- NULL
blood_test$ID <- NULL

colnames(blood_train)
colnames(blood_train) <- c("monthsLD","nDonations","volume","monthsFD","donated")
colnames(blood_test)
colnames(blood_test) <- c("monthsLD","nDonations","volume","monthsFD")

logm1 <- glm(donated ~., data = blood_train, family = "binomial")
summary(logm1)

logm2 <- stepAIC(logm1, direction = "both")
summary(logm2)

# Same AIC as model 1 (412.16)
# Check correlations
corrplot(cor(blood_train), type="lower", method="number")

# Correlation of 1: volume and number of donations (not surprising to donate a set amount)

# Other models
# 10-fold cross validation
blood_train$donated <- factor(blood_train$donated)

set.seed(100)
control = trainControl(method="cv", number=10)
metric = "Accuracy"

# LDA
set.seed(100)
lda_fit <- train(donated~., data=blood_train, method="lda", metric=metric, trControl=control)

# Tree
set.seed(100)
tree_fit <- train(donated~., data=blood_train, method="rpart", metric=metric, trControl=control)

# KNN
set.seed(100)
knn_fit <- train(donated~., data=blood_train, method="knn", metric=metric, trControl=control)

# Bayesian GLM
set.seed(100)
glm_fit <- train(donated~., data=blood_train, method="bayesglm", metric=metric, trControl=control)

# SVM
set.seed(100)
svm_fit <- train(donated~., data=blood_train, method="svmRadial", metric=metric, trControl=control)

# Random Forest
set.seed(100)
rf_fit <- train(donated~., data=blood_train, method="rf", metric=metric, trControl=control)

# XGBoost
set.seed(100)
xgbl_fit <- train(donated~., data=blood_train, method="xgbLinear", metric=metric, trControl=control)

set.seed(100)
xgbt_fit <- train(donated~., data=blood_train, method="xgbTree", metric=metric, trControl=control)

set.seed(100)
xgbd_fit <- train(donated~., data=blood_train, method="xgbDART", metric=metric, trControl=control)

# Summarize results
results = resamples(list(lda=lda_fit, tree=tree_fit, knn=knn_fit, 
                         glm=glm_fit, svm=svm_fit, rf=rf_fit,
                         xgbL=xgbl_fit, xgbT=xgbt_fit, xgbD=xgbd_fit))
summary(results)

# Best mean accuracies:
# xgbTree 0.7851329   # xgbDART 0.7851329   
# Kappas: 
# xgbTree 0.34587744  # xgbDART 0.34154834  

# Select xgbtree
print(xgbt_fit)

# Predict with xgbtree
pred_xgbt <- predict(xgbt_fit, blood_test)
pred_xgbt

write.csv(pred_xgbt, "blood_prediction.csv")

# Optimal cut-off point
pred_xgbt_train <- predict(xgbt_fit, type="prob", blood_train)
pred_1 <- as.numeric(pred_xgbt_train[,2])
xgbt_roc <- roc(response = blood_train$donated, predictor = pred_1)
plot(xgbt_roc, legacy.axes = TRUE, print.auc.y = 1.0, print.auc = TRUE)
coords(xgbt_roc, "best", "threshold")
# AUC 0.811
# threshold = 0.2962086   


# Part B ------------------------------------------------------------------

creditcard <- read.csv("creditcard.csv")
str(creditcard)
summary(creditcard)
creditcard <- creditcard[,-1]

# Part B EDA --------------------------------------------------------------

# Plot percentage of defaults, borrow code from D04c_churn
creditcard %>% 
  group_by(default.payment.next.month) %>% 
  summarize(Count = n()) %>% 
  mutate(percent = prop.table(Count)*100)%>%
  ggplot(aes(reorder(default.payment.next.month, -percent), percent), fill = default.payment.next.month)+
  geom_col(fill = c("grey", "light blue"))+
  geom_text(aes(label = sprintf("%.1f%%", percent)), hjust = 0.2, vjust = 2, size = 5)+ 
  theme_bw()+  
  xlab("Default (1 = Yes)") + ylab("Percent") + ggtitle("Default Percent")

ggplot(creditcard, aes(x = LIMIT_BAL)) + geom_histogram()
table(creditcard$SEX)
ggplot(creditcard, aes(x = EDUCATION)) + geom_histogram()
ggplot(creditcard, aes(x = MARRIAGE)) + geom_histogram()
ggplot(creditcard, aes(x = AGE)) + geom_histogram()
ggplot(creditcard, aes(x = PAY_0)) + geom_histogram()
ggplot(creditcard, aes(x = BILL_AMT1)) + geom_histogram()
ggplot(creditcard, aes(x = PAY_AMT1)) + geom_histogram()

# Clean Data / Make Factors
# According to description file, Education should be 1-4, so group 0,5,6 into others
creditcard$EDUCATION[which( !(creditcard$EDUCATION %in% c(1,2,3,4)) )] <- 4
ggplot(creditcard, aes(x = EDUCATION)) + geom_histogram()

# Marriage should be 1-3, group 0 into other (3)
creditcard$MARRIAGE[creditcard$MARRIAGE == 0] <- 3
ggplot(creditcard, aes(x = MARRIAGE)) + geom_histogram()

# Factors
factor_cols <- c("SEX","EDUCATION","MARRIAGE","PAY_0","PAY_2","PAY_3",
                 "PAY_4","PAY_5","PAY_6","default.payment.next.month")

creditcard[factor_cols] <- lapply(creditcard[factor_cols],as.factor)
str(creditcard)

# More EDA
# Default vs Factor Features
ggplot(creditcard,aes(x=SEX,fill=default.payment.next.month)) + geom_bar() +
  xlab("SEX, 1=M, 2=F") + 
  guides(fill=guide_legend(title="Default (1=Y)"))
ggplot(creditcard,aes(x=EDUCATION,fill=default.payment.next.month)) + geom_bar() +
  xlab("EDUCATION, 1=Graduate School, 2=University, 3=High School, 4=Other") + 
  guides(fill=guide_legend(title="Default (1=Y)"))
ggplot(creditcard,aes(x=MARRIAGE,fill=default.payment.next.month)) + geom_bar() +
  xlab("MARRIAGE, 1=Married, 2=Single, 3=Other") + 
  guides(fill=guide_legend(title="Default (1=Y)"))

# Default vs numeric Features
ggplot(creditcard, aes(x=default.payment.next.month, y=AGE, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="AGE")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)"))
ggplot(creditcard, aes(x=default.payment.next.month, y=LIMIT_BAL, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="Amount of given credit in NT dollars")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)"))

# Default vs 1 month of each monthly feature
# vs BILL_AMT
ggplot(creditcard, aes(x=default.payment.next.month, y=BILL_AMT1, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="Amount of bill statement in September, 2005 (NT dollar)")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)"))

# Change y lim
ggplot(creditcard, aes(x=default.payment.next.month, y=BILL_AMT1, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="Amount of bill statement in September, 2005 (NT dollar)")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)")) +
  ylim(0,200000)

# vs PAY_AMT
ggplot(creditcard, aes(x=default.payment.next.month, y=PAY_AMT1, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="Amount of previous payment in September, 2005 (NT dollar)")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)"))

# Change y lim
ggplot(creditcard, aes(x=default.payment.next.month, y=PAY_AMT1, fill=default.payment.next.month)) + geom_violin()+
  geom_boxplot(width=0.1, fill="white") + labs(title="Amount of previous payment in September, 2005 (NT dollar)")+ 
  xlab("Default") +
  guides(fill=guide_legend(title="Default (1=Y)")) +
  ylim(0,15000)

# vs PAY_ (factor)
ggplot(creditcard,aes(x=PAY_0,fill=default.payment.next.month)) + geom_bar() +
  xlab("Repayment status Sept 2005, -2=full, -1=min, 0+=delay for n+1 months") + 
  guides(fill=guide_legend(title="Default (1=Y)"))



# Part B Learning ---------------------------------------------------------

# Supervised Learning: Logistic Regression
log_fit <- glm(default.payment.next.month ~., data = creditcard, family = "binomial")
summary(log_fit)
# AIC: 26172

log_pred <- predict(log_fit,creditcard, type = "response")
summary(log_pred)

# ROC/AUC
log_roc <- roc(response = creditcard$default.payment.next.month, predictor = log_pred)
plot(log_roc, legacy.axes=TRUE, print.auc.y=1.0, print.auc=TRUE)
coords(log_roc,"best","threshold")
# coords: threshold 0.2066047 is "best"
# AUC: 0.772

# Threshold 50
pred_50 <- as.factor(as.numeric(log_pred >= 0.5))
confusionMatrix(pred_50,creditcard$default.payment.next.month, positive = "1")
# Accuracy is 0.82, but sensitivity is only 0.357
# So 0.5 is probably not the best threshold choice

# Different thresholds using ROCR
rocr_pred <- prediction(log_pred, creditcard$default.payment.next.month)
rocr_perf <- performance(rocr_pred,"tpr","fpr")
plot(rocr_perf, print.cutoffs.at = seq(0.05,by=0.05))
# From plot, maybe something from 0.2-0.25 would be better,
# as suggested earlier by coords, so there is a higher TPR without FPR getting 
# too high

# PCA
creditcard2 <- subset(creditcard, select = -c(default.payment.next.month))
creditcard2[] <- sapply(creditcard2, as.numeric)

cc_pr <- prcomp(creditcard2, scale = TRUE)
summary(cc_pr)
cc_pr$rotation[,1:5]  # First 5 PC's
cc_pr$x[,1:5]
cc_pr$sdev[1:5]

# K-means clustering
set.seed(100)
cc_km <- kmeans(creditcard2, 4, nstart = 100)
plot(subset(creditcard2, select=c("LIMIT_BAL","BILL_AMT1")), col = cc_km$cluster+1,
     main = "K-means clustering K=4",
     xlab = "LIMIT_BAL", ylab = "BILL_AMT1", pch=20, cex=2)

# In the context of this plot, the clusters might represent
# Low balance limit/Low spenders,
# Medium balance limit/Medium spenders
# High balance limit/Low spenders
# High balance limit/High Spenders



