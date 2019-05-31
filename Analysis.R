packages <- c("plyr","dplyr","ggplot2")
lapply(packages, library, character.only = TRUE)
#load packages

df <- read.csv("C:/workspaceR/AB testing/ab_data.csv")
str(df)
#load dataframe and examine

colSums(is.na(df))
#check for NA

unique_id <- unique(df$user_id)
length(unique_id)
df <- df[!duplicated(df$user_id), ]
#check and remove duplicate user_id rows

summary(df$group)
summary(df$landing_page)
#explore columns

freqgrouplanding_page <- ddply(df, .(df$group, df$landing_page), nrow)
names(freqgrouplanding_page) <- c("group", "landing_page", "Freq")
freqgrouplanding_page
#check conditions

dfclean1 <- dplyr::filter(df, group == "control" & landing_page == "old_page")
dfclean2 <- dplyr::filter(df, group == "treatment" & landing_page == "new_page") 
df <- rbind(dfclean1, dfclean2)
#clean dataframe, remove rows with control+new_page and treatment+old_page

dfgrouplanding_page <- ddply(df, .(df$group, df$landing_page), nrow)
names(dfgrouplanding_page) <- c("group", "landing_page", "Freq")
dfgrouplanding_page
#check cleaned df

p <- ggplot(dfgrouplanding_page, aes(x = landing_page, y = Freq))+
  geom_col(aes(fill = group), width = 0.7)
p
#plot group, landing_page, frequency

groupconvertfreq <- ddply(df, .(df$group, df$converted), nrow)
names(groupconvertfreq) <- c("group", "converted", "Freq")
groupconvertfreq

x <- matrix(c(127785, 128047, 17489, 17264), nrow=2)
chisq.test(x)
#Chi-square test of independence. Since our p-value is greater than .05, we fail to reject the null hypothesis. 
##That indicates there is no difference of conversion between people who saw the old_page and people who saw the new_page.



df$Date <- as.Date(df$timestamp)
df$Time <- format(as.POSIXct(df$timestamp) ,format="%H:%M:%S")
df$Weekday <- weekdays(df$Date)
df$Weekday <- ordered(df$Weekday, levels=c("Monday", 
                                           "Tuesday", 
                                           "Wednesday", 
                                           "Thursday", 
                                           "Friday", 
                                           "Saturday", 
                                           "Sunday"))
barplot(table(df$Weekday))
#What day of the week did people participate in this study the most? Answer=Tuesday




