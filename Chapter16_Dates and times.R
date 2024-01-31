library(tidyverse)
library(lubridate)
library(nycflights13)

# From strings
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131)
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")
ymd(20170131, tz = "UTC")

# From individual components
flights %>% # dttm
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))
flights %>% # date
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_date(year, month, day))

make_datetime_100 <- function(year, month, day, time){make_datetime(year, month, day, time %/% 100, time %% 100)}
flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime_100(year, month, day, dep_time),
    arr_time = make_datetime_100(year, month, day, arr_time),
    sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
    sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))
head(flights_dt)

flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400) # 86400s = 1 day

flights_dt %>% 
  filter(dep_time < ymd(20130102)) %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 600) # 600s = 10 min
# This means that binwidth = 1 : 1s

as_date(365 * 10 + 2) # date니까 date 단위로 적용되는 것임
as_datetime(60 * 60 * 10) # 10시간 : 이거는 seconds 단위.. time에서부터 시작

#16.2 ex
ret <- ymd(c("2010-10-10", "bananas"))
print(class(ret))
ret # Warning!

now(tzone = "US") # tzone이 specify됨에 따라 결과물이 달라져용~

datetime <- ymd_hms("2016-07-08 12:34:56")
datetime
#mday : day of the month (which we typically use)
#yday : day of the year, wday : day of the week (요일)
month(datetime, label = TRUE, abbr = FALSE)
wday(datetime, label = TRUE, abbr = FALSE)

flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()

flights_dt %>% 
  mutate(minute = minute(dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, avg_delay)) +
  geom_line()

sched_dep <- flights_dt %>% 
  mutate(minute = minute(sched_dep_time)) %>% 
  group_by(minute) %>% 
  summarise(
    avg_delay = mean(arr_delay, na.rm = TRUE),
    n = n()) 
ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

# dep_time / sched_dep_time 다른 이유? 실제로 depart할 때는 nice한 dep time에 뜨려는 심리적 요인..?

ggplot(sched_dep, aes(minute, n)) +
  geom_line() # 0/15/30/45분에 압도적

flights_dt %>% 
  count(week = floor_date(dep_time, "week")) %>%  # 그냥 시간 반올림 기능인듯?
  ggplot(aes(week, n)) +
  geom_line()

flights_dt %>% 
  count(week = date(dep_time)) %>% #위에 것에 비해 매우 복잡함
  ggplot(aes(week, n)) +
  geom_line() 

update(datetime, year = 2020, month = 2, mday = 2, hour = 2)
ymd("2015-02-01") %>% 
  update(hour = 400)

view(flights_dt)
flights_dt %>% 
  mutate(dep_hour = update(dep_time, yday = 1)) %>% 
  ggplot(aes(dep_hour)) + 
  geom_freqpoly(binwidth = 300)
# 시간 정보만 활용하기 위해서 yday를 일부러 맞춘 것 같음

#16.3 ex
flights_dt %>%
  filter(!is.na(dep_time)) %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  mutate(month = factor(month(dep_time))) %>%
  ggplot(aes(dep_hour, color = month)) +
  geom_freqpoly(binwidth = 60 * 60)

flights_dt %>%
  mutate(dow = wday(sched_dep_time)) %>%
  group_by(dow) %>%
  summarise(
    dep_delay = mean(dep_delay),
    arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  print(n = Inf) # What this means?

wday(today()) # Sunday가 1이구나

flights_dt %>% 
  mutate(minute = minute(dep_time),
         early = dep_delay < 0) %>% 
  group_by(minute) %>% 
  summarise(
    early = mean(early, na.rm = TRUE),
    n = n()) %>% 
  ggplot(aes(minute, early)) +
  geom_line()

h_age <- today() - ymd(19791014)
h_age
as.duration(h_age)
ddays(0:5) # d series form duration

tomorrow <- today() + ddays(1)
tomorrow
today() + 1 # 뭐가 다른거징
today() + dyears(1)
today() + 1 # day가 더해지는 기본값이라 그런거군
today() + ddays(1)

# Just simply use periods: human-familiar!
10 * (months(6) + days(1))

ymd("2016-01-01") + dyears(1)
ymd("2016-01-01") + years(1)

flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  ) # 이미 이 식을 쓰면서 조정된 결과라 FALSE가 전부임
flights_dt %>% 
  filter(overnight, arr_time < dep_time) 

next_year <- today() + years(1)
(today() %--% next_year) / ddays(1)
(today() %--% next_year) %/% days(1)

#16.4 ex
dmonths(2) # 얘는 duration일 수 없음.. 달마다 날짜 다름 
months(2) # possible

ymd("2015-01-01") + months(0:11) # 이런 계산이 되는구나
floor_date(today(), unit = "year") + months(0:11) 

age <- function(bday){(bday %--% today()) %/% years(1)}
age(ymd("1999-02-01")) # Yes I am 24 years old in US ! haha

(today() %--% (today() + years(1))) / months(1)
(today() %--% (today() + years(1))) / days(30)

# TimeZone
Sys.timezone()
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Asia/Seoul"))
x1 - x2
x2 - x1
# with_tz 쓰면 +hm으로 표기하고 시간 변화는 X (실제 시간은 같은 셈임)
# force_tz 쓰면 represented된 시간에 차이가 생겨서 명시된 시간이 그대로 타임존으로 옮겨감. 시차 발생.

