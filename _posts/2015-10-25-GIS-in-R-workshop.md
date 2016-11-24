---
title: "Work with GIS data in R"
layout: default
---
## Work with GIS data in R  
*The ducoment is based on the workshop I tought on Oct. 25 2015, Interdepartmental Workshop Series, Oklahoma State University, Stillwater, OK*

## 1. basic
Install and load libraries.


{% highlight r %}
# install.packages("rgdal") 
# install.packages("raster")
# install.packages("dismo")
library("rgdal") # this package is the basis of analyzing GIS data in R; for example, it handle basis coordinate systems, it defines a lot of spatial data types
library("raster")
library("dismo")
{% endhighlight %}

## 2. warm up 
R is pretty fun to use, let's plot some maps from one line of code

{% highlight r %}
require("XML")
# get a map of OK, you could type text that used to search on Google Maps
myMap <- gmap("oklahoma")
raster::plot(myMap)
{% endhighlight %}

![plot of chunk unnamed-chunk-2](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-2-1.png)

{% highlight r %}
# try different text
plot(gmap("stillwater,OK")) # seems good
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-3-1.png)

{% highlight r %}
# get a snapshot of Walmart (satellite image)
plot(gmap("walmart,stillwater,OK",type = "satellite") )
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-4-1.png)

{% highlight r %}
# get a snapshot of Boomer Lake (satellite image)
plot(gmap("boomer lake,stillwater,OK",type = "satellite") )
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-5-1.png)

## 3. spatial points
### 3.1 generate spatial points


{% highlight r %}
# get a map of OK 
myMap <- gmap("Oklahoma",lonlat=TRUE)
{% endhighlight %}


{% highlight r %}
# show the extent of this map (raster)
okExtent<- extent(myMap)
okExtent
{% endhighlight %}



{% highlight text %}
## class       : Extent 
## xmin        : -105.8468 
## xmax        : -91.56882 
## ymin        : 32.32012 
## ymax        : 38.17342
{% endhighlight %}


{% highlight r %}
# generate 10 random points (longitude & latitude) within this extent
myLongitude <- runif(n=10, min=okExtent[1] ,max=okExtent[2] )
myLatitude <- runif(n=10, min=okExtent[3] ,max=okExtent[4] )

# combine longitude and latitude by column
coords <- cbind(myLongitude,myLatitude)
head(coords)
{% endhighlight %}



{% highlight text %}
##      myLongitude myLatitude
## [1,]   -93.43081   34.73915
## [2,]   -92.68065   34.33011
## [3,]  -101.66260   34.13352
## [4,]   -95.98800   37.43642
## [5,]   -95.31286   36.34747
## [6,]  -102.96578   33.37099
{% endhighlight %}


{% highlight r %}
# make the points spatial
myPoints <- SpatialPoints(coords)

# plot the points
plot(myPoints) # but there is no background
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-9-1.png)


{% highlight r %}
# add some background
plot(myMap)
plot(myPoints, add=TRUE, col="red")
{% endhighlight %}

![plot of chunk unnamed-chunk-10](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-10-1.png)


### 3.2 generate spatial points with attribute column


{% highlight r %}
# generate random attribute for the points
myAtt <- sample(c("presence","absence"),10,replace=TRUE)

# change myAtt to DataFrame
myAtt <- as.data.frame(myAtt)
head(myAtt)
{% endhighlight %}



{% highlight text %}
##      myAtt
## 1  absence
## 2 presence
## 3  absence
## 4  absence
## 5 presence
## 6  absence
{% endhighlight %}



{% highlight r %}
# make spatial data frame (spatial points with attributes)
myPoints <- SpatialPointsDataFrame(coords,as.data.frame(myAtt))

# show the attribute of myPoints
myPoints@data
{% endhighlight %}



{% highlight text %}
##       myAtt
## 1   absence
## 2  presence
## 3   absence
## 4   absence
## 5  presence
## 6   absence
## 7   absence
## 8   absence
## 9   absence
## 10 presence
{% endhighlight %}



### 3.3 select a subset of points based on attributes

{% highlight r %}
# This is like subsetting a dataframe
myPoints_presence <- myPoints[myPoints$myAtt=="presence", ]

# plot the previously selected points as red
plot(myPoints)
plot(myPoints_presence,add=T,col="red")
{% endhighlight %}

![plot of chunk unnamed-chunk-12](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-12-1.png)

### 3.4 save our selected file as a shape file

{% highlight r %}
# the 1st parameter is the object, the 2nd parameter is the path and file name
shapefile(myPoints_presence,filename="temp/output.shp",overwrite=TRUE)
{% endhighlight %}



{% highlight text %}
## Error in rgdal::writeOGR(x, filename, layer, driver = "ESRI Shapefile", : Layer creation failed
{% endhighlight %}



{% highlight r %}
#file.exists("output.shp")
{% endhighlight %}

## 4. spatial polygons

### 4.1 build buffer of points, the unit of width depends on the geographic reference system of "myPoints"

{% highlight r %}
# build a dissolved buffer
myBuffer <- buffer(myPoints,width=1)
{% endhighlight %}



{% highlight text %}
## Loading required namespace: rgeos
{% endhighlight %}



{% highlight r %}
length(myBuffer)
{% endhighlight %}



{% highlight text %}
## [1] 1
{% endhighlight %}



{% highlight r %}
plot(myBuffer)
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-14-1.png)

{% highlight r %}
# build buffer independently for each point
myBuffer <- buffer(myPoints,width=1,dissolve=FALSE)
length(myBuffer)
{% endhighlight %}



{% highlight text %}
## [1] 10
{% endhighlight %}



{% highlight r %}
plot(myBuffer)
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-14-2.png)

{% highlight r %}
# plot them
plot(myMap)
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-14-3.png)

{% highlight r %}
plot(myPoints,add=T)
plot(myBuffer,add=T)
{% endhighlight %}

![plot of chunk unnamed-chunk-14](/figure/source/2015-10-25-GIS-in-R-workshop/2015-10-25-GIS-in-R-workshop/unnamed-chunk-14-4.png)



### 4.2 load existing polygons (data from <http://www.diva-gis.org/Data>)

{% highlight r %}
# use the shapefile function, which is used for export if the object is specified
map_state <- shapefile("data/USA_adm1.shp")
{% endhighlight %}



{% highlight text %}
## Error: file.exists(extension(x, ".shp")) is not TRUE
{% endhighlight %}



{% highlight r %}
# show the summary of the data
summary(map_state)
{% endhighlight %}



{% highlight text %}
## Error in summary(map_state): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
# show the structure of the data
head(map_state@data, n=5)
{% endhighlight %}



{% highlight text %}
## Error in head(map_state@data, n = 5): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
# show one colume
map_state$NAME_1
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
# plot the data
plot(map_state)
{% endhighlight %}



{% highlight text %}
## Error in plot(map_state): object 'map_state' not found
{% endhighlight %}


### 4.3 subset

{% highlight r %}
# only select Oklahoma
map_ok <- map_state[map_state$NAME_1 == "Oklahoma", ]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
plot(map_ok)
{% endhighlight %}



{% highlight text %}
## Error in plot(map_ok): object 'map_ok' not found
{% endhighlight %}



{% highlight r %}
# select states large area (> 30)
# step 1: do the logic judgement
selection <- map_state$Shape_Area > 30
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
# step 2: subset
map_selected <- map_state[selection,]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map_state' not found
{% endhighlight %}



{% highlight r %}
# the following code shows the same results, but I will nor run it.
#map_selected <- map_state[map_state$Shape_Area < 10,]

# show all columns/fields/attributes of the selections
map_selected@data
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map_selected' not found
{% endhighlight %}



{% highlight r %}
plot(map_selected)
{% endhighlight %}



{% highlight text %}
## Error in plot(map_selected): object 'map_selected' not found
{% endhighlight %}

### 4.4 save polygons

{% highlight r %}
shapefile(map_selected,"temp/selected_states.shp",overwrite=TRUE)
{% endhighlight %}



{% highlight text %}
## Error in shapefile(map_selected, "temp/selected_states.shp", overwrite = TRUE): object 'map_selected' not found
{% endhighlight %}


## 5. spatial raster

### 5.1 read/write raster files (data from <http://www.worldclim.org>)

{% highlight r %}
# read one raster layer
myLayer<- raster("data/bio1.bil")
{% endhighlight %}



{% highlight text %}
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
{% endhighlight %}



{% highlight r %}
plot(myLayer)
{% endhighlight %}



{% highlight text %}
## Error in plot(myLayer): object 'myLayer' not found
{% endhighlight %}



{% highlight r %}
# write one raster layer (not run)
# writeRaster(myLayer,filename="temp/ok_bio1.bil",format="EHdr",overwrite=TRUE)

# load several raster layers
# step 1 get a list of file names
list.files("data/") # we need to filter the names
{% endhighlight %}



{% highlight text %}
## character(0)
{% endhighlight %}



{% highlight r %}
list.files("data/",pattern=".bil") # the names are correct, but we need the full path
{% endhighlight %}



{% highlight text %}
## character(0)
{% endhighlight %}



{% highlight r %}
list.files("data/",pattern=".bil", full.names = TRUE) # the full name give you a relative path to current working directory
{% endhighlight %}



{% highlight text %}
## character(0)
{% endhighlight %}



{% highlight r %}
myFiles <- list.files("data/",pattern=".bil", full.names = TRUE) 

# step 2 treat them as raster stack
myLayers <- stack(myFiles)
{% endhighlight %}



{% highlight text %}
## Error in x[[1]]: subscript out of bounds
{% endhighlight %}



{% highlight r %}
plot(myLayers)
{% endhighlight %}



{% highlight text %}
## Error in plot(myLayers): object 'myLayers' not found
{% endhighlight %}



{% highlight r %}
# save several raster layers
formattedNames <- paste("temp/",names(myLayers),".bil", sep="")
{% endhighlight %}



{% highlight text %}
## Error in paste("temp/", names(myLayers), ".bil", sep = ""): object 'myLayers' not found
{% endhighlight %}



{% highlight r %}
formattedNames
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'formattedNames' not found
{% endhighlight %}



{% highlight r %}
# not run
# writeRaster(myLayers,filename= formattedNames, format="EHdr", bylayer=TRUE)
{% endhighlight %}

### 5.2 extraction by polygon

{% highlight r %}
# we only want to show Oklahoma, extract raster layer by polygon
raster_ok <- mask(myLayer, map_ok) # we may get error if the reference systems are different
{% endhighlight %}



{% highlight text %}
## Error in mask(myLayer, map_ok): object 'myLayer' not found
{% endhighlight %}

### 5.3 projection

{% highlight r %}
# check their CRS
crs(myLayer)
{% endhighlight %}



{% highlight text %}
## Error in crs(myLayer): object 'myLayer' not found
{% endhighlight %}



{% highlight r %}
crs(map_ok)
{% endhighlight %}



{% highlight text %}
## Error in crs(map_ok): object 'map_ok' not found
{% endhighlight %}



{% highlight r %}
# unify the CRS
map_ok_new <- spTransform(map_ok, crs(myLayer))
{% endhighlight %}



{% highlight text %}
## Error in spTransform(map_ok, crs(myLayer)): object 'map_ok' not found
{% endhighlight %}



{% highlight r %}
crs(map_ok_new)
{% endhighlight %}



{% highlight text %}
## Error in crs(map_ok_new): object 'map_ok_new' not found
{% endhighlight %}



{% highlight r %}
# extract raster by polygon 
raster_ok <- crop( myLayer ,extent(map_ok_new) ) # first cut by a rectangle
{% endhighlight %}



{% highlight text %}
## Error in crop(myLayer, extent(map_ok_new)): object 'myLayer' not found
{% endhighlight %}



{% highlight r %}
raster_ok <- mask(raster_ok, map_ok_new) # then cut by boundary
{% endhighlight %}



{% highlight text %}
## Error in mask(raster_ok, map_ok_new): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
plot(raster_ok)
{% endhighlight %}



{% highlight text %}
## Error in plot(raster_ok): object 'raster_ok' not found
{% endhighlight %}

### 5.4 extract by point

{% highlight r %}
extract(raster_ok,myPoints)
{% endhighlight %}



{% highlight text %}
## Error in extract(raster_ok, myPoints): object 'raster_ok' not found
{% endhighlight %}

### 5.5 resample

{% highlight r %}
# we want the new layer to be 3 times coarser at each axis (9 times coarser)
# read current resolution
raster_ok
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
nrow(raster_ok)
{% endhighlight %}



{% highlight text %}
## Error in nrow(raster_ok): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
ncol(raster_ok)
{% endhighlight %}



{% highlight text %}
## Error in ncol(raster_ok): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
extent(raster_ok)
{% endhighlight %}



{% highlight text %}
## Error in extent(raster_ok): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
# define new resolution
newRaster <- raster( nrow= nrow(raster_ok)/3 , ncol= ncol(raster_ok)/3 )
{% endhighlight %}



{% highlight text %}
## Error in nrow(raster_ok): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
# define extent
extent(newRaster) <- extent(raster_ok)
{% endhighlight %}



{% highlight text %}
## Error in extent(raster_ok): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
# fill the new layer with new values
newRaster <- resample(x=raster_ok,y=newRaster,method='bilinear')
{% endhighlight %}



{% highlight text %}
## Error in resample(x = raster_ok, y = newRaster, method = "bilinear"): object 'raster_ok' not found
{% endhighlight %}



{% highlight r %}
plot(newRaster) # new layer seems coarser
{% endhighlight %}



{% highlight text %}
## Error in plot(newRaster): object 'newRaster' not found
{% endhighlight %}

### 5.6 reclassify raster layer

{% highlight r %}
# we want to classify the world into two classes based on temperature, high > mean & low < mean
myLayer<- raster("data/bio1.bil")
{% endhighlight %}



{% highlight text %}
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
{% endhighlight %}



{% highlight r %}
# values smaller than meanT becomes 1; values larger than meanT will be 2
myMethod <- c(-Inf, 100, 1,  100, Inf, 2)
myLayer_classified <- reclassify(myLayer,rcl= myMethod)
{% endhighlight %}



{% highlight text %}
## Error in reclassify(myLayer, rcl = myMethod): object 'myLayer' not found
{% endhighlight %}



{% highlight r %}
plot(myLayer_classified)
{% endhighlight %}



{% highlight text %}
## Error in plot(myLayer_classified): object 'myLayer_classified' not found
{% endhighlight %}

### 5.7 raster calculation

{% highlight r %}
# read precipitation data 
wet <- raster("data/bio13.bil") # precipitation of wettest month
{% endhighlight %}



{% highlight text %}
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
{% endhighlight %}



{% highlight r %}
dry <- raster("data/bio14.bil") # precipitation of driest month
{% endhighlight %}



{% highlight text %}
## Error in .rasterObjectFromFile(x, band = band, objecttype = "RasterLayer", : Cannot create a RasterLayer object from this file. (file does not exist)
{% endhighlight %}



{% highlight r %}
plot(stack(wet,dry))
{% endhighlight %}



{% highlight text %}
## Error in stack(wet, dry): object 'wet' not found
{% endhighlight %}



{% highlight r %}
# calculate the difference
diff <- wet - dry
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'wet' not found
{% endhighlight %}



{% highlight r %}
#plot(diff)

# calculate the mean of the two month
twoLayers <- stack(wet,dry)
{% endhighlight %}



{% highlight text %}
## Error in stack(wet, dry): object 'wet' not found
{% endhighlight %}



{% highlight r %}
meanPPT <- calc(twoLayers,fun=mean)
{% endhighlight %}



{% highlight text %}
## Error in calc(twoLayers, fun = mean): object 'twoLayers' not found
{% endhighlight %}



{% highlight r %}
#plot(meanPPT)

# the following code gives the same results
meanPPT2 <-  (wet + dry)/2
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'wet' not found
{% endhighlight %}



{% highlight r %}
# histogram of one layer
hist(twoLayers[[1]])
{% endhighlight %}



{% highlight text %}
## Error in hist(twoLayers[[1]]): object 'twoLayers' not found
{% endhighlight %}



{% highlight r %}
# correlation between different layers
pairs(twoLayers[[1:2]])
{% endhighlight %}



{% highlight text %}
## Error in pairs(twoLayers[[1:2]]): object 'twoLayers' not found
{% endhighlight %}

################################





## references
1. Spatial data in R: Using R as a GIS <http://pakillo.github.io/R-GIS-tutorial/>
