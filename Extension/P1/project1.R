# Project 1
# UCLA Extension Data Science Intensive
# Kevin Wang

# Part A ------------------------------------------------------------------

p <- 650000     # Define constants
d <- 0.1
z <- 0.028
y <- 30

c <- z/12       # Calculate subvalues
n <- y*12

m <- ((p*(1-d))*(c*(1+c)^n))/(((1+c)^n)-1)   # Calculate m
m               # $2403.732 monthly payment


# Part B ------------------------------------------------------------------

setwd("E:/Extension/DSI/P1")
library(readxl)           
laz2018 <- data.frame(read_excel("P01_LA zipcode payroll.xlsx", sheet="2018"))

# Extract total employment
totals <- subset(laz2018, is.na(as.numeric(laz2018$Zip.Code)) )
rownames(totals) <- NULL

library(tidyverse)
totals$Zip.Code <- parse_number(totals$Zip.Code)

totals <- subset(totals, select=c(1,4,5,6))
colnames(totals) <- c("zipcode","Total.Establishments","Total.Employment",
                      "Total.Wages")

# Examine only Information and PS&T Employment
laz2018new <- subset(laz2018, !is.na(as.numeric(laz2018$Zip.Code)))
laz2018new <- subset(laz2018, Industry == "Information" | Industry == 
                 "Professional, Scientific, & Technical Services" )

# Get rid of *****'s
laz2018new$Employment <- as.numeric(gsub("*****","0",laz2018new$Employment,fixed=TRUE))
laz2018new$Wages <- as.numeric(gsub("*****","0",laz2018new$Wages,fixed=TRUE))
laz2018new$Zip.Code <- as.numeric(laz2018new$Zip.Code)

# Get only Employment numbers
lazTemp <- subset(laz2018new, Industry == "Information")
lazFinal <- data.frame(as.numeric(lazTemp$Zip.Code))
colnames(lazFinal) = "zipcode"
lazFinal$information <- lazTemp$Employment

lazTemp <- subset(laz2018new, Industry == "Professional, Scientific, & Technical Services")
lazTemp <- lazTemp[c("Zip.Code","Employment")]
colnames(lazTemp) <- c("zipcode","professional")

# Compile results
library(dplyr) 

lazFinal <- full_join(lazFinal,lazTemp)
lazFinal <- full_join(lazFinal,totals)
lazFinal <- lazFinal[c("zipcode","Total.Employment","information","professional")]

colnames(lazFinal)[2] <- "total"
lazFinal$total <- as.numeric(lazFinal$total)

lazFinal$per <- (lazFinal$information+lazFinal$professional)/lazFinal$total

# Reorder results
lazFinal <- lazFinal[order(lazFinal$zipcode),]
rownames(lazFinal) <- NULL

# Check and compare result
lazExpected <- read.csv("laz18tech.csv")
lazExpected <- select(lazExpected, -X)

# Save as CSV
write.csv(lazFinal,"p1_result.csv")

















