library(tidyverse)
# What type of variation occurs within my variables?
# What type of covariation occurs between my variables?

#7.3 Variation
diamonds %>%
  count(cut) # Simply count the variable of the data

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
diamonds %>% 
  count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3) # Reduce the range of data 
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) # Smaller Plotting

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1) # Overlay the graph

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01) # Smalelr Binwidth

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25) # What is the relationship btw two clusters?

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) + # Where is Outliers?
  coord_cartesian(ylim = c(0, 50)) # 좌표평면 크기 제한 (ylim) ! You can also use (xlim).

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual

#7.3.3
carot_99 <- diamonds %>%
  filter(carat == c(0.99, 1)) %>%
  count(carat)
carot_99 # 답지랑 결과가 다른데 반올림 하고 안하고의 차이? 자동 반올림임?

#7.4 Missing Values
diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y)) # ifelse 구문 사용, 액셀과 비슷함

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point() # 결측값 알아서 없애줌... 근데 Warning에 표시함! 없애고 싶으면 na.rm = TRUE 사용

nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time), # 논리 구문 사용해서 결측값 분리
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60 # n.n 형태로 시간 변환
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4) # 논리값에 따라 분리되도록 매핑

#7.4.1
ggplot(diamonds2, aes(x = y)) +
  geom_histogram() # It provides a warning message that the data have non-finite values.
# geom_bar, in a discrete case, treats NA as a new category of the variable.
# This is because histogram needs numeric values, hence it treats NA as a missing value. However, Bar_chart recognize this as a character.

#7.4.2
mean(c(0, 1, 2, NA))
mean(c(0, 1, 2, NA), na.rm = TRUE) # na.rm removes the NA, which facilitate the computation.

#7.5 Covariation
#7.5.1 Categorical - Continuous

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut)) # Hard to compare...
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500) # Density ft makes easy to compare.

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot() # Using Boxplots
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median, decreasing = TRUE), y = hwy)) + # class를 hwy의 median을 기준으로 reorder 한다. 내림차순 할 거면 decreasing?
  coord_flip() # Change the direction (Transpose)

#7.5.1.3
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(y = reorder(class, hwy, FUN = median), x = hwy), orientation = "y")
# 그러나 ggplot 이제는 방향 인식 잘해서 딱히 걱정할 필요 없음. Orientation이라는 구문만 알아두기.

#7.5.2 Categorical - Categorical
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>% 
  count(color, cut) %>%  # 알아서 group_by 되는듯?
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n)) # fill aesthetic 넣어야 함. DATA SIZE 커지면 Heatmap

#7.5.3 Conti - Conti
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 1/100) # Alpha is transparency
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price)) # bin2d : Rectangular bins. by install hexbin package, you can also use geom_hex.

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1))) # Conti - Conti plot. 
# You can use conti variable by grouping interval, by cut_width, then it can work as Categorical variable.
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 10)))
# Cut number은 전체 data range를 20등분하여 각각 같은 수의 data가 들어가게끔 한다.

#7.5.3.2
diamonds %>%
  ggplot(mapping = aes(x = cut_number(price, 10), y = carat)) + 
  geom_boxplot() + 
  coord_flip() # 어떻게 해야 원하는 그림이 나올지 고민해보고 하자!

ggplot(diamonds, aes(x = cut_width(price, 2000, boundary = 0), y = carat)) +
  geom_boxplot(varwidth = TRUE) +
  coord_flip() # boundary = 0 ensures that the first bin is 0$ ~ 2000$.

#7.5.3.4
diamonds %>%
  ggplot(mapping = aes(x = carat, y = price, color = cut)) +
           geom_smooth(se = FALSE)

ggplot(diamonds, aes(x = cut_number(carat, 5), y = price, colour = cut)) +
  geom_boxplot() # Solution ans

ggplot(diamonds, aes(colour = cut_number(carat, 5), y = price, x = cut)) +
  geom_boxplot() # Solution ans

#7.5.3.5
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

#7.6 Patterns and models
# It may have some patterns... related to covariates.

#7.7 ggplot calls
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_freqpoly(binwidth = 0.25)

ggplot(faithful, aes(eruptions)) + 
  geom_freqpoly(binwidth = 0.25) # 이제는 단순화하겠다.
