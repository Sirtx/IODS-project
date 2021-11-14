### Jani Haukka 13.111.2021 The script creates learning dataset

library(dplyr)

### read online
lrn14<-read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', header = T, sep = '\t', stringsAsFactors = F)

### read local backup from backup, if online source is down
# diary<-read.table('JYTOPKYS3-data.txt', header = T, sep = '\t', stringsAsFactors = F)

### Get dataset dimensions
dim(lrn14)
# [1] 183  60
# Dataset has 183 rows and 60 columns

### Get structure of the dataset
str(lrn14)

# data.frame':	183 obs. of  60 variables:
# $ Aa      : int  3 2 4 4 3 4 4 3 2 3 ...
# $ Ab      : int  1 2 1 2 2 2 1 1 1 2 ...

## 59 variables have int-type, 1 chr-type

lrn14$attitude  <- lrn14$Attitude / 10

### From DataComp
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14,one_of(keep_columns))


########## Not asked in exercise, but the example data has these column names changed
### Change "Age" to "age"
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"
#########


# select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)

### Change working diretory to project folder
setwd('C:/Users/Jani/Documents/R/MOOC/IODS-project')

### Write to file
write.table(learning2014, 'data/learning_2014_out.csv', sep = ',', col.names = T, row.names = F, quote = T) 

### Read again 
l2014<-read.table('data/learning_2014_out.csv', header = T, sep = ',', stringsAsFactors = F)

### Check structure
str(l2014)
head(l2014)

### Check if original and loaded dataframes are same
all.equal(learning2014,l2014)
# [1] TRUE


