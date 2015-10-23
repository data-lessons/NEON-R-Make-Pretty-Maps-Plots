setwd('/home/mckwit/Downloads/WData/1_WorkshopData')

library(raster) 
library(animation) #for making .gif animation
library(zoo) #timeseries data
library(stringr) #string manipulation

##Path to rasters 
rastPath <- "Landsat_NDVI/HARV/2011/ndvi"

##Get names of raster files and extract Day of Year
##The title of each raster starts will a three digit number that indicates the day of year.
##We can manualy input it or we can use str_extract pull the information using regular expressions.
rastFiles <-  list.files(rastPath, full.names=FALSE, pattern = ".tif$")
doy <- c(5,  37,  85, 133, 181, 197, 213, 229, 245, 261, 277, 293, 309) 
doy <- as.numeric(str_extract(rastFiles,"^[0-9]{3,3}")) 

##List full raster paths and read raster stack
rastFiles <-  list.files(rastPath, full.names=TRUE, pattern = ".tif$")
rastStack <- stack(rastFiles)

## Read in RGB files
rgbPath <- "Landsat_NDVI/HARV/2011/RGB"
rgbFiles <-  list.files(rgbPath, full.names=TRUE, pattern = ".tif$")

#Get climate(Temperature) Data
csvPath = "AtmosData/HARV"
csvFiles <-  list.files(csvPath, full.names=TRUE, pattern = "daily")
dayAtm = read.csv(csvFiles)

## Ploting Time series data with emphasis on the year we have NDVI data for, 2011.

## Initial plot call defines the plotting region based on all of the data within the plot.
## In this plot we are not going plot the data, type = 'n', label the plot, or add axes.
plot(x = dayAtm[,'jd'],y = dayAtm[,'airt'],type='n',xlab="",ylab="",bty="n",xaxt='n',yaxt='n')
  # Add a grid to the background
  grid() 
  # Add all of the data points to the plot.
  # col = color of the points, rgb(red,green,blue,transparency),pch = point type, cex = point size 
  points(x = dayAtm[,'jd'],y = dayAtm[,'airt'],col=rgb(.2,.2,.2,.1),pch=20,cex=.75)
  # whr = which rows of the data are from 2011 
  yr = format(as.Date(dayAtm[,'date']),"%Y")
  whr = which(yr =='2011')
  # store a rolling mean for 2011 to smooth the data
  meanTemp <- rollmean(dayAtm[whr,'airt'],30)
  # store the days for 2011
  days <- dayAtm[whr,'jd']
  # Add 2011 data as a line. lwd = line width
  lines(x = days,y = meanTemp, col='black',lwd=2)
  # Add axes to plot. Side = which side of the plot to place the axis, 1=bottom,2=left,3=top,4=right
  axis(side = 1,tick = F) 
  axis(side = 2,tick = F)
  # Add labels
  title(xlab="Day of Year",ylab="Temperature (C)",main = "30 Day Mean Temperature" )

  #Highlight data at one day of year.
  whr = which(days == 197) #Which row of dataset is DOY 197
  #Add vertical(v=) and horizontal(h=) lines at DOY 197 
  abline(v = as.numeric(197),h = meanTemp[whr],col='red',lty=3)
  #Add point at DOY 197
  points(as.numeric(197),meanTemp[whr],col='red',pch=20)

# Put all of these lines into one function call
timeSeriesPlot <- function(x = dayAtm[,'jd'], y = dayAtm[,'airt'], 
                           emphYear = '2011', emphDOY = '197',
                           xlab="Day of Year",ylab="Temperature (C)",main = "30 Day Mean Temperature"
  ){
  
  plot(x = x,y = y,type='n',xlab="",ylab="",bty="n",xaxt='n',yaxt='n')
  # Add a grid to the background
  grid() 
  # Add all of the data points to the plot.
  # col = color of the points, rgb(red,green,blue,transparency),pch = point type, cex = point size 
  points(x = x,y = y,col=rgb(.2,.2,.2,.1),pch=20,cex=.75)
  # whr = which rows of the data are from 2011 
  yr = format(as.Date(dayAtm[,'date']),"%Y") #make year from date
  whr = which(yr ==emphYear)
  # store a rolling mean for 2011 to smooth the data
  meanTemp <- rollmean(y[whr],30)
  # store the days for 2011
  days <- x[whr]
  # Add 2011 data as a line. lwd = line width
  lines(x = days,y = meanTemp, col='black',lwd=2)
  # Add axes to plot. Side = which side of the plot to place the axis, 1=bottom,2=left,3=top,4=right
  axis(side = 1,tick = F) 
  axis(side = 2,tick = F)
  # Add labels
  title(xlab=xlab,ylab=ylab,main = main ,cex.lab=1.25)
  
  #Highlight data at one day of year.
  whr = which(days == emphDOY) #Which row of dataset is emphasis
  #Add vertical(v=) and horizontal(h=) lines at emphasis 
  abline(v = as.numeric(emphDOY),h = meanTemp[whr],col='red',lty=3)
  #Add point at DOY emphasis
  points(as.numeric(emphDOY),meanTemp[whr],col='red',pch=20)
  
}

?layout

par(fig=c(0,0.5,0,0.5))
plot(1,1)


### It's time for the animator
### To animate a gif we will need to use the animation library 
### and a loops to sequentially display the graphics to be displayed

## The structure of a for loop 
## Add a quick intro
  
##   
saveGIF(
  ## add every thing to plot in the gif (this would be a great place to introduce functions ass well)
  for (i in 1:length(rastFiles)) {
    #par: controls the graphics element, mfrow=c(# of rows, # of columns), mar=c(botom margin size,left,right,top,right)
    par(mfrow=c(1,3),mar=c(4,5,4,5))
        
    #add our NDVI raster from above (great if this is a function),
    #rastStack[[i]], iterates through the raster stack for each layer in the gif
    plot(rastStack[[i]],legend=T,
         main=paste0("NDVI on Day of Year ", doy[i]),
         col=rev(terrain.colors(30)),
         zlim=c(1500,10000) ,bty='n',
         cex.lab=2,cex.axis=1.5,cex.main=2.5,
         legend.width=2, legend.shrink=0.75)
    #Add the timeseries we created previously created he only differnaces is where points are emphasized 
    plot(dayAtm[,'jd'],dayAtm[,'airt'],type='n',xlab="",ylab="",bty="n",xaxt='n',yaxt='n')
      grid()
      points(dayAtm[,'jd'],dayAtm[,'airt'],col=rgb(.2,.2,.2,.1),pch=20,cex=.75)
      whr = which(yr =='2011')
      meanTemp <- rollmean(dayAtm[whr,'airt'],30)
      days <- dayAtm[whr,'jd']
      lines(days,meanTemp,col='black',lwd=2)
      axis(1,tick=F,cex.axis=1.5)
      axis(2,tick=F,cex.axis=1.5)
      title(xlab="Day of Year",ylab="",main = "30 Day Mean Temperature (C)" 
            ,cex.lab=2,cex.main=2.5)
      
      ## Emphasis moves by iterator: doy[i]
      whr = which(days == as.numeric(doy[i]))
      abline(v = as.numeric(doy[i]),h = meanTemp[whr],col='red',lty=3,lwd=2)
      points(as.numeric(doy[i]),meanTemp[whr],col='red',pch=20,cex=2)
    
    ## Add RGB images to plot
    rgbStack <- stack(rgbFiles[i])
    plotRGB(rgbStack)
  }, 
  movie.name = "temp.gif", 
  ani.width = 1500, ani.height = 500, 
  interval=1)

    
    saveGIF(
     for (i in 1:length(rastFiles)) {
        par(mfrow=c(1,3),mar=c(4,5,4,5))
        
        plot(rastStack[[i]],
          main=paste0("NDVI on Day of Year ", doy[i]),
          col=rev(terrain.colors(30)),
          zlim=c(1500,10000) ,bty='n',
          cex.lab=2,cex.axis=1.5,cex.main=2.5,
          legend.width=2, legend.shrink=0.75)
            
          timeSeriesPlot(emphDOY = doy[i])
            
          rgbStack <- stack(rgbFiles[i])
          plotRGB(rgbStack)
      }, 
      movie.name = "temp.gif", 
      ani.width = 1500, ani.height = 500, 
      interval=1)    