# 수치 / 문자열 / 배열 자료형을 정의한다.
v1 = 1
v2 = "abc"
v3 = c(1,2,3)

# 테이블 형태의 자료형인 데이터 프레임을 정의한다.
df1 = data.frame(
  Name=c("Jerry","Tom","Smith"),
  Math=c(50,60,75))
df1

source("dbook.R")

load.packages(c("stringr", "ggplot2", "dplyr", "knitr"))
