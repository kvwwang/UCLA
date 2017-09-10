# read in data
data <- read.csv("C:/Users/Kevin/Desktop/Assignments/Graduate/EE239AS/P1/network_backup_dataset.csv")
data2 <- read.csv("C:/Users/Kevin/Desktop/Assignments/Graduate/EE239AS/P1/network_backup_dataset.csv")
data3 <- read.csv("C:/Users/Kevin/Desktop/Assignments/Graduate/EE239AS/P1/network_backup_dataset.csv")

# Part 1 ------------------------------------------------------------------
day = NULL
day.counter = 1
for (k in 1:18588) {
  if (k > 1) {
    if (data[k,]$Day.of.Week != data[k-1,]$Day.of.Week)
      day.counter = day.counter+1
  }
  day[k] = day.counter
  
}

data$day <- day 

d20 = data[which(data$day <= 20),]

d20_wf0 = d20[which(d20$Work.Flow.ID == 'work_flow_0'),]
d20_wf1 = d20[which(d20$Work.Flow.ID == 'work_flow_1'),]
d20_wf2 = d20[which(d20$Work.Flow.ID == 'work_flow_2'),]
d20_wf3 = d20[which(d20$Work.Flow.ID == 'work_flow_3'),]
d20_wf4 = d20[which(d20$Work.Flow.ID == 'work_flow_4'),]

# size0 = d20$Size.of.Backup..GB.[which(d20$Work.Flow.ID == 'work_flow_0')]
# size1 = d20$Size.of.Backup..GB.[which(d20$Work.Flow.ID == 'work_flow_1')]
# size2 = d20$Size.of.Backup..GB.[which(d20$Work.Flow.ID == 'work_flow_2')]
# size3 = d20$Size.of.Backup..GB.[which(d20$Work.Flow.ID == 'work_flow_3')]
# size4 = d20$Size.of.Backup..GB.[which(d20$Work.Flow.ID == 'work_flow_4')]

plot(d20_wf0$day,d20_wf0$Size.of.Backup..GB.,main='Work Flow 0',xlab='Day',ylab='Size of Backup (GB)')
plot(d20_wf1$day,d20_wf1$Size.of.Backup..GB.,main='Work Flow 1',xlab='Day',ylab='Size of Backup (GB)')
plot(d20_wf2$day,d20_wf2$Size.of.Backup..GB.,main='Work Flow 2',xlab='Day',ylab='Size of Backup (GB)')
plot(d20_wf3$day,d20_wf3$Size.of.Backup..GB.,main='Work Flow 3',xlab='Day',ylab='Size of Backup (GB)')
plot(d20_wf4$day,d20_wf4$Size.of.Backup..GB.,main='Work Flow 4',xlab='Day',ylab='Size of Backup (GB)')


# Part 2a ------------------------------------------------------------------
fit1 = lm(data$Size.of.Backup..GB~data$Week.+data$Day.of.Week+data$Backup.Start.Time...Hour.of.Day+data$Work.Flow.ID+data$File.Name+data$Backup.Time..hour.)
summary(fit1)

tr_sz = 16729
set.seed(111) #change seed 10 times for different training sets
training = sample(seq_len(nrow(data)),size=tr_sz)
train = data[training,]
test = data[-training,]

# fit_tt = lm(train$Size.of.Backup..GB~train$Week.+train$Day.of.Week+train$Backup.Start.Time...Hour.of.Day+train$Work.Flow.ID+train$File.Name+train$Backup.Time..hour.)
fit_tt = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=train)
summary(fit_tt)

test_res = predict.lm(fit_tt,test)

plot(fit_tt)

plot(test$day,test$Size.of.Backup..GB.,main='Fitted vs. Actual',xlab='Day',ylab='Size of Backup (GB)')
par(new=TRUE)
plot(test$day,test_res,col='blue', ann=FALSE, axes=FALSE)

RMSE = sqrt(sum((test$Size.of.Backup..GB.-test_res)^2)/1859)


# Part 2b -----------------------------------------------------------------
library(randomForest)

rf1 = randomForest(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=data2,type='regression',ntree=20,mtry=6)
print(rf1)

set.seed(111) #change seed 10 times for different training sets
training_2b = sample(seq_len(nrow(data2)),size=tr_sz)
train_2b = data2[training_2b,]
test_2b = data2[-training_2b,]
rf1_tt = randomForest(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=train_2b,type='regression',ntree=20,mtry=6)
print(rf1_tt)
test_rf = predict(rf1_tt,test_2b,type='response')
RMSE2 = sqrt(sum((test_2b$Size.of.Backup..GB.-test_rf)^2)/1859)


rf2 = randomForest(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=data2,type='regression',ntree=20,mtry=3)
print(rf2)

set.seed(111) #change seed 10 times for different training sets
training = sample(seq_len(nrow(data)),size=tr_sz)
train = data[training,]
test = data[-training,]
rf2_tt = randomForest(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=train,type='regression',ntree=20,mtry=6)
test_rf2 = predict(rf2_tt,test,type='response')

plot(test$day,test_rf,main='Fitted Output of Test',xlab='Day',ylab='Size of Backup (GB)')


# Part 2c -----------------------------------------------------------------
library(neuralnet)

#set up training set
tr_sz = 16729
set.seed(111) #change seed 10 times for different training sets
training = sample(seq_len(nrow(data)),size=tr_sz)
train = data[training,]
test = data[-training,]
dm = model.matrix(~Size.of.Backup..GB. + Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=train)

nn1 = neuralnet(Size.of.Backup..GB. ~ Week..+ Day.of.WeekMonday + Day.of.WeekTuesday + Day.of.WeekWednesday + Day.of.WeekThursday + Day.of.WeekSaturday + Day.of.WeekSunday + Backup.Start.Time...Hour.of.Day +Work.Flow.IDwork_flow_1+Work.Flow.IDwork_flow_2+Work.Flow.IDwork_flow_3+Work.Flow.IDwork_flow_4 +File.NameFile_1 +File.NameFile_2 +File.NameFile_3 +File.NameFile_4 +File.NameFile_5 +File.NameFile_6 +File.NameFile_7 +File.NameFile_8 +File.NameFile_9 +File.NameFile_10 +File.NameFile_11 +File.NameFile_12 +File.NameFile_13 +File.NameFile_14 +File.NameFile_15 +File.NameFile_16 +File.NameFile_17 +File.NameFile_18 +File.NameFile_19 +File.NameFile_20 +File.NameFile_21 +File.NameFile_22 +File.NameFile_23 +File.NameFile_24 +File.NameFile_25 +File.NameFile_26 +File.NameFile_27 +File.NameFile_28 +File.NameFile_29+Backup.Time..hour.,data=dm)
print(nn1)
plot(nn1)
#dt = model.matrix(~Size.of.Backup..GB. + Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+Work.Flow.ID+File.Name+Backup.Time..hour.,data=test)
#test_nn = compute(nn1,dt)


# Part 3-1 ------------------------------------------------------------------
d_wf0 = d20[which(data$Work.Flow.ID == 'work_flow_0'),]
d_wf1 = d20[which(data$Work.Flow.ID == 'work_flow_1'),]
d_wf2 = d20[which(data$Work.Flow.ID == 'work_flow_2'),]
d_wf3 = d20[which(data$Work.Flow.ID == 'work_flow_3'),]
d_wf4 = d20[which(data$Work.Flow.ID == 'work_flow_4'),]

tr_sz_0 = floor(nrow(d_wf0)*.9)
tr_sz_1 = floor(nrow(d_wf1)*.9)
tr_sz_2 = floor(nrow(d_wf2)*.9)
tr_sz_3 = floor(nrow(d_wf3)*.9)
tr_sz_4 = floor(nrow(d_wf4)*.9)
set.seed(111) #change seed 10 times for different training sets
training0 = sample(seq_len(nrow(data)),size=tr_sz_0)
training1 = sample(seq_len(nrow(data)),size=tr_sz_1)
training2 = sample(seq_len(nrow(data)),size=tr_sz_2)
training3 = sample(seq_len(nrow(data)),size=tr_sz_3)
training4 = sample(seq_len(nrow(data)),size=tr_sz_4)

train0 = data[training0,]
train1 = data[training1,]
train2 = data[training2,]
train3 = data[training3,]
train4 = data[training4,]
test0 = data[-training0,]
test1 = data[-training1,]
test2 = data[-training2,]
test3 = data[-training3,]
test4 = data[-training4,]

fit_wf0 = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+File.Name+Backup.Time..hour.,data=train0)
fit_wf1 = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+File.Name+Backup.Time..hour.,data=train1)
fit_wf2 = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+File.Name+Backup.Time..hour.,data=train2)
fit_wf3 = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+File.Name+Backup.Time..hour.,data=train3)
fit_wf4 = lm(Size.of.Backup..GB. ~ Week..+Day.of.Week+Backup.Start.Time...Hour.of.Day+File.Name+Backup.Time..hour.,data=train4)

summary(fit_wf0)
summary(fit_wf1)
summary(fit_wf2)
summary(fit_wf3)
summary(fit_wf4)

test_res0 = predict.lm(fit_wf0,test0)
test_res1 = predict.lm(fit_wf1,test1)
test_res2 = predict.lm(fit_wf2,test2)
test_res3 = predict.lm(fit_wf3,test3)
test_res4 = predict.lm(fit_wf4,test4)

RMSE0 = sqrt(sum((test0$Size.of.Backup..GB.-test_res0)^2)/nrow(test0))
RMSE1 = sqrt(sum((test1$Size.of.Backup..GB.-test_res1)^2)/nrow(test1))
RMSE2 = sqrt(sum((test2$Size.of.Backup..GB.-test_res2)^2)/nrow(test2))
RMSE3 = sqrt(sum((test3$Size.of.Backup..GB.-test_res3)^2)/nrow(test3))
RMSE4 = sqrt(sum((test4$Size.of.Backup..GB.-test_res4)^2)/nrow(test4))


# Part 3-2 fixed----------------------------------------------------------------
tr_sz = 16729
set.seed(1111) #change seed 10 times for different training sets
training = sample(seq_len(nrow(data)),size=tr_sz)
train = data[training,]
test = data[-training,]

degree = 1 #adjust degree for polynomials
RMSE_FIX = NULL
max_deg = 80 #max degree without overflow error

for (degree in 1:max_deg) {
  SoB = train$Size.of.Backup..GB.
  Week = train$Week..
  DoW = as.numeric(train$Day.of.Week)
  BST = train$Backup.Start.Time...Hour.of.Day
  WF = as.numeric(train$Work.Flow.ID)
  FN = as.numeric(train$File.Name)
  BTH = train$Backup.Time..hour.
  fit_poly = lm(SoB ~ poly(Week,degree,raw=TRUE)+poly(DoW,degree,raw=TRUE)+poly(BST,degree,raw=TRUE)+poly(WF,degree,raw=TRUE)+poly(FN,degree,raw=TRUE)+poly(BTH,degree,raw=TRUE))
  
  SoB = test$Size.of.Backup..GB.
  Week = test$Week..
  DoW = as.numeric(test$Day.of.Week)
  BST = test$Backup.Start.Time...Hour.of.Day
  WF = as.numeric(test$Work.Flow.ID)
  FN = as.numeric(test$File.Name)
  BTH = test$Backup.Time..hour.
  test_res = predict.lm(fit_poly,test)
  RMSE_FIX[degree] = sqrt(sum((test$Size.of.Backup..GB.-test_res)^2)/1859)
}
plot(RMSE_FIX,xlab='degree',ylab='RMSE',main='RMSE for Fixed Sets')


# Part 3-2 CV -------------------------------------------------------------
tr_sz = 16729
set.seed(1111) #change seed 10 times for different training sets

degree = 1 #adjust degree for polynomials
RMSE_CV = NULL
RMSE_TEMP = NULL
max_deg = 20 #max degree without overflow error
l = 1

for (degree in 1:max_deg) {
  for (l in 1:10) {
    training = sample(seq_len(nrow(data)),size=tr_sz)
    train = data[training,]
    test = data[-training,]
    SoB = train$Size.of.Backup..GB.
    Week = train$Week..
    DoW = as.numeric(train$Day.of.Week)
    BST = train$Backup.Start.Time...Hour.of.Day
    WF = as.numeric(train$Work.Flow.ID)
    FN = as.numeric(train$File.Name)
    BTH = train$Backup.Time..hour.
    fit_poly = lm(SoB ~ poly(Week,degree,raw=TRUE)+poly(DoW,degree,raw=TRUE)+poly(BST,degree,raw=TRUE)+poly(WF,degree,raw=TRUE)+poly(FN,degree,raw=TRUE)+poly(BTH,degree,raw=TRUE))
    
    SoB = test$Size.of.Backup..GB.
    Week = test$Week..
    DoW = as.numeric(test$Day.of.Week)
    BST = test$Backup.Start.Time...Hour.of.Day
    WF = as.numeric(test$Work.Flow.ID)
    FN = as.numeric(test$File.Name)
    BTH = test$Backup.Time..hour.
    test_res = predict.lm(fit_poly,test)
    RMSE_TEMP[l] = sqrt(sum((test$Size.of.Backup..GB.-test_res)^2)/1859)
  }
  RMSE_CV[degree] = mean(RMSE_TEMP)
  RMSE_TEMP=NULL
}
plot(RMSE_CV,xlab='degree',ylab='RMSE',main='RMSE for 10-Fold Cross Validation')



