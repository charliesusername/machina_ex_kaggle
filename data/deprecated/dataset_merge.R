library(dplyr)
df1 <- read.table('Charlie/cleaned_data.csv')
df2 <- read.csv('mdrozdov/mdrozdov_cols41_60_clean.csv')
df3 <- read.csv('mikedollar/train21_40.csv')
df4 <- read.csv('saudino480/clean_data_1_20.csv')
df5 <- read.csv('data/train.csv')

correct_names <- function(df) {
  names(df) <- gsub('\\.','_',tolower(names(df)))
  return (df) }



df1 = correct_names(df1)
df2 = correct_names(df2)
df3 = correct_names(df3)
df4 = correct_names(df4)
df5 = correct_names(df5)

df5 = df5 %>% select(id, saleprice)
df4 = df4 %>% select(-x)
df3 = df3 %>% select(-x)



dfout = bind_cols(list(df1,df2,df3,df4,df5))
dfout = dfout %>% select(-id1,-id2,-id3,-id4)

write.table(dfout,file='data/cleaned_dataset_train.csv',sep = ',')
