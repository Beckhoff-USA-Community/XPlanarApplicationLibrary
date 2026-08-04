# Globals
Global variable lists of the library.

## Interface Properties (ip)
Arrays of Mover, Track Segment, and Station interfaces for use within the application.

|**Name**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Movers|ARRAY[1..SystemParameters.MOVER_COUNT] OF [I_XPlanarMover](./interfaces.md#i_xplanarmover)|R|Access to mover interfaces for higher level objects|
|Stations|ARRAY[1..SystemParameters.STATION_COUNT] OF [I_XPlanarStation](./interfaces.md#i_xplanarstation)|R|Access to station interfaces for higher level objects|
|Tracks|ARRAY[1..SystemParameters.TRACKCOUNT] OF [I_XPlanarTrack](./interfaces.md#i_xplanartrack)|R|Access to track interfaces for higher level objects|

## XPlanar
System level variables

|**Name**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Environment|Tc3_PlanarMotion.MC_PlanarEnvironment|R|Access to the XPlanar Environment object|
|EnvironmentTcIo|Tc3_XPlanarUtility.FB_TcIoXPlanarEnvironment|R|Access to the XPlanar Environment Utility TcIo Functions|
|Group|Tc3_PlanarMotion.MC_PlanarGroup|R|Access to the XPlanar Group object|
|XPUCount|UINT|R|Number of XPlanar processing units configured in the system|
|PartCount|UINT|R|Number of XPlanar Parts configured in the system|
|TrackCount|UINT|R|Number of Track Segments configured in the system|
|MoverCount|UINT|R|Number of Movers configured in the system|
|TileCount|UINT|R|Number of Tiles configured in the system|

## XPlanarHMI
XPlanar object arrays for HMI display

|**Name**|**Type**|**Access**|**Description**|
|--|--|--|--|
|MoverObjects|ARRAY[1..SystemParameters.MOVER_COUNT] OF ST_MoverObjectInfos|R|Size and BTN of each mover|
|MoverPositions|ARRAY[1..SystemParameters.MOVER_COUNT] OF MoverVector|R|Current position of each mover|
|TileObjects|ARRAY[1..Param_TcIoXPlanarEnvironment.MaxTiles] OF ST_TileObjectInfos|R|Size and position of each configured tile|
|StationObjects|ARRAY[1..SystemParameters.STATION_COUNT] OF ST_StationObjectInfos|R|Size and position of each defined station|
