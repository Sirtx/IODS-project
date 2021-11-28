### Jani Haukka 28.11.2021 The script creates human development index dataset

library(dplyr)
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# Looking at the "hd" and "gii" datasets
str(hd)
dim(hd)
summary(hd)

# hd dataset has 8 variables and 195 observations

str(gii)
dim(gii)
summary(gii)

# gii has 10 variables and 195 observations


### Shortening the column names for "hd"
colnames(hd)[1] <- "hdi_rank"
colnames(hd)[2] <- "ctry"
colnames(hd)[3] <- "hdi"
colnames(hd)[4] <- "lifex"
colnames(hd)[5] <- "edu_exp"
colnames(hd)[6] <- "mean_edu"
colnames(hd)[7] <- "gni_cap"
colnames(hd)[8] <- "gni_hdi"

### Shortening the column names for "gii"
colnames(gii)[1] <- "gii_rank"
colnames(gii)[2] <- "ctry"
colnames(gii)[3] <- "gii"
colnames(gii)[4] <- "mat_mor"
colnames(gii)[5] <- "adl_birth"
colnames(gii)[6] <- "rep_parl"
colnames(gii)[7] <- "fem2edu"
colnames(gii)[8] <- "male2edu"
colnames(gii)[9] <- "fem_lab"
colnames(gii)[10] <- "male_lab"


### Creating column with female 2nd education / male 2nd education ratio 
gii <- mutate(gii, edu2_ratio = (fem2edu / male2edu))

### Creating column with female labor participation / participation ratio
gii <- mutate(gii, lab_ratio = (fem_lab / male_lab))

### Glimpse at the dataset
glimpse(gii)


### Joining the 2 datasets together by country
human <- inner_join(hd, gii, by = "ctry")

### The new human dataset has 19 columns and 195 observations
dim(human)

# saving the joined dataset
write.table(human,"data/human.csv", row.names = F, col.names = T, sep = ';', quote = F)
