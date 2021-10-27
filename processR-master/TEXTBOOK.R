
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
drawModel(labels=labels,data=pmi,whatLabel="est")qqqqqqqqqqqqqqqqqqqqqqqqqqq
