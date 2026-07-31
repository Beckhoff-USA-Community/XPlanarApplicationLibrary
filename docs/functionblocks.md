# Function Blocks

## FB_PlanarFeedbackResult
Complete Implementation of the **I_PlanarTaskResult** interface used by method calls.  Includes MC_PlanarFeedback used by base XPlanar functions

### Properties

|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|PlanarFeedback|REFERENCE TO MC_PlanarFeedback|R|Referece to Planar Feedback Function Block used by base XPlanar functions

### Methods

|**Method**|**Return Type**|**Access**|**Description**|
|--|--|--|--|
|Update|-|PROTECTED|Cyclically called by parent to keep MC_PlanarFeeback and feedback properties up to date along with any additional cyclic logic for the extended task.

## FB_Component_XPlanar

(extends `FB_ComponentBase`)
Function block that allows for an implementation of and XPlanar system as a component of a Machine.

!!! note
    See also:
        - [I_ComponentBase](../SPT_Base_Types/interfaces.md#i_componentbase){:target="_blank"}

### Notes
- The `CyclicLogic()` method should be called every PLC cycle to ensure the XPlanarEnvironment and XPlanarGroup NC objects along with each Movers/Stations/Tracks are cycled properly and statuses updated.  **Called inherently if using SPT Framework**
- The `Initialize()` method sets mover default halt dynamics and sets up all required interface pointers and references. **Called inherently from Cyclic Logic**
- The `Reset()` method contains and sequence to reset and re-enable faulted xplanar objects
- The `CreateEvents()` method should be called before operation to initialize configured Event Logger events **Called inherently Cyclic Logic**
- The `Monitoring()`method should be called to monitor status for event handling **Called inherently if using SPT Framework**

### Properties

|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|MoverDetectionInfo|ST_TcIoMoverDetectionInfos|R|Structure of configured and detected count of each mover type|
|TracksInitialized|BOOL|R|Signal reflecting that track segments have been build and do not need to be re-initialized|
|TileCount|UDINT|R|Actual tile count of the XPlanar system|
|Xpu|I_TcIoXPlanarProcessingUnit|R|Access to XPlanar environment and driver functions|  

### Methods

|**Method**|**Return Type**|**Access**|**Description**|
|--|--|--|--|
|Abort|BOOL|PUBLIC|Aborting sequence for immediate halting of system and disabling movers| 
|BuildTracks|BOOL|PUBLIC|Sequence for initializing all configured track segments|
|CheckMovers|BOOL|PUBLIC|Method that can be called to check all valid movers and raise an alarm if a lost mover is detected|
|CheckTilePower|BOOL|PUBLIC|Method that can be called to check DC Link voltage for all tiles and will raise an alarm if not ok|
|EnableGroup|BOOL|PUBLIC|Method used to Enable the XPlanar Group|
|CyclicLogic|-|PUBLIC|Handles XPlanar object update calls and all other logic that needs to happen every cycle|
|EnableMovers|BOOL|PUBLIC|Method used to Enable all movers with the option of adding them to the XPlanar Group|
|EnableTracks|BOOL|PUBLIC|Method used to Enable all track segments with the option of adding them to the XPlanar Group|
|IdentifyMovers|BOOL|PUBLIC|Method used to identify and sort movers based on assigned ID Bumper|
|MoverRedetect|BOOL|PUBLIC|Method used to perform a mover redetect|
|RecoverStations|BOOL|PUBLIC|Method to cylce through the prepare sequence of each station|
|Reset|--|--|--|

## FB_XPlanarMover
Complete implementation of I_XPlanarMover for control of an XPlanar mover.

!!! note
    See also:
        - [I_XPlanarMover](./interfaces.md#i_xplanarmover){:target="_blank"}


### Notes
- The `CyclicLogic()` method is inherently called by the [FB_Component_XPlanar](#fb_component_xplanar) parent object and ensures the NC object is cycled properly and updates the component Busy flag

- The `Reset()` method should be called to clear any mover faults

### HMICommunication method
The `HMICommunication()` method should be called to update status of the mover to the HMI. **Called inherently if using SPT Framework**

## FB_MoverQueue
Function Block to handle a queueing of movers in a station.

### Properties

|**Property**|**Type**|**Access**|**Description**|
|--|--|--|--|
|Count|UDINT|R|Actual count of movers in the queue|
|FirstMover|I_XPlanarMover|R|Interface to the lead mover in the queue|
|LastMover|I_XPlanarMover|R|Interface to the last mover in the queue|
|MoverIDs|ARRAY[1..StationParameters.MaxMoversPerStation]|R|Index values of movers currently in the queue|
|Queue|Reference To ARRAY[1..StationParameters.MaxMoversPerStation]|R|Reference to the entire queue of mover interfaces|

### Methods

|**Method**|**Return Type**|**Access**|**Description**|
|--|--|--|--|
|Clear|BOOL|PUBLIC|Full clear and reset of the queue buffer|
|Dequeue|BOOL|PUBLIC|Unload the leading mover from the queue|
|Enqueue|BOOL|PUBLIC|Load mover into the queue|


## FB_XPlanarStationBase
Complete implementation of `I_XPlanarStation` for configuring and controlling a processing point on the XPlanar table.

!!! note
    See also:
        - [I_XPlanarStation](./interfaces.md#i_xplanarstation){:target="_blank"}

### Notes
- The `Recover()` method is called by the recovery sequence of the FB_XPlanar parent object and if a mover is in the 'bubble' of the station it will be brought center and joined to the defined track segment of the station (if applicable).

- The `CyclicLogic()` method is inherently called by the FB_XPlanar sum up component and continually monitors for a mover to arrive.  
- As movers pass through the `HasMover` flag will set, if a mover enters the station and stops the `MoverReady` flag will be set.


## FB_XPlanarTrackSegment
Complete implementation of `I_XPlanarTrack` for configuring and building planar track segments in NC


!!! note
    See also:
        - [I_XPlanarTrack](./interfaces.md#i_xplanartrack){:target="_blank"}



### Notes
- The `CyclicLogic()` method is inherently called by the FB_XPlanar parent object and ensures the NC object is cycled properly.

- The `Build()` method is called by the Build Tracks sequence of the FB_XPlanar parent object and checks the point configuration and initializes the segment with its linked NC group.