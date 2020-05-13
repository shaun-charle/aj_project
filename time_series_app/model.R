#Load Libraries
library(forecast)
library(dplyr)

model_function <- function(data){
#data <- read.csv('data/Data-sales.csv')
data$date <- as.Date(data$Date,format='%d/%m/%Y')
data <- data%>%mutate(sales_volume=Volume*UnitPrice)
agg_data <- data%>%select(date, sales_volume)%>%group_by(date)%>%summarise(daily_sales_volume = sum(sales_volume))

## Create a time series object
ts_agg_data <- ts(agg_data$daily_sales_volume, start = c(2019, 1),
                  frequency = 365)
plot(ts_agg_data)
fitARIMA<-forecast::Arima(ts_agg_data, order=c(1,1,1),seasonal = list(order = c(1,1,0), period = 24),method="ML")
fitARIMA

#forcast future values
par(mfrow=c(1,1))
futurVal <- forecast::forecast(object=fitARIMA,h=31, level=c(99.5)) #h is the number of days we are forcasting
plot(futurVal)
pdf('plot.pdf',5,5)
plot(futurVal)
dev.off()
forcast_table =data.frame('date' = seq(as.Date("2019/07/01"), by = "day", length.out = 31), 'forcasted_total_daily_sales'=c(futurVal$mean))

save(file='report_info.RData', forcast_table)

}