# Libraries
library(readr)
library(dplyr)
library(ggplot2)

# Object types
# - numeric
num <- 5

# - character
char <- "hello"

# - logical
logi <- T


# Data structures and cohersion
# - vector and matrix
v1 <- c(5, 2, 5)
v2 <- c(5, "2", 5)

2 * v1
# 2 * v2 #this will cause error

m1 <- matrix(data = sample(6, 6), 3, 3)
m1

# - data.frame
df1 <- data.frame(accident_id = c(001, 002, 003), casualties = c(1, 2, 4))
df1


# Importing and inspecting csv
fars <- read_csv("~/Documents/IDV/2 Winter 2017/rTutorial/data/accident.csv")
str(fars)

# Selections in a data frame df[row, column]
# - by number
fars[1:5, 2]

# - by name
fars[1:5, "ST_CASE"]

# Dropping columns
to.keep <- c("ST_CASE", "MONTH", "FATALS", "DRUNK_DR")
fars2 <- fars[to.keep]
head(fars2)
str(fars2)

# Manipulating the data with dplyr!

# Complex selections - ??select()
fars3 <- select(fars, ST_CASE, YEAR, MONTH, DAY, FATALS, DRUNK_DR)

over.two.dead <- select(fars, ST_CASE, MONTH, FATALS, DRUNK_DR)
over.two.dead <- filter(over.two.dead, FATALS > 2)

# Piping!
over.two.dead <- select(fars, ST_CASE, MONTH, FATALS, DRUNK_DR) %>% #35000
  filter(FATALS > 2) #450

over.two.dead

# arrange fars3 by fatalities in descending order
by.fatalities <- arrange(fars2, desc(FATALS))

# add a colum DATE to fars3 that is the full date year/month/day
fars4 <- mutate(fars3, DATE = paste(YEAR, MONTH, DAY, sep = '/'))

# summarize fars 4 by total fatalities and total drunk incidents, and its ratio
totals <- summarize(fars4,
                    totFat = sum(FATALS),
                    totDrunk = sum(DRUNK_DR),
                    ratio = totDrunk/totFat)

totals

# Some simple graphics - fatalities in time

# first we create a dataset and make a date object
accidents <- select(fars4, -DAY, -MONTH, -YEAR)
accidents$DATE <- as.Date(accidents$DATE)

# let's group by date of the accident
group <- group_by(accidents, DATE)
accidentsByDate <- summarize(group, FATALS = n())

ggplot(accidentsByDate, aes(DATE, FATALS)) +
  geom_point(color = 'firebrick') +
  labs(x = "Date", y = "Number of fatalities")
