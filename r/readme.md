# R Project for site

## R in WSL
Files Windows knows to open in R, like R projects, can already be opened with `open r.Rproj`, thanks to the open-wsl script added in the class setup process. 

This command places a script in `~/bash` to tell WSL system how to open rstudio with `rstudio`.
`curl -o ~/bin/rstudio https://raw.githubusercontent.com/code4policy/Team-A3/add-r-directory/r/rstudio.sh` 

Then mark the file safe. 
`chmod +x ~/bin/rstudio`

## Within this directory are data, figures, and scripts directories, along with the r.Rproj project file.

### The folder ./data is for data used by and outputs created by .r files in ./scripts.

all-geocodes-v2018.csv - manipulated version of all-geocodes-v2018.xlsx that r parses for FIPS Codes and County Names

all-geocodes-v2018.xlsx - original file downloaded from https://www.census.gov/geographies/reference-files/2018/demo/popest/2018-fips.html





# Header 1
## Header 2
### Header 3