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

# Converting Date for Subsequent Subsetting
epc.data$Date <- as.Date(epc.data.copy$Date, "%d/%m/%Y")

# Subsetting data set for 02/01 and 02/02/2007
epc.data <- epc.data[epc.data[,1] == "2007-02-01" |
			 epc.data[,1] == "2007-02-02", ]

# Open file for plotting Histogram
png(file = "Plot1.png", bg= "transparent")

# Histogram Creation
# Options Used:
#	main, xlab = "" 		To remove default title & xlabel
#	col = "orange" 		Column colour
#	labels = TRUE 		To display frequency values
#	xlim and ylim		TO set x & y axes ranges

hist(epc.data.Subset$Global_active_power, 
	main = "", xlab = "", col = "orange", border = TRUE, labels = TRUE, 
	xlim = range(0, 8), ylim = range(0, 1400, 200))

# Adding Titles
title(main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# Closing open file
dev.off()