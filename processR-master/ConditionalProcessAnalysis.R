##------------조건부 과정모형 실습--------------##
# 참고도서 : 문건웅. (2019). R을 이용한 조건부과정분석. 학지사.


# 1. 필요한 패키지 설치 -----------------------------------------------------------

# https://cran.r-project.org/bin/windows/Rtools/ 여기에서 Rtools을 다운로드하여 설치
# R 4.0 버전이 출시되면서 Rtools가 스크립트 및 콘솔창에서 설치가 안되므로
# 설치 이후 상기 사이트의 Putting Rtools on the PATH를 읽고 그대로 세팅해주어야함
# 상기 Putting Rtools on the PATH 대로 했음에도 불구하고 환경변수 설정이 안될 경우 참고할 수 있는 Youtube 영상: https://youtu.be/F5LYjvLxNJw
# 한글로 설명된 사이트 https://funnystatistics.tistory.com/23

writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")

Sys.which("make")
## "C:\\rtools40\\usr\\bin\\make.exe"

install.packages("jsonlite", type = "source")


    # devtools : 개발자용 패키지, 여기에서는 깃헙에 있는 패키지를 설치 하는데 사용 | https://devtools.r-lib.org 상세정보 확인
install.packages("devtools")

    # tidyverse : 데이터분석에 필요한 패키지, stringr : 문자열을 쉽게 처리하도록 도와주는 함수세트 제공
install.packages(c("tidyverse","stringr"))

    # rlang : R 및 Tidyverse 패키지 활용을 위한 기반 패키지
install.packages("rlang", dependencies = TRUE, INSTALL_opts = "--no-lock")

    # lavaan : 확인적 요인분석, 구조방정식, 잠재성장모형 등 고급통계를 쉬운 문법으로 구동시킬 수 있는 패키지
    # https://cran.r-project.org/web/packages/lavaan/index.html
install.packages("lavaan", dependencies = TRUE)

# ggplot2 : 시각화 패키지
install.packages("ggplot2")

    # predict3d, processR : 저자가 개발한 매개, 조절, 조건부과정분석 패키지
devtools::install_github("cardiomoon/predict3d", force = TRUE)
devtools::install_github("cardiomoon/processR", force = TRUE)

# 2. 패키지 실행 ---------------------------------------------------------------

# 저자는 library 보다 require를 사용하여 패키지를 불러올 것을 권장하고 있음
    # library 함수는 설치되어있지 않은 패키지를 불러오는 경우에 오류값을 반환
    # require 함수는 설치되어있지 않은 패키지를 불러오는 경우에 경고메시지를 보여줌

require(processR)
require(predict3d)
library(ggplot2)
library(lavaan)


# 3. 조건부과정분석의 기초 ----------------------------------------------------------
#processR 패키지의 내장함수를 활용하여 모형 그림을 생성

# 3.1 직접효과만 조절되는 모형 (PROCSS Macro Model 5) ------------------------

labels = list(X="X",Y="Y",M="M") #독립변수X, 매개변수M, 종속변수Y
moderator = list (name = "W", site = "c") # w가 조절하는 포지션 설정 : a(X→M), b(M→Y), c(X→Y)
drawConcept(labels=labels, moderator=moderator) #개념적모형
drawModel(labels=labels,moderator=moderator) #통계적모형

pmacroModel(5)
statisticalDiagram(5)

# M = iM + aX + eM
# Y = iY + c'1X + c'2W + c'3XW + bM + eY
# Y = iY + (c'1 + c'3W) X + c'2W + bM + eY


# 3.2 간접효과만 조절되는 모형 (PROCESS Macro Model 14) --------------------------

labels = list(X="X",Y="Y",M="M") #독립변수X, 매개변수M, 종속변수Y
moderator = list (name = "W", site = "b") # w가 조절하는 포지션 설정 : a(X→M), b(M→Y), c(X→Y)
drawConcept(labels=labels, moderator=moderator) #개념적모형
drawModel(labels=labels,moderator=moderator) #통계적모형

# M = iM + aX + eM
# Y = iY + c'X + b1M + b2W + b3MW + eY
# Y = iY + c'X + (b1 + b3W)M + b2W + eY
# 간접효과 ab = a(b1 + b3W) = ab1 + ab3W


# 3.3 직접효과와 간접효과가 모두 조절되는 모형(PROCESS Macro Model 28) ----------------------
labels = list(X="X",Y="Y",M="M") #독립변수X, 매개변수M, 종속변수Y
moderator = list (name = c("W","Z"), site = list(c("a"), c("b","c")), arr.pos=list(c(0.5), c(0.4,0.7))) # W와 Z가 조절하는 위치 설정 : a(X→M), b(M→Y), c(X→Y) / arr.pos = 조절화살표의 위치(0~1)
drawConcept(labels=labels, moderator=moderator, nodemode=2) #개념적모형
drawModel(labels=labels,moderator=moderator,nodemode=5) #통계적모형

# M = iM + a1X + a2W + a3XW + eM
# Y = iY + c'1X + c'2Z + c'3XZ + b1M + b2MZ + eY
# θX→M = (a1 + a3W)X
# θM→Y = (b1 + b2Z)M
# 간접효과 = θX→M * θM→Y = (a1 + a3W) * (b1 + b2Z) = a1b1 + a1b2Z + a3b1W + a3b2WZ


# 3.4 병렬다중매개모형에서 특정간접효과가 조절되는 모형 (PROCESS Macro Mode 58.2) ----------------
pmacroModel(58.2)
statisticalDiagram(58.2)


# 4. 사례연구 : 팀에서 감정을 숨기기 ---------------------------------------------------
# 사용하는 데이터 = teams
# Cole et al.(2008)은 자동차 부품회사의 80개 팀을 대상으로 4가지 변수 측정 | 직장, 특히 팀 내에서 업무를 함께할 경우에는 자신의 감정을 억누르는 것이 팀의 업무효율을 위해 긍정적인 효과를 나타내는가?
# DYSFUNC (dysfunctional behavior, 역기능행동) : 팀구성원이 얼마나 자주 다른 사람들의 업무를 악화시키거나 변화와 혁신을 방해하는 행동을 하는지
# NEGTONE (negative effect, 부정적 정서상태) : 업무수행 시 얼마나 자주 분노 또는 역겨움을 느끼는지 질문하여 측정
# NEGEXP (nonverbal negative expressivity, 부정적 감정표현) : 팀 구성원들이 얼마나 쉽게 자신들의 비언어적 부정적 감정을 표현하는가에 대한 상사의 평가
# PERFORM (team performance, 팀 성과) : 팀이 얼마나 효율적이고 시간내에 업무를 달성하는지에 대한 상사의 평가
# DYSFUNC(X)이 NEGTONE(M)으로 가득한 환경을 만들고, PERFORM(Y)를 떨어뜨리는 매개효과 + NEGEXP(W)을 통해 본인의 감정을 숨김으로써 업무에 집중한다는 조절효과 : PROCESS Macro Model 14

labels = list(X="DYSFUNC",M="NEGTONE",Y="PERFORM")
moderator = list(name="NEGEXP",site=list("b"),pos=2)
drawConcept(labels=labels,moderator=moderator,box.col='lightcyan')
drawModel(labels=labels,moderator=moderator)
