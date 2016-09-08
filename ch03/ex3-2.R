# 환경 설정하기
source("dbook.R")
load.packages(c("stringr", "reshape2", "dplyr", "ggplot2"))

# pew.txt을 읽어들이고 확인한다.
pew.raw <- read.delim("pew.txt", check.names=FALSE, stringsAsFactors=FALSE)
head(pew.raw)



# 표준 테이블로 변환하기
# religion 속성을 제외한 다른 속성을 측정값(measure)으로 변환한다.
pew.tidy <- melt(pew.raw, "religion")

# 데이터의 속성 이름을 지정한다.
names(pew.tidy) <- c("religion", "income", "count")
head(pew.tidy)



# 소득 속성 추가하기
# 범위 형태의 문자열을 숫자로 바꾸는 함수
range.to.number <- function(v) {
  # 정규식을 사용하여 범위 문자열에서 숫자 문자열을 모두 추출한다.
  range.values = str_extract_all(v, "\\d+")
  # 숫자가 추출되면, 숫자 문자열을 수치형으로 바꾸고 그 평균을 구한다.
  if(length(range.values[[1]]) > 0)
    mean(sapply(range.values, as.integer))
  else
    NA
}

range.to.number("$10k")
range.to.number("$10-20k")
range.to.number("No Number")

# 소득 값을 숫자로 변환한다.
pew.tidy$income.usd = sapply(pew.tidy$income, range.to.number) * 1000
head(pew.tidy$income.usd)

# 변환에 실패한 항목을 버린다.
pew.tidy = na.omit(pew.tidy)
head(pew.tidy)

qplot(income.usd, religion, data=pew.tidy, size=count)
