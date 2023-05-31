library(tidyverse)
library(lubridate)
library(padr)
library(openxlsx)
## if packages are not already installed, install using install.packages("[packagename]")

## CT precipitation dataset
df <- read.csv("All_CT_precip_data_2000_2021.csv")

## use only the main 23 data stations
## completing the time frame date sequence (all dates in 2000-2021)
## adding rows where missing dates
df_work <- df %>% 
  mutate(DATE = as.Date(DATE)) %>% #change date column to date format
  group_by(STATION) %>%
  filter(STATION %in% c(
    "USC00060973",
    "USW00094702",
    "USC00067958",
    "USC00067970",
    "USC00061762",
    "USW00014707",
    "USC00069388",
    "USC00065910",
    "USW00014740",
    "USC00062658",
    "USC00060128",
    "USW00054788",
    "USW00054767",
    "USC00060227",
    "USC00060299",
    "USC00063207",
    "USC00063420",
    "USC00065445",
    "USC00066655",
    "USC00067432",
    "USC00068138",
    "USW00014752",
    "USW00054734"
  )) %>% 
  pad(group = "STATION") #add rows in where there are missing dates


## dataset for only Bradley data
bdl <- df_work %>% 
  filter(STATION == "USW00014740") %>% 
  select(1:4,6:7)
  
## fill in all the blank gaps from other stations with BDL data
df_work_fill <- df_work %>% 
  select(1:7) %>% 
  left_join(bdl, by = c("DATE")) %>% 
  mutate(PRCP = coalesce(PRCP.x, PRCP.y), # if there is an NA for a date, coalesce fills in the NA with the BDL data
         STATION = coalesce(STATION.x, STATION.y),
         NAME = coalesce(NAME.x, NAME.y),
         LATITUDE = coalesce(LATITUDE.x, LATITUDE.y),
         LONGITUDE = coalesce(LONGITUDE.x, LONGITUDE.y),
         difference = PRCP.x-PRCP.y) %>% 
  select(STATION, NAME, LATITUDE, LONGITUDE, DATE, PRCP, difference)



## summary stats of difference btwn bdl station and other stations
df_summary <- df_work_fill %>% 
  select(NAME, STATION, difference) %>% 
  group_by(STATION) %>% 
  summarise(mean = mean(difference, na.rm=TRUE),
            median = median(difference, na.rm=TRUE),
            iqr = IQR(difference, na.rm=TRUE),
            n = n()) %>% 
  arrange(mean)
         

## calculate the wet or dry determination for each date at each station
wet_dry <- df_work_fill %>%
  select(-difference) %>% 
  group_by(STATION) %>% 
  mutate(prcp_48 = PRCP + lag(PRCP),
         prcp_72 = PRCP + lag(PRCP) + lag(PRCP, n = 2),
         prcp_96 = PRCP + lag(PRCP) + lag(PRCP, n = 2) + lag(PRCP, n = 3),
         wet_dry = ifelse(PRCP >= 0.1 | prcp_48 >= 0.25 | prcp_96 >= 2.0, 
                          "wet", "dry"))


## write the wet/dry csv
# write.csv(wet_dry, "WetDryAnalysis_CT_dataset_v2.csv")




