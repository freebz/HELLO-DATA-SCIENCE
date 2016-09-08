# 회귀 분석

source("dbook.R")
load.packages(c("plyr", "dplyr", "ggplot2", "tidyr", "rpart", "randomForest"))

bos = read.table("boston.txt", sep="\t", header=T)
head(bos)
summary(bos)


# 탐색적 분석
plot(bos[,c(1:13, 14)])

ctab = round(cor(bos), 3)
write.table(ctab, "clipboard")

par(mfrow=c(1,2))
hist(bos$medv, main="Density of Median (medv)")
plot(density(bos$medv), main="Density of Median (medv)")


# 학습 모델 만들기

# 주어진 데이터로 선형 모델을 만든다
lm.m <- function(tbl) {
  lm(medv ~ crim + zn + indus + chas + nox + rm + age +
       dis + rad + tax + ptratio + black + lstat, tbl)
}

# 주어진 데이터로 의사결정트리 모델을 만든다
rpart.m <- function(tbl) {
  rpart(medv ~ crim + zn + indus + chas + nox + rm + age +
          dis + rad + tax + ptratio + black + lstat, tbl)
}

# 주어진 데이터로 랜덤포레스트 모델을 만든다
randomForest.m <- function(tbl) {
  randomForest(medv ~ crim + zn + indus + chas + nox + rm + age +
                 dis + rad + tax + ptratio + black + lstat, tbl)
}


lm1 = lm.m(bos)
barplot(lm1$coefficients)

rp1 = rpart.m(bos)
plot(rp1)
text(rp1)

rf1 = randomForest.m(bos)
par(mfrow=c(1,2))
plot(rf1, log="y", main="Error Rate ~ # of Trees")
varImpPlot(rf1, main="Variable Importance")


# 학습 모델 평가하기

# 주어진 데이터를 k개로 나누어 교차검증을 수행
cval.model <- function(cvt, fun.model, k, ...)
{
  # 원본 데이터의 각 항목에 1~k까지의 숫자를 배정
  cvt$fold = sample(1:k, nrow(cvt), replace=T)
  
  # 각 fold의 학습 모델을 만들어 결과를 모음
  adply(1:k, 1, function(i) {
    cvtr = cvt[cvt$fold != i,]  # 학습 데이터
    cvte = cvt[cvt$fold == i,]  # 평가 데이터
    cvte$res = predict(fun.model(cvtr, ...), cvte)
    cvte
  })
}

# 3차 교차검증을 세가지 모델에 대해 수행
crt1 = cval.model(bos, lm.m, 3)
crt2 = cval.model(bos, rpart.m, 3)
crt3 = cval.model(bos, randomForest.m, 3)
head(crt3)

# RMSE지표를 계산
rmse <- function(c1, c2) {
  sqrt(mean((c1 - c2) ^ 2))
}
# 세 모델의 교차검증 결과에 대한 RMSE를 계산
rmse(crt1$medv, crt1$res)
rmse(crt2$medv, crt2$res)
rmse(crt3$medv, crt3$res)

par(mfrow=c(1,3))
plot(crt1$medv, crt1$res, ylim=c(0,50),
     xlab="Actual", ylab="Predicted", main="Linear Regression")
lines(loess.smooth(crt1$medv, crt1$res))
plot(crt2$medv, crt2$res, ylim=c(0,50),
     xlab="Actual", ylab="Predicted", main="Decision Tree")
lines(loess.smooth(crt2$medv, crt2$res))
plot(crt3$medv, crt3$res, ylim=c(0,50),
     xlab="Actual", ylab="Predicted", main="RandomForest")
lines(loess.smooth(crt3$medv, crt3$res))
