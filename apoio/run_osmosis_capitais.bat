rem Esse arquivo executável extrai todas as capitais do país por bounding box
rem Baixar Maceio

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.816 bottom=-9.715995 right=-35.558 top=-9.37^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.816 bottom=-9.715995 right=-35.558 top=-9.37^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.816 bottom=-9.715995 right=-35.558 top=-9.37^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.816 bottom=-9.715995 right=-35.558 top=-9.37^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.816 bottom=-9.715995 right=-35.558 top=-9.37^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb mco/malha_viaria_maceio.osm.pbf  


rem Baixar Rio Branco

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-69.364 bottom=-10.485 right=-67.482 top=-9.505^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-69.364 bottom=-10.485 right=-67.482 top=-9.505^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-69.364 bottom=-10.485 right=-67.482 top=-9.505^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-69.364 bottom=-10.485 right=-67.482 top=-9.505^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-69.364 bottom=-10.485 right=-67.482 top=-9.505^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rbr/malha_viaria_rio_branco.osm.pbf  


rem Baixar Macapá

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.501 bottom=-0.097 right=-49.892 top=1.274^
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
 --wb mac/malha_viaria_macapa.osm.pbf

rem Baixar Manaus

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-60.801 bottom=-3.222 right=-59.16 top=-1.924^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-60.801 bottom=-3.222 right=-59.16 top=-1.924^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-60.801 bottom=-3.222 right=-59.16 top=-1.924^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-60.801 bottom=-3.222 right=-59.16 top=-1.924^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-60.801 bottom=-3.222 right=-59.16 top=-1.924^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb man/malha_viaria_manaus.osm.pbf

rem Baixar Salvador

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.699435 bottom=-13.017395 right=-38.303414 top=-12.733537^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.699435 bottom=-13.017395 right=-38.303414 top=-12.733537^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.699435 bottom=-13.017395 right=-38.303414 top=-12.733537^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.699435 bottom=-13.017395 right=-38.303414 top=-12.733537^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.699435 bottom=-13.017395 right=-38.303414 top=-12.733537^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb ssa/malha_viaria_salvador.osm.pbf

rem Baixar Fortaleza

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.636568 bottom=-3.888124 right=-38.401541 top=-3.691979^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.636568 bottom=-3.888124 right=-38.401541 top=-3.691979^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.636568 bottom=-3.888124 right=-38.401541 top=-3.691979^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.636568 bottom=-3.888124 right=-38.401541 top=-3.691979^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-38.636568 bottom=-3.888124 right=-38.401541 top=-3.691979^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb for/malha_viaria_fortaleza.osm.pbf

rem Baixar Distrito Federal

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.316808 bottom=-16.070296 right=-47.290959 top=-15.475587^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.316808 bottom=-16.070296 right=-47.290959 top=-15.475587^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.316808 bottom=-16.070296 right=-47.290959 top=-15.475587^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.316808 bottom=-16.070296 right=-47.290959 top=-15.475587^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.316808 bottom=-16.070296 right=-47.290959 top=-15.475587^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb dis/malha_viaria_distrito_federal.osm.pbf

rem Baixar Vitória

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-40.456586 bottom=-20.433687 right=-40.178151 top=-20.23377^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-40.456586 bottom=-20.433687 right=-40.178151 top=-20.23377^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-40.456586 bottom=-20.433687 right=-40.178151 top=-20.23377^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-40.456586 bottom=-20.433687 right=-40.178151 top=-20.23377^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-40.456586 bottom=-20.433687 right=-40.178151 top=-20.23377^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb vit/malha_viaria_vitoria.osm.pbf

rem Baixar Goiania

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.446637 bottom=-16.831832 right=-49.078 top=-16.453^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.446637 bottom=-16.831832 right=-49.078 top=-16.453^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.446637 bottom=-16.831832 right=-49.078 top=-16.453^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.446637 bottom=-16.831832 right=-49.078 top=-16.453^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.446637 bottom=-16.831832 right=-49.078 top=-16.453^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb goi/malha_viaria_goiania.osm.pbf

rem Baixar Sao luiz

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.434 bottom=-2.8 right=-44.162979 top=-2.454^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.434 bottom=-2.8 right=-44.162979 top=-2.454^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.434 bottom=-2.8 right=-44.162979 top=-2.454^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.434 bottom=-2.8 right=-44.162979 top=-2.454^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.434 bottom=-2.8 right=-44.162979 top=-2.454^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb sls/malha_viaria_sao_luis.osm.pbf

rem Baixar Cuiaba

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-56.303238 bottom=-15.767005 right=-55.464 top=-15.071^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-56.303238 bottom=-15.767005 right=-55.464 top=-15.071^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-56.303238 bottom=-15.767005 right=-55.464 top=-15.071^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-56.303238 bottom=-15.767005 right=-55.464 top=-15.071^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-56.303238 bottom=-15.767005 right=-55.464 top=-15.071^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb cui/malha_viaria_cuiaba.osm.pbf

rem Baixar Campo Grande

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-54.9253 bottom=-21.5845 right=-53.5997 top=-20.1652^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-54.9253 bottom=-21.5845 right=-53.5997 top=-20.1652^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-54.9253 bottom=-21.5845 right=-53.5997 top=-20.1652^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-54.9253 bottom=-21.5845 right=-53.5997 top=-20.1652^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-54.9253 bottom=-21.5845 right=-53.5997 top=-20.1652^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb cam/malha_viaria_campo_grande.osm.pbf

rem Baixar Belo Horizonte

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.063292 bottom=-20.059465 right=-43.85722 top=-19.776544^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.063292 bottom=-20.059465 right=-43.85722 top=-19.776544^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.063292 bottom=-20.059465 right=-43.85722 top=-19.776544^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.063292 bottom=-20.059465 right=-43.85722 top=-19.776544^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-44.063292 bottom=-20.059465 right=-43.85722 top=-19.776544^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb bho/malha_viaria_bel.osm.pbf

rem Baixar Belem

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.624396 bottom=-1.535306 right=-48.296281 top=-1.019452^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.624396 bottom=-1.535306 right=-48.296281 top=-1.019452^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.624396 bottom=-1.535306 right=-48.296281 top=-1.019452^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.624396 bottom=-1.535306 right=-48.296281 top=-1.019452^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.624396 bottom=-1.535306 right=-48.296281 top=-1.019452^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb bel/malha_viaria_belem.osm.pbf

rem Baixar Joao Pessoa

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-7.247743 right=-34.793018 top=-7.055965^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-7.247743 right=-34.793018 top=-7.055965^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-7.247743 right=-34.793018 top=-7.055965^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-7.247743 right=-34.793018 top=-7.055965^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-7.247743 right=-34.793018 top=-7.055965^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb joa/malha_viaria_joao_pessoa.osm.pbf

rem Baixar Curitiba

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-49.38914 bottom=-25.643217 right=-49.184318 top=-25.346701^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-25.643217 right=-49.184318 top=-25.346701^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-25.643217 right=-49.184318 top=-25.346701^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-25.643217 right=-49.184318 top=-25.346701^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-34.974011 bottom=-25.643217 right=-49.184318 top=-25.346701^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb cur/malha_viaria_curitiba.osm.pbf

rem Baixar Recife

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.018648 bottom=-8.155187 right=-34.858553 top=-7.928942^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.018648 bottom=-8.155187 right=-34.858553 top=-7.928942^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.018648 bottom=-8.155187 right=-34.858553 top=-7.928942^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.018648 bottom=-8.155187 right=-34.858553 top=-7.928942^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.018648 bottom=-8.155187 right=-34.858553 top=-7.928942^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rec/malha_varia_recife.osm.pbf

rem Baixar Teresina

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-42.970644 bottom=-5.586 right=-42.599 top=-4.787^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-42.970644 bottom=-5.586 right=-42.599 top=-4.787^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-42.970644 bottom=-5.586 right=-42.599 top=-4.787^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-42.970644 bottom=-5.586 right=-42.599 top=-4.787^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-42.970644 bottom=-5.586 right=-42.599 top=-4.787^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb ter/malha_viaria_teresina.osm.pbf

rem Baixar Rio de Janeiro

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-43.796252 bottom=-23.082705 right=-43.099081 top=-22.746088^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-43.796252 bottom=-23.082705 right=-43.099081 top=-22.746088^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-43.796252 bottom=-23.082705 right=-43.099081 top=-22.746088^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-43.796252 bottom=-23.082705 right=-43.099081 top=-22.746088^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-43.796252 bottom=-23.082705 right=-43.099081 top=-22.746088^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb rio/malha_viaria_rio_de_janeiro.osm.pbf

rem Baixar Natal

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.291263 bottom=-5.900211 right=-35.153103 top=-5.702722^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.291263 bottom=-5.900211 right=-35.153103 top=-5.702722^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.291263 bottom=-5.900211 right=-35.153103 top=-5.702722^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.291263 bottom=-5.900211 right=-35.153103 top=-5.702722^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-35.291263 bottom=-5.900211 right=-35.153103 top=-5.702722^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb nat/malha_viaria_natal.osm.pbf

rem Baixar Porto Alegre

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.30344 bottom=-30.26945 right=-51.018852 top=-29.932474^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.30344 bottom=-30.26945 right=-51.018852 top=-29.932474^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.30344 bottom=-30.26945 right=-51.018852 top=-29.932474^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.30344 bottom=-30.26945 right=-51.018852 top=-29.932474^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-51.30344 bottom=-30.26945 right=-51.018852 top=-29.932474^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb poa/malha_viaria_porto_alegre.osm.pbf

rem Baixar Porto Velho

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-66.8059 bottom=-10.0 right=-62.237 top=-7.9693^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-66.8059 bottom=-10.0 right=-62.237 top=-7.9693^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-66.8059 bottom=-10.0 right=-62.237 top=-7.9693^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-66.8059 bottom=-10.0 right=-62.237 top=-7.9693^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-66.8059 bottom=-10.0 right=-62.237 top=-7.9693^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb por/malha_viaria_porto_velho.osm.pbf


rem Baixar Boa vista

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-61.0 bottom=2.4288 right=-60.2865 top=3.606^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-61.0 bottom=2.4288 right=-60.2865 top=3.606^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-61.0 bottom=2.4288 right=-60.2865 top=3.606^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-61.0 bottom=2.4288 right=-60.2865 top=3.606^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-61.0 bottom=2.4288 right=-60.2865 top=3.606^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb boa/malha_viaria_boa_vista.osm.pbf

rem Baixar Florianopolis

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.613 bottom=-27.847 right=-48.358593 top=-27.379^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.613 bottom=-27.847 right=-48.358593 top=-27.379^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.613 bottom=-27.847 right=-48.358593 top=-27.379^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.613 bottom=-27.847 right=-48.358593 top=-27.379^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.613 bottom=-27.847 right=-48.358593 top=-27.379^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb flo/malha_viaria_florianopolis.osm.pbf

rem Baixar São Paulo

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-46.826409 bottom=-24.007 right=-46.36509 top=-23.357^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-46.826409 bottom=-24.007 right=-46.36509 top=-23.357^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-46.826409 bottom=-24.007 right=-46.36509 top=-23.357^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-46.826409 bottom=-24.007 right=-46.36509 top=-23.357^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-46.826409 bottom=-24.007 right=-46.36509 top=-23.357^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb spo/malha_viaria_sao_paulo.osm.pbf

rem Baixar Aracaju

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-37.174 bottom=-11.161242 right=-37.026 top=-10.862221^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-37.174 bottom=-11.161242 right=-37.026 top=-10.862221^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-37.174 bottom=-11.161242 right=-37.026 top=-10.862221^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-37.174 bottom=-11.161242 right=-37.026 top=-10.862221^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-37.174 bottom=-11.161242 right=-37.026 top=-10.862221^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb ara/malha_viaria_aracaju.osm.pbf

rem Baixar Palmas

call osmosis --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.422086 bottom=-10.46 right=-47.794 top=-9.918335^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways highway=motorway,trunk,primary,secondary,tertiary,unclassified,residential,motorway_link,trunk_link,primary_link,secondary_link,tertiary_link,living_street,service,pedestrian,track,bus_guideway,escape,raceway,road,busway,footway,bridleway,steps,corridor,path,cycleway,proposed,construction,bus_stop,crossing,elevator,emergency_bay,emergency_access_point,give_way,milestone,mini_roundabout,motorway_junction,passing_place,platform,rest_area,speed_camera,street_lamp,services,stop,traffic_mirror,traffic_signals,trailhead,turning_circle,turning_loop,toll_gantry^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.422086 bottom=-10.46 right=-47.794 top=-9.918335^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways aeroway=aerodrome,apron,gate,hangar,helipad,heliport,navigationaid,runway,spaceport,taxiway,terminal,windsock^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.422086 bottom=-10.46 right=-47.794 top=-9.918335^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways railway=abandoned,construction,disused,funicular,light_rail,miniature,monorail,narrow_gauge,preserved,rail,subway,tram,halt,platform,station,subway_entrance,tram_stop,buffer_stop,derail,crossing,level_crossing,signal,switch,railway_crossing,turntable,roundhouse,traverser,wash^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.422086 bottom=-10.46 right=-47.794 top=-9.918335^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways building=aerodrome,ferry_terminal,train_station^
 --tf reject-relations^
 --used-node^
 --read-pbf file=brazil.osm.pbf^
 --bounding-box left=-48.422086 bottom=-10.46 right=-47.794 top=-9.918335^
 --way-key keyList="name,building,aeroway,amenity,railway,layer,public_transport,operator,highway,surface,bridge,tunnel,smoothness,width,oneway,parking,capacity,barrier"^
 --tf accept-ways amenity=ferry_terminal,bus_station^
 --tf reject-relations^
 --used-node^
 --merge^
 --merge^
 --merge^
 --merge^
 --wb pal/malha_viaria_palmas.osm.pbf


  






