## Info about Data

### Global
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

### China
For final datasets and a Rmd file used for graphs in the China section, refer to the data-for-china folder.

For original datasets, refer to the original_data folder within the data-for-china folder.

The original datasets for China COVID-19 Data comes from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/MR5IJN

The original datasets for China Air Quality Data comes from https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/XETLSS

Step-by-step of the data transformation:

1) Merged COVID-19 data and Air Quality data using VLookup to match the city names written in English.

2) Took an average over Feb. - Oct. 2020 period for total cases, total deaths, PM2.5, PM10, NO2, O3, SO2, CO (for each city).

3) Divided total deaths by total cases for each city to calculate the death rate (see China_COVID_PM25 in data-for-china folder).

4) Removed cities that have 0 death cases (see China_COVID_PM25(remove_zero) in data-for-china folder).

5) For D3, took an average of all cities within a province to make a scatterplot at a province-level (see china_by_provinces and china_death_so2 in data-for-china folder). Also, D3 scatterplot codes come from https://www.d3-graph-gallery.com/graph/scatter_basic.html

6) For the last scatterplot in the China section, I produced a screenshot of the scatterplot that I produced using R. The Rmd file inside the data-for-china folder contains all of the codes I used to produce the scatterplot (step 4 was also done in the Rmd file).

You can use the [editor on GitHub](https://github.com/code4policy/Team-A3/edit/main/README.md) to maintain and preview the content for your website in Markdown files.

Whenever you commit to this repository, GitHub Pages will run [Jekyll](https://jekyllrb.com/) to rebuild the pages in your site, from the content in your Markdown files.

### US State-Level
For final datasets and a R file used for heat map and scattor plot in the US states level, refer to the data-for-US/original folder.

The original datasets for US COVID-19 Data comes from https://www.statista.com/statistics/1109011/coronavirus-covid19-death-rates-us-by-state/

The original datasets for US Air Quality(PM2.5) Data comes from https://aqs.epa.gov/aqsweb/airdata/download_files.html#Annual : Concentration by Monitor 2020. 

Step-by-step of the data transformation:

1) Merged PM 2.5 data by US_states using PM2.5 daily mean value and took a average value by state.

2) Filtered PM 2.5 data by US_states name and matched with COVID Death rate.

2-1) Filtered AQI(Air Quaility Index) by US states, but it was not used eventually. 

3) Using the gglot in R caculate the drawing the graph.

4) For D3 graphic, I uploaded my D3 graph on D3 folder, but it is not used on final project.

### US County-Level
All data used as inputs and produced as outputs for US county-level anlysis can be found in the [r folder](https://github.com/code4policy/Team-A3/tree/main/r).  The data transformation is documented via comments and legible code in [county_data.R](https://github.com/code4policy/Team-A3/blob/main/r/scripts/county_data.R).
