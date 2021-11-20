
# 제1장_R 및 Rstudio 설치하기 ----------------------------------------------------


# 제7절_그래프 저장하기 ------------------------------------------------------------
labels = list(X="cond", M = "pmi", Y="reaction")
drawModel(labels=labels,box.col="lightcyan")
??drawModel


# 7.1_그래프 저장하기 ------------------------------------------------------------

#Plots창(Ctrl+6) > Export > 파일유형, 경로 및 크기, 파일명 지정


# 7.2_표 만들기 ---------------------------------------------------------------

# 회귀계수 요약표 생성
modelsSummaryTable(labels=labels,data=pmi)
# Viewer창(Ctrl+9) > Show in new windows

# 회귀계수를 통계적 모형에 넣은 모형
drawModel(labels=labels,data=pmi,whatLabel="est")


# 제8절_통계 결과를 파워포인트로 -------------------------------------------------------
# ExtractToPPT.R 파일 참조


# 제2편_조건부과정분석의 기초 ---------------------------------------------------------


# 제2장_회귀에서 조절까지 -----------------------------------------------------------

# 0.1 사용하는 패키지 ------------------------------------------------------------

library(ggplot2)
library(predict3d)
library(processR)

#mtcars 데이터 : 1974년 모터트렌드 잡지에서 추출한 데이터, 공차중량wt과 마력hp, 연비mpg에 관한 데이터
str(mtcars)

fit = lm(mpg ~ wt, data=mtcars)
fit
summary(fit)
#mpg = 37.2851 + -5.3445wt

ggPredict(fit)

ggPredict(fit,show.text=FALSE,show.error=TRUE)


# 1.1 단순회귀분석의 개념적 모형과 통계적 모형 ----------------------------------------------
#개념적모형
pmacroModel(0,radx=0.1,rad=0.06,xmargin=0.03)
??pmacroModel
#통계적모형
statisticalDiagram(0,radx=0.06,ylim=c(0.1,0.6))

# 제2절_다중회귀분석 --------------------------------------------------------------


# 2.1 상호작용이 없는 다중회귀분석 -----------------------------------------------------
fit1 = lm(mpg ~ wt+vs,data=mtcars)
fit1
summary(fit1)

view(mtcars$vs)

ggPredict(fit1)
predict3d(fit1,radius=0.5)


# 2.1.1 상호작용이 없는 다중회귀분석의 개념적 모형과 통계적 모형 -----------------------------------
#개념적모형
pmacroModel(0,covar=list(name="C",site=list("Y")))

#통계적모형
statisticalDiagram(0,radx=0.06,covar=list(name="c",site=list("Y")),ylim=c(0.1,0.6))


# 2.2 상호작용이 있는 다중회귀모형 -----------------------------------------------------
# 종속변수 1개, 독립변수 2개(비율척도1, 더미변수1)

fit2 = lm(mpg ~ wt*vs,data=mtcars)
fit2
summary(fit2)

ggPredict(fit2)

predict3d(fit2)


# 종속변수 1개, 독립변수 2개(비율척도 2개)
fit3 = lm(mpg ~ wt*hp, data = mtcars)
fit3
summary(fit3)

# 이 모형에서 wt를 종속변수로, hqqqqqqqqqqqp를 조절변수로 생각하고, hp에 따른 wt와 mpg 사이의 회귀선의 기울기와 y절편을 생각해보자
# 우선 hp의 평균과 평균 +- 표준편차 계산
mean(mtcars$hp, na.rm=TRUE) + c(-1,0,1) * sd(mtcars$hp, na.rm = TRUE)
# hp의 평균은 146.69, 표준편차는 68.56

ggPredict(fit3) # 그래프로 표현하면

ggPredict(fit3,mode=3,colorn=50,show.text = FALSE) #회귀선을 50개로

predict3d(fit3,show.error=TRUE) # 3차원 그래프로


# 2.3.1 상호작용이 있는 다중회귀분석(조절효과)의 개념적 모형과 통계적 모형 -----------------------------

# 상호작용이 있는 다중회귀분석 = Hayes의 PROCESS Macro Model 1

# 개념적 모형
pmacroModel(1, radx = 0.1, rady=0.07)

# 통계적 모형
statisticalDiagram(no = 1, radx = 0.1, rady = 0.04)


# 제3절 조절된 조절 moderated moderation -----------------------------------------

# 독립변수가 3개이며, 모두 상호작용이 있는 모형 : 조절된 조절 Hayes PROCESS Macro Model 3

fit4 = lm (mpg ~ wt*hp*vs, data=mtcars)
fit4
summary(fit4)

ggPredict(fit4, show.point=FALSE)

predict3d(fit4, radius = 5, overlay = TRUE)

pmacroModel(3, radx = 0.1, rady = 0.07) # 개념적 모형

statisticalDiagram(3, radx = 0.1, rady = 0.05)


