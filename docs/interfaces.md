# Interfaces
## I_PlanarTaskResult
Definition of the XPlanar Task (Command) Feedback Class

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Aborted|BOOL|R|Command was aborted by the XPlanar System|
|BlockingObjectInfo|REFERENCE TO PlanarObjectInfo|R|Object information returned if the command was blocked by another planar object|
|Busy|BOOL|R|Command is active|
|Done|BOOL|R|Command was completed|
|Error|BOOL|R|Command returned an error|
|ErrorID|UDINT|R|Identification value of the error returned by the command|

## I_XPlanarMover
Defines required functionality for an XPlanar mover.

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|ActualPosition|MoverVector|R|Current mover position|
|CommandLog|REFERENCE TO ARRAY[1..MAX_LOG_COUNT] OF STRING|R|Log of commands recently sent to the mover|
|Destination|I_XPlanarStation|RW|Interface pointer for the next station the mover is going to|
|Error|BOOL|R|Error signal from Move Commands|
|ErrorID|UDINT|R|Error ID returned from Command Feedback|
|Gap|LREAL|RW|Collision Avoidance Gap value used for On Track movements|
|IdentifiedBTN|STRING|R|Reported BTN from ID Bumper|
|InStation|BOOL|RW|Signal indicating the mover is in a station queue|
|MoveCommand|I_MoveCommands|R|Interface pointer to Mover Commands|
|Dynamics|I_MoveDynamics|RW|Interface to Velocity, Accel, Decel, Jerk dynamics containers used by move commands|
|MoverBTN|STRING(13)|R|BTN that is assigned by the driver|
|MoverIndex|UDINT|RW|Index number of the mover|
|MoverType|MoverType|R|Identified Mover Type from the TcCOM Object|
|pm|REFERENCE TO MC_PlanarMover|R|Reference to base planar motion functions|
|RotateDynamics|ST_MoveDynamics|RW|Structure of dynamic vars Velocity, Accel, Decel, Jerk used by Rotation commands|
|Status|REFERENCE TO CDT_MCTOPLC_PLANAR_MOVER_STD|R|Reference to the current operating status structure of the mover|
|Utility|I_TcIoXPlanarMover|R|Interface to Mover TcIo Driver functions|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|AddToGroup|I_PlanarTaskResult|Adds the mover to the XPlanar Group|
|Disable|I_PlanarTaskResult|Disables the mover|
|Enable|I_PlanarTaskResult|Enables the mover|
|Halt|I_PlanarTaskResult|Halts the mover|
|Reset|I_PlanarTaskResult|Resets the mover|

## I_MoveCommands
Built in Mover functions that can be easily called from the application.

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|FreeMove|I_PlanarTaskResult|Command the mover to an XY position on the table. Mover must be in *FreeMovement* Command Mode|
|JoinClosestTrack|I_PlanarTaskResult|Join the mover to the closest track segment|
|JoinTrack|I_PlanarTaskResult|Join the mover to a specified Track Segment|
|LeaveTrack|I_PlanarTaskResult|Command the mover to leave its current track segment and move to a specified XY position|
|Rotate|I_PlanarTaskResult|Rotate the mover to a specified modulo C position and number of additional turns. *Use a negative number to change rotation direction. 0, 0 for a shortest way move back to absolute 0*|
|SendToStation|I_PlanarTaskResult|Send the mover to a desired Station|
|SquareUp|I_PlanarTaskResult|Rotate the mover to its nearest quarter angle and zero the A and B Axis|
|TiltA|I_PlanarTaskResult|Tilt the mover on the A Axis|
|TiltB|I_PlanarTaskResult|Tilt the mover on the B Axis|
|TrackMove|I_PlanarTaskResult|Command the mover to a specified linear position on a track segment. Mover must be in *OnTrack* Command Mode|
|TrackMoveXY|I_PlanarTaskResult|Command the mover to a specified XY position on a track segment. Mover must be in *OnTrack* Command Mode|
|VerticalMove|I_PlanarTaskResult|Raise or lower the mover on the Z Axis|

## I_MoveDynamics
Interface to Mover Dynamic Constraints

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Movement|REFERENCE TO ST_MoveDynamics|RW|Structure of dynamic vars Velocity, Accel, Decel, Jerk used by XYZ based move commands|
|Rotation|REFERENCE TO ST_MoveDynamics|RW|Structure of dynamic vars Velocity, Accel, Decel, Jerk used by C Axis based rotate commands|
|Tilt|REFERENCE TO ST_MoveDynamics|RW|Structure of dynamic vars Velocity, Accel, Decel, Jerk used by AB Axis based tilt commands|

## I_XPlanarStation
Defines a specified area of a track where a mover is going to be processed.

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|AllowQueing|BOOL|W|Set to FALSE and the sending station will not release a mover until this station is clear. *Default = TRUE*|
|CanReleaseMover|BOOL|W|Set to FALSE if the immediate area around the station is blocked and a mover should not be released. *Default = TRUE*|
|CurrentMover|I_XPlanarMover|R|Interface pointer to the lead mover in the station's mover queue|
|HasMover|BOOL|R|A mover is currently in the defined station area|
|ID|UDINT|RW|Index number of the station|
|MoverQueue|REFERENCE TO FB_MoverQueue|R|Reference to the movers currently queued up in the station|
|NextStation|I_XPlanarStation|RW|Interface pointer to the next station to send the mover to|
|NumMoversRequired|UDINT|RW|Number of movers required by the station before the station is ready to process. **Only required with the Multi Mover station type**|
|Position|REFERENCE TO PositionXYC|R|Reference to the position of the station on the XPlanar table|
|Size|REFERENCE TO Position2D_LREAL|RW|Configured station size in X and Y. *Default is 120mm x 120mm*|
|StationComplete|BOOL|W|Bit for an external process to tell the station that processing is complete and to release the mover to the next station|
|StationReady|BOOL|R|Mover(s) are registered in the station and ready to command|
|StationType|E_StationType(UDINT)|RW|Type of function the station is set up to do. (0 = Process, 1 = DecisionPoint, 2 = Multi Mover Process)|
|TrackID|I_XPlanarTrack|RW|Interface pointer to the track segment the station resides on. (do not set if not using tracks)|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|Execute|-|'Automatic' function of the station. Watch for a mover to arrive, execute a process if assigned, and send the mover away|
|Reset|BOOL|Reset the internal state machine of the station|

## I_XPlanarTrack
Defines functionality of a specified track segment

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Definition|REFERENCE TO ST_TrackDefinition|R|Structure containing segment build definitions. *StartFrom, EndAt, CloseLoop, ARRAY OF track point items*|
|Error|BOOL|R|Bit indicating an error occurred during the build process|
|ErrorID|UDINT|R|Identification number of the error that occurred on the Track object|
|Index|UDINT|RW|Index number of the segment|
|MoverCount|UDINT|R|Number of movers currently on the segment|
|MovingMoverCount|UDINT|R|Number of movers currently on the segment and movers actively planned for movement on this segment|
|pm|REFERENCE TO MC_PlanarTrack|R|Reference to base planar motion functions|
|Status|REFERENCE TO CDT_MCTOPLC_PLANAR_TRACK|R|Current operating status structure of the Track|
|TrackLength|UDINT|R|Linear length of the track segment in mm|
|Utility|I_McPlanarTrack|R|Interface to Track segment TcIo Driver functions|

### Methods
|**Method**|**Return Type**|**Description**|
|--|--|--|
|AddToGroup|I_PlanarTaskResult|Add the track segment to the XPlanar Group|
|AppendLine|I_PlanarTaskResult|Append a line item to the track segment|
|AppendPoint|I_PlanarTaskResult|Append a point item to the track segment|
|Build|I_PlanarTaskResult|Build the track segment according to the Definition configuration|
|Clear|I_PlanarTaskResult|Clears all defined points from the track segment|
|CloseLoop|I_PlanarTaskResult|Closes the loop to the first defined track point|
|Disable|I_PlanarTaskResult|Disables the track segment|
|Enable|I_PlanarTaskResult|Enables the track segment|
|GetTrackPositionAt|LREAL|Calculates the closest linear track point for a given XY coordinate|
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
|ForceDisable|I_PlanarTaskResult|Disables the XPlanar Part|
|SetAllowEnable|I_PlanarTaskResult|Allows the XPlanar Part to be enabled by the XPlanar TcCOM|
|Reset|I_PlanarTaskResult|Resets the XPlanar Part|

## I_XPlanarTile
Defines functionality of the XPlanar Tile Object

### Properties
|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Btn|STRING(13)|R|Btn number of the tile|
|DcLinkOk|BOOL|R|Tile power is OK. *Only if operating in Normal mode with hardware*|
|Index|UINT|R|Index of the tile in the array|
|PartIndex|UINT|R|Index of the XPlanar Part the tile is configured in|
|PositionOnPart|REFERENCE TO ST_TcIoTilePositionOnPart|R|Position of the tile origin point in the XPlanar Part configuration|
|Temperatures|REFERENCE TO ST_TileTemperatures|R|Last read temperature of the center and each tile quadrant (North, South, East, West)|
|TimeToShutdown|UDINT|R|Last read time in milliseconds to tile shutdown based on temperature|
|Utility|I_TcIoXPlanarTile|R|Interface to Tile TcIo Driver functions|
