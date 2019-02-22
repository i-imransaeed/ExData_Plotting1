#dplyr provides a flexible grammar of data manipulation. It's the next iteration of plyr, focused on tools for working with data frames (hence the d in the name).
library(dplyr)

# Generic variables 

zipDataFileName <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataFileDir <- "exdata%2Fdata%2Fhousehold_power_consumption"
zipDataFilePath <- paste0(getwd(),"/", zipDataFileName)
dataFileName <- "household_power_consumption.txt"
dataFilePath <- paste0(getwd(),"/", dataFileName)

# STEP 1 - Get data
# Chcek if data exists in working directory.
if (!file.exists(zipDataFilePath)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, zipDataFilePath, method="curl")
}  
# STEP 1.1 - Unzip previously obtained data
if (file.exists(zipDataFilePath) & !file.exists(dataFileDir)) { 
  unzip(zipDataFilePath) 
}
houseHoldPowerConsData <- read.table(dataFilePath, header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
houseHoldPowerConsData$Date <-  as.Date(houseHoldPowerConsData$Date, format="%d/%m/%Y")
subSetData <- subset(houseHoldPowerConsData, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")) 
subSetData$dateTime <- strptime(paste(subSetData$Date, subSetData$Time), "%Y-%m-%d %H:%M:%S")
# Plot 2
subSetData$dateTime <- as.POSIXct(subSetData$dateTime)

with(subSetData,
    {
      par(mfrow = c(2, 2))
      plot(dateTime, Global_active_power, type="l", xlab="", ylab="Global Active Power", cex=0.2)
      plot(dateTime, Voltage, type="l", xlab="Date Time", ylab="Voltage")
      plot(dateTime, Sub_metering_1, type="l", ylab="Energy Submetering", xlab="")
      lines(dateTime, Sub_metering_2, type="l", col="red")
      lines(dateTime, Sub_metering_3, type="l", col="blue")
      legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2.5, col=c("black", "red", "blue"), bty="o")
      plot(dateTime, Global_reactive_power, type="l", xlab="Date Time", ylab="Global_reactive_power")
      dev.copy(png, file = "plot4.png", height = 480, width = 480)
      dev.off()
  })

