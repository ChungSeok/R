
#############################################################################################
#############################################################################################
#######################조절분석의 기초##############################
#############################################################################################
#############################################################################################


##?????? ???????????? ????????????
getwd()

##????????? ?????? ?????????리로 ????????????
setwd("C:/Users/LG/Desktop/Presentation_stat")

##필요한 패키지 설치
install.packages("processR")
install.packages("flextable")
install.packages("lavaan")
install.packages("nortest")
install.packages("dplyr")
library(processR)
library(flextable)
library(lavaan)
library(nortest)
library(dplyr)
require(processR)
require(flextable)
require(lavaan)
require(nortest)
require(dplyr)


## frame에 따른 회의적인 태도 및 정당화 정수의 기술통계량
labels=list(X="frame", Y="justify", W="skeptic")
xlabels=c("Natural causes condition", "Climate change condition")
meanSummaryTable(data=disaster, labels=labels, xlabels=xlabels)


##두집단 t-test

t.test(justify~frame,data=disaster, var.equal=TRUE)


##원조중단의 정당성을 평가하는 여러 회귀모형
library(ggplot2)

fit1=lm(justify~frame, data=disaster)
fit2=lm(justify~frame+skeptic, data=disaster)
fit3=lm(justify~frame+skeptic, data=disaster)
disaster=meanCentering(disaster, names=c("frame", "skeptic"))
disaster$frame2=ifelse(disaster$frame==0,-0.5,0.5)
fit4=lm(justify~frame*skeptic.c, data=disaster)
fit5=lm(justify~frame2*skeptic.c, data=disaster)
fitlist=list(fit1,fit2,fit3,fit4,fit5)
labels=list(X="frame", W="skeptic", X.C="frame.c", W.c="skeptic", X2="frame2")
fitlabels=c("","","","(mean-centerd W)","(mean~centerd W)", "(mean-centered W, X coded-0.5 and o.5)")
modelsSummary2Table(fitlist,labels=labels,fitlabels=fitlabels,autoPrefix=FALSE)


##조절모형의 시각화
fit=lm(justify~frame*skeptic,data=disaster)
modSummary2Table(fit)%>%width(width = 1)

condPlot(fit,mode=2,xpos=0.7)

##기후변화 예제 상호작용 탐색 John-Neyman Interval
jnPlot(fit)
