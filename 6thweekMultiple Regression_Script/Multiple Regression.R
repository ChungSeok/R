
setwd("C:/Users/chlwl/Desktop/Multiple_Regression")
#데이터 저장한 경로를 워킹디렉토리로 설정(오류 시 '\'를 '/'로 수정하여 진행)


install.packages("car")
install.packages("QuantPsyc")

library(QuantPsyc)
library(car)
library(boot)
##패키지 설치 및 부착



#######################################################
######### 다중회귀분석(Multiple Regression) ###########
#######################################################

album2<-read.delim("Album Sales 2.dat", header = TRUE)

albumSales.2<-lm(sales ~ adverts, data = album2)
## 광고 횟수 - 매출 간 단순회귀분석

albumSales.3<-lm(sales ~ adverts + airplay + attract, data = album2)
## 독립변수 추가시 '+'로 진행

summary(albumSales.2)
## adverts가 sales에 미치는 영향에 대한 단순회귀분석: advers의 영향력은 33%, 회귀모델은 유의함.

summary(albumSales.3)
## 세 변수(adverts, airply, attract)가 sales에 미치는 영향력은 66%, 다중회귀모델은 유의함.
## 도출된 B값으로 다중회귀식을 구성할 경우 Y' = -26.61 + 0.08*B1 + 3.37*B2 + 11.09*B3


lm.beta(albumSales.3)
## Standardized parameter: 독립변수의 베타계수 간 상대적인 비교를 위해서는 lm.beta()를 통해 표준화베타계수를 구할 수 있음.
## 비표준화계수(B)는 회귀식 구성 시 사용, 표준화계수(Beta)는 회귀계수 간의 비교 시 활용 
## 각 독립변수별로 단위가 다를 수 있기 때문에 표준화 과정을 거치는 것

## 비표준화계수는 attract의 영향이 큰 것으로 나타내지만, 표준화계수는 attract가 가장 영향력이 낮고, 오히려 adverts와 airplay의 영향력이 큰 것을 확인할 수 있음.
## 따라서 서로 다른 독립변수 간 차이를 확인하기 위해선 표준화된 회귀계수를 사용.


anova(albumSales.2, albumSales.3)
## 모형2(단순회귀분석)와 모형3(다중회귀분석)에 대한 설명력 비교
## F값 및 p값으로부터 통계적으로 두 모형은 서로 다른 모형임을 판단할 수 있음



####################################################
###############  기본가정 검정  ####################
####################################################

library(base)
library("car")
## 회귀분석 기본 가정 검정을 위한 패키지 : base (cook's distance, leverage값 등)


## 잔차의 정상성, 선형성, 동변량성(그래픽적 방법)
par(mfrow=c(2,2))
plot(albumSales.3)
# normal qq는 잔차 선형성, 동변량성 확인하는 지표 - 45도 각도로 대각선 위에 점이 위치하면 잔차 선형성, 동변량성이 적절한 것으로 판단가능

hist(album2$studentized.residuals)
## 히스토그램을 통해 표준화잔차의 분포가 정상분포함을 확인할 수 있음.


#### 잔차의 독립성(D-W통계치)
durbinWatsonTest(albumSales.3)
## 더빈왓슨 통계량 - 잔차간의 자기상관이 있는지 없는지를 판단
## 2에 근접할 경우 잔차 간 자기상관이 없는 것으로 판단
## D-W값이 1.948로 잔차 간 독립성을 확보한 것으로 판단 가능. 

## 동일한 함수: dwt(albumSales.3)


#### 다중공선성 검정(공차, 분산팽창계수)
vif(albumSales.3)
# 각 독립변수의 분산팽창계수(VIF)값 확인
# 값이 10 이상이면 다중공선성을 의심할 수 있으나 해당 케이스는 그렇지 않은 것으로 판단할 수 있음/

1/vif(albumSales.3)
## 공차(Tolerance)확인
## 공차는 분산팽창계수의 역수이며, 1에 근접할수록 다중공선성이 없는 것으로 판단, 10 이상인 경우 다중공선성 존재 가능 


