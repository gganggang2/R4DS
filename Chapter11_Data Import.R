library(tidyverse)

# readr::read_csv
# csv : comma separated values

read_csv("a,b,c
         1,2,3
         4,5,6") # First row is the column names

read_csv("kkruppingppong
  kkruppingppongpong
  x,y,z
  1,2,3", skip = 2) # Skip two rows above

read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#") # "#"로 시작되는 모든 행 skip

read_csv("1,2,3
         4,5,6",
         col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = FALSE) # \n 하면 줄바꿈 기능

read_csv("a,b,c\n1,2,.", na = ".") # "."이 들어간 항목은 NA 처리

#11.2.1
#read_delim(file, delim = "|"). delim은 모든 delimiter(구분기호) 가 들어간 파일 읽을 수 있음.

#11.2.4
read_delim("x,y\n1,'a,b'", quote = "'")
read_csv("x,y\n1,'a,b'", quote = "'") # This also works!!!ㅋㅋㅋㅋ
read_csv2("a;b\n1;3") # column-separated

#11.3 Parsing a Vector

parse_integer(c("1", "231", ".", "456"), na = ".")
x <- parse_integer(c("123", "345", "abc", "123.45"))
problems(x) # 문제 발견!

parse_double("1.23")
parse_double("1,23") # 이거는 코드가 적용이 안되는 걸 확인할 수 있음
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("It cost $123.45") # 얘는 Character 싹 다 무시함
parse_number("123.456.789", locale = locale(grouping_mark = ".")) # locale 따위 그냥 개무시함

# charToRaw... Character을 Raw ASCII Code로 변환하는 코드인 듯함. 솔직히 쓸 일 있겠냐..?

fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

parse_datetime("20101010")
parse_date("2010-10-01")
parse_date("2010/10/01") # - 나 / 기호로 구분하면 인식함

library(hms)
parse_time("01:10 am")
parse_time("20:10:01") # 시간은 :로만 구분하는 듯?

parse_date("01/02/15", "%m/%d/%y")
parse_date("2001/02/15", "%Y/%m/%d") # 연도 4글자 치려면 Y, 2글자는 y.
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
parse_date("1 1월 2015", "%d %B %Y", locale = locale("ko")) # 오 대박

#11.3.3
locale_custom <- locale(date_format = "Day %d Mon %M Year %y",
                        time_format = "Sec %S Min %M Hour %H")
date_custom <- c("Day 01 Mon 02 Year 03", "Day 03 Mon 01 Year 01")
parse_date(date_custom, locale = locale_custom) # 이런 식으로 custom 지정해 놓고 하는 게 가능!

#11.3.4 Create own locale
au_locale <- locale(date_format = "%d/%m/%Y")
parse_date("01/02/1999", locale = au_locale)

#11.3.7
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y") # 개빡세네 이거;
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
d4_locale <- locale(date_format = "%B %d (%Y)")
parse_date(d4, locale = d4_locale)
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p") # 이건 뭐농

str(parse_guess("2010-10-10"))
guess_parser(c("1", "5", "9"))

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)
colnames(challenge)
tail(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
challenge
  
write_csv(challenge, "challenge.csv")
challenge
read_csv("challenge.csv")
read_csv("diamonds.csv")

# haven : read SPSS / readxl : read excel files / DBI : read SQL files
