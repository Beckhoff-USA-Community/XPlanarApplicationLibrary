# Interfaces
## I_PlanarTaskResult
Definition of the XPlanar Task (Command) Feedback Class 

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Aborted|BOOL|R|Command was aborted by the Xplanar System|
|BlockingObjectInfo|REFERENCE TO PlanarObjectInfo|R|Object information returned if command was blocked by another planar object|
|Busy|BOOL|R|Command is active|
|Done|BOOL|R|Command was complented|
|Error|BOOL|R|Command returned an error|
|ErrorID|UDINT|R|Identification value of the error returned by the command|

## I_XPlanarMover
Defines required functionality for an XPlanar mover.

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|ActualPosition|MoverVector|R|Current mover position.|
|CommandLog|REFERENCE TO ARRAY|R|Log of commands recently sent to the mover.|
|Destination|I_XPlanarStation|RW|Interface pointer for the next station the mover is going to.|
|Error|BOOL|R|Error signal from Move Commands|
|ErrorID|UDINT|R|Error ID returned from Command Feedback|
|Gap|LREAL|RW|Collision Avoidance Gap value used for On Track movements.|
|IdentifiedBTN|STRING|RO|Reported BTN from ID Bumper|
|InStation|BOOL|RW|Signal indicating mover is in a station queue|
|MoveCommand|I_MoveCommands|RO|Interface pointer to Mover Commands|
|Dynamics|I_MoveDynamics|RW|Interface to Velocity, Accel, Decel, Jerk dynamics containers used by move commands|
|MoverBTN|STRING(13)|R|BTN that is assigned by the driver|
|MoverIndex|UDINT|RW|Index number of the mover|
|MoverType|MoverType|RO|Identified Mover Type from TcCOM Object|
|pm|REFERENCE TO MC_PLanarMover_|R|Reference to base planar motion functions|
|RotateDynamics|ST_MoveDynamics|RW|Sturcture of dynamic vars. Velocity, Accel, Decel, Jerk used by Rotation commands|
|Status|REFERENCE TO CDT_MCTOPLC_PLANAR_MOVER_STD_|R|Reference to current operating status structure of the mover|
|Utility|I_TcIoXPlanarMover|RO|Interface to Mover TcIo Driver functions|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|AddToGroup|I_PlanarTaskResult|Adds mover to the XPlanar Group|
|Disable|I_PlanarTaskResult|Disables the mover|
|Enable|I_PlanarTaskResult|Enables the mover|
|Halt|I_PlanarTaskResult|Halts the mover|
|Reset|I_PlanarTaskResult|Resets the mover|

## I_MoveCommands
Built in Mover functions that can be easily called from the application.

|**Method**|**Return Type**|**Description**|
|--|--|--|
|FreeMove|I_PlanarTaskResult|Command the mover to an XY position on the table.| Mover must be in *FreeMovement* Command Mode.|
|JoinTrack|I_PlanarTaskResult|Join the mover to a specified Track Segment|
|LeaveTrack|I_PlanarTaskResult|Command mover to un-join its current track segment and move to a specified xy position|
|Rotate|I_PlanarTaskResult|Rotate the mover a specified modulo C position and number of additional turns.| *Use negative number to change rotation direction.* *0, 0 for a shortest way move back to absolute 0*|
|SendToStation|I_PlanarTaskResult|Send the mover to a desired Station|
|SquareUp|I_PlanarTaskResult|Rotate the mover to its nearest quarter angle and Zero the A and B Axis|
|TiltA|I_PlanarTaskResult|Tilt the mover on the A Axis|
|TiltB|I_PlanarTaskResult|Tilt the mover on the B Axis|
|TrackMove|I_PlanarTaskResult|Command the mover to a specified linear position on a track segment.| Mover must be in *OnTrack* Command Mode.|
|TrackMoveXY|I_PlanarTaskResult|Command the mover to a specified XY position on a track segment.| Mover must be in *OnTrack* Command Mode.|
|VerticalMove|I_PlanarTaskResult|Raise or lower the mover on the Z Axis|

## I_MoveDynamics
Interface to Mover Dynamic Constraints

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Movement|REFERENCE TO ST_MoveDynamics|RW|Sturcture of dynamic vars. Velocity, Accel, Decel, Jerk used by XYZ based move commands|
|Rotation|REFERENCE TO ST_MoveDynamics|RW|Sturcture of dynamic vars. Velocity, Accel, Decel, Jerk used by C Axis based rotate commands|
|Tilt|REFERENCE TO ST_MoveDynamics|RW|Sturcture of dynamic vars. Velocity, Accel, Decel, Jerk used by AB Axis based tilt commands|

## I_XPlanarStation
Defines a specified area of a track where a mover is going to be processed.

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|AllowQueing|BOOL|W|Set to FALSE the sending station will not release mover until this station is clear|*Default = TRUE*|
|CanReleaseMover|BOOL|W|Set to FALSE if Immediate area around the station is blocked, do not release mover|*Default = TRUE*|
|CurrentMover|I_XPlanarMover|R|Interface pointer to the lead mover in the stations mover queue |
|HasMover|BOOL|BOOL|A Mover is currently in the defined station area|
|ID|UDINT|RW|Index number of the station|
|MoverQueue|Reference To FB_MoverQueue_|R|Reference to the movers currently queued up in the station|
|NextStation|I_XPlanarStation|RW|Interface pointer to the next station to send the mover to|
|NumMoversRequired|UDINT|RW|Number of movers required by the station before station is ready to process.|**Only required with Multi-Mover station type**|
|Positon|REFERENCE TO PositionXYC|R|Reference to the postition of the station on the XPlanar table|
|Size|REFERENCE TO Position2D_LREAL_|RW|Configured station size in X and Y |*Default is 120mm x 120mm*|
|StationComplete|BOOL|W|Bit for an external process to tell the station that processing is complete and release the mover to the next station|
|StationReady|BOOL|R|Mover(s) are registered in the station and ready to command|
|StationType|E_StationType(UDINT)|RW|Type of function the station is being setup to do.| (0 = Process, 1 = DecisionPoint, 2 = Multi Mover Process.)|
|TrackID|I_XPlanarTrack|RW|Interface pointer to the track segment the station resides on. (do not set if not using tracks)

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|Execute|null|'Automatic' function of the station.  Watch for a mover to arrive, execute a process if assigned, and send the mover away|
|Reset|BOOL|Reset the internal state machine of the station|

## I_XPlanarTrack
Defines functionality of a specified track segment

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Definition|REFERENCE TO ST_TrackDefinition|R|Structure containing segment build definitions|*StartFrom, EndAt, CLoseLoop, ARRAY OF Track Point Itmes*
|Error|BOOL|R|Bit indicating an error occurred during the build process|
|ErrorID|UDINT|R|Identification number of error that occurred on the Track object|
|Index|UDINT|RW|Index number of the segment|
|MoverCount|UDINT|R|Number of movers currently on segment|
|MovingMoverCount|UDINT|R|Number of movers currently on segment and movers actively planned for movement on this segment|
|pm|REFERENCE TO MC_PlanarTrack|R|Reference to base planar motion functions|
|Status|REFERENCE TO CDT_MCTOPLC_PLANAR_TRACK|R|Current operating status structure of Track|
|TrackLength|UDINT|R|Linear length of track segment in mm|
|Utility|I_McPlanarTrack|RO|Interface to Track segment TcIo Driver functions|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|AddToGroup|I_PlanarTaskResult|Add the track segment to the XPlanar Group|
|AppendLine|I_PlanarTaskResult|Append a line item to the track segment|
|AppendPoint|I_PlanarTaskResult|Append a point item to the track segment|
|Build|I_PlanarTaskResult|Build the track segment according to Definition configuration|
|Clear|I_PlanarTaskResult|Clears all defined points from the track segment|
|CloseLoop|I_PlanarTaskResult|Closes loop to the first defined track point|
|Reset|BOOL|Reset the internal state machine of the station|
|Disable|I_PlanarTaskResult|Disables the track segment|
|Enable|I_PlanarTaskResult|Enables the track segment|
|GetTrackPositionAt|LREAL|Calculates closest linear track point for a given XY coordinate|
|Reset|I_PlanarTaskResult|Resets the track segment|

## I_XPlanarPart
Defines functionality of the XPlanar Part Object

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|ObjectID|OTCID|R|Object ID of the XPlanar Part MC3 Object|
|pm|REFERENCE TO MC_PlanarPart|R|Reference to base planar motion functions|
|State|REFERENCE TO MC_PlanarState|R|Current State of the XPlanar Part|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|ForceDisable|I_PlanarTaskResult|Disables Xplanar part|
|SetAllowEnable|I_PlanarTaskResult|Allows the XPlanar Part to be enabled by the Xplanar TcCom|
|Reset|I_PlanarTaskResult|Resets the XPlanar Part|

## I_XPlanarTile
Defines functionality of the XPlanar Tile Object

## Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Btn|STRING(13)|R|Btn number of the tile.|
|DcLinkOk|BOOL|R|Tile power is OK.|*Only if operating in Normal mode with hardware*|
|Index|UINT|R|Index of tile in array.|
|PartIndex|UINT|Index of XPlanar Part Tile is configured in.|
|PositionOnPart|REFERENCE TO ST_TcIoTilePositionOnPart|R|Position of tile origin point in the XPlanar Part configuration|
|Temperatures|REFERENTE TO ST_TileTemperatures|R|Last read temperature of center and each tile quadrant (North, South, East, West)|
|TimeToShutdown|UDINT|R|Last read time in milliseconds to tile shutdown based on temperature|
|Utility|I_TcIoXPlanarTile|Interface to Tile TcIo Driver functions|


