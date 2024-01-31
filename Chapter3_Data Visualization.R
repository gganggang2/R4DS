#3.2 First Step
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#3.2 Q1
ggplot(data=mpg) #You can see the cartesian Plot
#3.2 Q2
nrow(mpg)
ncol(mpg)
#3.2 Q3
?mpg
#3.2 Q4
ggplot(data = mpg) + geom_point(aes(x = hwy, y = cyl))
ggplot(mpg, aes(x = cyl, y = hwy)) + geom_point()
#3.2 Q5
ggplot(mpg, aes(x = class, y = drv)) + geom_point()

#3.3 Aesthetic mappings
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
#Aesthetic is a visual property.. can add a third variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#> Warning: Using size for a discrete variable is not advised.
# alpha is transparency
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# shape is literally shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

#3.3 Q1
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
#3.3 Q2
?mpg
mpg
glimpse(mpg) #you can see a data at a glimpse
#3.3 Q3
ggplot(mpg, aes(x = displ, y = hwy, color = cty)) + geom_point()
ggplot(mpg, aes(x = displ, y = hwy, size = cty)) + geom_point()
ggplot(mpg, aes(x = displ, y = hwy, shape = cty)) + geom_point()
#shape is discrete; cannot respond to conti var
#3.3 Q4 : Available
#3.3 Q5
?geom_point
ggplot(mpg, aes(x = displ, y = hwy, stroke = year)) + geom_point()
#3.3 Q6
ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()
#Color Output would be a logical Variable

#3.4 Common Problems
#> DO NOT USE '+' in front of the sentence!!!!! use like line 2~3

#3.5 Facet
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl) # Meaning of ~ : Divide by presented variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(.~class)
# .~ is same with ~? wrap is for 1 var, grid is for more than 2 vars?

#3.5.3 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))
ggplot(data = mpg) +
  facet_grid(drv~cyl) # This makes an empty paper 
mpg$cyl
mpg$displ
# .~ means that this ignores the dimension of x or y. It seems more adequate that (A ~ B) means A : rows and B : columns.

#3.5.4~5
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~class, ncol = 2) # You can figure out the role of ncol / nrow
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(.~class, ncol = 2) # You can skip the . 

#3.5.6
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
# This might be differ from which data you use.

#3.6 Gemoetric objects
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, lty = drv)) #linetype = lty
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = TRUE
  ) #show.legend means 범례.
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point() + geom_smooth()
#filter : Data filtering
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
# Point is same; only geom_smooth changed.

#3.6.2 : aes에 color 걸어도 상관없음.. All geom has affected by color = drv.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

#3.6.3 : Hard to understand the logic of GROUP. Just GROUPing... But R does it automatically. Then no use?
  ggplot(data = mpg) +
    geom_smooth(mapping = aes(x = displ, y = hwy, group = drv), show.legend = TRUE)

#3.6.4 : se in smooth means 신뢰대? But we realized that se is standard error.
#3.6.6 : To add variabe in visualization, use aes... if not, just use like colour = white.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 4, colour = "white") + 
    geom_point(size = 2, aes(colour = drv))

#3.7 Statistical Transformations : Every geom has a default stat.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1)) # Why Group = 1?

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  ) # The role of fun.min and fun.max?

#3.7.1
?stat_summary
ggplot(data = diamonds) +
  geom_pointrange(aes(x = cut, y = depth), stat = "summary",
                  fun.min = min, fun.max = max, fun = median)
ggplot(data = diamonds) +
  geom_pointrange(aes(x = cut, y = depth), stat = "summary",
                  fun.min = min, fun.max = max, fun = mean)
#fun.data seems better... but how to use this?

#3.7.2
?geom_col

#3.7.4
ggplot(data = mpg) + 
  stat_smooth(mapping = aes(x = displ, y = drv), method = lm)

#3.7.5 : Why group = 1? If then, R recognizes the grouping within the groups.
#IT seems ambiguous...
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

#3.8 : Point Adjustments
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut)) #geom_bar's stat is stat_count().
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity)) #Position Adjustment
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity") #Position = Identity is not useful.
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar() #fill is... similar like colour = ?

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill") #fill by the same height
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") #separation
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter") #Avoid Overlapping of points

#3.8.1 
summary(mpg$hwy)
nrow(mpg)
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_jitter() #Because of the overlapping data...
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter() #This might be better?

#3.8.2~3
?geom_jitter
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_jitter(width = 0.5, height = 1)

#3.8.4
?geom_boxplot #dodge2
ggplot(data = mpg, aes(x = hwy, y = drv, colour = class)) + geom_boxplot()
ggplot(data = mpg, aes(x = hwy, y = drv, colour = class)) + geom_boxplot(position = "identity")
#Since the default position is dodge, identity makes this be overlapped.

#3.9 Coordinate Systems
#coord_flip() : switches the x and y axes.
#coord_quickmap() : Automatically adjust the ratio of maps.
#coord_polar() : Use Polar Coordinates.

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar
bar + coord_flip()
bar + coord_polar()

#3.9.1
ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") # Maybe y = count(Automatically)

#3.9.2
?labs #Put the label... trivial

#3.9.4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed() #Isn't this TOO MUCH distorted?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() + coord_fixed() + geom_jitter() # Is this just for comparison with y=x graph?

#Chapter Summarize
#ggplot + <GEOM_Function>(mapping, stat, position) + <COORDINATE_Function> + <FACET_Function>


#ALT + SHIFT + K 
#TAB or DOUBLE TAB



