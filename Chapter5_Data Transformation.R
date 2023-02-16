library(nycflights13)
library(tidyverse)
glimpse(flights) #If you want to see as a table, use view(flights)

#5.2 Filter()
sqrt(2) ^ 2 = 2 # This makes an error
sqrt(2) ^ 2 == 2 # This results FALSE
near(sqrt(2) ^ 2, 2) # This results TRUE, since R calculate this precisely.

filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))

df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)

#5.2.1
filter(flights, dest %in% c("IAH", "HOU")) #2
filter(flights, month == 7 | month == 8 | month == 9) #4
filter(flights, dep_delay >= 60 & dep_delay - arr_delay > 30) #6

#5.2.2
filter(flights, between(month, 7,9))

#5.2.3
filter(flights, is.na(dep_time))

#5.2.4
Inf * 0 # This is a counterexample of Na * 0 != 0

#5.3 Arrange() : Default value is ascending... use desc().
#5.3.1
arrange(flights, desc(is.na(dep_time))) # Since missing value always comes to the last.
arrange(df, desc(is.na(x)))
arrange(df, desc(is.na(x)), desc(x))
#5.3.2
arrange(flights, desc(dep_delay))
#5.3.3
head(arrange(flights, desc(distance / air_time))) # This computation also works
#5.3.4
head(arrange(flights, desc(distance)))

#5.4 Select()
rename(flights, tail_num = tailnum) # Use rename() rather than select() IF you want to change the name of variable.
summary(flights$tailnum)
summary(flights$tail_num)
select(flights, time_hour, air_time, everything()) #Use Everything to reorder
select(flights, time_hour)

#5.4.1 : There are many different methods to utilize select()
#5.4.3 : difference between all_of(), one_of(), any_of()
#If Variable name is overlapped (Vector, Variable) R will recognize the vars as a column name first. To avoid this, use !!! in front of the vector.
#5.4.4
select(flights, contains("TIME")) #This is the issue of CAPITALIZATION. But it works! to avoid this insensitivity, use 'ignore.case = FALSE'.

#5.5 Mutate()
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
) # Select the columns that I want

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60)
# Add new variable that I want (added in back side)

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
) # Keep the new variables only

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
) # %/% means Quotient, %% means the mod.

#5.5.1
head(flights$dep_time)
transmute(flights, 
          new_dep_time = (dep_time %/% 100) * 60 + dep_time %% 100,
          new_sched_dep_time = (sched_dep_time %/% 100) * 60 + sched_dep_time %% 100)

#5.5.2
head(flights$air_time)
head(flights$arr_time - flights$dep_time)
select(flights, air_time, arr_time, dep_time)
# Problem is that air_time is a pure duration; arr_time and dep_time mean real-time.

#5.5.3
select(flights, dep_time, sched_dep_time, dep_delay)

#5.5.4
# min_rank : same value = same rank, all count ( 1 2 2 2 5)
# dense_rank : same value = same rank, but they are counted by 1 (1 2 2 2 3)

#5.5.5
1:3 + 1:10

#5.5.6 What trigonometric ft can we use : sin, cos, tan, sinpi, cospi, tanpi, asin, acos, atan...

#5.6 Summarise()
by_day <- group_by(flights, year, month, day)
head(by_day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))
# Use summarize with group_by ... It would be useful.
# What is na.rm ? missing values?

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
) # Summarize has a grouped output.
delay <- filter(delay, count > 20, dest != "HNL")
delay

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  filter(count > 20, dest != "HNL")
delays # %>% means 'THEN'

# How to remove missing values? : Make new data which is filtered by !is.na(x).
# is.na means, is this na value? na.rm means, would you like to remove(rm) na values?
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
delays

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay),
    n = n() # add on the count of each group
  )
delays

#cmd + shift + P
#Alt + Shift + K 

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
    )

daily <- group_by(flights, year, month, day)
per_day <- summarize(daily, flights = n())
per_day
per_month <- summarize(per_day, flights = sum(flights))
per_month
per_year <- summarize(per_month, flights = sum(flights))
per_year
# Summarize peel off each of the level

daily %>% 
  ungroup() %>%
  summarise(flights = n()) # Ungrouping

count(flights) # same as above!

#5.6.2
not_cancelled %>%
  count(dest) # categorized by dest.. 
not_cancelled %>%
  group_by(dest) %>%
  
not_cancelled %>% 
  count(tailnum, wt = distance)
not_cancelled %>%
  group_by(tailnum) %>%
  summarize(n = sum(distance))
# You can also use 'tally'.

flights %>% 
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarize(cancelled_num = sum(cancelled), flights_num = n())

flights %>%
  filter(is.na(arr_delay) | is.na(dep_delay)) %>%
  group_by(year, month, day) %>%
  summarize(flights_num = n())

flights %>%
  filter(is.na(arr_delay) | is.na(dep_delay)) %>%
  summarize(n = n())

#5.6.5
dest_bad <- flights %>% group_by(carrier, dest) %>% summarise(n())
dest_bad
carrier_bad <- summarize(dest_bad, n = n())
arrange(carrier_bad, n) # EV is the worst Carrier.
dest_bad
real_dest_bad <- dest_bad %>% group_by(dest) %>% summarize(n = n())
real_dest_bad %>% arrange(desc(n)) # ATL, BOS, CLT, ORD, TPA...
# Have to use 'mean of delay time'?

#5.6.6
flights %>%
  count(dest, sort = TRUE) # Sort arranges the data in descending order.
# To be noticed that Summarize is useful with group_by.

#5.7 Grouped Mutates
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365) %>%
  select(dest, everything())
popular_dests

popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay) # Is this meaningful info?

#5.7.4
flights %>%
  filter(!is.na(arr_delay & dep_delay)) %>%
  group_by(dest) %>%
  summarize(total_delay = sum(arr_delay) + sum(dep_delay))

flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    arr_delay_prop = arr_delay / arr_delay_total
  ) %>%
  select(dest,arr_delay_total,
         arr_delay, arr_delay_prop) %>%
  arrange(dest, desc(arr_delay_prop))
# Group 이후에 Mutate 했으니까 sum(arr_delay)의 적용 범위는 dest에 국한됨. 
# This means that... 그래도 별로 의미 없는 결과인 것 같은데?

# 원리는 어느 정도 이해를 했으니까 5.7 Exercise 는 일단 Keep.
# cmd + shift + s : run all over the code?