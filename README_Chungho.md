For final datasets and a R file used for heat map and scattor plot in the US states level, refer to the data-for-US/original folder.

The original datasets for US COVID-19 Data comes from https://www.statista.com/statistics/1109011/coronavirus-covid19-death-rates-us-by-state/

The original datasets for US Air Quality(PM2.5) Data comes from https://aqs.epa.gov/aqsweb/airdata/download_files.html#Annual : Concentration by Monitor 2020. 

Step-by-step of the data transformation:

1) Merged PM 2.5 data by US_states using PM2.5 daily mean value and took a average value by state.

2) Filtered PM 2.5 data by US_states name and matched with COVID Death rate.

2-1) Filtered AQI(Air Quaility Index) by US states, but it was not used eventually. 

3) Using the gglot in R caculate the drawing the graph.

4) For D3 graphic, I uploaded my D3 graph on D3 folder, but it is not used on final project.
