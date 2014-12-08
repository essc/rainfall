
#!/bin/sh -x
# Enviromental Science for Social Change, 2014


# Visualize one layer to check if the aggration run was OK.

g.region pacific -pm
d.mon stop=cairo
d.mon --overwrite width=180 height=72 resolution=12 output=web/acc.png start=cairo
d.erase
d.rast --overwrite map=tenday_hourly_0
d.grid size=5:00:00 color=grey fontsize=12 width=2
d.vect --overwrite map=ne_admin_10m width=1.2 type=boundary color='black'
d.vect map='PAR' type=boundary width=4 color='white'
d.vect map=accumulation_contour color='white'
d.legend map=tenday_hourly_0 range=0,600 labelnum=5 at=0,50,2,500 use=0,0,50,80,100,120,150,180,200,400,500 fontscale=10 -f
#d.text text="10day Accumulated Rainfall(2014-12-04)" align=lc 

#script.run_command('d.mon', start='png', output='view.png', overwrite=True)
#script.run_command('d.erase')
#script.run_command('d.rast', map='10day_hourly_0', overwrite=True)
#script.run_command('d.vect', map='ph_provinces_10m_NE', color='black', overwrite=True)
#script.run_command('d.vect', map='PAR', color='white', overwrite=True)
#script.run_command('d.vect', map='accumulation_contour', color='white', overwrite=True)
#script.run_command('d.grid', size='00:30:00', color='red', flags=w)
#script.run_command('d.legend', rast='10day_hourly_0', range=(0,800), labelnum='5', at=(5,10,5,50), flags='d' )
#Image('view.png')



#script.parse_command('g.region', region='manila', flags="p")  
#script.run_command('d.mon', start='png', output='view.png', overwrite=True)
#script.run_command('d.erase')
#script.run_command('d.rast', map='2year_anomaly', overwrite=True)
#script.run_command('d.rast.num', map='2year_anomaly', grid_color='none', text_color='grey', overwrite=True)
#script.run_command('d.vect', map='site', color='black', overwrite=True, attribute_column='site')
#script.run_command('d.vect', map='ph_provinces_10m_NE', color='black', overwrite=True)
#script.run_command('d.vect', map='PAR', color='white', overwrite=True)
#script.run_command('d.vect', map='accumulation_contour', color='white', overwrite=True)
#script.run_command('d.legend', rast='2year_anomaly', labelnum='5', range=(-500,500), at=(5,10,5,50), flags='d' )
#Image('view.png')
