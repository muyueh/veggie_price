Sys.setlocale("LC_TIME", "C") # or will use chinese month name

library(lubridate)
library(zoo)
library(stringr)

# ARIMA 
# http://www.statmethods.net/advstats/timeseries.html

setwd("/Library/WebServer/Documents/TestingDataV/30/veggie_price")
Weather = read.table("./weather/clean.tsv", header=T, sep="\t")
Weather = transform(Weather, 
                    dt = as.Date(dt),
                    precp = as.numeric(precp),
                    solar = as.numeric(solar),
                    temp_max = as.numeric(temp_max),
                    temp_min = as.numeric(temp_min),
                    evap = as.numeric(evap),
                    temp = as.numeric(temp)                    
)


# including today
accu = function(days, dataset){  
  n = dim(dataset)[1]
  
  out = c(matrix(NA, days - 1))
  
  sm = 0
  
  for(i in 1:days){
    sm = sm + dataset[i, 2]
  }  
  out = c(out, sm)
  
  for(o in (1:(n - days))){
    sm = sm - dataset[o, 2] + dataset[o + days, 2]
    out = c(out, sm)
  }
  
  rslt = cbind(dataset, out)
  lgth = length(rslt[1,])
  print(lgth)
  colnames(rslt)[lgth] = paste("precp", days, sep="_")
  
  (rslt)
}

accu = function(days, dataset){  
  n = dim(dataset)[1]
  
  out = c(matrix(NA, days - 1))
  
  sm = 0
  
  for(i in 1:days){
    sm = sm + dataset[i, 2]
  }  
  out = c(out, sm)
  
  for(o in (1:(n - days))){
    sm = sm - dataset[o, 2] + dataset[o + days, 2]
    out = c(out, sm)
  }
  
  rslt = cbind(dataset, out)
  lgth = length(rslt[1,])
  print(lgth)
  colnames(rslt)[lgth] = paste("precp", days, sep="_")
  
  (rslt)
}

# accu = function(days, dataset){  
#   n = dim(dataset)[1]
#   
#   out = c(matrix(NA, days - 1))
#   
#   for(o in (0:(n - days))){
#     sm = 0
#     for(i in (1 + o):(days + o)){
#       sm = sm + dataset[i, 2]
#     }
#     out = c(out, sm)
#   }
#   
#   colnames(out) = paste("precp", days, sep="+")
#   print(length(out))
#   (out)
# 
#   rslt = cbind(dataset, out)
#   lgth = length(rslt[1,])
#   print(lgth)
#   colnames(rslt)[lgth] = paste("precp", days, sep="+")
#   
#   (rslt)
# }
# 


View(accu(30, Weather))



accuWeather = accu(180, accu(150, accu(120, accu(90, accu(60, accu(30, Weather))))))
# this is too much loop; should be able to do this on one loop



View(accuWeather)

View(Weather)

# View(accu(2, Weather))

tail(Weather)

View(Weather[, 2])


# View(Weather)



# SQ茭白筍 # 0.5 high r squared

# SE青蔥
# LD青江白菜

# FT南瓜
# FK甜椒
# "FT南瓜"


Data = read.table("./data/SD洋蔥.tsv", header=T, sep="\t")

onlyMonth = function(date){
  return (format(as.yearmon(date), "%m"));
}
onlyWeek = function(date){
  return (weekdays(date))
}



PData = transform(Data, 
               date = as.Date(as.Date(date, "%Y年%m月%d") + years(1911))
)


# filtering out based on datatype
PData = PData[is.na(as.numeric(as.character(PData[, "mktname"]))), ]
PData = PData[is.na(as.numeric(as.character(PData[, "sbtype"]))), ]
PData = PData[is.na(as.numeric(as.character(PData[, "transformation"]))), ]
PData = PData[!is.na(as.numeric(as.character(PData[, "middleprice"]))), ]
PData = PData[!is.na(as.numeric(as.character(PData[, "quantity"]))), ]

PData = transform(PData, 
                  middleprice = as.numeric(as.character(middleprice)),
                  quantity = as.numeric(as.character(quantity))
)



# to update new levels
PData$mktname = factor(PData$mktname)
PData$sbtype = factor(PData$sbtype)
PData$transformation = factor(PData$transformation)

# levels(PData$mktname)

# View(PData)


fit =  lm(middleprice ~ factor(onlyWeek(date)) + factor(onlyMonth(date)) + date + factor(sbtype) + factor(mktname) + quantity, data = PData)
summary(fit)
# anova(fit)
# plot(fit)

# class((PData$date)[1])
# class((Weather$dt)[1])

# -- merging


m = merge(accuWeather, PData, by.x = "dt", by.y = "date", all.y=T)
# View(m)



mfit =  lm(temp_max ~ temp_min, data = m)
mfit =  lm(temp ~ solar, data = m)



mfit =  lm(middleprice ~ temp_max, data = m)




mfit =  lm(middleprice ~ precp, data = m)
summary(mfit)

mfit =  lm(middleprice ~ precp+3", data = m)
summary(mfit)


# 
# 
# mfit =  lm(middleprice ~ precp + solar + temp_max + temp_min + evap + temp + factor(onlyWeek(date)) + factor(onlyMonth(date)) + date + factor(sbtype) + factor(mktname) + quantity, data = m)
# 
# 
# 
# mfit =  lm(middleprice ~ precp, data = m)
summary(mfit)
