Sys.setlocale("LC_TIME", "C") # or will use chinese month name

library(lubridate)
library(zoo)
library(stringr)

# ARIMA 
# http://www.statmethods.net/advstats/timeseries.html

# worst than temp/precp

# how to account for delay
# grouping different vegetable

# extreme weather detection
# stable weather index

# able to run hypothesis vs. all

# custome area veggie


# use a broader range

# interchange


#why in the original weather info there is na?

setwd("/Library/WebServer/Documents/TestingDataV/30/veggie_price")
Weather = read.table("./weather/clean.tsv", header=T, sep="\t")

# View(Weather)
Weather = transform(Weather, 
                    dt = as.Date(dt),
                    precp = as.numeric(as.character(precp)),
                    solar = as.numeric(as.character(solar)),
                    temp_max = as.numeric(as.character(temp_max)),
                    temp_min = as.numeric(as.character(temp_min)),
                    evap = as.numeric(as.character(evap)),
                    temp = as.numeric(as.character(temp))
)


Weather = Weather[!is.na(Weather$dt), ]

View(Weather)

ifna = function(n){
  if (is.na(n)){
    return (0)
  }
  else{
    return (n)
  }
}


# including today
accu = function(days, dataset, idx, colname){  
  n = dim(dataset)[1]
  out = c(matrix(NA, days - 1)) #rep(NA, 10)
  sm = 0
  
  for(i in 1:days){
    sm = sm + ifna(dataset[i, idx])
  }  
  out = c(out, sm)
  
  for(o in (1:(n - days))){
    sm = sm - ifna(dataset[o, idx]) + ifna(dataset[o + days, idx])
    out = c(out, sm)
  }
  
  rslt = cbind(dataset, out)
  lgth = length(rslt[1,])
  print(lgth)
  colnames(rslt)[lgth] = paste(colname, days, sep="_")
  
  (rslt)
}


# this is only an abstraction of code, still wasting many looping time 
# this is too much loop; should be able to do this on one loop
abstra_accu = function(dataset, idx, name){
  accu(180, accu(150, accu(120, accu(90, accu(60, accu(30, dataset, idx, name), idx, name), idx, name), idx, name), idx, name), idx, name) 
}


# accu_multi = function(dataset){  
#   n = dim(dataset)[1]  
#   
#   
#   for(days in seq(30, 180, 30)){
#     out = c(matrix(NA, days - 1))
#     sm = 0
#   }
#   
#   for(i in 1:days){
#     sm = sm + dataset[i, 2]
#   }  
#   out = c(out, sm)
#   
#   for(o in (1:(n - days))){
#     sm = sm - dataset[o, 2] + dataset[o + days, 2]
#     out = c(out, sm)
#   }
#   
#   rslt = cbind(dataset, out)
#   lgth = length(rslt[1,])
#   print(lgth)
#   colnames(rslt)[lgth] = paste("precp", days, sep="_")
#   
#   (rslt)
# }


temp_diff = function(dataset){  
  n = dim(dataset)[1]
  
  out = c()
    
  for(i in 1:n){    
    out = c(out, ifna(dataset[i, 4]) - ifna(dataset[i, 5]))
  }
    
  rslt = cbind(dataset, out)
  lgth = length(rslt[1,])
  print(lgth)
  colnames(rslt)[lgth] = paste("temp_diff")
  
  (rslt)
}


# 
# extremdate = function(dataset){  
#   n = dim(dataset)[1]
#   
#   out = c()
#   
#   for(i in 1:n){    
#       if dataset[i, 4]
#     out = 
#       
#       c(out, ifna(dataset[i, 4]) - ifna(dataset[i, 5]))
#   }
#   
#   rslt = cbind(dataset, out)
#   lgth = length(rslt[1,])
#   print(lgth)
#   colnames(rslt)[lgth] = paste("temp_diff")
#   
#   (rslt)
# }

# accuSun = accu(30, Weather, 3, "solar")

accuAllWeather = temp_diff(Weather)
accuAllWeather = abstra_accu(abstra_accu(abstra_accu(abstra_accu(abstra_accu(accuAllWeather, 3, "precp"), 7, "temp"), 2, "solar"), 6, "evap"), 8, "temp_diff")

View(accuAllWeather)

write.table(accuAllWeather, file="./weather/accuAllWeather.tsv", sep='\t', quote=F, row.names=F)


# setwd("/Library/WebServer/Documents/TestingDataV/30/veggie_price")
# accuAllWeather = read.table("./weather/accuAllWeather.tsv", header=T, sep="\t", na.strings = "NA", colClasses= c("Date", rep("numeric",37)))


# View(accuAllWeather)


onlyMonth = function(date){
  return (format(as.yearmon(date), "%m"));
}
onlyWeek = function(date){
  return (weekdays(date))
}



not a good idea
# 
# roundTen = function(n){
#   return (floor(n / 10) * 10)
# }
# 
# roundFive = function(n){
#   return (floor(n / 5) * 5)
# }
# 
# roundOne = function(n){
#   return (floor(n / 1) * 1)
# }




# SQ茭白筍 # 0.5 high r squared

# SE青蔥


# FT南瓜
# FK甜椒
# FT南瓜

#SD洋蔥 0.4814 (wo weather 0.45)
#SQ茭白筍 0.59 (wo weather 0.54); quan: 0.4622 / r_middleprice can be as high as 0.98
#LI萵苣菜 0.4598  (wo weather 0.3976) / 0.98 

#SE青蔥/0.99 

# LD青江白菜/0.94 

Data = read.table("./data/SD洋蔥.tsv", header=T, sep="\t")

PData = transform(Data, 
               date = as.Date(as.Date(date, "%Y年%m月%d") + years(1911))
)

### filtering out based on datatype
PData = PData[is.na(as.numeric(as.character(PData[, "mktname"]))), ]
PData = PData[is.na(as.numeric(as.character(PData[, "sbtype"]))), ]
PData = PData[is.na(as.numeric(as.character(PData[, "transformation"]))), ]
PData = PData[!is.na(as.numeric(as.character(PData[, "middleprice"]))), ]
PData = PData[!is.na(as.numeric(as.character(PData[, "quantity"]))), ]

PData = transform(PData, 
                  middleprice = as.numeric(as.character(middleprice)),
                  quantity = as.numeric(as.character(quantity))
)

### to update new levels
PData$mktname = factor(PData$mktname)
PData$sbtype = factor(PData$sbtype)
PData$transformation = factor(PData$transformation)

# levels(PData$mktname)
# View(PData)

# fit =  lm(middleprice ~ factor(onlyWeek(date)) + factor(onlyMonth(date)) + date + factor(sbtype) + factor(mktname) + quantity, data = PData)
# summary(fit)
# 
# fit =  lm(middleprice ~ quantity, data = PData)
# summary(fit)

# anova(fit)
# plot(fit)



m = merge(accuAllWeather, PData, by.x = "dt", by.y = "date")
m = m[!is.na(m$dt), ] # remove na on dt

View(colMeans(accuAllWeather))

col_w = colMeans(subset(accuAllWeather, select= -c(dt)), na.rm = T)
View(col_w)




View(m)



# View(nm)

# length(accuAllWeather[,1])
# length(PData[,1])
# length(m[,1])
# 
# View(m[is.na(m$dt), ]) #6935
# length(m[,1]) #54726
# length(m[!is.na(m$dt), ][,1])




# mfit =  lm( r_middle_price_10 ~ . + factor(onlyMonth(dt)), data = subset(nm, select= -c(middleprice, transformation))) # remove all null
# summary(mfit)

mfit =  lm(middleprice ~ . + factor(onlyMonth(dt)), data = subset(m, select= -c(transformation))) # remove all null
summary(mfit)

mfit =  lm(middleprice ~ . + factor(onlyMonth(dt)), data = subset(nm, select= -c(transformation))) # remove all null
summary(mfit)

# length(m$quantity)
# length(resid(mfit))

plot(m$quantity, resid(mfit))

View(tail(m))


mfit =  lm(middleprice ~ . , data = subset(nm, select= -c(transformation)))
summary(mfit)

mfit =  lm(middleprice ~ precp_120 + precp_60 + solar_90 + precp + precp_30 + evap_150 + temp_90 + solar + temp_30 , data = m[, -c(34)])
summary(mfit)

mfit =  lm(middleprice ~ . , data = m[, -c(34)])
summary(mfit)


mfit =  lm(middleprice ~ . , data = PData[, -c(4)])
summary(mfit)

# library(MASS)
# stepwise = stepAIC(mfit, direction="both")
# stepwise$anova

# 
# Initial Model:
#   middleprice ~ dt + precp + solar + temp_max + temp_min + evap + 
#   temp + precp_30 + precp_60 + precp_90 + precp_120 + precp_150 + 
#   precp_180 + temp_30 + temp_60 + temp_90 + temp_120 + temp_150 + 
#   temp_180 + solar_30 + solar_60 + solar_90 + solar_120 + solar_150 + 
#   solar_180 + evap_30 + evap_60 + evap_90 + evap_120 + evap_150 + 
#   evap_180 + mktname + sbtype + quantity
# 
# Final Model:
#   middleprice ~ dt + temp_max + temp_min + evap + temp + precp_90 + 
#   precp_150 + precp_180 + temp_60 + temp_120 + temp_150 + temp_180 + 
#   solar_30 + solar_60 + solar_120 + solar_150 + solar_180 + 
#   evap_30 + evap_60 + evap_90 + evap_120 + evap_180 + mktname + 
#   sbtype + quantity
# 
# 
# Step Df     Deviance Resid. Df Resid. Dev      AIC
# 1                                  44637   781200.2 127940.7
# 2  - precp_120  1  0.002348081     44638   781200.2 127938.7
# 3   - precp_60  1  0.174544303     44639   781200.4 127936.7
# 4   - solar_90  1  2.738072890     44640   781203.1 127934.9
# 5      - precp  1  2.778702925     44641   781205.9 127933.0
# 6   - precp_30  1  3.312465360     44642   781209.2 127931.2
# 7   - evap_150  1  4.289448937     44643   781213.5 127929.5
# 8    - temp_90  1 11.455027675     44644   781224.9 127928.1
# 9      - solar  1 23.292010386     44645   781248.2 127927.5
# 10   - temp_30  1 33.141640531     44646   781281.4 127927.4

library(ggplot2)

sm = m[m$precp >200, ]

View(sm)

sm = m[m$evap_180 < 200, ]

sm = m[m$middleprice < 200, ]
ggplot(sm, (aes(NULL, NULL, x=dt, y = middleprice))) + geom_point()


ggplot(sm, (aes(NULL, NULL, x=precp_60, y=middleprice))) + geom_point(alpha=0.2)



ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=evap))) + geom_point()

ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=evap_150))) + geom_point()
ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=evap_180))) + geom_point()

ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=temp))) + geom_point()
ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=temp_diff))) + geom_point()


ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=temp_120))) + geom_point()
ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=precp_120))) + geom_point()

ggplot(accuAllWeather, (aes(NULL, NULL, x=dt, y=precp_150))) + geom_point()

ggplot(accuAllWeather, (aes(NULL, NULL, x=solar_150, y=precp_150))) + geom_point()


ggplot(accuAllWeather, (aes(NULL, NULL, x=onlyMonth(dt), y=precp))) + geom_point()
ggplot(accuAllWeather[accuAllWeather$solar <10, ], (aes(NULL, NULL, x=onlyMonth(dt), y=solar))) + geom_point()



