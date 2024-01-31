library(tidyverse)
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quotes'
string1
string2
string3 <- "\\"
string3
string3 <- "\""
string3
x <- c("\"", "\\")
x
writeLines(x)
x <- "\u00b5"
x
writeLines(c("one", "two", "three"))

# Checking String Length
str_length(c("a", "R for data science", NA))

# Combining two strings
str_c("x", "y")
str_c("x", "y", sep = ", ")
x <- c("abc", NA)
str_c("|-", x, "-|")
str_c("|-", str_replace_na(x, replacement = "Gyu"), "-|")
str_c("prefix-", c("a", "b", "c"), "-suffix")
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

# 얘는 IF 문법이 이렇게 되는구나
str_c(
  "Good ", time_of_day, " ", name,
  if (birthday == FALSE) " and HAPPY BIRTHDAY",
  ".") 
  
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
str_sub(x, -3, -1)

# Locale
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
str_sub(x, 1, 1) <- str_to_upper(str_sub(x,1,1))
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en")
str_sort(x, locale = "haw")
# Locale 값에 따라서 sorting이 달라지는 걸 check

#14.2.1
paste("foo", "bar")
paste0("foo", "bar") # 0짜리는 스페이스 안붙임
str_c("foo", "bar", sep = "  ")
# 참고로 paste는 결측값을 인지하지 못하는 듯 함

#14.2.2 : 대체 어떻게 쓰는거냐 collapse?
#14.2.3
str_sub("gganggang2", str_length("gganggang2")/2,  str_length("gganggang2")/2)
#If we use 'ceiling', it rounds up that we could use this even if the length of string is even.

#14.2.4
x = "The first two backslashes will resolve to a literal backslash in the regular expression, the third will escape the next character. So in the regular expression, this will escape some escaped character."
str_wrap(x, width = 100) 
# 이런 느낌이구나.. wrap이란 텍스트를 다음 행으로 넘기다는 뜻임

#14.2.5
str_trim("  gganggang2  ", side = "left")
# trim은 액셀처럼 공백 지워주는 역할 함. side는 어느 쪽 지울건지 정함

str_pad("gganggang2", 12, side = "both")
# pad는 가운데에 minimum length를 정해주고 공백을 추가함

#14.2.6 HARD 나 저거 대괄호 쓰는 거 모르겠음 x[[n]].. order을 의미?

# Matching Patterns

x <- c("apple", "banana", "pear")
str_view(x, "an")
str_view(x, ".a.")

x <- "a\\b"
writeLines(x)

str_view(c("abc", "a.c", "bef"), "a\\.c")
# \가 의미하는 건 escape... 즉 기존의 기능을 remove?

str_view(".g.g.g", "\\..\\..\\..", match = TRUE)
# 아 그니까 . 자체도 기능을 가지니까, \. 써서 기능을 없애주고, 근데 \도 기능을 가지니까 \\.을 해야 비로소 . 이 나온다?
str_view(c("a.b", "c.d"), ".\\..") # 아 이해했다

str_view(x, "\\\\")
# 이 단원은 도저히 이해가 안 감. 다음에 다시 오자.
# 그러니까 escape를 하고 싶으면 \앞에 무조건 \ 붙여야 함.
# 즉 기본적인 문법이 \\^ \\$ 이런거란 얘기임

x <- c("apple", "banana", "pear")
str_view(x, "^a")
str_view(x, "a$") # if you begin with power (^), you end up with money ($).

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
str_view(x, "^apple$")

#14.3.2.2
str_view(stringr::words, "^y")
# ^...$ 하면 anchoring 당한거라 3글자만 나오는데 ... 를 하면 3글자 이상이 나옴!

str_view(c("grey", "gray"), "gr(e|a)y")
str_view(stringr::words, "[^aeiou]")
str_view(stringr::words, "[aeiou]", match = FALSE)
str_view(stringr::words, "[^e]ed$")
str_subset(stringr::words, "[^e]ed$") #subset 하면 깔끔하게 나오네
str_subset(stringr::words, "(ing|ise)$")

str_subset(stringr::words, "q[^u]")
str_subset(stringr::words, "uq")

str_subset(stringr::words, "ou|ise$|ae|oe|yse$")

#14.3.4.1
# ? is {0,1} / + is {1,} / * is {0,} 역슬래쉬 아직도 헷갈려..
# I see.. 이게 "" 로 인해 string에 들어가는지 안들어가는지가 중요함

#14.3.4.3
# "^[^aeiou]{3}" 따옴표 걸어야함
# "[aeiou]{3,}" / ([aeiou][^aeiou]){2,}

# ""안에 들어가는 string은 \\ 2개 필요.. 밖에선 1개 필요

#14.3.5.2
# "^(.).*\\1$ we also need to put singleton.
# (.)(.)

x <- c("apple", "banana", "pear")
str_detect(x, "e")
sum(str_detect(words, "^t"))
mean(str_detect(words, "[aeiou]$")) # FALSE는 0 TRUE는 1 됨을 이용

words[str_detect(words, "x$")]
str_subset(words, "x$")

#14.4.1
words[str_detect(words, "(^x|x$)")]
words[str_detect(words, "^[aeiou].*[^aeiou]$")] %>% tail
words[str_detect(words, "a") &
        str_detect(words, "e") &
        str_detect(words, "i") &
        str_detect(words, "o") &
        str_detect(words, "u")]


df <- tibble(
  word = words, 
  i = seq_along(word)
)
df2 <- df %>% mutate(
    vowels = str_count(words, "[aeiou]"),
    consonants = str_count(words, "[^aeiou]"),
    length = str_length(words),
    prop = vowels / length
)
df2 %>% arrange(desc(prop))

length(sentences)
summary(sentences)
head(sentences)
tail(sentences)

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
has_colour <- str_subset(sentences, colour_match)
has_colour # colour가 들어있는 문장들을 부분집합으로 생성
matches <- str_extract(has_colour, colour_match)
matches # has_colour이라는 부분집합 안에 어떤 색이 포함되었는가 추출
more <- sentences[str_count(sentences, colour_match) > 1] # 색 2개 이상
str_view_all(more, colour_match) # color 부각해서 보여줌
str_extract_all(more, colour_match) # color match만 추출
str_extract_all(more, colour_match, simplify = TRUE)

x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)
# 이런 방식으로 string의 matrix화도 가능하다.

# 앞 뒤로 공백을 넣어 색깔 그 자체만 찾으려는 법
colour_match2 <- str_c("\\b(", str_c(colours, collapse = "|"), ")\\b")
colour_match2
more2 <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more2, colour_match2, match = TRUE)
 
#14.4.2.2 여기 하단의 문법 정도는 이해해 두자 특히 \\b 사용 in str
str_extract(sentences, "[A-Za-z]+")
str_extract(sentences, "[A-Za-z][A-Za-z']*") %>% head()
str_extract(sentences, "\\b[A-za-z]+ing\\b") %>% head()
pattern <-  "\\b[A-za-z]+ing\\b"
sentence_with_ing <- str_detect(sentences, pattern)
sentence_with_ing #true false로 도출
unique(unlist(str_extract_all(sentences[sentence_with_ing], pattern)))

#grouping
noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
  str_subset(noun) %>%
  head(10)
str_extract(has_noun, noun)
str_match(has_noun, noun) # 그치만 불완전함

tibble(sentence = sentences) %>% 
  tidyr::extract(
    sentence, c("article", "noun"), "(a|the) ([^ ]+)", 
    remove = FALSE
  )
str_match_all(has_noun, noun)

numword <- "\\b(one|two|three|four|five|six|seven|eight|nine|ten)+ (\\w+)"
sentences[str_detect(sentences, numword)] %>% # 저 + 뒤의 공백이 중요하네
  str_extract(numword)

# Find All Contraction
contraction <- "([A-Za-z]+)'([A-Za-z]+)"
sentences[str_detect(sentences, contraction)] %>%
  str_extract(contraction) %>%
  str_split("'")

# Replacements
x <- c("apple", "pear", "banana")
str_replace_all(x, "[aeiou]", "-") # all을 안하면 맨 앞에 한개만 바뀜

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5) # flip the order of the second and third words
# These are distinguished by parentheses.

#14.4.4
str_replace_all("past/present/future", "/", "\\\\") # 하나만 안돼?
replaced <- str_replace(words, "^([A-Za-z])(.*)([A-Za-z])$", "\\3\\2\\1")
intersect(replaced, words)
head(replaced, 10)

# Split
sentences %>%
  head(5) %>% 
  str_split(" ") # simplify option 넣으면 matrix화 된다.

"a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[[1]] # 이 대괄호의 의미는 무엇일까?

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)

x <- "This is a sentence.  This is another sentence."
str_view_all(x, boundary("sentence"))

#14.4.5
str_split("apples, pears, and bananas", ", +(and +)?") # 이러면 and 소거
# ? + * 의 활용이 아주 중요하고 소중하구만?

sentence <- "The quick (“brown”) fox can’t jump 32.3 feet, right?"
sentence
str_split(sentence, " ")
str_split(sentence, boundary("word")) # 이게 더 정교하다!

str_split(c("ab. cd|agt", "a.b.c.d.e"), "")[[2]] 
# 대괄호의 의미는 list의 몇 번째 원소인지를 뜻함
# [1] 은 list에 접근, [[1]] 은 list 내부의 값에 접근

# Others
str_view(fruit, "nana")
bananas <- c("banana", "Banana", "BANANA")

# ignore_case : 대소문자 구분을 ignore
str_view(bananas, regex("banana", ignore_case = TRUE))
str_view(bananas, "banana")

# multiline : ^$ 적용 단위를 문장으로 
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]

# coll : 지역 격차 해소 by locale factors
# fixed : regex보다 빠르지만 sensitive

x <- "This is a sentence."
str_view_all(x, boundary("word"))

#14.5.1
str_subset(c("a\\b", "ab"), "\\\\")
str_subset(c("a\\b", "ab"), fixed("\\"))

tibtib <- tibble(word = unlist(str_extract_all(sentences, boundary("word"))))
tibtib %>% 
  mutate(word = str_to_lower(word)) %>% 
  count(word, sort = TRUE) %>% 
  head(5)

# apropos("STH") 사용 시 STH가 포함된 사용 가능 obj finding
# dir(pattern = "STH") directory 안에 있는 sth 패턴의 파일을 찾아줌
# stringi 안에 stringr이  포함되어 있다.