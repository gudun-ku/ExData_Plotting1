## assuming that data file was downloaded and unpacked into subdir "./data inside working directory
destdir <- "./data"
filename <- "household_power_consumption.txt"
datafile <- paste0(destdir,"/",filename)

## making string date constants to filter data while reading file
firstDate <- as.Date("2007-02-01", "%Y-%m-%d")
secndDate <- as.Date("2007-02-02", "%Y-%m-%d")
firstDatestr <- paste0(gsub("0","",format(firstDate,"%d/%m")),"/",format(firstDate,"%Y"))
secndDatestr <- paste0(gsub("0","",format(secndDate,"%d/%m")),"/",format(secndDate,"%Y"))

## creating connection to file for nonblocking scan
con <- file(datafile, "r", blocking = FALSE)

## skip the file header
tmp <- scan(con, what = character(), nlines = 1, sep = ";",quiet = TRUE)
df <- data.frame(stringsAsFactors = FALSE)
n <- 2075259
for (i in 2:n) {
  tmp <- scan(con, what = list(Date = character(),
                               Time = character(),
                               Global_active_power = 0,
                               Global_reactive_power = 0,
                               Voltage = 0,
                               Global_intensity = 0,
                               Sub_metering_1 = 0,
                               Sub_metering_2 = 0,
                               Sub_metering_3 = 0),
              nlines = 1, 
              sep = ";",
              na.strings = "?",
              quiet = TRUE)
  
  if (tmp$Date == firstDatestr | tmp$Date == secndDatestr) {                 
    df <- rbind(df,as.data.frame(tmp, stringsAsFactors = FALSE))
  }
  
  
}
close(con)

## adding a new datetime variable to data frame
df$DateTime <- strptime(paste(df$Date,df$Time),"%d/%m/%Y %H:%M:%S")

## plot 3 

plot(x = df$DateTime,   
     y = df$Sub_metering_1,
     type="l",  
     xlab = "",
     ylab = "Energy sub metering",
     cex.lab=0.8, 
     lwd=1,
     col="black")
points(x = df$DateTime,   
       y = df$Sub_metering_2,
       type="l",         
       lwd=1,
       col="red")
points(x = df$DateTime,   
       y = df$Sub_metering_3,
       type="l",         
       lwd=1,
       col="blue")

legend('topright', 
       names(df)[7:9], 
       lty=1, col=c("black", "red", "blue"),        
       cex=0.8)

dev.copy(png, file = "plot3.png",width = 480, height = 480)
dev.off()