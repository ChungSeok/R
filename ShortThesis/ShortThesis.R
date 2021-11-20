getwd()

#package 불러오기
library(readxl)
library(foreign)
library(dplyr)
library(ggplot2)

#CSV 파일 불러오기
DataCSV <- read.csv("ShortThesisDataCSV.csv",header = T)


# 전체데이터에서 교육훈련투자규모 추가 (교육훈련비총액을 총 인건비로 나눔)
DataCSV %>%
  mutate(TrainCostRatio = C7C02_01_06/C7C02_01_05) -> DataCSV1
View(DataCSV1)

# 교육훈련투자규모 변수선언
DataCSV1 %>% 
  select(TrainCostRatio) -> TrainCostRatio

# 기업문화 측정항목 변수선언
DataCSV %>% 
  select(W727_01,W727_02,W727_03,W727_04,W727_05,W727_06,W727_07,W727_08,W727_09,W727_10,W727_11,W727_12) -> Culture

# 기업문화 측정값을 숫자로 변경
as.numeric(DataCSV$W727_01,DataCSV$W727_02,DataCSV$W727_03,DataCSV$W727_04,DataCSV$W727_05,DataCSV$W727_06,DataCSV$W727_07,DataCSV$W727_08,DataCSV$W727_09,DataCSV$W727_10,DataCSV$W727_11,DataCSV$W727_12)

# 기업문화 평균치 추가
Culture %>% 
  mutate(CultureAvg = (W727_01+W727_02+W727_03+W727_04+W727_05+W727_06+W727_07+W727_08+W727_09+W727_10+W727_11+W727_12) / 12) -> Culture

# 전체 데이터에 기업문화 평균치 추가
DataCSV1 %>% 
  mutate(CultureAvg = (W727_01+W727_02+W727_03+W727_04+W727_05+W727_06+W727_07+W727_08+W727_09+W727_10+W727_11+W727_12) / 12) -> DataCSV2

# 만족도 측정항목 변수선언
DataCSV3 %>% 
  select(W728_01,W728_02,W728_03,W728_04) -> Satis

# 만족도 측정값을 숫자로 변경
as.numeric(DataCSV$W728_01,DataCSV$W728_02,DataCSV$W728_03,DataCSV$W728_04)

# 만족도 평균치 추가
Satis %>% 
  mutate(SatisAvg = (W728_01+W728_02+W728_03+W728_04)/4) -> Satis

# 전체 데이터에 만족도 평균치 추가
DataCSV2 %>% 
  mutate(SatisAvg = (W728_01+W728_02+W728_03+W728_04)/4) -> DataCSV3

# 조직몰입과스트레스 변수선언
DataCSV3 %>% 
  select(W729_01,W729_02,W729_03,W729_04,W729_05,W729_06,W729_07) -> Engage

#역문항 코딩변경 -> 역코딩 ((측정값 최대치)+1 - 측정값)
DataCSV3 %>% 
  mutate(W729_01R = 5 - W729_01) -> DataCSV4
DataCSV4 %>% 
  mutate(W729_02R = 5 - W729_02) -> DataCSV5
DataCSV5 %>% 
  mutate(W729_03R = 5 - W729_03) -> DataCSV6
DataCSV6 %>% 
  mutate(W729_04R = 5 - W729_04) -> DataCSV7
DataCSV7 %>% 
  mutate(W729_05R = 5 - W729_05) -> DataCSV8
DataCSV8 %>% 
  mutate(W729_06R = 5 - W729_06) -> DataCSV9
DataCSV9 %>% 
  mutate(W729_07R = 5 - W729_07) -> DataCSV10

# 조직몰입과스트레스 1, 5, 6, 7 역문항 반영 후 변수선언
DataCSV10 %>% 
  select(W729_01R,W729_02,W729_03,W729_04,W729_05R,W729_06R,W729_07R) -> EngageR

#역문항반영 상관행렬 확인
cor(EngageR)

# 조직몰입과스트레스 평균값 추가
EngageR %>% 
  mutate(EngageAvg = (W729_01R+W729_02+W729_03+W729_04+W729_05R+W729_06R+W729_07R)/7) -> EngageR

# 4개 변수 합치기 cbind
cbind(TrainCostRatio, Culture, Satis, EngageR) -> Data

# 평균값만 추출
Data %>% 
  select(TrainCostRatio,CultureAvg,SatisAvg,EngageAvg) -> DataAvg

# 인건비 C7C02_01_05 Outlier 제거
DataAvg %>% 
  filter(TrainCostRatio>0,TrainCostRatio<0.03) ->DataAvgClean

# DataAvgClean Plot
library(ggplot2)
ggplot (DataAvgClean, aes(x=TrainCostRatio,y=TrainCostRatio)) + geom_point()

# 공분산 확인
cov(DataAvgClean)

# 분산 확인
var(DataAvgClean)

# 다중회귀분석
MR <- lm (SatisAvg ~ TrainCostRatio + CultureAvg + EngageAvg, data = DataAvgClean)
summary(MR)

# 회귀분석을 위한 기본가정 : 잔차의 정상성, 독립성, 동변량성, 독립성
library(QuantPsyc)
library(base)
library(boot)

par(mfrow=c(2,2))
plot(MR)

durbinWatsonTest(MR)

vif(MR)

1/vif(MR)

# 신뢰도 Cronbach'a
install.packages("psy")
library(psy)
install.packages("psych")
library(psych)
install.packages("ltm")
library(ltm)

cronbach(EngageR)
cronbach(Satis)
cronbach(Culture)

alpha(EngageR)
alpha(Satis)
alpha(Culture)


# 기술통계량
DataCSV10 %>% 
  filter(TrainCostRatio>0,TrainCostRatio<0.03) ->DataCSV11

DataCSV11 %>%
  select(TrainCostRatio,W727_01,W727_02,W727_03,W727_04,W727_05,W727_06,W727_07,W727_08,W727_09,W727_10,W727_11,W727_12,W728_01,W728_02,W728_03,W728_04,W729_01R,W729_02,W729_03,W729_04,W729_05R,W729_06R,W729_07R) -> Fnl_Data

Fnl_Data %>% 
  select(W727_01,W727_02,W727_03,W727_04,W727_05,W727_06,W727_07,W727_08,W727_09,W727_10,W727_11,W727_12) -> Fnl_Culture

Fnl_Data %>% 
  select(W729_01R,W729_02,W729_03,W729_04,W729_05R,W729_06R,W729_07R) -> Fnl_Engage

Fnl_Data %>% 
  select(W728_01,W728_02,W728_03,W728_04) -> Fnl_Satis

Fnl_Data %>% 
  select(TrainCostRatio) -> Fnl_TCR

summary(Fnl_Data)
psych::describe(Fnl_Data, trim=0.05)

hist(Fnl_Data$TrainCostRatio, labels=TRUE, breaks=200)
shapiro.test(Fnl_Data$TrainCostRatio)

# 교육훈련투자규모 Data transformation
Fnl_TCR %>% 
  mutate (TrainCostRatioLog = log(TrainCostRatio)) -> Fnl_TCR_Log

Fnl_TCR_Log %>% 
  select(TrainCostRatioLog) -> Fnl_TCR_Log

str(Fnl_TCR_Log)
as.data.frame(Fnl_TCR_Log, header = TRUE)

Fnl_Data_Log <- Fnl_Data_Log[-1]
Fnl_Data_Log

ggplot (Fnl_Data_Log, aes(x=TrainCostRatioLog,y=TrainCostRatioLog)) + geom_point()
hist(Fnl_Data_Log$TrainCostRatioLog, breaks=100)
shapiro.test(Fnl_Data_Log$TrainCostRatioLog)

# 기술통계
summary(Fnl_Data_Log)

psych::describe(Fnl_Data_Log, trim=0.05)

# 데이터합치기 cbind
cbind(DataAvgClean,Fnl_TCR_Log) -> Data_Clean_Log
FD <- Data_Clean_Log[-1]
head(FD)


# PROCESS Model 7
process (data = FD,
         y = "SatisAvg", x = "TrainCostRatioLog", m = "EngageAvg",
         w = "CultureAvg", model = 7,
         center = 2, moments = 1, modelbt = 1,
         boot = 10000, seed = 191217)