
#############################################################################################
#############################################################################################
#######################모든 변수가 계량변수인 데이터의 조절분석##############################
#############################################################################################
#############################################################################################


##현재 디렉토리 확인하기
getwd()

##파일이 있는 디렉토리로 설정하기
setwd("C:/Users/jeonj/Dropbox/Master's Course/Coursework/sta")

##필요한 패키지 설치하기
install.packages("processR")
install.packages("lavaan")
install.packages("tidyverse")

##데이터 불러오기
library(processR)
##library(sem)

##개념적 모형 그리기
labels=list(X="negemot",Y="govact", W="age", C1="posemot", C2="ideology", C3="sex")
moderator = list(name="age", site=list("c"))
covar = list(name=c("posemot","ideology","sex"), site=list("Y","Y","Y"))
pmacroModel(1, labels=labels, covar=covar, radx=0.05)


##통계적 모형 그리기
arrowslabels = paste0("b", 1:6)
statisticalDiagram(1, labels=labels, covar=covar, radx=0.11, arrowslabels=arrowslabels, whatLabel = "label")


##회귀모형 만들기(상호작용값존재)
fit = lm(govact ~ negemot * age + posemot + ideology + sex, data=glbwarm)
summary(fit)

##회귀모형 만들기(상호작용값 제외한 모형)
fit1 = lm(govact ~ negemot + age + posemot + ideology + sex, data=glbwarm)
summary(fit1)

##두 회귀모형의 설명력 비교를 위한 F-Test
anova(fit1, fit)

##negemot(X), age(W)의 16, 50, 84 백분위수 구하기
quantile(glbwarm$negemot, probs=c(0.16,0.5, 0.84), type=6)
modSummary2(fit, labels=labels, modx.values=c(30,50,70))


##나이가 30일때 X의 조건부 효과
fit1_30=lm(govact~negemot*I(age-30)+posemot+ideology+sex, data=glbwarm)
summary(fit1_30)

##나이에 따른 조건부효과 요약
modSummary3(fit, mod2.values = c(30,50,70))
condPlot(fit, xmode=2, mode=2, pred.values = c(30,50,70), xpos=0.2)

##Johnson-Neyman 방법 (W의 모든 관찰범위에서 유의한 방법addEq = TRUE, mod.range=c(17,87))
jnPlot(fit, addEq = TRUE, mod.range=c(17,87))




#############################################################################################
#############################################################################################
##############################변수를 Centering하는 R코드#####################################
#############################################################################################
#############################################################################################
##변수의 평균중심화
x=1:10
x
x.c = x-mean(x)
x.c

##결측치가 있는 변수에서의 평균중심화 방법
x.c = x-mean(x, na.rm=TRUE)
x.c

##일부 데이터프레임의 변수에 대한 평균중심화
colnames(glbwarm)
newdata = meanCentering(glbwarm, names=c("negemot","age"))
colnames(newdata)


##회귀모형에서의 평균중심화
##x와 w를 표준화하여 zx와 zw를 만든 후, 표준화된 값을 곱하여 상호작용을 만든 후 회귀분석한 것
fitcentering = lm(govact ~ negemot * age, data=glbwarm)
std.fit = compareMC(fitcentering, mode=2)[[3]]
summary(std.fit)

