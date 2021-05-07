library(data.table)
library(ggplot2)
library(MASS)
library(stringr)
library(writexl)
library(caret)
library(mice)
library(MLeval)
library(sparklyr)
library(dplyr)

setwd("E:/Extension/DSI/Capstone")

hmda_fill <- fread("testset1_imp.csv")
hmda_fill$V1 <- NULL
str(hmda_fill)

factorcols <- colnames(hmda_fill)
factorcols <- factorcols[!factorcols %in% c("loan_amount_000s","applicant_income_000s","population",
                                            "minority_population","hud_median_family_income",
                                            "tract_to_msamd_income","number_of_owner_occupied_units",
                                            "number_of_1_to_4_family_units","rate_spread")]
hmda_fill[,(factorcols):= lapply(.SD, as.factor), .SDcols = factorcols]

# relevel race

hmda_fill$applicant_race_1 <- relevel(hmda_fill$applicant_race_1,ref="5")
hmda_fill$co_applicant_race_1 <- relevel(hmda_fill$co_applicant_race_1,ref="5")

model01 <- glm(approved ~ .-action_taken, data = hmda_fill, family = "binomial",na.action = na.omit)
summary(model01)

m2step <- stepAIC(model01,steps=5)

model03 <- glm(approved ~ .-action_taken-loan_amount_000s-preapproval
               -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex
               -purchaser_type, data = hmda_fill, family = "binomial",na.action = na.omit)
summary(model03)

m3step <- stepAIC(model03,steps=5)


# CV test -----------------------------------------------------------------
control = trainControl(method="cv", number=5, verboseIter = TRUE)
metric = "Accuracy"

set.seed(100)
log_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="glm", family = "binomial",
                 metric=metric, trControl=control, na.action = na.omit)
summary(log_fit)

set.seed(100)
tree_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                  -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                  data=hmda_fill, method="rpart",
                  metric=metric, trControl=control, na.action = na.omit)

results = resamples(list(log=log_fit, tree=tree_fit ) )
summary(results)

# -------------------------------------------------------------------------
set.seed(1)
hmda_fill <- hmda_fill[sample(.N,100000)]

set.seed(100)
knn_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="knn", 
                 metric=metric, trControl=control, na.action = na.omit)
confusionMatrix.train(knn_fit)

set.seed(100)
log_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="glm", family = "binomial",
                 metric=metric, trControl=control, na.action = na.omit)

results = resamples(list(log=log_fit, knn=knn_fit ) )
summary(results)


# -------------------------------------------------------------------------


set.seed(100)
rf_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                data=hmda_fill, method="rf", 
                metric=metric, trControl=control, na.action = na.omit)

results = resamples(list(log=log_fit, rf=rf_fit ) )
summary(results)

confusionMatrix.train(rf_fit)
confusionMatrix.train(log_fit)

# -------------------------------------------------------------------------

set.seed(100)
svm_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="svmRadial", 
                 metric=metric, trControl=control, na.action = na.omit)

set.seed(100)
xgb_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="xgbLinear", 
                 metric=metric, trControl=control, na.action = na.omit)

results = resamples(list(log=log_fit, xgb=xgb_fit ) )
summary(results)

confusionMatrix.train(xgb_fit)
confusionMatrix.train(log_fit)

# -------------------------------------------------------------------------

model100k <- glm(approved ~ .-action_taken
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data = hmda_fill, family = "binomial",na.action = na.omit)
summary(model100k)

m100step <- stepAIC(model100k,steps=5)
summary(m100step)

# -------------------------------------------------------------------------
control2 = trainControl(method="cv", number=5, verboseIter = TRUE,
                       summaryFunction = twoClassSummary, classProbs = TRUE,
                       savePredictions = TRUE)

hmda_df <- data.frame(hmda_fill)

mnames <- function(x) {
  levels(hmda_df[,x]) <- make.names(levels(hmda_df[,x])) 
  return (hmda_df[,x])
}
cols <- colnames(hmda_df)
hmda_df[,cols] <- lapply(cols,mnames)

set.seed(100)
log_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="glm", family = "binomial",
                 metric=metric, trControl=control2, na.action = na.omit)
logev <- evalm(log_fit)

set.seed(100)
xgb_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="xgbLinear", 
                 metric=metric, trControl=control2, na.action = na.omit)
xgbev <- evalm(xgb_fit)

# -------------------------------------------------------------------------

table(hmda_fill$approved)
mean(as.numeric(hmda_fill$approved)-1)

control3d = trainControl(method="cv", number=5, verboseIter = TRUE, sampling = "down")
control3u = trainControl(method="cv", number=5, verboseIter = TRUE, sampling = "up")

set.seed(100)
log_fit_d <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="glm", family = "binomial",
                 metric=metric, trControl=control3d, na.action = na.omit)
set.seed(100)
log_fit_u <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                   -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                   data=hmda_fill, method="glm", family = "binomial",
                   metric=metric, trControl=control3u, na.action = na.omit)

set.seed(100)
xgb_fit_d <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="xgbLinear", 
                 metric=metric, trControl=control3d, na.action = na.omit)
set.seed(100)
xgb_fit_u <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                   -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                   data=hmda_fill, method="xgbLinear", 
                   metric=metric, trControl=control3u, na.action = na.omit)

results = resamples(list(log_d=log_fit_d, log_u=log_fit_u,
                         xgb_d=xgb_fit_d, xgb_u=xgb_fit_u))
summary(results)


# -------------------------------------------------------------------------

control4 = trainControl(method="cv", number=5, verboseIter = TRUE,
                        summaryFunction = twoClassSummary, classProbs = TRUE,
                        savePredictions = TRUE, sampling = "down")

set.seed(100)
log_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="glm", family = "binomial",
                 metric=metric, trControl=control4, na.action = na.omit)
logev <- evalm(log_fit)

set.seed(100)
xgb_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="xgbLinear", 
                 metric=metric, trControl=control4, na.action = na.omit)
xgbev <- evalm(xgb_fit)

control4 = trainControl(method="cv", number=5, verboseIter = TRUE,
                        summaryFunction = twoClassSummary, classProbs = TRUE,
                        savePredictions = TRUE, sampling = "up")

set.seed(100)
log_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="glm", family = "binomial",
                 metric=metric, trControl=control4, na.action = na.omit)
logev <- evalm(log_fit)

set.seed(100)
xgb_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_df, method="xgbLinear", 
                 metric=metric, trControl=control4, na.action = na.omit)
xgbev <- evalm(xgb_fit)


# Spark -------------------------------------------------------------------
set.seed(100)
system.time(log_fitr <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                             -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                             data=hmda_fill, method="glm", family = "binomial",
                             metric=metric, trControl=control, na.action = na.omit))


sc <- spark_connect(master = "local")
hmda_tbl <- copy_to(sc,hmda_fill)

pipeline <- ml_pipeline(sc) %>% 
  ft_r_formula(approved ~ .-action_taken-loan_amount_000s-purchaser_type
               -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex) %>% 
  ml_logistic_regression()

cv <- ml_cross_validator(sc, estimator = pipeline, 
                         evaluator = ml_binary_classification_evaluator(sc),
                         estimator_param_maps = list(logistic_regression = list(elastic_net_param = 0)),
                         num_folds = 5)

log_fits <- ml_fit(cv, hmda_tbl)
system.time(log_fits <- ml_fit(cv, hmda_tbl))








