library(magrittr)

diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>% 
  dplyr::mutate(price_per_carat = price / carat)

diamonds$carat[1] <- NA
diamonds$carat
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df
x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

?range
range(c(1:10))[2]

x <- c(1:10, Inf)
rescale01(x)

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)  

# I learned this ----------------------------------------------------------

# cmd + shift + M = %>% 
# cmd + shift + R = chunking!

f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)] # 저 minus대괄호 drop out 임
}

f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
f1("apple", "b")

f3 <- function(x, y) {
  rep(y, length.out = length(x))
}
f3(1:5, "gimotti")

rnorm(10)
MASS::mvrnorm(10, 0, 1)
?dnorm
dnorm(c(-0.5, 0.5))

# 19.4 -------------------------------------------------------------------

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}

?ifelse

greet <- function(time) {
  hr <- lubridate::hour(time)
  if(hr < 12) {
    print("Good Morning!")
    } else if(hr < 18) {
      print("Good Afternoon!")
    } else {
      print("Good Evening!")
    }
  }
greet(lubridate::ymd_h("2017-01-08:05"))

fizzbuzz <- function(x) {
  if (x %% 15 == 0) {
    print("fizzbuzz")
  }
  else if (x %% 3 == 0) {
    print("fizz")
  }
  else if (x %% 5 == 0) {
    print("buzz") 
  }
  else {
    print(x)
  }
}
fizzbuzz(3)
fizzbuzz(30)
fizzbuzz(7)
fizzbuzz(500)

10 %% 3 # MOD (Residual)
10 %/% 3 # Quotient

# 뒤에 브라켓 붙이는 원리가 아직 확실하게 납득 X
# If는 Single Value Only, Cut은 Vector 가능

switch(x, 
       a = ,
       b = "ab",
       c = ,
       d = "cd"
)

switcheroo <- function(x) {
switch(x,
       a = "ggang",
       b = ,
       c = "gganggang",
       d = "gganggang2")
)
} # 별로 쓸모가?;;

# 19.5 --------------------------------------------------------------------

commas <- function(...) {
  stringr::str_c(..., collapse = "- ")
}

commas(letters[1:10], collapse = "-")
letters

# 이 단원의 정체를 모르겠음

f <- function(x) {
  x + y
} 
f(10)
y <- 100
f(10)

`+` <- function(x, y) {
  if (runif(1) < 0.1) {
    sum(x, y)
  } else {
    sum(x, y) * 1.1
  }
}
table(replicate(1000, 1 + 2))
replicate(1000, 1 + 2) # 그냥 iteration 아님?
?replicate
