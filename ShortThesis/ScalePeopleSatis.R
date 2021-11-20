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

CleanData %>% 
  group_by(W7_sex) %>%
    summarise(TrainAvg = mean(TrainHour))

summaryBy(TrainHour ~ W7_sex, Data= CleanData, FUN = C(mean,sd))
??summaryBy

# 기술통계량 :1인당 교육훈련시간에 대해서 성별을 기준으로 한 통계량
summaryBy(TrainHour~W7_sex, data=CleanData, FUN = c(mean,sd,max,min,length))

# 기술통계량 : 인재대우에 대해서 성별을 기준으로 한 통계량
summaryBy(PeopleAvg~W7_sex, data=CleanData, FUN = c(mean,sd,max,min,length))

# 기술통계량 : 직무만족에 대해서 성별을 기준으로 한 통계량
summaryBy(SatisAvg~W7_sex, data=CleanData, FUN = c(mean,sd,max,min,length))

# 기술통계량 :1인당 교육훈련시간에 대해서 성별을 기준으로 한 통계량
summaryBy(TrainHour+PeopleAvg+SatisAvg~W7_sex, data=CleanData, FUN = c(mean,sd,max,min,length))

# 기술통계량 :1인당 교육훈련시간에 대해서 성별을 기준으로 한 통계량
summaryBy(TrainHour+PeopleAvg+SatisAvg~C7_SCALE, data=CleanData, FUN = c(mean,sd,max,min,length))

# 회귀분석
LM1 <- lm (PeopleAvg ~ TrainHour, data = CleanData)
summary(LM1)

LM2 <- lm (SatisAvg ~ TrainHour + PeopleAvg, data = CleanData)
summary(LM2)

# PROCESS Model 4
process (data = CleanData, y = "SatisAvg", x = "TrainHour", m ="PeopleAvg", model = 4, boot = 10000, seed = 191217)

library(dplyr)
CleanData %>% 
  select(SatisAvg, TrainHour, PeopleAvg) -> CleanData2

cor(CleanData2, use = "everything",  method = "pearson")

library(ggplot2)
Scatterplot<-ggplot(CleanData2, aes(TrainHour, TrainHour))+geom_point()
Scatterplot

hist(CleanData2$TrainHour, breaks=20)
mean(CleanData$TrainHour)

# PROCESS Model 6 Test
process (data = CleanData, y = "SatisAvg", x = "TrainHour", m =c("PeopleAvg","W725_01"), model = 6, boot = 10000, seed = 191217)

getwd()
Data111 <- read.csv("111.csv", header = TRUE)
str(Data111)

process (data = Data111, y = "EngageAvg", x = "HiaAvg", m ="CommAvg", model = 4, boot = 1000, seed = 191217)

process (data = Data111, y = "EngageAvg", x = "InnoAvg", m ="CommAvg", model = 4, boot = 1000, seed = 191217)

process (data = Data111, y = "EngageAvg", x = "ConAvg", m ="CommAvg", model = 4, boot = 1000, seed = 191217)

process (data = Data111, y = "EngageAvg", x = "AbiAvg", m ="CommAvg", model = 4, boot = 1000, seed = 191217)
