library(tidyverse)
library(stringr)
library(lfe)
# ----

#Read Data
air <- read_csv("data/ctyfactbook2019.csv") #https://www.epa.gov/air-trends/air-quality-cities-and-counties
covid <- read_csv ("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_daily_reports/01-10-2021.csv")

# covid <- read_csv("https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD")
#If above doens't work, there is version accessed 1/6 here
# covid <- read_csv("data/Provisional_COVID-19_Death_Counts_in_the_United_States_by_County-1-6-21.csv")

# Format FIPS Codes for joining
air$`County FIPS Code` <- str_pad(as.character(air$`County FIPS Code`), 
                                  5, 
                                  pad = "0")

covid <- covid %>% 
  filter(!is.na(FIPS)) %>% 
  mutate(Death_Rate = Incident_Rate/Confirmed*Deaths)
covid$FIPS <- str_pad(as.character(covid$FIPS), 
                                    5, 
                                    pad = "0")

data <- full_join(air, covid, by= c("County FIPS Code"="FIPS"))

# from https://www.ers.usda.gov/webdocs/DataFiles/48747/PovertyEstimates.xls?v=6924.4
poverty <- read_csv("data/poverty-by-county.csv")
povery <- poverty %>% select(FIPStxt, Stabr, Area_name, POVALL_2019)

data <- left_join(data, poverty, by= c("County FIPS Code" = "FIPStxt"))
  
# Export FIPS and Death Rate----
df <- data %>%
  filter(Admin2 != "Unassigned") %>% 
  rename(FIPS = `County FIPS Code`) %>% 
  select(FIPS, Case_Fatality_Ratio) %>% 
  filter(!is.na(Case_Fatality_Ratio)) %>% 
  mutate(Case_Fatality_Ratio = round(Case_Fatality_Ratio, 2)) %>% 
  rename(DeathRate = Case_Fatality_Ratio)

write_csv(df, "data/deaths_per_case.csv")

# Export FIPS and PM25----
df <- data %>% 
  rename(FIPS = `County FIPS Code`) %>% 
  select(FIPS, `PM2.5     Wtd AM (µg/m3)`) %>% 
  rename(pm25 = `PM2.5     Wtd AM (µg/m3)`) %>% 
  filter(!(pm25 == "ND" | pm25 == "IN")) %>% 
  mutate(pm25 = as.numeric(pm25))

write_csv(df, "data/pm25.csv")

# Export FIPS and Poverty Rate ----
df <- data %>% 
  select(`County FIPS Code`,
         PCTPOVALL_2019) %>% 
  filter(!is.na(PCTPOVALL_2019)) %>% 
  rename(fips = `County FIPS Code`,
         povrate = PCTPOVALL_2019 )

write_csv(df, "data/poverty.csv")

# Regressing death rate on air quality----
df <- data %>% 
  select(`County FIPS Code`,
         State, 
         Incident_Rate, 
         Death_Rate,
         Case_Fatality_Ratio, 
         `PM2.5     Wtd AM (µg/m3)`) %>% 
  rename(deaths_per_case = Case_Fatality_Ratio,
         pm25 = `PM2.5     Wtd AM (µg/m3)`,
         fips = `County FIPS Code`) %>% 
  filter(!(pm25 == "ND" | pm25 == "IN")) %>% 
  mutate(pm25 = as.numeric(pm25))

reg <- felm(data = df, formula = deaths_per_case ~ log(pm25) + pm25 + pm25^2)
summary (reg)

# Add state fixed effect
regfe <- felm(data = df, formula = deaths_per_case ~ log(pm25) + pm25 + pm25^2 | State | 0 | fips)
summary (regfe)

# Controlling for county poverty rate----
df <- data %>% 
  select(`County FIPS Code`,
         State,
         Case_Fatality_Ratio, 
         `PM2.5     Wtd AM (µg/m3)`, 
         PCTPOVALL_2019) %>% 
  rename(deaths_per_case = Case_Fatality_Ratio,
         pm25 = `PM2.5     Wtd AM (µg/m3)`,
         fips = `County FIPS Code`,
         povrate = PCTPOVALL_2019 ) %>% 
  filter(!(pm25 == "ND" | pm25 == "IN")) %>% 
  mutate(pm25 = as.numeric(pm25))

reg <- felm(data = df, formula = deaths_per_case ~ povrate + pm25^2)
summary (reg)

# Add state fixed effect
regfe <- felm(data = df, formula = deaths_per_case ~ povrate + log(pm25) | State | 0 | fips)
summary (regfe)

reg <- felm(data = df, formula = deaths_per_case ~ povrate + pm25^2)
summary (reg)

# Plot Correlations----

df <- data %>%
  filter(Admin2 != "Unassigned" &
           !is.na(Case_Fatality_Ratio) &
           `PM2.5     Wtd AM (µg/m3)` != "IN" &
           `PM2.5     Wtd AM (µg/m3)` != "ND" &
           !is.na(PCTPOVALL_2019)) %>%   
  rename(FIPS = `County FIPS Code`, 
         PM25 = `PM2.5     Wtd AM (µg/m3)`) %>% 
  select(FIPS, 
         Case_Fatality_Ratio, 
         PM25, 
         PCTPOVALL_2019) %>% 
  mutate(Case_Fatality_Ratio = round(Case_Fatality_Ratio, 2),
         PM25 = as.numeric(PM25)) %>% 
  rename(DeathRate = Case_Fatality_Ratio)

#scatterplot using Death_rate vs PM2.5 with R value
ggplot(data=df, 
       aes(x=PM25, y=DeathRate))+
  geom_point() + 
  xlab("PM2.5 Levels") + 
  ylab("COVID 19 Death Rate") + 
  ggtitle("PM2.5 vs COVID 19 Death Rate")+
  geom_smooth(method=lm)+
  annotate(x=15, 
           y=10, 
           label=paste("R = ", 
                       round(cor(df$PM25,
                                 df$DeathRate),
                             2)), 
           geom="text", 
           size=4)

ggplot(data=df, 
       aes(x=PCTPOVALL_2019, y=DeathRate))+
  geom_point() + 
  xlab("% of All People Living in Poverty") + 
  ylab("COVID 19 Death Rate") + 
  ggtitle("County Poverty Rate vs COVID 19 Death Rate")+
  geom_smooth(method=lm, formula = y ~ x) +
  annotate(x=35, 
           y=6, 
           label=paste("R = ", 
                       round(cor(df$DeathRate,
                                 df$PCTPOVALL_2019),
                             2)), 
           geom="text", 
           size=4)

# Scatterplot Death Rate & Data in All Counties ----
df <- data %>%
  filter(Admin2 != "Unassigned" &
           !is.na(Case_Fatality_Ratio) &
           !is.na(PCTPOVALL_2019)) %>%   
  rename(FIPS = `County FIPS Code`) %>% 
  select(FIPS, 
         Case_Fatality_Ratio, 
         PCTPOVALL_2019) %>% 
  mutate(Case_Fatality_Ratio = round(Case_Fatality_Ratio, 2)) %>% 
  rename(DeathRate = Case_Fatality_Ratio)

ggplot(data=df, 
       aes(x=PCTPOVALL_2019, y=DeathRate))+
  geom_point() + 
  xlab("% of All People Living in Poverty") + 
  ylab("COVID 19 Death Rate") + 
  ggtitle("County Poverty Rate vs COVID 19 Death Rate")+
  geom_smooth(method=lm, formula = y ~ x) +
  annotate(x=40, 
           y=7.5, 
           label=paste("R = ", 
                       round(cor(df$DeathRate,
                                 df$PCTPOVALL_2019),
                             2)), 
           geom="text", 
           size=4)

#scatterplot using Death_rate vs PM10 with R value
# ggplot(data=covid_aqi_w_death, aes(x=PM10, y=Death_rate))+geom_point() + xlab("PM10 Levels") + ylab("COVID 19 Death Rate") + ggtitle("PM10 vs COVID 19 Death Rate")+geom_smooth(method=lm)+annotate(x=130, y=20, label=paste("R = ", round(cor(covid_aqi_w_death$PM10,covid_aqi_w_death$Death_rate),2)), geom="text", size=4)
# 
# #scatterplot using Death_rate vs CO with R value
# ggplot(data=covid_aqi_w_death, aes(x=CO, y=Death_rate))+geom_point() + xlab("CO Levels") + ylab("COVID 19 Death Rate") + ggtitle("CO vs COVID 19 Death Rate")+geom_smooth(method=lm)+annotate(x=2.2, y=20, label=paste("R = ", round(cor(covid_aqi_w_death$CO,covid_aqi_w_death$Death_rate),2)), geom="text", size=4)
# 
# #scatterplot using Death_rate vs NO2 with R value
# ggplot(data=covid_aqi_w_death, aes(x=NO2, y=Death_rate))+geom_point() + xlab("NO2 Levels") + ylab("COVID 19 Death Rate") + ggtitle("NO2 vs COVID 19 Death Rate")+geom_smooth(method=lm)+annotate(x=85, y=20, label=paste("R = ", round(cor(covid_aqi_w_death$NO2,covid_aqi_w_death$Death_rate),2)), geom="text", size=4)
# 
# #scatterplot using Death_rate vs O3 with R value
# ggplot(data=covid_aqi_w_death, aes(x=O3, y=Death_rate))+geom_point() + xlab("O3 Levels") + ylab("COVID 19 Death Rate") + ggtitle("O3 vs COVID 19 Death Rate")+geom_smooth(method=lm)+annotate(x=67, y=20, label=paste("R = ", round(cor(covid_aqi_w_death$O3,covid_aqi_w_death$Death_rate),2)), geom="text", size=4)
# 
# #scatterplot using Death_rate vs SO2 with R value
# ggplot(data=covid_aqi_w_death, aes(x=SO2, y=Death_rate))+geom_point() + xlab("SO2 Levels") + ylab("COVID 19 Death Rate") + ggtitle("SO2 vs COVID 19 Death Rate")+geom_smooth(method=lm)+annotate(x=55, y=20, label=paste("R = ", round(cor(covid_aqi_w_death$SO2,covid_aqi_w_death$Death_rate),2)), geom="text", size=4)




# Scratchpad----

df <- df %>% filter(!is.na(State)) %>% 
  select(-c(county, 
            state, 
            date, 
            confirmed_cases,
            confirmed_deaths,
            probable_cases,
            probable_deaths,
            date)) %>% 
  mutate(cases_per_100k = cases/`2010 Population`*100000,
         deaths_per_100k = deaths/`2010 Population`*100000,
         deaths_per_case = deaths/cases)

df2 <- df %>% select(`County FIPS Code`, deaths_per_case)
write_csv(df, "data/county_covid_air.csv")
write_csv(df2, "data/county_covid_air2.csv")


write_csv(covid %>% 
            mutate(cases_per_100k = cases/`2010 Population`*100000,
                   deaths_per_100k = deaths/`2010 Population`*100000,
                   deaths_per_case = deaths/cases) %>% 
            select(fips, deaths_per_case), "data/temp.csv")
