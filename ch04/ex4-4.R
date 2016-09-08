# 통계적 추론

source("dbook.R")
load.packages(c("dplyr", "ggplot2", "tidyr", "knitr"))

ht = read.table("fba.txt", header = T)
head(ht)

# 탐색적 분석
par(mfrow=c(1,2))
plot(ht$Air, xlab="Trial", ylab="Distance (air-filled)")
lines(supsmu(ht$Trial, ht$Air))
plot(ht$Helium, xlab="Trial", ylab="Distance (helium-filled)")
lines(supsmu(ht$Trial, ht$Helium))

# 데이터 가공하기
ht$Diff = ht$Helium - ht$Air
htf = filter(ht, Air >= 15 & Helium >= 15)
head(htf)

nrow(ht)
nrow(htf)

# 통계적 추론

# 전체 데이터에 대한 통계적 추론 ()
t.test(ht$Air, ht$Helium)

# 전체 데이터에 대한 통계적 추론 (대응 표본)
t.test(ht$Air, ht$Helium, paired = T)

# 가공된 부분 데이터에 대한 통계적 추론 (대응 표본)
t.test(htf$Air, htf$Helium, paired = T)
