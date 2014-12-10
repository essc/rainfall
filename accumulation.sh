#!/bin/sh -x
# Enviromental Science for Social Change, 2014

## Download TRMM data from http://disc2.nascom.nasa.gov:80/dods/3B42RT_V7_rainrate

# Define start and end date.
END=$(date -u --date='1 hours ago' +"%Y-%m-%d %H:00:00")
START=$(date -u --date='456 hours ago' +"%Y-%m-%d %H:00:00")
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

ncks -O -v r -d time,${MIN},${MAX} -d lon,115.00,155.00 -d lat,4.00,22.00 \
http://disc2.nascom.nasa.gov:80/dods/3B42RT_V7_rainrate \
temp/3hourly_trmm.nc

echo "Finished downloading data."

ncdump -tc temp/3hourly_trmm.nc

## Import data to GRASS GIS

#Set region pacific
g.region region=pacific -p

# Remove data from previous run
#g.remove -f --q type=rast pattern=b.*
g.mremove -f --q rast=b.*

## Import netcdf layers
gdal_translate -of "GTiff" temp/3hourly_trmm.nc temp/3hourly_trmm.tif
r.in.gdal --quiet input=temp/3hourly_trmm.tif output=b -ok
g.mlist type=rast pattern=b* > temp/file.txt
sort -t . -k 2 -g temp/file.txt > temp/filesort.txt  

#g.region rast=b.1 save=pacific -p
## Register layers as strds

t.unregister input=trmm_3hr_rainrate file=temp/filesort.txt
#t.remove inputs=trmm_3hr_rainrate -rf

t.register -i --quiet --overwrite type=rast input='trmm_3hr_rainrate' \
start="${START}" increment="3 hours" file=temp/filesort.txt

## Convert 3hourly rainrate to hourly
#t.remove inputs=hourly_rainrate -rf
t.rast.mapcalc --overwrite input=trmm_3hr_rainrate output=hourly_rainrate basename=hourly_rainrate expression="int(trmm_3hr_rainrate * 3)"


## Create 1 day aggregate from the computed hourly rainrate
t.rast.aggregate --overwrite input="hourly_rainrate" \
output="daily_aggregate" base="daily_aggregate" granularity="1 days" \
method="sum" sampling="start"

## Create 10 day accumulation
t.rast.aggregate --overwrite input="hourly_rainrate" \
output="tenday_hourly" base="tenday_hourly" granularity="10 days" \
method="sum" sampling="start" where="end_time == '${TEN_DAYS}'"

r.contour --overwrite input=tenday_hourly_0 output=accumulation_contour step=50 minlevel=0
r.colors map=tenday_hourly_0 rules=rules/accumulation.rules

# testing t.rast.accumulate
#t.rast.accumulate --overwrite input=tenday_hourly output=tenday_accumulation \
#base=tenday_accumulation start="${TEN_DAYS}" stop="${END}" \
#cycle="10 days" granularity="1 days" method=mean

## Compare to returnperiod

# 2yr returnperiod
g.region region=manila

r.mapcalc --overwrite "anomaly_2yr = int(tenday_hourly_0 - rtnprd_2yr)"
r.colors map=anomaly_2yr rules=rules/anomaly.rules

r.mapcalc --overwrite "anomaly_5yr = int(tenday_hourly_0 - rtnprd_5yr)"
r.colors map=anomaly_5yr rules=rules/anomaly.rules

# 10yr returnperiod
r.mapcalc --overwrite "anomaly_10yr = int(tenday_hourly_0 - rtnprd_10yr)"
r.colors map=anomaly_10yr rules=rules/anomaly.rules

# 25yr returnperiod
r.mapcalc --overwrite "anomaly_25yr = int(tenday_hourly_0 - rtnprd_25yr)"
r.colors map=anomaly_25yr rules=rules/anomaly.rules

# 50yr returnperiod
r.mapcalc --overwrite "anomaly_50yr = int(tenday_hourly_0 - rtnprd_50yr)"
r.colors map=anomaly_50yr rules=rules/anomaly.rules

# 100yr returnperiod
r.mapcalc --o "anomaly_100yr = int(tenday_hourly_0 - rtnprd_100yr)"
r.colors map=anomaly_100yr rules=rules/anomaly.rules

## Get data from sites
 
t.vect.observe.strds --overwrite input=site strds=hourly_rainrate output=site_hourly vector_output=site_hourly column=hourly
t.vect.observe.strds --overwrite input=site strds=tenday_hourly output=site_10day vector_output=site_10day column=acc10day

#export

t.vect.db.select input=site_hourly columns=hourly separator=, where="cat = 2" > web/quiapo_hourly.txt
t.vect.db.select input=site_10day columns=acc10day separator=, where="cat = 2" > web/quiapo_10day.txt

t.vect.db.select input=site_hourly columns=hourly separator=, where="cat = 1" > web/payatas_hourly.txt
t.vect.db.select input=site_10day columns=acc10day separator=, where="cat = 1" > web/payatas_10day.txt

g.region region=pacific
r.out.gdal input=tenday_hourly_0 output=web/tenday_hourly_"${END}".tif

echo "Temporal coverage is "${TEN_DAYS}" UTC to "${END}" UTC". > web/log.txt
#echo "r.info tenday_hourly_0" >> web/log.txt

