library(tidyverse)
library(stringr)
library(lfe)
# ----

#Read Data
# Data grabbed from #https://www.epa.gov/air-trends/air-quality-cities-and-counties, saved into .csv for R
air <- read_csv("data/ctyfactbook2019.csv")

# Format FIPS Codes for joining, drop county
air <- air %>% 
  mutate(`County FIPS Code` = str_pad(as.character(`County FIPS Code`), 
                                                   5, 
                                                   pad = "0")) %>% 
  select(-County) %>% 
  rename(FIPS=`County FIPS Code`)

# catalogued version in "data/us-county-covid-01-11-2021.csv"
covid <- read_csv ("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_daily_reports/01-10-2021.csv")

# Calculate deaths per case, format fips code
covid <- covid %>% 
  filter(!is.na(FIPS)) %>% 
  mutate(Death_Rate = Incident_Rate/Confirmed*Deaths,
         FIPS = str_pad(as.character(FIPS), 
                        5, 
                        pad = "0"))

# fips master list from https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html
fips_master <- read_csv("data/all-geocodes-v2018.csv")
fips_master <- fips_master %>% 
  filter(`County Code (FIPS)`!="000",
         `County Subdivision Code (FIPS)`=="00000", 
         `Place Code (FIPS)`=="00000", 
         `Consolidtated City Code (FIPS)`=="00000") %>% 
  mutate(County_FIPS_Full = paste(`State Code (FIPS)`,`County Code (FIPS)`, sep="")) %>% 
  select(County_FIPS_Full, `Area Name (including legal/statistical area description)`) %>% 
  rename(FIPS = County_FIPS_Full,
         County = `Area Name (including legal/statistical area description)`)

# Join data
data <- left_join(fips_master, air, by="FIPS")
data <- full_join(data, covid, by= "FIPS")

# Grabbed from https://www.ers.usda.gov/webdocs/DataFiles/48747/PovertyEstimates.xls?v=6924.4
poverty <- read_csv("data/poverty-by-county.csv")
poverty <- poverty %>% 
  rename(FIPS = FIPStxt)

# Join
data <- left_join(data, poverty, by= "FIPS")

# Export FIPS and Death Rate----
df <- data %>%
  filter(Admin2 != "Unassigned") %>% 
  select(FIPS, County, Case_Fatality_Ratio) %>% 
  filter(!is.na(Case_Fatality_Ratio)) %>% 
  mutate(Case_Fatality_Ratio = round(Case_Fatality_Ratio, 2)) %>% 
  rename(DeathRate = Case_Fatality_Ratio)

write_csv(df, "data/deaths_per_case.csv")

# Export FIPS and PM25----
df <- data %>% 
  select(FIPS, County, `PM2.5     Wtd AM (µg/m3)`) %>% 
  rename(pm25 = `PM2.5     Wtd AM (µg/m3)`) %>% 
  filter(pm25 != "ND",
         pm25 != "IN",
         !is.na(pm25)) %>% 
  mutate(pm25 = as.numeric(pm25))

write_csv(df, "data/pm25.csv")

# Export FIPS and Poverty Rate ----
df <- data %>% 
  select(FIPS,
         County,
         PCTPOVALL_2019) %>% 
  filter(!is.na(PCTPOVALL_2019)) %>% 
  rename(povrate = PCTPOVALL_2019 )

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
  ggtitle("COVID 19 Death Rate vs County Poverty Rate")+
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
  ggtitle("COVID 19 Death Rate vs County Poverty Rate")+
  geom_smooth(method=lm, formula = y ~ x) +
  annotate(x=40, 
           y=7.5, 
           label=paste("R = ", 
                       round(cor(df$DeathRate,
                                 df$PCTPOVALL_2019),
                             2)), 
           geom="text", 
           size=4)
