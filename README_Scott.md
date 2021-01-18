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