For the Global Data analysis, the following data sources were used:

-> For global (by-country) data on Corona Death rate: https://github.com/owid/covid-19-data/tree/master/public/data
-> For global (by-country) data on PM2.5 Air Pollution levels: https://data.worldbank.org/indicator/EN.ATM.PM25.MC.M3

Data manipulation:

Step 1: I matched 3-letter country codes from both data sets with a VLOOKUP function in excel and did a TRUE check if the match had worked
Step 2: I took the average of air pollution data between 2010 and 2017, to avoid overstating the effect of oulier years (e.g. through volcano eruptions or special weather conditions leading to higher PM 2.5 levels in any particular year)
Step 3: I deleted the indicators from the data set that I didn't need
Step 4: I recalculated deaths per 1million into deaths per 100k for consistency with the other teammembers metrics
Step 5: I deleted micronations from the data set
Step 6: I made a marker for whether a country was in the EU or not
Step 7: I produced my graphs with data wrapper