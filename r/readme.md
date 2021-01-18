# R Project for site

## Directory Structure
- /data/ - houses data inputs to and outputs from r scripts
- /scripts/ - houses r scripts
- /figures/ - houses r output graphics
- /r.rproj - R project
- /readme.md - readme
- /rstudio.sh - WSL shell script to add to bin (see below)

## R in WSL
Files Windows knows to open in R, like R projects, can already be opened with `open r.Rproj`, thanks to the open-wsl script added in the class setup process. 

This command places a script in `~/bash` to tell WSL system how to open rstudio with `rstudio`.
`curl -o ~/bin/rstudio https://raw.githubusercontent.com/code4policy/Team-A3/add-r-directory/r/rstudio.sh` 

Then mark the file safe. 
`chmod +x ~/bin/rstudio`
