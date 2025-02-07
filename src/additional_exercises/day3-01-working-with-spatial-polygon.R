
# 
# The  will use following data set fo US Atlantic regions (expcept Florida)  which could be avilable fro download from  [here]
# (https://www.dropbox.com/s/1ofgjkpat6dso1l/DATA_06.7z?dl=0).
# 
# 
# 
# ## Age Adjusted Lung & Bronchus Cancer Mortality Rates by County
# 
# Age Adjusted Lung & Bronchus Cancer Mortality Rates from 1980 t0 2014 by county was obtained from 
# [Institute for Health Metrics and Evaluation (IHME)](http://ghdx.healthdata.org/us-data). The 
# rate was estimated using spatially explicit Bayesian mixed effects regression models for both 
# males and females [(Mokdad et al., 2016)](https://jamanetwork.com/journals/jama/fullarticle/2598772). 
# The model incorporated 7 covariates, such as  proportion of the adult population that graduated high school, 
# the proportion of the population that is Hispanic, the proportion of the population that is black, 
# the proportion of the population that is a race other than black or white, The proportion of a county 
# that is contained within a state or federal Native American reservation, the median household income, 
# and the population density.  To reduce the noise due to low mortality rate in a small population size, 
# we smoothed data with the [Empirical Bayesian smoother](https://en.wikipedia.org/wiki/Empirical_Bayes_method),  
# a tool for dealing with rate instability associated with small sample sizes.  It takes the population in the 
# region as an indicator of confidence in the data, with higher population providing a higher confidence in the 
# value at that location.  We used  [SpaceStat](https://www.biomedware.com/?module=Page&sID=spacestat) (Evaluation version) 
# Software for smoothing data. 
# 
# 
# ## Age-standardized Cigarette Smoking (%) Prevalence by County
# 
# Age-standardized cigarette smoking (%) prevalence by County estimated from the 
# [Behavioral Risk Factor Surveillance System (BRFSS)](https://www.cdc.gov/brfss/index.html) 
# survey data [(Dwyer-Lindgren et al., 2014)](https://pophealthmetrics.biomedcentral.com/articles/10.1186/1478-7954-12-5).  
# The prevalence (%) were estimated by logistic hierarchical mixed effects regression models, stratified by sex. 
# All estimates were age-standardized following the age structure of the 2000 census. The uncertainty of the 
# prevalence estimates was assessed using simulation methods.
# 
# 
# ## Age-standardized Poverty Rate by County 
# 
# County-level poverty data (% population below poverty level)  are from US Census 
# [Small Area Income and Poverty Estimates (SAIPE)](https://www.census.gov/programs-surveys/saipe/about.html) 
# Program. Income and poverty rate were estimated by combining survey data with population estimates and administrative records. 
# 
# 
# ## Particulate Matter (PM2.5)
# 
# Annual mean PM2.5 from 1998 to 2012 were modeled from aerosol optical depth from multiple satellite 
# ([Multiangle Imaging Spectra Radiometer](https://www-misr.jpl.nasa.gov/), 
#   [MODIS Dark Target](https://darktarget.gsfc.nasa.gov/products/land-10), 
#   [MODIS and SeaWiFS Deep Blue](https://deepblue.gsfc.nasa.gov/science), 
#   [MODIS MAIAC](https://ladsweb.modaps.eosdis.nasa.gov/api/v1/productGroupPage/name=maiac))  
# products  and validated by ground-based PM2.5 monitoring sites 
# [(Aaron van Donkelaar et al., 2016)](https://pubs.acs.org/doi/abs/10.1021/acs.est.5b05833).  
# All raster grid of PM2.5 were re-sampled at 2.5 km x 2 km grid size using [Empirical Bayesian Kriging]
# (http://desktop.arcgis.com/en/arcmap/10.3/guide-books/extensions/geostatistical-analyst/what-is-empirical-bayesian-kriging-.htm) 
# in ArcPython - Geo-statistical Tool [(ESRI, 2017)](https://www.esri.com/en-us/home)). 
# County population weighted mean for each year were calculated from the population data.    
# 
# 
# ## Nitrogen dioxide (NO2)
# 
# Annual mean ambient NO2 Concentrations estimated from three satellite instruments, such as  
# [Global Ozone Monitoring Experiment (GOME)](https://earth.esa.int/web/guest/missions/esa-operational-eo-missions/ers/instruments/gome),  
# [Scanning Imaging Absorption Spectrometer for Atmospheric Chartography (SCIAMACHY)]
# (https://www.sciencedirect.com/science/article/pii/009457659400278T) and [GOME-2]
# (http://www.ospo.noaa.gov/Products/atmosphere/gome/gome-A.html) satellite  
# in combination with chemical transport model [(Gedders et al., (2016)]
# (https://ehp.niehs.nih.gov/1409567/). All raster grid of PM2.5 were re-sampled at 2.5 km x 2 km grid size using 
# [Empirical Bayesian Kriging]
# (http://desktop.arcgis.com/en/arcmap/10.3/guide-books/extensions/geostatistical-analyst/what-is-empirical-bayesian-kriging-.htm) 
# in ArcPython - Geo-statistical Tool [(ESRI, 2017)](https://www.esri.com/en-us/home)). County population weighted mean for 
# each year were calculated from the population data.
#                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   


# 
# ## Sulfer dioxide (SO2)
# 
# Annual mean ambient SO2 Concentrations estimated were obtained from time series Multi-source SO2 emission retrievals 
# and consistency of satellite and surface measurements of [(Fioletov et al,(2017)]
# (https://www.atmos-chem-phys.net/17/12597/2017https://www.atmos-chem-phys.net/17/12597/2017/). 
# All raster grid of PM2.5 were re-sampled at 2.5 km x 2 km grid size using [Empirical Bayesian Kriging]
# (http://desktop.arcgis.com/en/arcmap/10.3/guide-books/extensions/geostatistical-analyst/what-is-empirical-bayesian-kriging-.htm) 
# in ArcPython - Geo-statistical Tool [(ESRI, 2017)](https://www.esri.com/en-us/home)). 
#   County population weighted mean for each year were calculated from the population data.


### Load packages


library(sp)
library(rgeos)
library(rgdal)
library(lattice)
library(latticeExtra)
library(RColorBrewer)
library(ggplot2) 
library(raster)
library(classInt)
library(stringr)
library(data.table)
library(rcompanion)


#### Load Data


# Define data folder
dataFolder<-"data/GWR/"

#### Load all CSV files

cancer<-read.csv(paste0(dataFolder, "Lung_cancer_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
poverty<-read.csv(paste0(dataFolder, "POVERTY_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
smoking<-read.csv(paste0(dataFolder, "SMOKING_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
PM25<-read.csv(paste0(dataFolder, "PM25_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
NO2<-read.csv(paste0(dataFolder, "NO2_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
SO2<-read.csv(paste0(dataFolder, "SO2_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
pop<-read.csv(paste0(dataFolder, "POP_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)


### Data Processing

#### Load State and County Shape files and Extract Centriod from County Shape file

county<-shapefile(paste0(dataFolder,"COUNTY_ATLANTIC.shp"))
state<-shapefile(paste0(dataFolder,"STATE_ATLANTIC.shp"))

#### Calculate Country Centriods

cent = gCentroid(county,byid=TRUE)


plot(state, main="County Centriods")
points(cent,pch=1, cex=0.5, col="red")



#### Convert contriods to SPDF  

XY.centriods<-as.data.frame(cent)
str(XY.centriods)


#### Calculate Mean  of All variables

#We will create a data frame 15 years (1998-2012) mean  all variables, and will this data in spatial statistics lesson. 


avg<-read.csv(paste0(dataFolder, "FIPS_COUNTY_ATLANTIC_COUNTY.csv"), stringsAsFactors = FALSE, check.names=FALSE)
avg$x<-XY.centriods$x
avg$y<-XY.centriods$y
avg$pop<-apply(pop[2:16],1,mean,na.rm=TRUE)
avg$cancer<-apply(cancer[2:16],1,mean,na.rm=TRUE)
avg$poverty<-apply(poverty[2:16],1,mean,na.rm=TRUE)
avg$smoking<-apply(smoking[2:16],1,mean,na.rm=TRUE)
avg$PM25<-apply(PM25[2:16],1,mean,na.rm=TRUE)
avg$NO2<-apply(NO2[2:16],1,mean,na.rm=TRUE)
avg$SO2<-apply(SO2[2:16],1,mean,na.rm=TRUE)
head(avg)
#write.csv(avg, paste0(dataFolder, "data_atlantic_1998_2012.csv"), row.names=FALSE)

#### Calculate confidence CI (95% CI, alpha = .05. )  of Mean 

#Now we will create a data frame with mean, standard and calculate of confidence intervals

numb=15
dof=15-1
cancer.stat<-read.csv(paste0(dataFolder, "FIPS_COUNTY_ATLANTIC_COUNTY.csv"), stringsAsFactors = FALSE, check.names=FALSE)
cancer.stat$avg<-apply(cancer[2:16],1,mean,na.rm=TRUE)
cancer.stat$std<-apply(cancer[2:16],1,sd,na.rm=TRUE)
cancer.stat$mse<- qt(.95,dof)*cancer.stat$std/sqrt(10)
cancer.stat$upper<-cancer.stat$avg + cancer.stat$mse
cancer.stat$lower<-cancer.stat$avg - cancer.stat$mse 
head(cancer.stat)



### Visualization


#Before plotting the data, we need join the data to county shape files

# Join data to county shape file
SPOLY.DF<-merge(county,cancer.stat, by="FIPS")



polys<- list("sp.lines", as(state, "SpatialLines"), col="grey", lwd=.8,lty=1)
col.palette<-colorRampPalette(c("blue",  "sky blue", "green","yellow", "red"),space="rgb",interpolate = "linear")

at.break = classIntervals(cancer.stat$avg, n = 20, style = "quantile")$brks
round(quantile(cancer.stat$avg, probs=seq(0,1, by=0.05)),1)


spplot(SPOLY.DF, 
       c("avg", "lower", "upper"), 
       names.attr = c("Mean","Lower", "Upper"),
       main = "Mean and 90% CI of Lung Cancer Mortality Rate (1998-2012)\n
             (death per 100,000)",
       sp.layout=list(polys),
       col="transparent",
       par.settings = list(axis.line = list(col = "grey"), 
                           strip.background = list(col = 'transparent'),
                           strip.border = list(col = 'grey')),
       par.strip.text=list(cex=0.9),
       at=at.break,
       colorkey=list(space="right",height=1, width=1.8,at=1:21,labels=list(cex=2.0,at=1:21,
                                                                           labels=c("" ,"", "< 55", "" ,"", "62","", "", "" , "", "69", "", "", "", "", 
                                                                                    "77", "", "", "> 85", "", ""))),
       col.regions=col.palette(100))




### Animation

#We  Created an animated time series map of  Lung Cancer Mortality Rate  from 1998-2012, To create an animation map in R,  we have to install #*animation*  packages in R. This package depends on [*ImageMagick*](https://www.imagemagick.org/) software. 


library(animation)


#After install you have define PATH of this software.  


Sys.setenv(PATH = paste("C:\\Program Files\\ImageMagick-7.0.6-0-Q16", Sys.getenv("PATH"), sep = ";"))
ani.options(convert="C:\\Program Files\\ImageMagick-7.0.6-0-Q16\\covert.exe")
magickPath<-shortPathName("C:\\Program Files\\ImageMagick-7.0.6-0-Q16-x64\\magick.exe")
ani.options(convert=magickPath)


wide.df<-read.csv(paste0(dataFolder, "Lung_cancer_1998_2012.csv"), stringsAsFactors = FALSE, check.names=FALSE)
# add id variable
wide.df$id <- c(1:666) # total 738 counties
# change name of first variable
colnames(wide.df)[1] <- 'FIPS'
# convert from wide to long
long.df<- reshape2::melt(wide.df, id.vars=c("FIPS","id"))
head(long.df)
# change name of third variable
colnames(long.df)[3] <- 'Year'
colnames(long.df)[4] <- 'Rate'

at.risk = classIntervals(long.df$Rate, n = 20, style = "quantile")$brks
round(quantile(long.df$Rate, probs=seq(0,1, by=0.05)),4)


mydata <- merge(county,cancer, by='FIPS')
names(mydata)
# delete unncessary  columns
mydata <- mydata[, -c(1:12)] # delete columns 1 through 11 & 27
new.col<-paste0("Year", seq(1998, 2012, by=1))
names(mydata)[1:15] = new.col



year=1998:2012
saveGIF(
  for (i in seq(year)){
    print(spplot(mydata [,i], 
                 main = list(label=paste0("Mortality Rate from Lung & Bronchus Cancer
                                          \n(death per 100,000):",year[i]),cex=1.5),
                 sp.layout=list(polys),
                 par.settings=list(axis.line=list(col="grey80",lwd=0.5)),
                 col="transparent",
                 at=at.risk,
                 colorkey=list(space="right",height=1, width=1.8,at=1:21,labels=list(cex=2.0,at=1:21,
                                                                                     labels=c("" ,"", "< 54", "" ,"", "62","", "", "" , "", "69", "", "", "", "", 
                                                                                              "75", "", "", "> 92", "", ""))),
                 col.regions=col.palette(100)))}, 
  ani.width = 500, ani.height = 700, interval = .5, clean = TRUE, outdir = "/mnt/lfs2/erichs/git/BCB503_advanced_geospatial_workshop/data/animation/")

