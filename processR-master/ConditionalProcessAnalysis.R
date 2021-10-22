##------------조건부 과정모형 실습 --------------##
# 참고도서 : 문건웅. (2019). R을 이용한 조건부과정분석. 학지사.

## 필요한 패키지 설치

    # devtools : 개발자용 패키지, 여기에서는 깃헙에 있는 패키지를 설치 하는데 사용 | https://devtools.r-lib.org 상세정보 확인
install.packages("devtools")

    # tidyverse : 데이터분석에 필요한 패키지, stringr : 문자열을 쉽게 처리하도록 도와주는 함수세트 제공
install.packages(c("tidyverse","stringr"))

    # lavaan : 확인적 요인분석, 구조방정식, 잠재성장모형 등 고급통계를 쉬운 문법으로 구동시킬 수 있는 패키지
    # https://cran.r-project.org/web/packages/lavaan/index.html
install.packages("lavaan", repos = "http://www.da.ugent.be", type = "source")

install.packages("dylib")

    # predict3d, processR : 저자가 개발한 매개, 조절, 조건부과정분석 패키지
devtools::install_github("cardiomoon/predict3d")
devtools::install_github("cardiomoon/processR")

    #패키지 실행 : 저자는 library 보다 require를 사용하여 패키지를 불러올 것을 권장하고 있음
require(processR)

labels=liste(X="cond", M="pmi", Y="reaction")
drawModel(labels=labels,box.col="lightcyan")
