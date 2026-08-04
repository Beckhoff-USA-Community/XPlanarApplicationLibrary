# Overview
A modular XPlanar control component function block with minimal overhead built on the Planar Motion and XPlanar Utility TF5890 libraries that can easily scale to custom and larger projects.  This function block can be used within the SPT Framework or any other architecture.

## Class Diagrams
The library splits into an overview and four subsystem diagrams. Full member tables with descriptions and access levels are on the [Function Blocks](./functionblocks.md) and [Interfaces](./interfaces.md) pages.

### Overview
```mermaid
classDiagram
    direction TB

    class FB_Component_XPlanar
    class ip
    class I_XPlanarMover{
        <<interface>>
    }
    class I_MoveCommands{
        <<interface>>
    }
    class I_MoveDynamics{
        <<interface>>
    }
    class I_XPlanarStation{
        <<interface>>
    }
    class I_XPlanarTrack{
        <<interface>>
    }
    class FB_XPlanarMover
    class FB_XPlanarStation
    class FB_XPlanarTrackSegment

    FB_Component_XPlanar ..> FB_XPlanarMover : calls CyclicLogic()
    FB_Component_XPlanar ..> FB_XPlanarStation : calls CyclicLogic()
    FB_Component_XPlanar ..> FB_XPlanarTrackSegment : calls CyclicLogic()

    I_XPlanarMover <|.. FB_XPlanarMover
    I_MoveCommands <|.. FB_XPlanarMover
    I_MoveDynamics <|.. FB_XPlanarMover
    I_XPlanarStation <|.. FB_XPlanarStation
    I_XPlanarTrack <|.. FB_XPlanarTrackSegment
    I_XPlanarMover o-- I_XPlanarStation : Destination

    ip --> I_XPlanarMover : Movers
    ip --> I_XPlanarStation : Stations
    ip --> I_XPlanarTrack : Tracks

    note for ip "Global variable list from the Globals page. Arrays of mover, station, and track interfaces for use within the application."
```

### Component
```mermaid
classDiagram
    direction TB

    class FB_Component_XPlanar{
        Abort() BOOL
        AddMoversToGroup() I_PlanarTaskResult
        AddTracksToGroup() I_PlanarTaskResult
        EnableGroup() I_PlanarTaskResult
        EnableMovers() I_PlanarTaskResult
        EnableTracks() I_PlanarTaskResult
        IdentifyMovers() I_PlanarTaskResult
        MoverRedetect() I_PlanarTaskResult
        Recover() I_PlanarTaskResult
        Reset() BOOL
        CreateEvents()
        HMICommunication()
        Monitoring()
        CyclicLogic()
    }
    class FB_XPlanarMover{
        CyclicLogic()
        HMICommunication()
    }
    class FB_XPlanarStation{
        CyclicLogic()
        WatchForMover()
    }
    class FB_XPlanarTrackSegment{
        CyclicLogic()
    }

    FB_Component_XPlanar ..> FB_XPlanarMover : calls CyclicLogic()
    FB_Component_XPlanar ..> FB_XPlanarStation : calls CyclicLogic()
    FB_Component_XPlanar ..> FB_XPlanarTrackSegment : calls CyclicLogic()

    note for FB_Component_XPlanar "Call CyclicLogic() every PLC cycle. It cycles each mover, station, and track object and updates their statuses."
```

### Mover
```mermaid
classDiagram
    direction TB

    class I_XPlanarMover{
        <<interface>>
        MoverVector ActualPosition
        REFERENCE_TO ARRAY[1..MAX_LOG_COUNT] of STRING CommandLog
        I_XPlanarStation Destination
        I_MoveDynamics Dynamics
        LREAL Gap
        STRING IdentifiedBTN
        BOOL InStation
        I_MoveCommands MoveCommand
        STRING MoverBTN
        UDINT MoverIndex
        MOVERTYPE MoverType
        REFERENCE_TO Tc3_MC3PlanarMotion.MC_PlanarMover pm
        REFERENCE_TO CDT_MCTOPLC_PLANAR_MOVER_STD Status
        I_TcIoXPlanarMover Utility
        AddToGroup(PlanarGroup) I_PlanarTaskResult
        Disable() I_PlanarTaskResult
        Enable() I_PlanarTaskResult
        Halt() I_PlanarTaskResult
        Reset() I_PlanarTaskResult
    }

    class I_MoveCommands{
        <<interface>>
        FreeMove(LREAL XPosition, LREAL YPosition) I_PlanarTaskResult
        JoinClosestTrack(BOOL UseOrientation) I_PlanarTaskResult
        JoinTrack(I_XPlanarTrack ipTrack, BOOL UseOrientation) I_PlanarTaskResult
        LeaveTrack(LREAL DestinationX, LREAL DestinationY, BOOL UseOrientation) I_PlanarTaskResult
        Rotate(LREAL Position, DINT AdditionalTurns) I_PlanarTaskResult
        SendToStation(I_XPlanarStation Destination) I_PlanarTaskResult
        SquareUp() I_PlanarTaskResult
        TiltA(LREAL Position) I_PlanarTaskResult
        TiltB(LREAL Position) I_PlanarTaskResult
        TrackMove(LREAL Position, LREAL Gap, I_XPlanarTrack Track, MC_DIRECTION Direction) I_PlanarTaskResult
        TrackMoveXY(LREAL XPosition, LREAL YPosition, LREAL Gap, I_XPlanarTrack Track, MC_DIRECTION Direction) I_PlanarTaskResult
        VerticalMove(LREAL Position) I_PlanarTaskResult
    }

    class I_MoveDynamics{
        <<interface>>
        REFERENCE_TO ST_MoveDynamics Movement
        REFERENCE_TO ST_MoveDynamics Rotation
        REFERENCE_TO ST_MoveDynamics Tilt
    }

    class I_PlanarTaskResult{
        <<interface>>
        BOOL Aborted
        REFERENCE TO PlanarObjectInfo BlockingObjectInfo
        BOOL Busy
        BOOL Done
        BOOL Error
        UDINT ErrorID
    }

    class FB_XPlanarMover{
        CyclicLogic()
        HMICommunication()
    }

    I_XPlanarMover <|.. FB_XPlanarMover
    I_MoveCommands <|.. FB_XPlanarMover
    I_MoveDynamics <|.. FB_XPlanarMover

    I_XPlanarMover --> I_MoveCommands : MoveCommand
    I_XPlanarMover --> I_MoveDynamics : Dynamics
    I_MoveCommands ..> I_PlanarTaskResult : returns
```

### Station
```mermaid
classDiagram
    direction TB

    class I_XPlanarStation{
        <<interface>>
        BOOL AllowQueing
        BOOL CanReleaseMover
        I_XPlanarMover CurrentMover
        BOOL HasMover
        UDINT ID
        REFERENCE_TO FB_MoverQueue MoverQueue
        STRING Name
        I_XPlanarStation NextStation
        UDINT NumMoversRequired
        REFERENCE_TO PositionXYC Position
        Position2D_LREAL Size
        BOOL StationComplete
        BOOL StationReady
        E_StationType StationType
        UDINT TrackID
        Execute()
        Reset() BOOL
    }

    class FB_XPlanarStation{
        CyclicLogic()
        WatchForMover()
    }

    class FB_MoverQueue{
        UDINT Count
        I_XPlanarMover FirstMover
        I_XPlanarMover LastMover
        ARRAY[1..StationParameters.MaxMoversPerStation] MoverIDs
        REFERENCE TO ARRAY[1..StationParameters.MaxMoversPerStation] Queue
        Clear() BOOL
        Dequeue() BOOL
        Enqueue() BOOL
    }

    class I_XPlanarMover{
        <<interface>>
    }

    I_XPlanarStation <|.. FB_XPlanarStation
    I_XPlanarStation --> FB_MoverQueue : MoverQueue
    I_XPlanarStation --> I_XPlanarStation : NextStation
    I_XPlanarMover o-- I_XPlanarStation : Destination
    FB_MoverQueue --> I_XPlanarMover : FirstMover, LastMover

    note for FB_XPlanarStation "As movers pass through, HasMover sets. If a mover enters the station and stops, StationReady sets."
```

### Track Segment
```mermaid
classDiagram
    direction TB

    class I_XPlanarTrack{
        <<interface>>
        REFERENCE_TO ST_TrackDefinition Definition
        UDINT Index
        UDINT MoverCount
        UDINT MovingMoverCount
        REFERENCE_TO Tc3_MC3PlanarMotion.MC_PlanarTrack pm
        REFERENCE_TO CDT_MCTOPLC_PLANAR_TRACK_STD Status
        LREAL TrackLength
        I_TcIoXPlanarTrack Utility
        AddToGroup(PlanarGroup) I_PlanarTaskResult
        AppendLine(LREAL StartPointX, LREAL StartPointY, LREAL EndPointX, LREAL EndPointY) I_PlanarTaskResult
        AppendPoint(LREAL PointX, LREAL PointY) I_PlanarTaskResult
        Build() I_PlanarTaskResult
        Clear() I_PlanarTaskResult
        CloseLoop() I_PlanarTaskResult
        Disable() I_PlanarTaskResult
        Enable() I_PlanarTaskResult
        GetTrackPositionAt(PositionXYC Position) LREAL
        Reset() I_PlanarTaskResult
    }

    class FB_XPlanarTrackSegment{
        CyclicLogic()
    }

    I_XPlanarTrack <|.. FB_XPlanarTrackSegment

    note for FB_XPlanarTrackSegment "Build() checks the point configuration and initializes the segment with its linked NC group."
```
