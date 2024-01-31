library(tidyverse)
tidyverse_update()

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

median(df$a)
median(df$b)
median(df$c)
median(df$d)

output <- vector("double", ncol(df))
for (i in seq_along(df)) {
  output[[i]] <- median(df[[i]])
}
output
?seq_along

#21.2.1
mean_mtcars <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
  mean_mtcars[[i]] <- mean(mtcars[[i]])
}
mean_mtcars

type_flights <- vector("list", ncol(nycflights13::flights))
names(type_flights) <- names(nycflights13::flights)
type_flights
for (i in names(nycflights13::flights)){
  type_flights[[i]] <- class(nycflights13::flights[[i]])
}
type_flights

# 21.3 --------------------------------------------------------------------

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(df$a)
df$a
df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
df
# 웬만하면 더블 브라켓 쓰라는 거구나

