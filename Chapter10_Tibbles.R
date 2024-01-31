library(tidyverse)
iris
summary(iris)
count(iris)
as_tibble(iris) # tibble 데이터로 변환

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  '2000' = "number"
)
tb # 이 ``(Backsticks)는 column name을 의미할 때 쓰면 되겠구만!

tribble(
  ~x, ~y, ~z,
  "a", 2, 3.6,
  "b", 1, 8.5
) # 그냥 있는 그대로 Matrix 만들 때 편한 듯? Of course in a small amount of DATA

nycflights13::flights %>% 
  print(n = 10, width = Inf) # print 10 rows, infinite columns (all columns)

nycflights13::flights %>% 
  View()

df <- tibble(
  x = runif(5),
  y = rnorm(5)
) # 균등분포 5개, 정규분포 5개 임의추출?

df$x
df$y
df[["x"]]
df[[1]] # [[를 이용하면 위치도 입력 가능함
df %>% .$x # If you want to connect by pipe, use special placeholder : .

#10.1 
mtcars
as_tibble(mtcars)
is_tibble(mtcars)
is_tibble(as_tibble(mtcars))
class(mtcars) # 해당 개체의 Class 측정하는 방법 드디어 찾았당

#10.4
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying
annoying$"1" # 얘가 왜 되는지 모르겠네
annoying[[1]] # 얘는 위치 기준으로 뽑는거
annoying[["1"]] # 얘가 정상임 Column name
annoying$`1` # Backsticks 확인.

ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

mutate(annoying, `3` = `2` / `1`)
annoying
annoying[["3"]] = annoying[["2"]] / annoying[["1"]]
annoying

annoying <-  rename(annoying, one = `1`, two = `2`, three = `3`)
annoying
annoying <- rename(annoying, ggang = one, gggang = two, ggggang = three)
annoying

#10.5
enframe(c(a = 1, b = 2, c = 3))
