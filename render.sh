#!/bin/sh -x
# Enviromental Science for Social Change, 2014
# render maps

# plot 10 day accumulated rainfall

g.region pacific -pm
d.mon stop=cairo
d.mon --overwrite width=180 height=72 resolution=12 output=web/acc.png start=cairo
d.erase
d.rast --overwrite map=tenday_hourly_0
d.grid size=5:00:00 color=grey fontsize=12 width=2
d.vect --overwrite map=ne_admin_10m width=1.2 type=boundary color='black'
d.vect map='PAR' type=boundary width=4 color='white'
d.vect map=accumulation_contour color='white'
d.legend map=tenday_hourly_0 range=0,600 labelnum=5 at=0,40,2,500 use=0,50,80,100,120,150,180,200,400,500 fontscale=12 -f
#d.text text="10day Accumulated Rainfall(2014-12-04)" align=lc 

# Plot returnperiod
g.region manila -pm

for i in anomaly_2yr anomaly_5yr anomaly_10yr anomaly_25yr anomaly_50yr anomaly_100yr
   do
      d.mon stop=cairo
      d.mon --overwrite width=15 height=12 resolution=100 output=web/$i.png start=cairo
      d.erase
      d.rast --overwrite map=$i
      d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
      d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
      d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
      d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
      d.vect --overwrite map=site color=red fcolor=red icon=basic/circle size=20 attribute_column=site lsize=15 yref=bottom
      #d.rast.num -f map=2year_anomaly grid_color=none text_color=grey 
      d.legend map=$i range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontscale=30 -f
   done
