library("tidyverse")
library(tidyverse)

table1
table3

table1 %>%
  mutate(rate = cases / population * 10000)

table1 %>%
  count(year, wt = cases)

library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

#12.2.2
table2 %>%
  group_by(type) %>%
  summarize(count = count)

t2_cases <- filter(table2, type == "cases") %>%
  rename(cases = count) %>%
  arrange(country, year) # 왜 한 번에 쳐야지만 되는거?

t2_population <- filter(table2, type == "population") %>%
  rename(population = count) %>%
  arrange(country, year)
t2_population

t2_cases_per_cap <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
)

t2_cases_per_cap

t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(cases_per_cap = (cases / population) * 10000) %>%
  select(country, year, cases_per_cap)
t2_cases_per_cap

t2_cases_per_cap <- t2_cases_per_cap %>%
  mutate(type = "cases_per_cap") %>%
  rename(count = cases_per_cap)
t2_cases_per_cap
table2
bind_rows(table2, t2_cases_per_cap) %>%
  arrange(country, year, type, count)

table4a
table4b
table4c <- tibble(country = table4a$country,
                  `1999` = table4a[["1999"]] / table4b[["1999"]] * 10000,
                  `2000` = table4a[["2000"]] / table4b[["2000"]] * 10000)
table4c # `1999` means the name of column... 저게 Chr 표시인가?

#12.2.3
table1
table2
table2 %>%
  filter(type == "cases") %>% # cases 정보만 필요하니까 추출
  ggplot(aes(year, count)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country)) +
  ylab("cases")

#12.3 Pivoting
table4a
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
table4b %>%
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
table4b  

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b) # left_join 이용해서 합쳐보리기
#pivot_longer은 위아래로 길게 만드는 효과가 있는 듯 함

table2
table2 %>%
  pivot_wider(names_from = type, values_from = count)
# names_from이니까 어디에서 column name을 가져온다는 의미. names_to는 c( , )에 해당되는 column을 year column 하에 배치한다는 의미.

#12.3.3
people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)
people
people %>%
  pivot_wider(names_from = "name", values_from = "values")
people

people2 <- people %>%
  group_by(name, names) %>%
  mutate(obs = row_number())
people2

people2 %>%
  pivot_wider(names_from = "name", values_from = "values")

#12.3.4
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes", NA, 10,
  "no", 20, 12
)
preg
preg_tidy2 <- preg %>%
  pivot_longer(c(male, female), names_to = "sex", values_to = "count", values_drop_na = TRUE)
preg_tidy2 # Pivot_longer 한 다음에 NA Drop 시켜버리기

#12.4 Separating and Uniting
table3
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)
# Convert = TRUE를 입력함으로써 chr 아닌 int type으로 변수 변환 가능

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)
# sep 의 기능은 양수 쓰면 왼쪽으로부터 몇 칸까지 끊음 (left 함수 같은거)

table5
table5 %>% 
  unite(new, century, year, sep = "")

#12.4.1 
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "drop")
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "right")

#12.4.3
tibble(x = c("X1", "X20", "AA11", "AA2")) %>%
  extract(x, c("variable", "id"), regex = "([A-Z]+)([0-9]+)")

# Separate, Extract, Unite 모두 한 개의 column을 분해하거나, 한 개의 column으로 융합하는 기능

#12.5 Missing Values
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(cols = c(`2015`, `2016`), 
               names_to = "year", values_to = "return", 
               values_drop_na = TRUE) # drop_na = TRUE 지정해야 NA가 생략됨

stocks %>% 
  complete(year, qtr, fill = list(return = 0)) # Complete 쓰면 NA를 Explicitly 표현하여 가능한 모든 조합 표현
# Complete 에서 결측값 처리하는 방법!

treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment %>%
  fill(person, .direction = "up") # fill + column 쓰면 가장 최근에 결측값 아닌 걸 복붙함
# direction 쓰면 채우는 방향 변경 가능함.

#12.6 Case Study

who
glimpse(who)
view(who) # Data 가 있기는 한 걸 확인함

who1 <- who %>%
  pivot_longer(
    cols = new_sp_m014:newrel_f65,
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  )
who1 # 이 과정을 통해 결측값이 과하게 많다고 판단되는 열들은 하나로 합쳐버리고 결측값은 제거함

who1 %>%
  count(key) %>%
  print(n = 100) # newrel의 문제점 확인

who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2 %>%
  count(key) %>% 
  print(n = 100) # check complete.

who3 <- who2 %>% 
  separate(key, c("new", "type", "sexage"), sep = "_")
who3 # sep "_" 기호를 이용하여 column 분할도 가능함~~ 베리굿~~

who3 %>% 
  count(new)

who4 <- who3 %>% 
  select(-new, -iso2, -iso3) # 저것들을 제외하고 셀렉한다는 뜻
who4

who5 <- who4 %>% 
  separate(sexage, c("sex", "age"), sep = 1)
who5

# 이거 함수 다 손에 익으려면 시간이 꽤 필요하겠는걸

#12.6.1
view(who) # 0이 없으면 NA가 0을 의미하는 것일 수 있음.
who1 %>% 
  filter(cases == 0) %>%
  nrow()

#12.6.4
who5
who5 %>% 
  group_by(country, year, sex) %>% 
  filter(year > 1995) %>% 
  summarize(cases = sum(cases)) %>% 
  unite(country_sex, country, sex, remove = FALSE, sep = "/") %>% 
  ggplot(aes(x = year, y = cases, group = country_sex, colour = sex)) +
  geom_line()

