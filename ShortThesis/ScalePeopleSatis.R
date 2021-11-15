getwd()

#package 불러오기
library(readxl)
library(foreign)
library(dplyr)
library(ggplot2)
library(psy)
library(psych)
library(ltm)
install.packages("doBy")
library(doBy)

#CSV 파일 불러오기
Data <- read.csv("ScalePeopleSatis.csv",header = T)
str(Data)

#컬럼명변경
names(Data)[1] <- c("TrainHour")
names(Data)

#결측치제거
Data %>% 
  filter(TrainHour > 0) -> CleanData

#기술통계량
psych::describe(CleanData)

Data %>% 
  group_by(W7_sex) %>%
    summarise(TrainAvg = mean(TrainHour), )

# 1인당 교육훈련시간에 대해서 성별로 나눔
summaryBy(TrainHour~W7_sex, data=CleanData, FUN = c(mean,sd,max,min), na.rm=TRUE)

# 회귀분석
LM1 <- lm (PeopleAvg ~ TrainHour, data = CleanData)
summary(LM1)

LM2 <- lm (SatisAvg ~ TrainHour + PeopleAvg, data = CleanData)
summary(LM2)

# PROCESS Model 4
process (data = CleanData, y = "SatisAvg", x = "TrainHour", m ="PeopleAvg", model = 4, boot = 10000, seed = 191217)