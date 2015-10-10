# Check if Download Directory exists

if (!file_test("-d", "./exdata_data_household_power_consumption")) {

	# Check if download file exists
	if(!file_test("-f", "./household_power_consumption.txt")) {

	# Required for Windows machine, otherwise use method = "curl" in download.file
	setInternet2(TRUE)

	# Download file
	download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
		"./exdata_data_household_power_consumption.zip", mode = "wb")

	#Unzip file
	utils::unzip("./exdata_data_household_power_consumption.zip", exdir = ".")

	}
}

# Check file size
file.size.mb <- ((file.info("./household_power_consumption.txt")$size / 1024) / 1024)

file.size.mb

# Read unzipped file into a data frame
# Use Options: 
#	sep = ;			Field Separator
#	na.strings = c("?") 	Convert all "?" to NA
#	comment.char = "", 	To boost performance

epc.data <- read.table("./household_power_consumption.txt", 
			sep = ";", header = TRUE, na.strings = c("?"),
			comment.char = "", stringsAsFactors = FALSE)

# Converting Date to a R Date class column for Subsequent Subsetting
epc.data$Date <- as.Date(epc.data.copy$Date, "%d/%m/%Y")

# Subsetting data set for 02/01 and 02/02/2007
epc.data <- epc.data[epc.data[,1] == "2007-02-01" |
			 epc.data[,1] == "2007-02-02", ]

# Creating Date Time Column
epc.data <- cbind(epc.data, datetime = strptime(paste(epc.data$Date, epc.data$Time), "%Y-%m-%d %H:%M:%S", 
		tz = "GMT"))

# Open file for plotting Histogram
#	Deafult Height and Width of PNG are in 480 pixels

png(file = "Plot4.png", bg = "transparent")

# Dividing Plotting Device (file) into 4 panels

par(mfrow = c(2, 2))

# Plotting Lines
# Options Used:
#	main = "", xlab = "", ylab = ""	Setting these to NULL values

with(epc.data, { 
	plot(datetime, Global_active_power,
		type = "l", main = "", xlab = "", ylab = "Global Active Power")
	plot(datetime, Voltage,
		type = "l", main = "", xlab = "datetime", ylab = "Voltage")
	{
	plot(datetime, Sub_metering_1,
		type = "n", main = "", xlab = "", ylab = "Energy Sub Metering")
	lines(datetime, Sub_metering_1)
	lines(datetime, Sub_metering_2, col = "red")
	lines(datetime, Sub_metering_3, col = "blue")
	legend("topright", lty = c(1, 1, 1), col = c("black", "red", "red"),
		legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
		bty = "n")
	}
	plot(datetime, Global_reactive_power,
		type = "l", main = "", lwd = 0.25,
		xlab = "datetime", ylab = "Global Reactive Power")
	})

# Closing open file
dev.off()