#Title: rv-05-raster-multi-band-in-r.R
#BCB503 Geospatial Workshop, April 23 and 24th, 2020
#University of Idaho
#Data Carpentry Geospatial Analysis
#Instructors: Erich Seamon, University of Idaho - Travis Seaborn, University of Idaho

library(raster)
library(rgdal)
library(ggplot2)
library(dplyr)


#We introduced multi-band raster data in an earlier lesson.This episode 
#explores how to import and plot a multi-band raster in R.

## Getting Started with Multi-Band Data in R

#In this episode, the multi-band data that we are working with is imagery
#collected using the NEON high resolution camera over the NEON Harvard Forest 
#field site Each RGB image is a 3-band raster. The same steps would apply to
#working with a multi-spectral image with 4 or more bands - like Landsat imagery.

#If we read a RasterStack object into R using the `raster()` function, it only reads
#in the first band.

RGB_band1_HARV <- raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")


#We need to convert this data to a data frame in order to plot it with `ggplot`. 

RGB_band1_HARV_df  <- as.data.frame(RGB_band1_HARV, xy = TRUE)


ggplot() +
  geom_raster(data = RGB_band1_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho)) + 
  coord_quickmap()

## Challenge

#View the attributes of this band. What are its dimensions, CRS, 
#resolution, min and max values, and band number?

## Solution

RGB_band1_HARV


#Notice that when we look at the attributes of this band, we see:
#`band: 1  (of  3  bands)`

#This is R telling us that this particular raster object has more bands (3)
#associated with it.

## Data Tip

#The number of bands associated with a
#raster object can also be determined using the `nbands()` function: syntax is
#`nbands(RGB_band1_HARV)`.

### Image Raster Data Values

#As we saw in the previous exercise, this raster contains values between 
#0 and 255. These values represent degrees of brightness associated 
#with the image band. In the case of a RGB image (red, green and blue), 
#band 1 is the red band. When we plot the red band, larger numbers 
#(towards 255) represent pixels with more red in them (a strong red reflection). 
#Smaller numbers (towards 0) represent pixels with less red in them 
#(less red was reflected). To plot an RGB image, we mix red + green + blue 
#values into one single color to create a full color image - similar to the 
#color image a digital camera creates.

### Import A Specific Band

#We can use the `raster()` function to import specific bands in our raster object
#by specifying which band we want with `band = N` (N represents the band 
#number we want to work with). To import the green band, we would use `band = 2`.

RGB_band2_HARV <-  raster("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif", band = 2)


#We can convert this data to a data frame and plot the same way we plotted the 
#red band: 

RGB_band2_HARV_df <- as.data.frame(RGB_band2_HARV, xy = TRUE)


ggplot() +
  geom_raster(data = RGB_band2_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho)) + 
  coord_equal()


## Challenge: Making Sense of Single Band Images
 
#Compare the plots of band 1 (red) and band 2 (green). Is the forested 
#area darker or lighter in band 2 (the green band) compared to band 1 
#(the red band)?

## Solution

#We'd expect a *brighter* value for the forest in band 2 (green) than in
#band 1 (red) because the leaves on trees of most often appear "green" -
#healthy leaves reflect MORE green light than red light.


## Raster Stacks in R

#Next, we will work with all three image bands (red, green and blue) as an R
#RasterStack object. We will then plot a 3-band composite, or full color,
#image.

#To bring in all bands of a multi-band raster, we use the`stack()` function.

RGB_stack_HARV <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")

#Let's preview the attributes of our stack object: 

RGB_stack_HARV


#We can view the attributes of each band in the stack in a single output: 

RGB_stack_HARV@layers


#If we have hundreds of bands, we can specify which band we'd like to view
#attributes for using an index value: 

RGB_stack_HARV[[2]]


#We can also use the `ggplot` functions to plot the data in any layer
#of our RasterStack object. Remember, we need to convert to a data
#frame first. 
 
RGB_stack_HARV_df  <- as.data.frame(RGB_stack_HARV, xy = TRUE)


#Each band in our RasterStack gets its own column in the data frame. Thus we have: 

str(RGB_stack_HARV_df)


#Let's create a histogram of the first band: 

ggplot() +
  geom_histogram(data = RGB_stack_HARV_df, aes(HARV_RGB_Ortho.1))


#And a raster plot of the second band: 

ggplot() +
  geom_raster(data = RGB_stack_HARV_df,
              aes(x = x, y = y, alpha = HARV_RGB_Ortho.2)) + 
  coord_quickmap()

#We can access any individual band in the same way.

### Create A Three Band Image
#To render a final three band, colored image in R, we use the `plotRGB()` function.

#This function allows us to:

#1. Identify what bands we want to render in the red, green and blue regions. The
#`plotRGB()` function defaults to a 1=red, 2=green, and 3=blue band order. 
#However, you can define what bands you'd like to plot manually. Manual 
#definition of bands is useful if you have, for example a near-infrared 
#band and want to create a color infrared image.

#2. Adjust the `stretch` of the image to increase or decrease contrast.

#Let's plot our 3-band image. Note that we can use the `plotRGB()`
#function directly with our RasterStack object (we don't need a 
#dataframe as this function isn't part of the `ggplot2` package).

plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3)


#The image above looks pretty good. We can explore whether applying a stretch to
#the image might improve clarity and contrast using `stretch="lin"` or
#`stretch="hist"`.

#When the range of pixel brightness values is closer to 0, a darker 
#image is rendered by default. We can stretch the values to extend to the 
#full 0-255 range of potential values to increase the visual contrast of the image.


#When the range of pixel brightness values is closer to 255, a
#lighter image is rendered by default. We can stretch the values to extend to
#the full 0-255 range of potential values to increase the visual contrast of
#the image.


plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "lin")


plotRGB(RGB_stack_HARV,
        r = 1, g = 2, b = 3,
        scale = 800,
        stretch = "hist")

#In this case, the stretch doesn't enhance the contrast our image significantly
#given the distribution of reflectance (or brightness) values is distributed well
#between 0 and 255.

## Challenge - NoData Values
 
#Let's explore what happens with NoData values when working with 
#RasterStack objects and using the
#`plotRGB()` function. We will use the 
#`HARV_Ortho_wNA.tif` GeoTIFF file in the
#`NEON-DS-Airborne-Remote-Sensing/HARVRGB_Imagery/` directory.

#1. View the files attributes. Are there `NoData` values assigned for this file?
#2. If so, what is the `NoData` Value?
#3. How many bands does it have?
#4. Load the multi-band raster file into R.
#5. Plot the object as a true color image.
#6. What happened to the black edges in the data?
#7. What does this tell us about the difference in the data structure between
#`HARV_Ortho_wNA.tif` and `HARV_RGB_Ortho.tif` (R object `RGB_stack`). How can
#you check?

## Answers

#1) First we use the `GDALinfo()` function to view the 
#data attributes.

GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")


#2) From the output above, we see that there are `NoData` values
#and they are assigned the value of -9999. 
 
#3) The data has three bands. 
 
#4) To read in the file, we will use the `stack()` function: 

HARV_NA <- stack("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_Ortho_wNA.tif")

#5) We can plot the data with the `plotRGB()` function: 


plotRGB(HARV_NA,
        r = 1, g = 2, b = 3)


#6) The black edges are not plotted.

#7) Both data sets have `NoData` values, however, in the RGB_stack the 
#NoData value is not defined in the tiff tags, thus R renders them as 
#black as the reflectance values are 0. The black edges in the 
#other file are defined as -9999 and R renders them as NA.

GDALinfo("data/NEON-DS-Airborne-Remote-Sensing/HARV/RGB_Imagery/HARV_RGB_Ortho.tif")


## Data Tip
#We can create a RasterStack from
#several, individual single-band GeoTIFFs too. We will do this in 
#a later episode

## RasterStack vs RasterBrick in R

#The R RasterStack and RasterBrick object types can both store multiple bands.
#However, how they store each band is different. The bands in a RasterStack are
#stored as links to raster data that is located somewhere on our computer. A
#RasterBrick contains all of the objects stored within the actual R object.
#In most cases, we can work with a RasterBrick in the same way we might work
#with a RasterStack. However a RasterBrick is often more efficient and faster
#to process - which is important when working with larger files.

## More Resources

#You can read the help for the `brick()` function by typing `?brick`.

#We can turn a RasterStack into a RasterBrick in R by using
#`brick(StackName)`. Let's use the `object.size()` function to compare 
#RasterStack and RasterBrick objects. First we will check
#the size of our RasterStack object:

object.size(RGB_stack_HARV)


#Now we will create a RasterBrick object from our RasterStack data and view its size:

RGB_brick_HARV <- brick(RGB_stack_HARV)

object.size(RGB_brick_HARV)


#Notice that in the RasterBrick, all of the bands are stored within the actual
#object. Thus, the RasterBrick object size is much larger than the
#RasterStack object.

#You use the `plotRGB()` function to plot a RasterBrick too:

plotRGB(RGB_brick_HARV)


## Challenge: What Functions Can Be Used on an R Object of a particular class?

#We can view various functions (or methods) available to use on an R object with
#`methods(class=class(objectNameHere))`. Use this to figure out:
 
#1. What methods can be used on the `RGB_stack_HARV` object?
#2. What methods can be used on a single band within `RGB_stack_HARV`?
#3. Why do you think there is a difference?

## Answers

#1) We can see a list of all of the methods available for our
#RasterStack object:

methods(class=class(RGB_stack_HARV))


#2) And compare that with the methods available for a single band:

methods(class=class(RGB_stack_HARV[1]))

#3) There are far more things one could or want to ask of a full stack than of
#a single band.

