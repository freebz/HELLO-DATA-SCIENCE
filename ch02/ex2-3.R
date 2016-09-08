# 데이터 준비하기

# 기본 가공법
cars$model = rownames(cars)
rownames(cars) = NULL

cars$maker = word(cars$model, 1)
head(cars)

# 고급 가공법(dplyr)
cars.small.narrow =               # 결과를 cars.small.narrow 변수에 저장한다.
  cars %>%                        # cars 데이터를 사용한다.
  filter(cyl == 4) %>%            # cyl 값이 4인 데이터만 남긴다.
  select(maker, model, mpg, cyl)  # 주어진 네 속성만 선택한다.
cars.small.narrow

makers =
  cars %>%
  group_by(maker) %>%               # 제조사 기준으로 데이터를 집계한다.
  summarize(maker.mpg = mean(mpg))  # 제조사별 평균 mpg다.
head(makers)

cars.makers = merge(cars, makers, by="maker")
head(cars.makers)
