
#!/bin/sh -x
# Enviromental Science for Social Change, 2014


# 10 day accumulated rainfall

g.region pacific -pm
d.mon stop=cairo
d.mon --overwrite width=180 height=72 resolution=12 output=web/acc.png start=cairo
d.erase
d.rast --overwrite map=10day_hourly_0 
d.grid size=5:00:00 color=grey fontsize=12 width=2
d.vect --overwrite map=ph_provinces_10m_NE width=1.2 type=boundary color='black'
d.vect map='PAR' type=boundary width=4 color='white'
d.vect map=accumulation_contour color='white'
d.legend rast=10day_hourly_0 range=0,600 labelnum=5 at=0,50,2,500 use=0,50,80,100,120,150,180,200,400,500 fontsize=15 -df
#d.text text="10day Accumulated Rainfall(2014-12-04)" align=lc 


# Run the return periods
g.region manila -pm

# 2yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_2yr.png start=cairo
d.erase
d.rast --overwrite map=2year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15 yref=bottom
#d.rast.num -f map=2year_anomaly grid_color=none text_color=grey 
d.legend rast=2year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

# 5yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_5yr.png start=cairo
d.erase
d.rast --overwrite map=5year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15
d.legend rast=5year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

# 10yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_10yr.png start=cairo
d.erase
d.rast --overwrite map=10year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15
d.legend rast=10year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

# 25yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_25yr.png start=cairo
d.erase
d.rast --overwrite map=25year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15
d.legend rast=25year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

# 50yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_50yr.png start=cairo
d.erase
d.rast --overwrite map=50year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15
d.legend rast=50year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

# 100yr returnperiod
d.mon stop=cairo
d.mon --overwrite width=15 height=12 resolution=100 output=web/anomaly_100yr.png start=cairo
d.erase
d.rast --overwrite map=100year_anomaly
d.vect --overwrite map=lake_laguna width=1 type=boundary color='100,100,100'
d.vect --overwrite map=lake_lamesa width=1 type=boundary color='100,100,100'
d.vect --overwrite map=ph_waterways width=1 type=line color='150,150,150'
d.vect --overwrite map=ph_land width=2 type=boundary color='100,100,100'
d.vect --overwrite map=site color=red fill_color=red icon=basic/circle size=20 attribute_column=site label_size=15
d.legend rast=100year_anomaly range=-1500,1500 labelnum=5 at=0,50,2,500 use=-1500,-1000,-500,-100,0,50,80,100,120,150,180,200,400,500,1000 fontsize=30 -df

