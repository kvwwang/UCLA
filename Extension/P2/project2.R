# Project 2
# UCLA Extension Data Science Intensive
# Kevin Wang

# Part A ------------------------------------------------------------------

library(data.table)
library(stringr)
library(dplyr)
library(readxl)
library(writexl)
setwd("E:/Extension/DSI/P2")
file_list <- list.files("ACS_DP02 data", pattern = "with_ann")

# Specify which columns/variables to keep

vars_id <- c(2,3,232,238,242,246,250,254,258,262)
vars_names <- c("fips5","county","adultpop","L9pop","f912pop","HSpop", "somecolpop",
                "assopop","bachpop","gradpop")

# Read data files
setwd("E:/Extension/DSI/P2/ACS_DP02 data")
df_list <- lapply(file_list, fread, skip=1, select=vars_id, 
                  colClasses = list(character=1:2), col.names = vars_names)

# Make desired output file
df_final = data.frame(df_list[[1]]$fips5, df_list[[1]]$county)
colnames(df_final) <- c("fips5","county")

for (j in 1:length(df_list)) {
  tempdf <- data.frame(df_list[[j]]$fips5, df_list[[j]]$county, df_list[[j]]$adultpop)
  colnames(tempdf) <- c("fips5","county", paste0("pop", str_pad(j+8, width=2, side="left", pad="0")))
  
  tempdf[, paste0("chci", str_pad(j+8, width=2, side="left", pad="0"))] <- 
    (50*df_list[[j]]$L9pop +
    100*df_list[[j]]$f912pop +
    120*df_list[[j]]$HSpop +
    130*df_list[[j]]$somecolpop +
    140*df_list[[j]]$assopop +
    190*df_list[[j]]$bachpop +
    230*df_list[[j]]$gradpop) / 100
  
  df_final <- right_join(df_final,tempdf, by=c("fips5","county"))
}

df_final$id <- as.numeric(df_final$fips5)

# Reorder columns
df_final <- df_final[ ,order(colnames(df_final))]
df_final <- relocate(df_final,id,fips5,county)

# Add new columns
df_final$chcig <- df_final$chci17 - df_final$chci09
df_final <- mutate(df_final, chcigr = chcig / chci09)
df_final$popg <- df_final$pop17 - df_final$pop09
df_final <- mutate(df_final, popgr = popg / pop09)

# Compare/check results
setwd("E:/Extension/DSI/P2")
chciExpected <- read_xlsx("chci.xlsx")

write_xlsx(df_final,"p2_result.xlsx")

# Reorder data
# By CHCI growth
arr_chcig <- arrange(df_final, desc(chcig))

# By CHCI growth rates
arr_chcigr <- arrange(df_final, desc(chcigr))


# Plot map in R
library(ggplot2)
library(maps)
library(RColorBrewer)

g_county <- map_data("county")
g_state <- map_data("state")

county01 <- g_county %>% mutate(polyname=paste(region, subregion, sep=",")) %>% left_join(county.fips, by="polyname")
chci <- df_final
colnames(chci)[1]="fips"
county_chci <- county01 %>% left_join(chci, by="fips")

qt1 <- quantile(county_chci$chci16, probs=c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1), na.rm=T)
county_chci$chci17a <- cut(county_chci$chci17, breaks=qt1, labels=paste(qt1[-1]))

state_layer=geom_polygon(aes(long,lat,group=group), fill=NA, data=g_state,color = "darkgreen") 
ggplot(county_chci, aes(long,lat,group=group)) + 
  geom_polygon(aes(fill = chci17a), colour = rgb(1,1,1,0.2)) + coord_quickmap() +
  scale_fill_brewer(palette = "RdBu") + state_layer

# From the plots, it appears that CHCI is typically higher in urban areas, since
# counties around where there are big cities are mostly blue while rural areas 
# are mostly red.

# Part B ------------------------------------------------------------------
setwd("E:/Extension/DSI/P2")

taxdata <- read_xlsx("P02_Corporate tax.xlsx")

# Page 55 models

fit1 <- lm(ypcg ~ ctax, taxdata)
summary(fit1)

fit2 <- lm(ypcg ~ ctax + ypc2000, taxdata)
summary(fit2)

fit3 <- lm(ypcg ~ ctax + ypc2000 + dty + ctax*dty, taxdata)
summary(fit3)

# Predict using equation 3
testdata <- data.frame(ctax = 20, ypc2000 = 10000, dty = 35)
test3pred <- predict(fit3, testdata)
test3pred           # predicted GDP per capita growth rate = 3.23925 

# Plot similar to figure 4
plot(taxdata$ctax, taxdata$ypcg, col = "blue", xlab = "Average Corporate Tax Rate '00-'08", 
     ylab = "Average GDP per capita Growth '00-'15", pch = 16, xlim = c(10,45), 
     ylim = c(-1,6))
grid()
abline(fit1, col = "red")
abline(h=0)

# Labels
c_lab <- sort(c("Italy","Ireland","Latvia","Japan","United States"))
c_abr <- sort(c("ITA","LTV","JPN","IRL","USA"))
with(taxdata[which(taxdata$country %in% c_lab),], text(ctax, ypcg, labels = c_abr, 
                                                       pos = c(2,2,1,2,4)) )


#  A potential reason to use corporate tax rates from 2000-2008 instead of until 
#  2015 is to provide a length of time for possible changes in tax rate to be 
#  reflected in the GDP growth rate

# Explore models and propose one with best R2
library(MuMIn)
options(na.action=na.fail)

testfit <- lm(ypcg ~ .-country, taxdata)
summary(testfit)

# Use dredge to explore potential models and examine top 10 fits
dfit <- dredge(testfit)
head(dfit,10)

ft1 <- lm(ypcg ~ ctax + ihc + trade + ypc2000, taxdata)
ft2 <- lm(ypcg ~ ctax + dty + ihc + ypc2000, taxdata)
ft3 <- lm(ypcg ~ ctax + ihc + ypc2000, taxdata)
ft4 <- lm(ypcg ~ ctax + dty + ihc + trade + ypc2000, taxdata)
ft5 <- lm(ypcg ~ ctax + ihc + trade + y2000 + ypc2000, taxdata)

ft6 <- lm(ypcg ~ ctax + dty + ihc + trade + y2000 + ypc2000, taxdata)
ft7 <- lm(ypcg ~ ctax + dty + ihc + y2000 + ypc2000, taxdata)
ft8 <- lm(ypcg ~ ctax + dty + ypc2000, taxdata)
ft9 <- lm(ypcg ~ ctax + ihc + y2000 + ypc2000, taxdata)
ft10 <- lm(ypcg ~ ctax + ypc2000, taxdata)

ft <- list(ft1,ft2,ft3,ft4,ft5,ft6,ft7,ft8,ft9,ft10)

# Find highest adj. R^2
get_ars <- function(x) {
  return(summary(x)$adj.r.squared)
}

ars <- lapply(ft,get_ars)
which.max(ars)

# The best model examined was ft6, but that was just using all variables
summary(ft6)

# Try playing around with some crosses
library(corrplot)
corrplot(cor(taxdata[,-1]), type="lower", method="number")

ft11 <- lm(ypcg ~ ctax + dty + ihc + trade + y2000 + ypc2000 + dty*ctax, taxdata)
summary(ft11)

ft12 <- lm(ypcg ~ ctax + dty + ihc + trade + ypc2000 + dty*ctax, taxdata)
summary(ft12)

ft13 <- lm(ypcg ~ ctax + dty + ihc + trade + ypc2000 + dty*ctax + ihc*ctax, taxdata)
summary(ft13)

ft14 <- lm(ypcg ~ ctax + dty + ihc + trade*ypc2000 + dty*ctax + ihc*ctax, taxdata)
summary(ft14)

ft15 <- lm(ypcg ~ ctax + dty + ihc + trade*ypc2000 + dty*ctax + ihc*ctax + ihc*ypc2000, taxdata)
summary(ft15)

ft16 <- lm(ypcg ~ ctax + dty  + trade*ypc2000 + dty*ctax + ihc*ctax, taxdata)
summary(ft16)

# ft14 and ft16 have highest adj. R^2 ( 0.7089 ), although most models were around 0.65-0.7
# Corporate tax rate, and debt to GDP ratio were
# persistently included in "better" models with varying significance. 

# Generally, lower ctax and dty corresponded with increased ypcg.
# Including some cross terms also helped the models. Corporate tax rate was 
# apparently related to several of the other variables like dty and ihc, and trade
# was related to GDP in 2000. 

# So lower Corporate tax may correspond with increased GDP growth, but ctax is also 
# related to other factors like debt, human capital, etc.



