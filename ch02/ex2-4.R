# 데이터 분석하기

# 요약 통계
table(cars$cyl)
table(cars$gear, cars$cyl)

# 기본 시각화
hist(cars$mpg)

plot(cars$wt, cars$mpg)

# 고급 시작화(ggplot2)
qplot(wt, mpg, data=cars, shape=factor(cyl))
