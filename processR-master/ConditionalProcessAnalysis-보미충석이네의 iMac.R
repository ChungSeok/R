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

# install.packages("remotes")
remotes::install_github("r-lib/rlang")

    # lavaan : 확인적 요인분석, 구조방정식, 잠재성장모형 등 고급통계를 쉬운 문법으로 구동시킬 수 있는 패키지
    # https://cran.r-project.org/web/packages/lavaan/index.html
install.packages("lavaan", dependencies = TRUE)


    # predict3d, processR : 저자가 개발한 매개, 조절, 조건부과정분석 패키지
devtools::install_github("cardiomoon/predict3d", force = TRUE)
devtools::install_github("cardiomoon/processR", force = TRUE)

# 2. 패키지 실행 ---------------------------------------------------------------

# 저자는 library 보다 require를 사용하여 패키지를 불러올 것을 권장하고 있음
    # library 함수는 설치되어있지 않은 패키지를 불러오는 경우에 오류값을 반환
    # require 함수는 설치되어있지 않은 패키지를 불러오는 경우에 경고메시지를 보여줌

remove.packages("rgl")

require(processR)
