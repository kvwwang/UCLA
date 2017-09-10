housing_data <- read.csv("C:/Users/Kevin/Desktop/Assignments/Graduate/EE239AS/P1/housing_data.csv", header=F)

library(plyr)
housing_data = rename(housing_data, c("V1"="crim","V2"="zn","V3"="indus","V4"="chas","V5"="nox","V6"="rm","V7"="age","V8"="dis","V9"="rad","V10"="tax","V11"="ptratio","V12"="b","V13"="lstat","V14"="medv"))


# 4-linear ----------------------------------------------------------------

fit_lm = lm(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat, data=housing_data)
summary(fit_lm)

tr_sz = floor(nrow(housing_data)*.9)
test_sz = nrow(housing_data)-tr_sz
set.seed(111) #change seed 10 times for different training sets

training = sample(seq_len(nrow(housing_data)),size=tr_sz)
train = housing_data[training,]
test = housing_data[-training,]

fit_tt = lm(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat, data=train)  
test_res = predict.lm(fit_tt,test)

plot(fit_tt)

plot(test$medv,main='Fitted vs. Actual',xlab='Sample',ylab='medv')
par(new=TRUE)
plot(test_res,col='blue', ann=FALSE, axes=FALSE)

set.seed(111)
RMSE = NULL
for (k in 1:10) {
  training = sample(seq_len(nrow(housing_data)),size=tr_sz)
  train = housing_data[training,]
  test = housing_data[-training,]
  
  fit_tt = lm(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat, data=train)  
  test_res = predict.lm(fit_tt,test)
  RMSE[k] = sqrt(sum((test$medv-test_res)^2)/test_sz)
}
RMSE_AVG = mean(RMSE)

# 4-poly fixed------------------------------------------------------------------
degree = 1 #adjust degree for polynomials
RMSE_FIX = NULL
max_deg = 10 #max degree without overflow error
set.seed(123)
training = sample(seq_len(nrow(housing_data)),size=tr_sz)
train = housing_data[training,]
test = housing_data[-training,]

for (degree in 1:max_deg) {
  CRIM = train$crim
  ZN = train$zn
  INDUS = train$indus
  CHAS = train$chas
  NOX = train$nox
  RM = train$rm
  AGE = train$age
  DIS = train$dis
  RAD = train$rad
  TAX = train$tax
  PTRATIO = train$ptratio
  B = train$b
  LSTAT = train$lstat
  MEDV = train$medv
  
  fit_poly = lm(MEDV ~ poly(CRIM,degree,raw=TRUE)+poly(ZN,degree,raw=TRUE)+poly(INDUS,degree,raw=TRUE)+poly(CHAS,degree,raw=TRUE)+poly(NOX,degree,raw=TRUE)+poly(RM,degree,raw=TRUE)+poly(AGE,degree,raw=TRUE)+poly(DIS,degree,raw=TRUE)+poly(RAD,degree,raw=TRUE)+poly(TAX,degree,raw=TRUE)+poly(PTRATIO,degree,raw=TRUE)+poly(B,degree,raw=TRUE)+poly(LSTAT,degree,raw=TRUE))  
  CRIM = test$crim
  ZN = test$zn
  INDUS = test$indus
  CHAS = test$chas
  NOX = test$nox
  RM = test$rm
  AGE = test$age
  DIS = test$dis
  RAD = test$rad
  TAX = test$tax
  PTRATIO = test$ptratio
  B = test$b
  LSTAT = test$lstat
  MEDV = test$medv
  
  test_res = predict.lm(fit_poly,test)
  RMSE_FIX[degree] = sqrt(sum((test$medv-test_res)^2)/test_sz)
}
plot(RMSE_FIX,xlab='degree',ylab='RMSE',main='RMSE for Fixed Sets')

# 4-poly CV -------------------------------------------------------------
set.seed(1111) #change seed 10 times for different training sets

degree = 1 #adjust degree for polynomials
RMSE_CV = NULL
RMSE_TEMP = NULL
max_deg = 8 #max degree without overflow error
l = 1

for (degree in 1:max_deg) {
  for (l in 1:10) {
    training = sample(seq_len(nrow(housing_data)),size=tr_sz)
    train = housing_data[training,]
    test = housing_data[-training,]
    
    CRIM = train$crim
    ZN = train$zn
    INDUS = train$indus
    CHAS = train$chas
    NOX = train$nox
    RM = train$rm
    AGE = train$age
    DIS = train$dis
    RAD = train$rad
    TAX = train$tax
    PTRATIO = train$ptratio
    B = train$b
    LSTAT = train$lstat
    MEDV = train$medv
    
    fit_poly = lm(MEDV ~ poly(CRIM,degree,raw=TRUE)+poly(ZN,degree,raw=TRUE)+poly(INDUS,degree,raw=TRUE)+poly(CHAS,degree,raw=TRUE)+poly(NOX,degree,raw=TRUE)+poly(RM,degree,raw=TRUE)+poly(AGE,degree,raw=TRUE)+poly(DIS,degree,raw=TRUE)+poly(RAD,degree,raw=TRUE)+poly(TAX,degree,raw=TRUE)+poly(PTRATIO,degree,raw=TRUE)+poly(B,degree,raw=TRUE)+poly(LSTAT,degree,raw=TRUE))  
    CRIM = test$crim
    ZN = test$zn
    INDUS = test$indus
    CHAS = test$chas
    NOX = test$nox
    RM = test$rm
    AGE = test$age
    DIS = test$dis
    RAD = test$rad
    TAX = test$tax
    PTRATIO = test$ptratio
    B = test$b
    LSTAT = test$lstat
    MEDV = test$medv
    
    test_res = predict.lm(fit_poly,test)
    RMSE_TEMP[l] = sqrt(sum((test$medv-test_res)^2)/test_sz)
  }
  RMSE_CV[degree] = mean(RMSE_TEMP)
  RMSE_TEMP=NULL
}
plot(RMSE_CV,xlab='degree',ylab='RMSE',main='RMSE for 10-Fold Cross Validation')


# 5 - ridge / lasso---------------------------------------------------------------
library(glmnet)

tr_sz = floor(nrow(housing_data)*.9)
test_sz = nrow(housing_data)-tr_sz
#Ridge
set.seed(111) #change seed 10 times for different training sets
RMSE_TEMP = NULL
l = 1

for (l in 1:10) {
  training = sample(seq_len(nrow(housing_data)),size=tr_sz)
  train = housing_data[training,]
  test = housing_data[-training,]
  
  CRIM = train$crim
  ZN = train$zn
  INDUS = train$indus
  CHAS = train$chas
  NOX = train$nox
  RM = train$rm
  AGE = train$age
  DIS = train$dis
  RAD = train$rad
  TAX = train$tax
  PTRATIO = train$ptratio
  B = train$b
  LSTAT = train$lstat
  MEDV = train$medv
  
  x = cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PTRATIO,B,LSTAT)
  
  fit_r = glmnet(x,MEDV,family="mgaussian",alpha=0,lambda=c(0.1,0.01,0.001))  #change alpha to switch between lasso/ridge
  
  CRIM = test$crim
  ZN = test$zn
  INDUS = test$indus
  CHAS = test$chas
  NOX = test$nox
  RM = test$rm
  AGE = test$age
  DIS = test$dis
  RAD = test$rad
  TAX = test$tax
  PTRATIO = test$ptratio
  B = test$b
  LSTAT = test$lstat
  MEDV = test$medv
  x = cbind(CRIM,ZN,INDUS,CHAS,NOX,RM,AGE,DIS,RAD,TAX,PTRATIO,B,LSTAT)
  
  test_res = predict.glmnet(fit_r,x)
  RMSE_TEMP[l] = sqrt(sum((test$medv-test_res)^2)/test_sz)
}
RMSE = mean(RMSE_TEMP)
