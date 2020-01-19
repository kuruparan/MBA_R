# Session 06 - Labs :  ***---Linear Regression - Numeric Prediction *****


## STEP 1: SET Working directory Ctrl + Shift + H and  ensure insurance.csv file is available


## Step 2: Exploring and preparing the data ----
  insurance <- read.csv("insurance.csv", stringsAsFactors = TRUE)
  str(insurance)

  # summarize the charges variable
  summary(insurance$expenses)
  
  # histogram of insurance charges
  hist(insurance$expenses)
  
  # table of region
  table(insurance$region)
  
  # exploring relationships among features: correlation matrix
  cor(insurance[c("age", "bmi", "children", "expenses")])
  
  # visualing relationships among features: scatterplot matrix
  pairs(insurance[c("age", "bmi", "children", "expenses")])
  
  # more informative scatterplot matrix using psych package
  if(require("psych") == FALSE) {install.packages("psych")};{library(psych)}
  pairs.panels(insurance[c("age", "bmi", "children", "expenses")])
  
  

## Step 3: Training a model on the data ----
  ins_model <- lm(expenses ~ age + children + bmi + sex + smoker + region,
                  data = insurance)
  ins_model <- lm(expenses ~ ., data = insurance) # this is equivalent to above
  
  # see the estimated beta coefficients
  ins_model
  
  
  
## Step 4: Evaluating model performance ----
  # see more detail about the estimated beta coefficients
  summary(ins_model)
  

  
## Step 5: Improving model performance ----
  
  
  
  # add a higher-order "age" term
  insurance$age2 <- insurance$age^2
  
  # add an indicator for BMI >= 30
  insurance$bmi30 <- ifelse(insurance$bmi >= 30, 1, 0)
  
  # create final model
  ins_model2 <- lm(expenses ~ age + age2 + children + bmi + sex +
                     bmi30*smoker + region, data = insurance)
  
  summary(ins_model2)
  
  # create final model
  ins_model3 <- lm(expenses ~  age2 + children  + sex +
                     bmi30*smoker + region, data = insurance)
  
  summary(ins_model3)
  
  
## step 6: Making predictions with the regression model
  
  insurance$pred <- predict(ins_model2, insurance)
  cor(insurance$pred, insurance$expenses)
  
  plot(insurance$pred, insurance$expenses)
  abline(a = 0, b = 1, col = "red", lwd = 3, lty = 2)
  
  predict(ins_model2,
          data.frame(age = 30, age2 = 30^2, children = 2,
                     bmi = 30, sex = "male", bmi30 = 1,
                     smoker = "no", region = "northeast"))
  
  predict(ins_model2,
          data.frame(age = 30, age2 = 30^2, children = 2,
                     bmi = 30, sex = "female", bmi30 = 1,
                     smoker = "no", region = "northeast"))
  
  
  predict(ins_model2,
          data.frame(age = 30, age2 = 30^2, children = 0,
                     bmi = 30, sex = "female", bmi30 = 1,
                     smoker = "no", region = "northeast"))
  
