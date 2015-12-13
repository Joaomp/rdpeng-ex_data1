# Exploratory Data Analysis
# Week 01
# Data: Electric power consumption
#   9 variables
#   2,075,259 rows 
#   Date, Time and 7 Floating point numbers (8 bytes per number)
#   Lets consider that date and time also use 8 bytes each
#   Estimate size = 20 Mb
#   Start at 16/12/2006

# Read the datafile from 01/02/2007 up to 02/02/2007
# Skip 66637 records
# Read only two days = 60 * 24 * 2
filename <- "household_power_consumption.txt"
tempfile <- tempfile()
file_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_URL, tempfile, method = "curl")

colclasses <- c("character", "character", rep("numeric", 7))
colnames <- c("Date", "Time", "Global_active_power", "Global_reactive_power", 
              "Voltage", "Global_intensity", 
              "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

data <- read.delim(unz(tempfile, filename), sep = ";", header = FALSE, 
                   colClasses = colclasses, col.names = colnames, 
                   na.strings = "?",
                   skip = 66637, nrows = 2880)
unlink(tempfile)

# add a column with the date converted - Just for fun
data$DateC <- as.Date(data$Date, "%d/%m/%Y")

# add a column with the time converted
data$TimeC <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# Plots 
# Construct the plot and save it to a PNG file with
# a width of 480 pixels and a height of 480 pixels.
# Name each of the plot files as plot1.png, plot2.png, etc.

# PLot 4: 4 plots
par(mfrow = c(2, 2), mar = c(8, 6, 4, 2), cex = 0.6)
with(data, {
   plot(TimeC, Global_active_power, type = "l", ylab="Global Active Power", xlab="")
   plot(TimeC, Voltage, type = "l", ylab="Voltage", xlab="datetime")        
   plot(data$TimeC, data$Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering")
      lines(data$TimeC, data$Sub_metering_2, col="red")
      lines(data$TimeC, data$Sub_metering_3, col="blue")
      legend("topright", lty=1, col = c("black", "blue", "red"), bty="n", 
             legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
             cex = 0.9, inset = c(0.1, 0.000, 0.1, 0.1))
      plot(TimeC, Global_reactive_power, type = "l", xlab="datetime")})

dev.copy(png, file = "plot4.png", width = 480, height = 480) 
dev.off()
