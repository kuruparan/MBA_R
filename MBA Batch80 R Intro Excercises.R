#----------------R Quick Intro Session - Lab Excercises --------------
#-----------Ensure this code is in your working directory
#----------- Use Run or Ctrl+Enter to run line by line and observed output in Console 

#Ex1:

# Open a New R Script Editor
# Type this code in the Editor

greeting <-"Hello"
yourname <-readline("What is your name?")
print(paste(greeting,yourname))

# Click 'Source'>> Type your name in the Console >> press Enter

# Ex3: Run this script

n <- floor(rnorm(10000, 500, 100))
t <- table(n)
barplot(t)

# Observe output, Check Environment and examine what are n and t? in the console
n
t
# Plot the frequencies on a bar graph: what is you obervation?
  barplot(table(floor(rnorm(10000, 500, 100))), xlab="Numbers", ylab="Frequencies")


#Ex4: Run this script

x <- c(3,2,1)
y <- 1:3
x
y
x+y
z<-x+y
z
z+1

#Ex5-7: on R Data Stuctures

# Vector

apple <- c('red','green',"yellow")
apple
apple[2]
# Get the class of the vector.
class(apple)
length(apple)


# List

l <- list(1, "a",c('a','b','c'), TRUE, 1+4i)
l
class(l)
class(l[[1]])
class(l[[2]])
class(l[[3]])
class(l[[4]])
class(l[[5]])

# Matrix

m <- matrix(c(1, 2, 3, 4,5,6), nrow = 2)
m
class(m)
mode(m)
typeof(m)

class(m[2,3])
typeof(m[2,3])

# Try this. What's your obervation about row/column filling?
m2 <- matrix(c(1, 2, 3, 4,5,6), ncol = 2)
m2

# Data Frame

# Run this block first
BMI <- data.frame(
  name = c("Supun", "Lal","Himesha"),
  gender = factor(c("Male", "Male","Female")),
  height = c(152, 171.5, 165),
  weight = c(81,93, 78),
  Age =c(42L,38L,26L),
  stringsAsFactors = FALSE
)

BMI

# Now run line by line and observe outcome

class(BMI)
typeof(BMI)
    length(BMI)
    length(BMI$name)
    length(BMI$Age)
        class(BMI$name)
        typeof(BMI$name)
        BMI$gender
        class(BMI$gender)
        typeof(BMI$gender)
        class(BMI$weight)
        typeof(BMI$weight)
        class(BMI$Age)
        typeof(BMI$Age)


        
#------------------- USED CARS CSV Excercises---------------------------

# Load CSV file data in to R data frame:
usedcars <- read.csv("usedcars.csv", stringsAsFactors = FALSE)
        
# Exploring and understanding your data

# Take a peep at you data - head(), tail()
head(usedcars)          
tail(usedcars)        

# Explore the structure of data - str()
str(usedcars)

#  Numeric variables - Explore 

summary(usedcars$year)
summary(usedcars[c("price","mileage")])

  # Also try this
  summary(usedcars[c(3,4)])
  summary(usedcars[3:4])

# Measures of central tendency & spread

summary(usedcars$price)
quantile(usedcars$price)
  IQR(usedcars$price)

quantile(usedcars$price, probs = c(0,0.25,0.5,0.75,1))
  #quantile(usedcars$price, probs = c(0.25,0.75))
  #diff(quantile(usedcars$price, probs = c(0.25,0.75)))

  #quantile(usedcars$price, seq(from = 0, to = 1, by = 0.20))
  #quantile(usedcars$price, seq(from = 0, to = 1, by = 0.10))

  
mean(usedcars$price)
median(usedcars$price)
min(usedcars$price)
max(usedcars$price)
range(usedcars$price)
  diff(range(usedcars$price))

#  Numeric variables - visualize with Boxplot 
boxplot(usedcars$price, main="Boxplot of Used Car Prices",ylab="Price ($)")

boxplot(usedcars$mileage, main="Boxplot of Used Car Mileage",ylab="Odometer (mi.)")

#  Numeric variables - visualize with Histogram
hist(usedcars$price, main = "Histogram of Used Car Prices", xlab = "Price ($)")

hist(usedcars$mileage, main = "Histogram of Used Car Mileage",xlab = "Odometer (mi.)")

# Numeric variables - Measure spread with var() & std()
var(usedcars$price)
sd(usedcars$price)  

var(usedcars$mileage)
sd(usedcars$mileage)  

# Categorical variables - Explore with table(), prop.table()[As mode () does't help]
table(usedcars$model)
prop.table(table(usedcars$model))

round(prop.table(table(usedcars$model))*100, digits=1)


# Exploring relationships between variables

#Eg 1: Examine linear association (correlation) with Scatterplot
plot(  x = usedcars$mileage, y = usedcars$price,
       main = "Scatterplot of Price vs. Mileage",
       xlab = "Used Car Odometer (mi.)",  ylab = "Used Car Price ($)")

#Eg 2: Examine a relationship between two nominal variables with -Two-way cross-tabulations [crosstab]

#install and load "gmodels package" to use #CrossTable()

install.packages("gmodels")
library(gmodels)

table(usedcars$color)

# conservative colors Black, Gray, Silver, and #White.
#so the other group will include Blue, Gold, Green, #Red, and Yellow.
usedcars$conservative <-
  usedcars$color %in% c("Black", "Gray", "Silver", "White")


#create the cross tab and observe "chi-squared test of independence" results
CrossTable(x = usedcars$model, y = usedcars$conservative, chisq = TRUE) 


#----------------End of R Quick Intro ---------------------
#----------------For more beginner resources, visit:

#1.https://www.datamentor.io/r-programming/
#2.https://www.tutorialspoint.com/r/r_tutorial.pdf

# CRAN Resources
#3.https://cran.r-project.org/doc/contrib/Paradis-rdebuts_en.pdf
#4.https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf




  
