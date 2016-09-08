# 개별 속성 분석하기
source("dbook.R")
load.packages(c("dplyr", "ggplot2", "tidyr", "knitr"))

mpg = read.table("mpg.txt", header=T, sep="\t")

# kable 테이블을 보기 좋게 출력
kable(sample_n(mpg,10))
str(mpg)
summary(mpg)

a = ggplot(mpg, aes(hwy))    # 기본 플롯을 만듦
p1 = a + geom_density()      # 기본 플롯을 확률밀도함수 형태로 출력
p2 = a + geom_histogram()    # 기본 플롯을 히스토그램 형태로 출력
p3 = a + geom_dotplot()      # 기본 플롯을 점플롯 형태로 출력
multiplot(p1, p2, p3, cols=3)

# 속성 간의 관계 분석하기
mpg.num = select(mpg, displ, year, cyl, cty, hwy)
round(cor(mpg.num), 3)

plot(mpg.num)

# cyl과 drv 속성의 교차 테이블을만든다.
table(mpg$cyl, mpg$drv)

mosaicplot(table(mpg$drv, mpg$cyl), cex=1.2, main="")

par(mfrow=c(1,2))
plot(jitter(mpg$cyl), mpg$hwy, xlab="Year", ylab="MPG(hwy)")
boxplot(hwy ~ cyl, filter(mpg, cyl != 5), xlab="Year", ylab="MPG(hwy)")

p1 = ggplot(mpg, aes(hwy, cty)) + geom_point() + geom_smooth()
p2 = ggplot(mpg, aes(displ, cty)) + geom_point() + geom_smooth()
multiplot(p2, p1, cols=2)

ggplot(mpg, aes(hwy, cty)) +
  geom_point(aes(color = cyl, size = displ))


# 메이저 제조사의 목록을 구하기
majors = mpg %>%
  group_by(manufacturer) %>%  # 데이터를 제조사 기준으로 그룹하여
  summarise(count=n()) %>%    # 제조사별 모델의 개수를 구하고
  filter(count > 10)          # 적어도 10대 이상의 모델이 있는 제조사만 남긴다.

# 메이저 제조사의 모델을 구하기
mpg.majors = mpg %>%
  filter(manufacturer %in% majors$manufacturer) %>%  # 메이저 제조사의 차량만 남기고
  distinct()                     # 차량별로 한대씩만 남긴다.

# 모델별 연비에 모델 이름을 추가한 플롯
ggplot(mpg.majors, aes(hwy, cty)) +                        # 기본 플롯에
  geom_text(aes(label = model, color = manufacturer), size = 4,    # 텍스트 레이블을 더하고
            position=position_jitter(width=1, height=2))   # 레이블이 겹치지 않도록 노이즈를 더한다.
