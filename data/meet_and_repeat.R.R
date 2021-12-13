### Jani Haukka 13.12.2021 The script creates week 6's datasets
library(dplyr)
library(tidyr)

BPRS<-read.table('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt', header = T, sep = ' ')
RATS<-read.table('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt', header = T, sep = '\t')

str(BPRS)
head(BPRS)


str(RATS)
head(RATS)

### Rats dataset includes longitudinal weight data from 16 rats, belonging to 3 groups. The weights were measured 11 times through 64 weeks


### Converting categorical variables to factors

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

### BPRS individuals lack unique identifiers, so adding id-column 
BPRS$id <- seq.int(nrow(BPRS))

### Converting to long form

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject, -id)

BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks, 5,6)))


RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 


### Wide and long data format comparison:

### In wide format the data, observations from different time points are as their own variables, whereas in long format, the measurements are combined into a single variable, meaning that each observation is in its own row. Therefore, in wide format one individual's observations are in separate columns, whereas in long format they are at separate rows. 

### Let's look at the dimensions and first few rows of wide and long BPRS and RATS datasets:

dim(BPRS)
# [1] 40 12

dim(BPRSL)
# [1] 360   6

head(BPRS)
# treatment subject week0 week1 week2 week3 week4 week5 week6 week7 week8 id
#       1       1    42    36    36    43    41    40    38    47    51  1
#       1       2    58    68    61    55    43    34    28    28    28  2
#       1       3    54    55    41    38    43    28    29    25    24  3
#       1       4    55    77    49    54    56    50    47    42    46  4
#       1       5    72    75    72    65    50    39    32    38    32  5
#       1       6    48    43    41    38    36    29    33    27    25  6

head(BPRSL)
# treatment subject id weeks bprs week
#        1       1  1 week0   42    0
#        1       2  2 week0   58    0
#        1       3  3 week0   54    0
#        1       4  4 week0   55    0
#        1       5  5 week0   72    0
#        1       6  6 week0   48    0

dim(RATS)
# [1] 16 13

dim(RATSL)
# [1] 176   5

head(RATS)
# ID Group WD1 WD8 WD15 WD22 WD29 WD36 WD43 WD44 WD50 WD57 WD64
#  1     1 240 250  255  260  262  258  266  266  265  272  278
#  2     1 225 230  230  232  240  240  243  244  238  247  245
#  3     1 245 250  250  255  262  265  267  267  264  268  269
#  4     1 260 255  255  265  265  268  270  272  274  273  275
#  5     1 255 260  255  270  270  273  274  273  276  278  280
#  6     1 260 265  270  275  275  277  278  278  284  279  281

head(RATSL)
# ID Group  WD Weight Time
#  1     1 WD1    240    1
#  2     1 WD1    225    1
#  3     1 WD1    245    1
#  4     1 WD1    260    1
#  5     1 WD1    255    1
#  6     1 WD1    260    1

### Here we see that BPRS is transformed into BPRSL by comining all bpsr observations into 1 variable, and adding 'week' varible, indicating time. RATS is transformed into RATSL that weight measurements are combined into one "Weight" variable and a new "Time" variable is added to indicating, which of the 8 measurements it's from.

### Writing datasets into tables
write.table(RATSL, 'data/RATSL.txt', row.names = F, col.names = T, sep = '\t', quote = F)



write.table(BPRSL, 'data/BPRSL.txt', row.names = F, col.names = T, sep = '\t', quote = F)


