# Check if Download Directory exists

if (!file_test("-d", "./exdata_data_household_power_consumption")) {

	# Check if download file exists
	if(!file_test("-f", "./household_power_consumption.txt")) {

	# Required for Windows machine, otherwise use method = "curl"
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

# Checking for NA values: if present removing from data set
if (anyNA(epc.data$Global_active_power)) {

epc.data <- epc.data[!is.na(epc.data$Global_active_power), ]

}

# Open file for plotting Histogram
#	Deafult Height and Width of PNG are in 480 pixels
png(file = "Plot2.png", bg= "transparent")

# Plotting Line
# Options Used:
#	type = "l"			To plot line
#	main = "", xlab = "", ylab = ""	Setting these to NULL values
#	tz = "GMT"			Setting Timezone to GMT

with(epc.data, 
	plot(strptime(paste(epc.data$Date, epc.data$Time), "%Y-%m-%d %H:%M:%S", 
		tz = "GMT"), epc.data$Global_active_power, 
		type = "l", main = "", xlab = "", ylab = ""))

# Adding Titles
title(ylab = "Global Active Power (kilowatts)")

# Closing open file
dev.off()