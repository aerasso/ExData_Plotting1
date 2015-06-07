##
##  Reads a data set and creates a histogram of global active power over a two day period
##
##  Coursera: Exploratory Data Analysis
##  Project 1
##
##  Dataset: Electric power consumption
##  Source: UCI Machine Learning Repository
##  https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
##  Global_active_power: household global minute-averaged active power (in kilowatt)
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

## -------------------- Creating Plot 1 -------------------------------------------------

## Checking if package "datasets" is installed. If not, then installing it
if (!"datasets" %in% rownames(installed.packages())){
    install.packages("datasets")
}
library("datasets")

## Resetting layout
par(mfrow = c(1, 1))

## Make plot appear on screen device
with(reqdata, hist(reqdata$Global_active_power,
                   main = "Global Active Power",
                   xlab="Global Active Power (kilowatts)",
                   col=2,
                   cex.main=0.75,
                   cex.axis=0.75,
                   cex.lab=0.75,
                   bg = "transparent"
                   
                   )) 

## cex doesn't work in hist()

## Copy first plot to a PNG file
dev.copy(png, file = "plot1.png") 
dev.off() 

##---------------------------------------------------------------------------------------
