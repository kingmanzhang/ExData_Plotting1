## set working directory
wd = "~/git/ExData_Plotting1"
if (dir.exists(wd)) {
    setwd(wd)
} else {
    setwd("~/")
}

filenamezip = "household_power_consumption.zip"
filename = "household_power_consumption.txt"
## download data
if (!file.exists(filename)) {
    fileurl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileurl, destfile = filenamezip)
    unzip(filenamezip)
}

## read data
data <- read.table(file = filename, sep = ";", header = TRUE, colClasses = "character", na.strings = "?")

desiredDateIndex <- grep("^[0]?[12]/[0]?2/2007", data$Date)
subset <- data[desiredDateIndex,]

require(dplyr)
require(lubridate)

subset <- subset %>% 
    mutate(DateTime = dmy_hms(paste(subset$Date, subset$Time, sep = " "), tz = "Europe/Paris"), 
           Global_active_power = as.numeric(Global_active_power),
           Global_reactive_power = as.numeric(Global_reactive_power),
           Voltage = as.numeric(Voltage),
           Global_intensity = as.numeric(Global_intensity),
           Sub_metering_1 = as.numeric(Sub_metering_1),
           Sub_metering_2 = as.numeric(Sub_metering_2),
           Sub_metering_3 = as.numeric(Sub_metering_3)) %>%
    select(-c(Date, Time)) %>% 
    select(DateTime, everything())

#plot3
plot(subset$Sub_metering_1 ~ subset$DateTime, type = "l", 
     xlab = "", ylab = "Energy sub metering")
lines(subset$Sub_metering_2 ~ subset$DateTime, type = "l", col = "red")
lines(subset$Sub_metering_3 ~ subset$DateTime, type = "l", col = "blue")
legend("topright", lty = 1, col = c("gray", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       y.intersp = 0.5)

dev.copy(png, filename = "plot3.png")
dev.off()