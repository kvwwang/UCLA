library(data.table)
library(ggplot2)
library(MASS)
library(stringr)
library(writexl)
library(caret)
library(mice)

setwd("E:/Extension/DSI/Capstone")

data_all <- fread("hmda_2017_nationwide_all-records_codes.csv")
data_all <- fread("hmda_2017_nationwide_all-records_codes.csv",nrows=50000)
# data_all <- fread("hmda_2008_nationwide_all-records_codes.csv",nrows=10000)

colnames(data_all)
str(data_all)
summary(data_all)

hmda <- subset(data_all,select=-c(as_of_year,respondent_id,edit_status,
                                  sequence_number,application_date_indicator))

table(hmda$co_applicant_race_1)

# View % of (co)applicants who are multiracial
sum(table(hmda$co_applicant_race_2))/nrow(hmda)
sum(table(hmda$applicant_race_2))/nrow(hmda)

hmda$multirace <- ifelse(!is.na(hmda$applicant_race_2),yes=1,no=0)
hmda$coapplicant <- ifelse(hmda$co_applicant_race_1==8,yes=0,no=1)
hmda$approved <- ifelse((hmda$action_taken %in% c(1,2,8) ),yes=1,no=0)

colnames(hmda)
str(hmda)

factorcols <- colnames(hmda)
factorcols <- factorcols[!factorcols %in% c("loan_amount_000s","applicant_income_000s","population",
                                            "minority_population","hud_median_family_income",
                                            "tract_to_msamd_income","number_of_owner_occupied_units",
                                            "number_of_1_to_4_family_units","rate_spread")]
hmda[,(factorcols):= lapply(.SD, as.factor), .SDcols = factorcols]

str(hmda)
summary(hmda)


# plots p1 ----------------------------------------------------------------

ggplot(hmda, aes(x=action_taken)) +
  geom_bar(aes(fill=action_taken)) +
  theme_bw() +
  labs(x="Action Taken",y="Count",title="2017 HMDA Actions") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  scale_fill_viridis_d() 

ggplot(hmda, aes(x=loan_type)) +
  geom_bar(aes(fill=loan_type)) +
  theme_bw() +
  labs(x="Loan Type",y="Count",title="2017 HMDA Loan Types") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  scale_fill_viridis_d() 

ggplot(hmda, aes(x=action_taken)) +
  geom_bar(aes(fill=loan_type),position="fill") +
  theme_bw() +
  labs(x="Action Taken",y="Percent",title="2017 HMDA Actions",fill="Loan Type") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda, aes(x=action_taken)) +
  geom_bar(aes(fill=applicant_race_1),position="fill") +
  theme_bw() +
  labs(x="Action Taken",y="Percent",title="2017 HMDA Actions by Race 1",fill="Applicant Race 1") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda, aes(x=applicant_race_1)) +
  geom_bar(aes(fill=action_taken),position="fill") +
  theme_bw() +
  labs(x="Applicant Race 1",y="Percent",title="2017 HMDA Actions by Race 1",fill="Action Taken") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda, aes(x=action_taken)) +
  geom_bar(aes(fill=applicant_sex),position="fill") +
  theme_bw() +
  labs(x="Action Taken",y="Percent",title="2017 HMDA Actions by Sex",fill="Applicant Sex") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda, aes(x=applicant_sex)) +
  geom_bar(aes(fill=action_taken),position="fill") +
  theme_bw() +
  labs(x="Applicant Sex",y="Percent",title="2017 HMDA Actions by Sex",fill="Action Taken") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 


ggplot(hmda, aes(x=action_taken, y=applicant_income_000s, fill=action_taken)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Action Taken",y="Applicant Income in 1000s",title="2017 HMDA Actions by Income",fill="Income") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
    ylim(c(0,200))
ggplot(hmda, aes(x=action_taken, y=applicant_income_000s, fill=action_taken)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Action Taken",y="Applicant Income in 1000s",title="2017 HMDA Actions by Income",fill="Income") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  ylim(c(0,150))



# -------------------------------------------------------------------------

hmda_reduced <-subset(hmda,select=-c(applicant_race_2,applicant_race_3,applicant_race_4,
                             applicant_race_5,co_applicant_race_2,co_applicant_race_3,
                             co_applicant_race_4,co_applicant_race_5))

hmda_reduced <- subset(hmda_reduced, action_taken != 6)
summary(hmda_reduced)

# without 6 ---------------------------------------------------------------

ggplot(hmda_reduced, aes(x=approved)) +
  geom_bar(aes(fill=loan_type),position="fill") +
  theme_bw() +
  labs(x="Approved",y="Percent",title="2017 HMDA Approvals",fill="Loan Type") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=loan_type)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Loan Type",y="Percent",title="2017 HMDA Approvals",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=approved)) +
  geom_bar(aes(fill=applicant_race_1),position="fill") +
  theme_bw() +
  labs(x="Approved",y="Percent",title="2017 HMDA Approvals by Race 1",fill="Applicant Race 1") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=applicant_race_1)) +
  geom_bar(aes(fill=approved)) +
  theme_bw() +
  labs(x="Applicant Race 1",y="Percent",title="2017 HMDA Approvals by Race 1",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=approved)) +
  geom_bar(aes(fill=applicant_sex),position="fill") +
  theme_bw() +
  labs(x="Approved",y="Percent",title="2017 HMDA Approvals by Sex",fill="Applicant Sex") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=applicant_sex)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Applicant Sex",y="Percent",title="2017 HMDA Approvals by Sex",fill="Approved") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d()

ggplot(hmda_reduced, aes(x=approved, y=applicant_income_000s, fill=approved)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Approved",y="Applicant Income in 1000s",title="2017 HMDA Approvals by Income") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  ylim(c(0,200))

ggplot(hmda_reduced, aes(x=approved, y=loan_amount_000s, fill=approved)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Approved",y="Loan Amount in 1000s",title="2017 HMDA Approvals by Loan Amount") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  ylim(c(0,500))

ggplot(hmda_reduced, aes(x=coapplicant)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Coapplicant?",y="Percent",title="2017 HMDA Approvals by Coapplicant",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=multirace)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Multiracial?",y="Percent",title="2017 HMDA Approvals by Multiracial",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=applicant_ethnicity)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Ethnicity",y="Percent",title="2017 HMDA Approvals by Applicant Ethnicity",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=agency_code)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Agency",y="Percent",title="2017 HMDA Approvals by Agency",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=property_type)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Property Type",y="Percent",title="2017 HMDA Approvals by Property Type",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=loan_purpose)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Loan Purpose",y="Percent",title="2017 HMDA Approvals by Loan Purpose",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 


# without 4+6 -------------------------------------------------------------
hmda_reduced <- subset(hmda_reduced, action_taken != 4)
summary(hmda_reduced)


ggplot(hmda_reduced, aes(x=approved)) +
  geom_bar(aes(fill=loan_type),position="fill") +
  theme_bw() +
  labs(x="Approved",y="Percent",title="2017 HMDA Approvals",fill="Loan Type") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=loan_type)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Loan Type",y="Percent",title="2017 HMDA Approvals",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=applicant_race_1)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Applicant Race 1",y="Percent",title="2017 HMDA Approvals by Race 1",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=applicant_race_1)) +
  geom_bar(aes(fill=approved)) +
  theme_bw() +
  labs(x="Applicant Race 1",y="Percent",title="2017 HMDA Approvals by Race 1",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=approved)) +
  geom_bar(aes(fill=applicant_sex),position="fill") +
  theme_bw() +
  labs(x="Approved",y="Percent",title="2017 HMDA Approvals by Sex",fill="Applicant Sex") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 
ggplot(hmda_reduced, aes(x=applicant_sex)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Applicant Sex",y="Percent",title="2017 HMDA Approvals by Sex",fill="Approved") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d()

ggplot(hmda_reduced, aes(x=approved, y=applicant_income_000s, fill=approved)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Approved",y="Applicant Income in 1000s",title="2017 HMDA Approvals by Income") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  ylim(c(0,250))

ggplot(hmda_reduced, aes(x=approved, y=loan_amount_000s, fill=approved)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Approved",y="Loan Amount in 1000s",title="2017 HMDA Approvals by Loan Amount") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  ylim(c(0,800))

ggplot(hmda_reduced, aes(x=coapplicant)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Coapplicant?",y="Percent",title="2017 HMDA Approvals by Coapplicant",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=multirace)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Multiracial?",y="Percent",title="2017 HMDA Approvals by Multiracial",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=applicant_ethnicity)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Ethnicity",y="Percent",title="2017 HMDA Approvals by Applicant Ethnicity",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=agency_code)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Agency",y="Percent",title="2017 HMDA Approvals by Agency",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=property_type)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Property Type",y="Percent",title="2017 HMDA Approvals by Property Type",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 

ggplot(hmda_reduced, aes(x=loan_purpose)) +
  geom_bar(aes(fill=approved),position="fill") +
  theme_bw() +
  labs(x="Loan Purpose",y="Percent",title="2017 HMDA Approvals by Loan Purpose",fill="Approved?") +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) + 
  scale_fill_viridis_d() 


# tableau -----------------------------------------------------------------------

hmda_reduced$state_code <- str_pad(hmda_reduced$state_code, 2, pad = "0")
hmda_reduced$county_code <- str_pad(hmda_reduced$county_code, 3, pad = "0")

hmda_reduced$fips <- paste0(hmda_reduced$state_code,hmda_reduced$county_code)
hmda_reduced$fips <- as.factor(hmda_reduced$fips)

write.csv(hmda_reduced,"testcs.csv")
write_xlsx(hmda_reduced,"hmdaxls.xlsx")

str(hmda_reduced)
summary(hmda_reduced)

# Final plots -------------------------------------------------------------

ggplot(hmda_reduced, aes(x=applicant_race_1, y=applicant_income_000s, fill=applicant_race_1)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Applicant Race",y="Income in 1000s",title="2017 Race/Income Plot") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  scale_fill_viridis_d() +
  ylim(c(0,250))

ggplot(hmda_reduced, aes(x=applicant_sex, y=applicant_income_000s, fill=applicant_sex)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Applicant Sex",y="Income in 1000s",title="2017 Sex/Income Plot") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  scale_fill_viridis_d() +
  ylim(c(0,250))

ggplot(hmda_reduced, aes(x=applicant_ethnicity, y=applicant_income_000s, fill=applicant_ethnicity)) + 
  geom_violin()+
  geom_boxplot(width=0.1, fill="white") + 
  labs(x="Applicant Ethnicity",y="Income in 1000s",title="2017 Ethnicity/Income Plot") + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        legend.position = "none") + 
  scale_fill_viridis_d() +
  ylim(c(0,250))

# Modeling ----------------------------------------------------------------

hmda_ml <- subset(hmda_reduced, select=-c(denial_reason_1,denial_reason_2,denial_reason_3,
                                        rate_spread,msamd,census_tract_number))
str(hmda_ml)
summary(hmda_ml)

# Very long computational time, unfortunately remove features with large # of factors
# Also hoepa_status, which is almost always 2
hmda_ml <- subset(hmda_ml, select=-c(state_code,county_code,fips,hoepa_status))

set.seed(1)
hmda_ml <- hmda_ml[sample(.N,1000000)]
write.csv(hmda_ml,"testset1.csv")
hmda_ml <- fread("testset1.csv")
hmda_ml$V1 <- NULL

str(hmda_ml)
summary(hmda_ml)

md.pattern(hmda_ml,rotate.names = TRUE)
hmda_fill <- complete(mice(hmda_ml, maxit = 1))
write.csv(hmda_fill,"testset1_imp.csv")
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

set.seed(100)
knn_fit <- train(approved ~ .-action_taken-loan_amount_000s-purchaser_type
                 -co_applicant_race_1-co_applicant_ethnicity-co_applicant_sex, 
                 data=hmda_fill, method="knn",
                 metric=metric, trControl=control, na.action = na.omit)

set.seed(100)
glm_fit <- train(approved ~ agency_code+loan_type+property_type+loan_purpose
                 +applicant_ethnicity+applicant_race_1+applicant_sex+
                   applicant_income_000s+multirace+coapplicant, 
                 data=hmda_fill, method="bayesglm",
                 metric=metric, trControl=control, na.action = na.omit)

# set.seed(100)
# svm_fit <- train(approved ~ agency_code+loan_type+property_type+loan_purpose
#                  +applicant_ethnicity+applicant_race_1+applicant_sex+
#                    applicant_income_000s+multirace+coapplicant, 
#                  data=hmda_fill, method="svmRadial",
#                  metric=metric, trControl=control, na.action = na.omit)

set.seed(100)
rf_fit <- train(approved ~ agency_code+loan_type+property_type+loan_purpose
                 +applicant_ethnicity+applicant_race_1+applicant_sex+
                   applicant_income_000s+multirace+coapplicant, 
                 data=hmda_fill, method="rf",
                 metric=metric, trControl=trainControl(method="cv", number=5, verboseIter = TRUE),
                na.action = na.omit)

# -------------------------------------------------------------------------

results = resamples(list(log=log_fit, tree=tree_fit, knn=knn_fit, 
                         glm=glm_fit,  rf=rf_fit
                         ))
summary(results)

results = resamples(list(log=log_fit, tree=tree_fit ) )
summary(results)


# -------------------------------------------------------------------------



str(hmda_fill)

summary(data_all)

summary(data_all$co_applicant_race_1)
summary(hmda$coapplicant)

14195114/14285496
14284412/14285496

14285496-14284412

5948632/5986659

data_all2 <- data_all[which(data_all$action_taken == 7)]
summary(data_all2)









