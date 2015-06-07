##
##  Reads a data set and creates an xy plot with energy for three submeters over a two day period
##
##  Coursera: Exploratory Data Analysis
##  Project 1
##
##  Dataset: Electric power consumption
##  Source: UCI Machine Learning Repository
##  https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
##  Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
##      It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave 
##      (hot plates are not electric but gas powered).
##  Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
##      It corresponds to the laundry room, containing a washing-machine, a tumble-drier, 
##      a refrigerator and a light.
##  Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
##      It corresponds to an electric water-heater and an air-conditioner.
##  Dates: 2007-02-01 and 2007-02-02


## -------------------- Loading and Preparing Data --------------------------------------

## Checking if data exists in the working directory. If not, the script downloads the data
workdir<-getwd()

if (!file.exists("exdata-data-household_power_consumption")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, "./exdata-data-household_power_consumption.zip")
    unzip("exdata-data-household_power_consumption.zip")
} 

## Checking if package "data.table" is installed. If not, then installing it
if (!"data.table" %in% rownames(installed.packages())){
    install.packages("data.table")
}
library("data.table")

## Reading the text file constituting  data and saving it in dataset
fpath = file.path(workdir, "household_power_consumption.txt")
dataset <- read.csv(fpath, sep=";", na.strings="?")

## Note: date is a factor with format dd/mm/yyyy in dataset and has to be converted to date type POSIXct
datetime<-strptime(paste(dataset$Date,dataset$Time),"%d/%m/%Y %H:%M:%S")

## New column added to dataframe dataset 
dataset <- cbind(dataset,datetime)

## Filtering dataset to obtain the required data
reqdata <- dataset [grep("2007-02-01|2007-02-02", dataset$datetime),] 

## Deleting older data not required to free up memory
rm("dataset")

## -------------------- Creating Plot 3 -------------------------------------------------

## Checking if package "datasets" is installed. If not, then installing it
if (!"datasets" %in% rownames(installed.packages())){
    install.packages("datasets")
}
library("datasets")

## Initializing file device (without making a copy of the screen) 
## to ensure a bug in dev.copy is not triggered thereby misplacing the legend
png("./plot3.png",width=480,height=480)

## Resetting layout
par(mfrow = c(1, 1))

## Make plot appear on screen device
with(reqdata, { plot(reqdata$datetime,reqdata$Sub_metering_1,
                   main = "",
                   xlab="",
                   ylab="Energy sub metering",
                   col=1,
                   cex.main=1,
                   cex.axis=1,
                   cex.lab=1,
                   pch=".",
                   bg = "transparent")
                   
                lines(reqdata$datetime,Sub_metering_1)
                lines(reqdata$datetime,Sub_metering_2, col="red")
                lines(reqdata$datetime,Sub_metering_3, col="blue")
                legend("topright", pch="___", col = c("black", "red", "blue"), cex=1,
                    legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))}
    )

## Closing the file device
dev.off() 

## --------------------------------------------------------------------------------------