# 데이터 집계하기

# 종교 집단에 따라 총 신자 수 및 평균 소득
pew.agg = pew.tidy %>%                                            # 원본 데이터를
  group_by(religion) %>%                                          # religion을 기준으로 그룹화하고
  summarise(total.count = sum(count),                             # 전체 교인의 명수와
            avg.income.usd = mean(income.usd*count) / sum(count)) # 평균 소득을 계산한다.
head(pew.agg)

# 종교별 전체 교인의 수 차트
q1 = qplot(x=religion, y=total.count, data=pew.agg, geom="bar",   # 차트의 XY축과 데이터 및 형태를 지정한다.
           width=0.5, stat="identity") + coord_flip()             # 차트의 세부 모양과 방향을 지정한다.

# 종교별 평균 소득 플롯
q2 = qplot(x=religion, y=avg.income.usd, data=pew.agg, geom="bar",
           width=0.5, stat="identity") + coord_flip()

# 위에서 만든 두개의 플롯을 한 화면에 출력한다. (cols는 열의 개수)
multiplot(q1, q2, cols=2)
