library(tidyverse)
library(dplyr)
install.packages("lfe",repos=unique(c(
  getOption("repos"),
  repos="https://cran.microsoft.com/snapshot/2020-12-04/"
)))
library(lfe)
library(readxl)
install.packages('ggplot2')
library('ggplot2')
install.packages('readxl')
library(readxl)
d <- data

g <- ggplot(data=data, aes(x=PM2.5, y=DeathRate))
g1 <- g+geom_point(color='gray75')
g1+stat_smooth(method = 'lm', se=F, color='black') +
geom_text(x=10, y=100, label="y=6.25x+63.91") + 
geom_text(x=10, y=80, label="R²=0.02873")
summary(lm(DeathRate~PM2.5, data))

g2 <- ggplot(data=data, aes(x=AQI, y=DeathRate))
g3 <- g2 +geom_point(color='gray75')
g3+stat_smooth(method = 'lm', se=F, color='black') +
  geom_text(x=30, y=100, label="y=2.41x+3.37") + 
  geom_text(x=30, y=80, label="R²=0.07463")
summary(lm(DeathRate~AQI, data))

