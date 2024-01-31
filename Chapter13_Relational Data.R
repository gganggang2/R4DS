library(tidyverse)
library(nycflights13)

airlines
airports
planes
weather

# Find A Primary Key : 고유 정보를 가지지 못하면 안 된다
planes %>% 
  count(tailnum) %>% 
  filter(n > 1) %>% 
  nrow()
weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1) %>% 
  nrow()
flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

#13.3.1
flights %>% 
  mutate(surrogate = row_number()) %>% 
  select(surrogate, everything()) # 내가 더 잘했당

#13.4 Mutating Joins
flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")

flights2 %>% 
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# inner join only includes the intersection of x,y ; easy to lose the observations
# outer join : include NA observations, too.
# natural join : by = NULL 쓰면 그냥 두 개가 붙는다. 자동으로!

flights2 %>% 
  left_join(planes, by = "tailnum")
# 이렇게 하면 서로 다른 years는 그냥 years.x / years.y로 자동 분류되는 듯?

glimpse(flights2$dest)
glimpse(airports$faa)
glimpse(airports)

#13.4.1
airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

avg_dest_delays <-
  flights %>%
  group_by(dest) %>% # Destination으로 묶고
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>% #Destination 별 Mean 구하고 결측값 제거
  inner_join(airports, by = c(dest = "faa"))

avg_dest_delays %>%
  ggplot(aes(lon, lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# suffix를 이용해서 column 이름을 명확하게 할 수 있음. .x랑 .y 같은거 붙이지 말고
# 아무리 봐도 실전에서 이거를 스스로 생각해보고 푸는 연습을 해야할 것 같다.

# 13.5 Filtering Joins
# Semi Join은 짝이 있는 경우에 대한 기존의 x값을 보여줌. filtering 하는 것 같음
# Anti Join은 짝이 있는 거 빼고 다 구함 > Match가 없는 짝을 구할 때 주로 사용.

#13.5.1 
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

flights %>% 
  count(is.na(arr_time))
flights %>% 
  filter(is.na(tailnum), !is.na(arr_time)) %>% 
  nrow()
# tailnum이 na인 것 중 arr_time이 na가 아닌 건 없다.

#13.5.2
planes_gte100 <- flights %>% 
  filter(!is.na(tailnum)) %>% #tailnum = NA 거르기
  group_by(tailnum) %>% 
  count() %>% 
  filter(n >= 100)
flights %>% 
  semi_join(planes_gte100, by = "tailnum")

#13.5.5
anti_join(flights, airports, by = c("dest" = "faa")) %>% 
  distinct(dest)
# 이하 4개의 dest는 FAA에 등록되지 않은 목적지

anti_join(airports, flights, by = c("faa" = "dest"))

#13.5.6
planes_carriers <-
  flights %>%
  filter(!is.na(tailnum)) %>%
  distinct(tailnum, carrier)
planes_carriers

planes_carriers %>%
  count(tailnum) %>%
  filter(n > 1) %>%
  nrow() # 17개 나오는데 하나의 tailnum을 두 놈이 운행한다는 뜻임

carrier_transfer_tbl <- planes_carriers %>%
  # keep only planes which have flown for more than one airline
  group_by(tailnum) %>%
  filter(n() > 1) %>% 
  left_join(airlines, by = "carrier") %>% 
  arrange(tailnum, carrier)
carrier_transfer_tbl

# Semi Join과 Inner Join의 차이 : Semi Join은 x - y match 하고 x만 표현.. inner join은 x + y 임. 말 그대로 semijoin은 filtering 용임
# Left/Right Join은 한 쪽은 무조건 다 내보냄. 반대쪽 모자른 건 NA
# SQL 공부하자.
