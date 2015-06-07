##
##  Reads a data set and creates a panel of 2 x 2 plots on electric power consumption
##
##  Coursera: Exploratory Data Analysis
##  Project 1
##
##  Dataset: Electric power consumption
##  Source: UCI Machine Learning Repository
##  https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
##  Upper left plot: xy plot of global active power over a two day period (in kilowatt)
##  Lower left plot: xy plot with energy for three submeters over a two day period (in watt-hour of active energy)
##  Upper right plot: Minute-averaged voltage over a two day period (in volt)
##  Lower right plot: Household global minute-averaged reactive power over a two day period (in kilowatt)
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

## -------------------- Creating Plot 4 -------------------------------------------------

## Checking if package "datasets" is installed. If not, then installing it
if (!"datasets" %in% rownames(installed.packages())){
    install.packages("datasets")
}
library("datasets")

## Initializing file device (without making a copy of the screen) 
## to ensure a bug in dev.copy is not triggered thereby misplacing the legend
png("./plot4.png",width=480,height=480)

## Make four plots appear on screen device
par(mfcol = c(2, 2))

## Plot upper left
with(reqdata, { plot(reqdata$datetime,reqdata$Global_active_power,
                main = "",
                xlab="",
                ylab="Global Active Power",
                col=1,
                cex.main=1,
                cex.axis=1,
                cex.lab=1,
                pch=".",
                bg = "transparent")
   
                lines(reqdata$datetime,reqdata$Global_active_power)}
     )

## Plot lower left
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

## Plot upper right
with(reqdata, { plot(reqdata$datetime,reqdata$Voltage,
                     main = "",
                     xlab="datetime",
                     ylab="Voltage",
                     col=1,
                     cex.main=1,
                     cex.axis=1,
                     cex.lab=1,
                     pch=".",
                     bg = "transparent")
                
                lines(reqdata$datetime,reqdata$Voltage)}
)

## Plot lower right
with(reqdata, { plot(reqdata$datetime,reqdata$Global_reactive_power,
                     main = "",
                     xlab="datetime",
                     ylab="Global_reactive_power",
                     col=1,
                     cex.main=1,
                     cex.axis=1,
                     cex.lab=1,
                     pch=".",
                     bg = "transparent")
                
                lines(reqdata$datetime,reqdata$Global_reactive_power)
                }
)

## Closing the file device
dev.off() 

## --------------------------------------------------------------------------------------