library(tidyverse)

# Factor 이란 범주형 Variable을 칭하는 것 같다.
x1 <- c("Dec", "Apr", "Jan", "Mar")
x1
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
y1 <- factor(x1, levels = month_levels)
y1
sort(y1)
x2 <- c("Dec", "Apr", "Jam", "Mar")
y2 <- factor(x2, levels = month_levels)
y2
sort(y2)
factor(x1) # omit levels -> alphabetical order
# parse_factor makes a warning instead of representing NA.
f1 <- factor(x1, levels = unique(x1))
f1
levels(f1)
levels(y1)

gss_cat
class(gss_cat)
summary(gss_cat)
glimpse(gss_cat)
gss_cat %>% 
  count(race)
ggplot(gss_cat, aes(race)) +
  geom_bar()

ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

rincome <- ggplot(gss_cat, aes(rincome)) +
  geom_bar()
gss_cat %>% 
  count(rincome)
rincome +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
rincome + coord_flip() # 그래 요고딩

gss_cat %>% 
  count(relig) %>% 
  arrange(desc(n))

gss_cat %>% 
  count(partyid) %>% 
  arrange(desc(n))

levels(gss_cat$denom)

gss_cat %>% 
  filter(!denom %in% c("No answer", "Don't know", "No denomination", "Other", "Not applicable")) %>% 
  count(relig)

# Scatterplot 그려서 체크하기
gss_cat %>%
  count(relig, denom) %>%
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90))

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
relig_summary
ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point() # 범주형 변수 reorder을 통해 가시성 up

relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()
ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable", after = 6L ))) +
  geom_point() # fct_relevel 하면 원하는 factor을 아무 위치로나 이동 가능

by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>% 
  mutate(prop = n / sum(n))

# 그래프 오른쪽 끝에 맞추어 정렬하는 법
ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)
ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() + 
  labs(colour = "marital")

gss_cat$marital
gss_cat %>% 
  mutate(marital = marital %>% 
           fct_infreq() %>% # 여기서 크기순 정렬
           fct_rev()) %>% # 이거는 오름차 내림차
  ggplot(aes(marital)) +
  geom_bar()

gss_cat %>% count(partyid)

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong"    = "Strong republican",
                              "Republican, weak"      = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak"        = "Not str democrat",
                              "Democrat, strong"      = "Strong democrat",
                              "Other"                 = "No answer",
                              "Other"                 = "Don't know",
                              "Other"                 = "Other party"
  )) %>%
  count(partyid) # 이거를 Others로 합칠 수가 있음.. Recode의 용이성

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
                                other = c("No answer", "Don't know", "Other party"),
                                rep = c("Strong republican", "Not str republican"),
                                ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                                dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid) # fct_collapse 이게 최강인데? recode보다?

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>% 
  count(relig) # 제일 빈도 높은 거 빼고 다 묶어버림

# over-collapse되는 경우를 방지하기 위해 n = ? 걸어주기
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>% 
  print(n = Inf)

#15.5 ex
gss_cat %>%
  mutate(
    partyid =
      fct_collapse(partyid,
                   other = c("No answer", "Don't know", "Other party"),
                   rep = c("Strong republican", "Not str republican"),
                   ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                   dem = c("Not str democrat", "Strong democrat")
      )
  ) %>%
  count(year, partyid) %>%
  group_by(year) %>%
  mutate(p = n / sum(n)) %>%
  ggplot(aes(
    x = year, y = p,
    colour = fct_reorder2(partyid, year, p)
  )) +  # fct_reorder2(y, x) 순이다. y가 종속.
  geom_point() +
  geom_line() +
  labs(colour = "Party ID.")

levels(gss_cat$rincome)

#15.4 ex
summary(gss_cat$tvhours)
gss_cat %>% 
  filter(!is.na(tvhours)) %>% 
  ggplot(aes(x = tvhours)) +
  geom_histogram(binwidth = 1)

keep(gss_cat, is.factor) %>% names()
levels(gss_cat$marital)
levels(gss_cat$race)
