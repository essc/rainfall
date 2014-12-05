#!/bin/sh -x


## Download TRMM data from http://disc2.nascom.nasa.gov:80/dods/3B42RT_V7_rainrate

# Define start and end date.
END=$(date -u +"%Y-%m-%d %H:00:00")
START=$(date -u --date='480 hours ago' +"%Y-%m-%d %H:00:00")
TEN_DAYS=$(date -u --date='240 hours ago' +"%Y-%m-%d %H:00:00")

# Define number of time-step (3hr).
STEP="160" #i.e. 20 days

# Count number from starting time of the entire data set (i.e. 3B42RT_V7_rainrate is 00z01mar2000)
DAY_END=`echo $(( ( $(date -d "${END}" +'%s') - $(date -d '2000-03-01 00:00:00' +'%s') )/60/60/24 ))`
DAY_START=`echo $(( ( $(date -d "${START}" +'%s') - $(date -d '2000-03-01 00:00:00' +'%s') )/60/60/24 ))`

# Calculate minimum time data as Time_Index = D*8 + hour/3
MAX=`echo "(${DAY_END}*8)+1" | bc`
MIN=`echo "(${DAY_START}*8)+1" | bc`

# Calculate minimum time
LOWER_STEP=`echo "${MAX} - ${STEP}" | bc`

echo "Temporal coverage is "${MIN}","${MAX}".  Downloading data from http://disc2.nascom.nasa.gov:80/dods/3B42RT_V7_rainrate"

#ncks -O -v r -d time,${MIN},${MAX} -d lon,115.00,155.00 -d lat,4.00,22.00 \
#http://disc2.nascom.nasa.gov:80/dods/3B42RT_V7_rainrate \
#3hourly_trmm.nc

echo "Finished downloading data."

ncdump -tc 3hourly_trmm.nc

## Import data to GRASS GIS

#Set region pacific
g.region region=pacific -p

# Remove data from previous run
g.remove -f --q type=rast pattern=b.*

## Import netcdf layers

r.in.gdal --quiet input=3hourly_trmm.nc output=b -ok
g.list type=rast pattern=b* > file.txt
sort -t . -k 2 -g file.txt > filesort.txt  

## Register layers as strds

t.unregister maps=3hr_rainrate file=filesort.txt
#t.unregister file=filesort.txt

#t.register -i --quiet --overwrite type=rast input='3hr_rainrate' start="${START}" \
#increment="3 hours" file=filesort.txt

## Convert 3hourly rainrate to hourly
#t.rast.mapcalc --overwrite input=3hr_rainrate output=hourly_rainrate basename=hourly_rainrate expression="int(3hr_rainrate * 3)"


## Create 1 day aggregate from the compute hourly rainrate

#t.rast.aggregate --overwrite input="hourly_rainrate" \
#output="1day_aggregate" base="1day_aggregate" granularity="1 days" \
#method="sum" sampling="start"

## Create 10 day accumulation
#t.rast.aggregate --overwrite input="hourly_rainrate" \
#output="10day_hourly" base="10day_hourly" granularity="10 days" \
#method="sum" sampling="start" where="start_time == '${TEN_DAYS}'"

#r.contour --overwrite input=10day_hourly_0 output=accumulation_contour step=50 minlevel=0
#r.colors map=10day_hourly_0 rules=accumulation.rules

# testing t.rast.accumulate
#t.rast.accumulate --overwrite input=10day_hourly output=10day_accumulation \
#base=10day_accumulation start="${TEN_DAYS}" stop="${END}" \
#cycle="10 days" granularity="1 days" method=mean

## Compare to returnperiod

# 2yr returnperiod
#g.region region=manila

#r.mapcalc --overwrite "2year_anomaly = int(10day_hourly_0 - 2yr_rtnprd)"
#r.colors map=2year_anomaly rules=anomaly.rules

# 10yr returnperiod
#r.mapcalc --overwrite "10year_anomaly = int(10day_hourly_0 - 10yr_rtnprd)"
#r.colors map=10year_anomaly rules=anomaly.rules

# 25yr returnperiod
#r.mapcalc --overwrite "25year_anomaly = int(10day_hourly_0 - 25yr_rtnprd)"
#r.colors map=25year_anomaly rules=anomaly.rules

# 50yr returnperiod
#r.mapcalc --overwrite "50year_anomaly = int(10day_hourly_0 - 50yr_rtnprd)"
#r.colors map=50year_anomaly rules=anomaly.rules

# 100yr returnperiod
#r.mapcalc --o "100year_anomaly = int(10day_hourly_0 - 100yr_rtnprd)"
#r.colors map=100year_anomaly rules=anomaly.rules

## Get data from sites
 
#t.vect.observe.strds --overwrite --q input=site strds=hourly_rainrate output=site_hourly vector_output=site_hourly column=hourly
#t.vect.observe.strds --overwrite input=site strds=10day_hourly output=site_10day vector_output=site_10day column=acc10day

#export

#t.vect.db.select input=site_hourly columns=hourly separator=comma where="cat = 2" > quiapo_hourly.txt
#t.vect.db.select input=site_10day columns=acc10day separator=comma where="cat = 2" > quiapo_10day.txt

#t.vect.db.select input=site_hourly columns=hourly separator=comma where="cat = 1" > payatas_hourly.txt
#t.vect.db.select input=site_10day columns=acc10day separator=comma where="cat = 1" > payatas_10day.txt


echo "Temporal coverage is "${START}" UTC to "${END}" UTC".

