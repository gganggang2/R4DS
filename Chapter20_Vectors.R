library(tidyverse)

typeof(letters)
typeof(1:10)

2L # type : integer
# 참고로 Double이 실수임

is.infinite(NA)
is.na(NA)
is.na(NaN)
is.nan(NA)

is.finite(3)
!is.infinite(3)
!is.infinite(Inf)
is.finite(Inf)
is.finite(NA)
!is.infinite(NA)
# NA에서 차이가 나는 것을 알 수 있음. 당연하긴 함

dplyr::near
.Machine$integer.max + 1L
as.numeric(.Machine$integer.max) + 1


# 20.4 --------------------------------------------------------------------
x <- sample(20, 100, replace = TRUE)
y <- x > 10
sum(y)
mean(y)

sample(10, 5) + 100
runif(10, 0, 2) > 0.5
1:10 + 1:2
# 이런 황당한 예시가 굴러가는 것처럼 scalar 개념이 따로 없는 R에선 그냥 알아서 벡터화된다.

tibble(x = 1:6, y = rep(1:2, each = 3))

x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
x[1]
x[-1]          
x <- c(10, 3, NA, 5, 8, 1, NA)
x[x %% 2 == 0]
x <- c(abc = 1, def = 2, xyz = 5)
x 
x[c("xyz", "def")]
x[[1]]
x[1]

?toupper

x <- c(-1:1, Inf, -Inf, NaN, NA)
x[-which(x > 0)]
x[x <= 0]
# 다르게 나오는 이유 : NaN이 0보다 작은지를 비교하는 건 NA(Not Available)이기 때문
which(x > 0) # index 출력, 즉 -붙으면 해당 index 제외하고 출력


# 20.5 --------------------------------------------------------------------

x <- list(1,2,3)
str(x)
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)

y <- list("a", 1L, 1.5, TRUE)
str(y)

z <- list(list(1, 2), list(3, 4))
str(z)

a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
a
str(a[1:2])
str(a[4])
a$a
a[[1]]
a[["a"]] # Get a Same Result

# 20.6 --------------------------------------------------------------------

x <- 1:10
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)

x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
attributes(x)
x

x <- as.Date("1971-01-01")
unclass(x)
typeof(x)
attributes(x)

x <- lubridate::ymd_hm("1970-01-01 01:00")
unclass(x)
attr(x, "tzone")
typeof(x)
attributes(x)
attr(x, "tzone") <- "US/Pacific"
x
attr(x, "tzone") <- "US/Eastern"
x
attributes(x)

tb <- tibble::tibble(x = 1:5, y = 5:1)
typeof(tb)
tb
attributes(tb)

df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
attributes(df)

hms::hms(3600)

tibble::tibble(x = 1:2, y = 4:1)

tibb <- tibble(x = 1:3, y = list("a", 1, list(1:3)))
tibb
tibb[[1]]
tibb[1]
tibb[3]
tibb[[2]]
tibb[[2]][[3]]
tibb[[2]][[3]][[1]][[1]]
