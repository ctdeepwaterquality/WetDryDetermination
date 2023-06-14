# CT Wet Dry Condition Determination

## Project Overview
To do many water quality analyses, it is important to know which days were wet days (had recently rained) or dry days. For Connecticut, we used daily precipitation at several weather stations across the state and used predetermined criteria to decide if a date was "wet" or "dry". We created a dataset of all the precipitation data from 2000-2021 and selected 23 stations that had the most completed precipitation datasets across the state. Then, using criteria listed in the [CT Bacteria TMDL Core Document](https://portal.ct.gov/-/media/DEEP/water/tmdl/CTFinalTMDL/STWDBact_tmdl_corefinal), determined if each date at each station was a "wet" or a "dry" day. 

## To get started
The script is included in this repository. You need a precipitation dataset that includes station information and precipitation amount data. We used the [NOAA Climate Data Online portal](https://www.ncei.noaa.gov/cdo-web/). 

