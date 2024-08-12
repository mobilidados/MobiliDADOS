rem Esse arquivo executável extrai as rms monitoradas por bounding box
rem Baixar RIDE

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.217 bottom=-17.3561 right=-46.2044 top=-14.536^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.217 bottom=-17.3561 right=-46.2044 top=-14.536^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.217 bottom=-17.3561 right=-46.2044 top=-14.536^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.217 bottom=-17.3561 right=-46.2044 top=-14.536^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.217 bottom=-17.3561 right=-46.2044 top=-14.536^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb ride/malha_viaria_ride.osm.pbf  


rem Baixar Região Metropolitana de Belém

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.837395 bottom=-1.841316 right=-47.638428 top=-0.982503^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.837395 bottom=-1.841316 right=-47.638428 top=-0.982503^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.837395 bottom=-1.841316 right=-47.638428 top=-0.982503^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.837395 bottom=-1.841316 right=-47.638428 top=-0.982503^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.837395 bottom=-1.841316 right=-47.638428 top=-0.982503^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmb/malha_viaria_rmb.osm.pbf  


rem Baixar Região Metropolitana de Belo Horizonte

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.6596 bottom=-20.486 right=-43.4791 top=-19.059^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.501 bottom=-0.097 right=-49.892 top=1.274^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.501 bottom=-0.097 right=-49.892 top=1.274^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.501 bottom=-0.097 right=-49.892 top=1.274^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.501 bottom=-0.097 right=-49.892 top=1.274^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmbh/malha_viaria_rmbh.osm.pbf

rem Baixar Região Metropolitana de Curitiba

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-50.2315 bottom=-26.1389 right=-48.4992 top=-24.402^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-50.2315 bottom=-26.1389 right=-48.4992 top=-24.402^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-50.2315 bottom=-26.1389 right=-48.4992 top=-24.402^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-50.2315 bottom=-26.1389 right=-48.4992 top=-24.402^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-50.2315 bottom=-26.1389 right=-48.4992 top=-24.402^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmc/malha_viaria_rmc.osm.pbf

rem Baixar Região Metropolitana de Fortaleza

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-39.005 bottom=-4.245 right=-38.223 top=-3.547636^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-39.005 bottom=-4.245 right=-38.223 top=-3.547636^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-39.005 bottom=-4.245 right=-38.223 top=-3.547636^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-39.005 bottom=-4.245 right=-38.223 top=-3.547636^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-39.005 bottom=-4.245 right=-38.223 top=-3.547636^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmf/malha_viaria_rmf.osm.pbf

rem Baixar Região Metropolitana de Recife

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.266 bottom=-8.609 right=-34.8062 top=-7.462^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.266 bottom=-8.609 right=-34.8062 top=-7.462^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.266 bottom=-8.609 right=-34.8062 top=-7.462^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.266 bottom=-8.609 right=-34.8062 top=-7.462^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.266 bottom=-8.609 right=-34.8062 top=-7.462^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmr/malha_viaria_rmr.osm.pbf

rem Baixar Região Metropolitana do Rio de Janeiro

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.3338 bottom=-23.1023 right=-42.4418 top=-22.0848^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.3338 bottom=-23.1023 right=-42.4418 top=-22.0848^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.3338 bottom=-23.1023 right=-42.4418 top=-22.0848^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.3338 bottom=-23.1023 right=-42.4418 top=-22.0848^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.3338 bottom=-23.1023 right=-42.4418 top=-22.0848^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmrj/malha_viaria_distrito_rmrj.osm.pbf

rem Baixar Região Metropolitana de Salvador

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.8048 bottom=-13.139 right=-37.8917 top=-12.261^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.8048 bottom=-13.139 right=-37.8917 top=-12.261^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.8048 bottom=-13.139 right=-37.8917 top=-12.261^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.8048 bottom=-13.139 right=-37.8917 top=-12.261^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.8048 bottom=-13.139 right=-37.8917 top=-12.261^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rms/malha_viaria_rms.osm.pbf

rem Baixar Região Metropolitana de São Paulo

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-47.208 bottom=-24.064 right=-45.6948 top=-23.183^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-47.208 bottom=-24.064 right=-45.6948 top=-23.183^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-47.208 bottom=-24.064 right=-45.6948 top=-23.183^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-47.208 bottom=-24.064 right=-45.6948 top=-23.183^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-47.208 bottom=-24.064 right=-45.6948 top=-23.183^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rmsp/malha_viaria_rmsp.osm.pbf