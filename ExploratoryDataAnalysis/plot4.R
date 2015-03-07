#------ created by AxWZK
#------ 20-FEB-2015
#------
#------ Coursera Exploratory Data Analysis course project #1 -----
#
#------ plot4.R ------ 
# read the data and generate some plots. This will be an 
# infrastructure script for development and testing only
# ---------------------------------------------------------------------

#----------------------------- The Setup ------------------------------
# ---------------------------------------------------------------------
# Define files, libraries, and working directories
library(dplyr)
library(lubridate)
library(ff)
library(ffbase)

setwd("/home/axwzk314/R/datasciencecoursera/ExploratoryDataAnalysis")
if (!file.exists("data")) { dir.create("data")}
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Fetching my raw materials
projectdataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(projectdataURL, 
              destfile="./data/Project_1_Dataset.zip", 
              method="curl"
)
unzip("./data/Project_1_Dataset.zip", exdir="./data")

#------------------------------ The Work ------------------------------

# ---------------------------------------------------------------------
# Create new classes to properly format Date on read and
# set up other columns to speed things up a bit
setClass('cleanDate')
setAs("character","cleanDate", 
      function(from) as.Date(from, format="%d/%m/%Y"))

col_type <- c('cleanDate', # Date
              'factor',    # Time
              'numeric',   # Global_active_power
              'numeric',   # Global_reactive_power
              'numeric',   # Voltage
              'numeric',   # Global_intensity
              'numeric',   # Sub_metering_1
              'numeric',   # Sub_metering_2 
              'numeric'    # Sub_metering_3)
              
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# create an ff DataFrame using ffbase. Its overkill but
# I wanted to practice using it. NOTE* Combining ffbase functions like
# subset and as.Date is not quite functional, hence the hackery later on
dat.big <- as.ffdf(read.table("./data/household_power_consumption.txt",
                              header=TRUE,
                              sep=";",
                              na.strings="?",
                              colClass=col_type))
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Peel off the date range we want, build a proper timestamp, 
# and add weekday
dat.use <- data.frame(subset(dat.big, 
                             Date >= "2007-02-01" & Date < "2007-02-03"))

dat.use$timestamp <- as.POSIXct(strptime(paste(as.character(dat.use$Date), 
                                               as.character(dat.use$Time)), 
                                         "%Y-%m-%d %H:%M:%S"))
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Spit out the plot
png(file="plot4.png")
par( mfrow = c(2,2))
with( dat.use, {plot(timestamp, Global_active_power,       # Upper Left
                     xlab="",
                     ylab="Global Active Power (kilowatts)",
                     type="n")
                lines(timestamp, Global_active_power)
                #
                plot(timestamp, Voltage,                  # Upper Right
                     xlab="datetime",
                     ylab="Voltage",
                     type="n")
                lines(timestamp, Voltage)
                #
                plot(timestamp, Sub_metering_1,
                     xlab="",
                     ylab="Energy sub metering",
                     type="n")
                #
                lines(timestamp, Sub_metering_1) 
                lines(timestamp, Sub_metering_2, col="red") 
                lines(timestamp, Sub_metering_3, col="purple") 
                #
                legend("topright", 
                       c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ),
                       col=c( "black", "red", "purple" ),
                       lwd=1)
                #
                plot(timestamp, Global_reactive_power,                  # Lower Right
                     xlab="datetime",
                     ylab="Global_reactive_power",
                     type="n")
                lines(timestamp, Global_reactive_power)})
dev.off()
# ---------------------------------------------------------------------
