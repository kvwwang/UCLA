# Project 3
# UCLA Extension Data Science Intensive
# Kevin Wang

# Initialization ---------------------------------------------------------
library(Hmisc)
library(dplyr)
library(mice)

setwd("E:/Extension/DSI/P3")

# Part A ------------------------------------------------------------------

uciwd ="https://archive.ics.uci.edu/ml/machine-learning-databases/"
mldata = paste(uciwd,"breast-cancer-wisconsin/breast-cancer-wisconsin.data", sep="")
bcancer = read.csv(mldata, header=F) 
colnames(bcancer)=c("ID","clump_thick","cell_size","cell_shape", "marginal","epithelial","nuclei",
                    "chromatin","nucleoli","mitoses","class")

# Handle ?'s
bcancer$nuclei <- as.numeric(bcancer$nuclei)
subset(bcancer,is.na(bcancer$nuclei))

# Set class as 0/1
bcancer$class <- bcancer$class %>% {gsub(2,0,.)} %>% {gsub(4,1,.)} %>% as.numeric()

# Try different imputation methods
mice1 <- complete(mice(bcancer))
bcancer$imp_med <- impute(bcancer$nuclei, median)

bcfit1 <- glm(class ~ . -nuclei-ID, data = bcancer, family = "binomial")
summary(bcfit1)

# Significant factors: imp_med (imputed nuclei), chromatin, marginal, 
# clump_thick, nucleoli (slightly)
# AIC: 122.89

bcfit2 <- glm(class ~ . -ID, data = mice1, family = "binomial")
summary(bcfit2)

# Significant factors: nuclei, chromatin, marginal, 
# clump_thick, mitoses (slightly)
# AIC: 122.89 (changes per iteration)

# Part B ------------------------------------------------------------------

# Change nonemployer_us.R to only examine ride-sharing data
# NAICS = 4853

setwd("E:/Extension/DSI/P3/gig economy project")
library(readxl) 
library(dplyr)
library(tidyr)

datalist = list.files(pattern = "*us.txt")
for (i in 1:length(datalist)) { 
  data = read.csv(datalist[i]) 
  assign(paste0("nemp", i+15), data)
}

censuswd ="https://www2.census.gov/programs-surveys/nonemployer-statistics/datasets/"

nonemp15 = paste(censuswd,"2015/historical-datasets/nonemp15us.txt", sep="")
nemp15 = read.csv(nonemp15)   
nonemp14 = paste(censuswd,"2014/historical-datasets/nonemp14us.txt", sep="")
nemp14 = read.csv(nonemp14)  
nonemp13 = paste(censuswd,"2013/historical-datasets/nonemp13us.txt", sep="")
nemp13 = read.csv(nonemp13)   
nonemp12 = paste(censuswd,"2012/historical-datasets/nonemp12us.txt", sep="")
nemp12 = read.csv(nonemp12)  
nonemp11 = paste(censuswd,"2011/historical-datasets/nonemp11us.txt", sep="")
nemp11 = read.csv(nonemp11)   
nonemp10 = paste(censuswd,"2010/historical-datasets/nonemp10us.txt", sep="")
nemp10 = read.csv(nonemp10)  
nonemp9 = paste(censuswd,"2009/historical-datasets/nonemp09us.txt", sep="")
nemp9 = read.csv(nonemp9)   
nonemp8 = paste(censuswd,"2008/historical-datasets/nonemp08us.txt", sep="")
nemp8 = read.csv(nonemp8) 
nonemp7 = paste(censuswd,"2007/historical-datasets/nonemp07us.txt", sep="")
nemp7 = read.csv(nonemp7)   
nonemp6 = paste(censuswd,"2006/historical-datasets/nonemp06us.txt", sep="")
nemp6 = read.csv(nonemp6)  
nonemp5 = paste(censuswd,"2005/historical-datasets/nonemp05us.txt", sep="")
nemp5 = read.csv(nonemp5)   

la18 = subset(nemp18, ST==0 & LFO == "-" & RCPTOT_SIZE ==1, select=c(NAICS, ESTAB, RCPTOT))
la18$income = 1000*la18$RCPTOT/la18$ESTAB
la18$NAICS = as.character(la18$NAICS)
la18.d2 = la18 %>% subset(NAICS == 4853) %>% rename(est18=ESTAB) %>% rename(income18=income) %>% mutate(RCPTOT=NULL)

la17 = subset(nemp17, ST==0 & LFO == "-" & RCPTOT_SIZE ==1, select=c(NAICS, ESTAB, RCPTOT))
la17$income = 1000*la17$RCPTOT/la17$ESTAB
la17$NAICS = as.character(la17$NAICS)
la17.d2 = la17 %>% subset(NAICS == 4853) %>% rename(est17=ESTAB) %>% rename(income17=income) %>% mutate(RCPTOT=NULL)

la16 = subset(nemp16, ST==0 & LFO == "-" & RCPTOT_SIZE ==1, select=c(NAICS, ESTAB, RCPTOT))
la16$income = 1000*la16$RCPTOT/la16$ESTAB
la16$NAICS = as.character(la16$NAICS)
la16.d2 = la16 %>% subset(NAICS == 4853) %>% rename(est16=ESTAB) %>% rename(income16=income) %>% mutate(RCPTOT=NULL)

la15 = subset(nemp15, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la15$income = 1000*la15$rcptot/la15$estab
la15$naics = as.character(la15$naics)
la15.d2 = la15 %>% subset(naics==4853) %>% rename(est15=estab) %>% rename(income15=income) %>% mutate(rcptot=NULL)

la14 = subset(nemp14, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la14$income = 1000*la14$rcptot/la14$estab
la14$naics = as.character(la14$naics)
la14.d2 = la14 %>% subset(naics==4853) %>% rename(est14=estab) %>% rename(income14=income) %>% mutate(rcptot=NULL)

la13 = subset(nemp13, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la13$income = 1000*la13$rcptot/la13$estab
la13$naics = as.character(la13$naics)
la13.d2 = la13 %>% subset(naics==4853) %>% rename(est13=estab) %>% rename(income13=income) %>% mutate(rcptot=NULL)

la12 = subset(nemp12, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la12$income = 1000*la12$rcptot/la12$estab
la12$naics = as.character(la12$naics)
la12.d2 = la12 %>% subset(naics==4853) %>% rename(est12=estab) %>% rename(income12=income) %>% mutate(rcptot=NULL)

la11 = subset(nemp11, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la11$income = 1000*la11$rcptot/la11$estab
la11$naics = as.character(la11$naics)
la11.d2 = la11 %>% subset(naics==4853) %>% rename(est11=estab) %>% rename(income11=income) %>% mutate(rcptot=NULL)

la10 = subset(nemp10, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la10$income = 1000*la10$rcptot/la10$estab
la10$naics = as.character(la10$naics)
la10.d2 = la10 %>% subset(naics==4853) %>% rename(est10=estab) %>% rename(income10=income) %>% mutate(rcptot=NULL)

la9 = subset(nemp9, st==0 & lfo == "-" & rcptot_size ==1, select=c(naics, estab, rcptot))
la9$income = 1000*la9$rcptot/la9$estab
la9$naics = as.character(la9$naics)
la9.d2 = la9 %>% subset(naics==4853) %>% rename(est9=estab) %>% rename(income9=income) %>% mutate(rcptot=NULL)

la8 = subset(nemp8, st==0 & lfo == "-", select=c(naics, estab, rcptot))
la8$income = 1000*la8$rcptot/la8$estab
la8$naics = as.character(la8$naics)
la8.d2 = la8 %>% subset(naics==4853) %>% rename(est8=estab) %>% rename(income8=income) %>% mutate(rcptot=NULL)

la7 = subset(nemp7, ST==0, select=c(NAICS, ESTAB, RCPTOT))
la7$income = 1000*la7$RCPTOT/la7$ESTAB
la7$NAICS = as.character(la7$NAICS)
la7.d2 = la7 %>% subset(NAICS==4853) %>% rename(est7=ESTAB) %>% rename(income7=income) %>% mutate(RCPTOT=NULL)

la6 = subset(nemp6, ST==0, select=c(NAICS, ESTAB, RCPTOT))
la6$income = 1000*la6$RCPTOT/la6$ESTAB
la6$NAICS = as.character(la6$NAICS)
la6.d2 = la6 %>% subset(NAICS==4853) %>% rename(est6=ESTAB) %>% rename(income6=income) %>% mutate(RCPTOT=NULL)

la5 = subset(nemp5, ST==0, select=c(NAICS, ESTAB, RCPTOT))
la5$income = 1000*la5$RCPTOT/la5$ESTAB
la5$NAICS = as.character(la5$NAICS)
la5.d2 = la5 %>% subset(NAICS==4853) %>% rename(est5=ESTAB) %>% rename(income5=income) %>% mutate(RCPTOT=NULL)

la8.d2 = la8.d2 %>% rename(NAICS=naics)
la9.d2 = la9.d2 %>% rename(NAICS=naics)
la10.d2 = la10.d2 %>% rename(NAICS=naics)
la11.d2 = la11.d2 %>% rename(NAICS=naics)
la12.d2 = la12.d2 %>% rename(NAICS=naics)
la13.d2 = la13.d2 %>% rename(NAICS=naics)
la14.d2 = la14.d2 %>% rename(NAICS=naics)
la15.d2 = la15.d2 %>% rename(NAICS=naics)

rsw = left_join(la5.d2, la6.d2, by="NAICS") %>% left_join(la7.d2,by="NAICS", keep=F) %>% left_join(la8.d2,by="NAICS", keep=F) %>% 
  left_join(la9.d2,by="NAICS", keep=F) %>%  left_join(la10.d2,by="NAICS", keep=F) %>% left_join(la11.d2,by="NAICS", keep=F) %>% left_join(la12.d2,by="NAICS", keep=F) %>% 
  left_join(la13.d2,by="NAICS", keep=F) %>% left_join(la14.d2,by="NAICS", keep=F) %>% left_join(la15.d2,by="NAICS", keep=F) %>% left_join(la16.d2,by="NAICS", keep=F) %>% 
  left_join(la17.d2,by="NAICS", keep=F) %>% left_join(la18.d2,by="NAICS", keep=F)

rsw = rsw[c("NAICS","est5","est6","est7","est8","est9","est10","est11","est12","est13","est14","est15","est16","est17","est18",
                    "income5","income6","income7","income8","income9","income10","income11","income12","income13","income14","income15","income16","income17","income18")]


setwd("E:/Extension/DSI/P3/gig economy project")
write.csv(rsw,"rsw.csv") 


# Part B using loops ------------------------------------------------------
# For practice, change Part B code to using loops

setwd("E:/Extension/DSI/P3/gig economy project")
library(readxl) 
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)

datalist = list.files(pattern = "*us.txt")

censuswd ="https://www2.census.gov/programs-surveys/nonemployer-statistics/datasets/20"

for (j in 5:15){
  datalist[j-4] <- paste0(censuswd,str_pad(j, width=2, side="left", pad="0"),
                          "/historical-datasets/nonemp",str_pad(j, width=2, side="left", pad="0"),"us.txt", sep="")
}

datalist <- c(datalist,list.files(pattern = "*us.txt"))

df_list <- lapply(datalist, fread)

ladf_final <- data.frame(NAICS = 4853)

for (j in 1:length(df_list)) {
  colnames(df_list[[j]]) <- toupper(colnames(df_list[[j]]))
  
  if ("LFO" %in% colnames(df_list[[j]])) {
    if("RCPTOT_SIZE" %in% colnames(df_list[[j]])) {
      tempdf <- subset(df_list[[j]], ST==0 & LFO == "-" & RCPTOT_SIZE ==1, select=c(NAICS, ESTAB, RCPTOT))
    }
    else {
      tempdf <- subset(df_list[[j]], ST==0 & LFO == "-", select=c(NAICS, ESTAB, RCPTOT))
    }
  }
  else {
    tempdf <- subset(df_list[[j]], ST==0, select=c(NAICS, ESTAB, RCPTOT))
  }
  tempdf$income <- 1000*tempdf$RCPTOT/tempdf$ESTAB
  tempdf$NAICS <- as.character(tempdf$NAICS)
  tempdf <- subset(tempdf, NAICS == 4853) %>% mutate(RCPTOT=NULL)
  
  # ladf_final[, paste0("est", str_pad(j+4, width=2, side="left", pad="0"))] <- tempdf$ESTAB
  # ladf_final[, paste0("income", str_pad(j+4, width=2, side="left", pad="0"))] <- tempdf$income
  ladf_final[, paste0("est", j+4)] <- tempdf$ESTAB
  ladf_final[, paste0("income", j+4)] <- tempdf$income
  
}

ladf_final <- ladf_final[c("NAICS","est5","est6","est7","est8","est9","est10","est11","est12","est13","est14","est15","est16","est17","est18",
                           "income5","income6","income7","income8","income9","income10","income11","income12","income13","income14","income15","income16","income17","income18")]

# ladf_final <- ladf_final[ ,order(colnames(ladf_final))]
# ladf_final <- relocate(ladf_final,NAICS)

setwd("E:/Extension/DSI/P3/gig economy project")
write.csv(ladf_final,"loop_rsw.csv") 


# Part C ------------------------------------------------------------------
setwd("E:/Extension/DSI/P3")
source("D03c_zillow.R", echo = TRUE)

good_feature <- filter(missing_values,missing_pct<0.25)
gfeature = as.vector(good_feature[,1])
zdata = cor_tmp %>% select(logerror, gfeature)
zdata3 = cor_tmp %>% select(abs_logerror, gfeature)

# rem_var <- c("id_parcel","fips","latitude","longitude","zoning_landuse_county",
#              "zoning_property","rawcensustractandblock","region_city","region_zip",
#              "censustractandblock","tax_year","tax_building","tax_land")

zdata_le <- subset(zdata, select=-c(id_parcel,fips,latitude,longitude,zoning_landuse_county,
                                    zoning_property,rawcensustractandblock,region_city,region_zip,
                                    censustractandblock,tax_year,tax_building,tax_land))

corrplot(cor(zdata_le, use="complete.obs"),type="lower")

# highly correlated groups: 
# num_bathroom_calc, num_bath, num_bathroom
# area_live_finished, area_total_calc
# tax_total, tax_property

zdata_le1 <- subset(zdata_le, select=-c(num_bathroom_calc,num_bath,
                                        area_live_finished,tax_total))
str(zdata_le1)
corrplot(cor(zdata_le1, use="complete.obs"),type="lower")

zdata_le1$zoning_landuse <- as.factor(zdata_le1$zoning_landuse)
zdata_le1$region_county <- as.factor(zdata_le1$region_county)

zdata_le1$abs_logerror <- zdata3$abs_logerror

fit_le1 <- lm(logerror~.-abs_logerror, data=zdata_le1)
summary(fit_le1)   # adj R2: 0.004811 

# Use regsubsets to find best model

library(leaps)

rs_le <- regsubsets(logerror~.-abs_logerror, data=zdata_le1)
sum_rs1 <- summary(rs_le)
which.max(sum_rs1$adjr2)  # 8
which.min(sum_rs1$cp)     # 8
which.min(sum_rs1$bic)    # 8

coef(rs_le,8)

fit_le2 <- lm(logerror ~ area_total_calc 
              + I(zoning_landuse == 47) 
              + I(zoning_landuse == 247)
              + I(zoning_landuse == 248)
              + I(zoning_landuse == 263)
              + I(zoning_landuse == 266)
              + tax_property
              + tax_delinquency
              , data=zdata_le1)
summary(fit_le2)  # adj R2: 0.004607

# absolute log error

fit_ale1 <- lm(abs_logerror~.-logerror, data=zdata_le1)
summary(fit_ale1)   # adj R2: 0.02622  

rs_ale <- regsubsets(abs_logerror~.-logerror, data=zdata_le1)
sum_rs2 <- summary(rs_ale)
which.max(sum_rs2$adjr2)  # 8
which.min(sum_rs2$cp)     # 8
which.min(sum_rs2$bic)    # 8

coef(rs_ale,8)

fit_ale2 <- lm(abs_logerror ~ build_year
               + area_total_calc 
               + num_bedroom
               + I(zoning_landuse == 47)
               + I(zoning_landuse == 261)
               + I(zoning_landuse == 266)
               + I(zoning_landuse == 269)
               + tax_delinquency
               , data=zdata_le1)
summary(fit_ale2)     # adj R2: 0.02437 

# For both log error and absolute log error, several zoning_landuse categories were significant,
# as well as tax_delinquency, tax_property, area_total_calc.
# Running against all factors, the linear model for abs_logerror showed almost all factors
# as significant compared to logerror; it is probably better to model using abs_logerror,
# maybe because trying to account for the direction of logerror made it harder to build a model with significant factors
# Using regsubsets with various model scoring methods all chose 8 factors, and the resulting
# models only contained significant factors, even if adj. R2 was not improved much, if at all.








