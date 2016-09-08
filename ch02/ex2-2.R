# R의 기본기능

# 데이터 읽고 쓰기
summary(mtcars)

write.table(mtcars, "mtcars_new.txt")
cars = read.table("mtcars_new.txt", header=T)

write.table(cars, "clipboard")

# 데이터 살펴보기
head(cars)

head(cars, n=10)

tail(cars)

rownames(cars)
colnames(cars)

cars$mpg
