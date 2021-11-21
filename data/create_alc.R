### Jani Haukka 21.111.2021 The script creates lalcohol consumption dataset

library(dplyr)

math<-read.table('data/student-mat.csv',sep = ';', header = T)
por<-read.table('data/student-por.csv',sep = ';', header = T)

str(math)
dim(math)

# There are 395 observations and 33 variables in math dataset

str(por)
dim(por)

# There are 649 observations and 33 variables in math dataset

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

#make vector of columnmanes not used as student identifiers, and print it
# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))


alc_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))


# Combine datasets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both datasets
#         Original joining/merging example is erroneous!
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m"))

#exploring the structure and dimensions of the new data alc

str(pormath)
dim(pormath)

# glimpse at new data
glimpse(pormath)

# define a new column alc_use by combining weekday and weekend alcohol use
pormath <- mutate(pormath, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
pormath <- mutate(pormath, high_use = alc_use > 2)

# glimpse at modified data
glimpse(pormath)

#the joined data has 370 observeations

#saving the new dataset
write.table(pormath, file = "data/alc.csv", sep = ';', col.names = T, row.names = F, quote = F)
