# 분류 실습

source("dbook.R")
load.packages(c("ggplot2", "rpart", "rpart.plot"))

train <- read.csv("titanic_train.csv")
test <- read.csv("titanic_test.csv")


# 개별 속성 분석
summary(train)
table(train$Survived)

par(mfrow=c(1,2))
plot(density(train$Fare), main="", xlab="Fare Distribution")
plot(density(train[!is.na(train$Age),]$Age), main="", xlab="Age Distribution")


# 속성간 관계 분석
par(mfrow=c(1,2))
mosaicplot(table(ifelse(train$Survived==1, "Survived", "Dead"), train$Sex), main="", cex=1.2)
mosaicplot(table(ifelse(train$Survived==1, "Survived", "Dead"), train$Pclass), main="", cex=1.2)

par(mfrow=c(1,2))
boxplot(Age ~ Survived, train, xlab="Survival", ylab="Age", cex=1.2)
plot(Age ~ jitter(Survived), train, cex=1.2)

qplot(jitter(Age), jitter(log(Fare)), data=train, color=factor(Survived), shape=factor(Sex))


# 모델 만들기
fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data=train, method="class")
rpart.plot(fit)

Prediction <- predict(fit, test, type="class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = Prediction)
head(submit)

write.csv(submit, file="titanic_submission.tsv", row.names=FALSE)
