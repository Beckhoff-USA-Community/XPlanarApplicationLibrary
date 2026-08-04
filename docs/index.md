# Overview
A modular XPlanar control component function block with minimal overhead built on the Planar Motion and XPlanar Utility TF5890 libraries that can easily scale to custom and larger projects.  This function block can be used within the SPT framework or any other architecture.

## Class Diagram
```mermaid
classDiagram
    I_XPlanarTrack <|.. FB_XPlanarTrackSegment
    I_XPlanarStation <|.. FB_XPlanarStation
    I_XPlanarMover o-- I_XPlanarStation
    I_XPlanarMover <|.. FB_XPlanarMover
    I_MoveCommands <|.. FB_XPlanarMover
    I_MoveDynamics <|.. FB_XPlanarMover

    ip --> I_XPlanarMover
    ip --> I_XPlanarTrack
    ip --> I_XPlanarStation

    class FB_Component_XPlanar{
      BOOL Abort()
      I_PlanarTaskResult AddMoversToGroup()
      I_PlanarTaskResult AddTracksToGroup()
      I_PlanarTaskResult EnableGroup()
      I_PlanarTaskResult EnableMovers()
      I_PlanarTaskResult EnableTracks()
      I_PlanarTaskResult IdentifyMovers()
      I_PlanarTaskResult MoverRedetect()
      I_PlanarTaskResult Recover()
      BOOL Reset()
      CreateEvents()
      HMICommunication()
      Monitoring()
      CyclicLogic()
    }
    class I_XPlanarMover{
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

      I_PlanarTaskResult AddToGroup(PlanarGroup)
      I_PlanarTaskResult Disable()
      I_PlanarTaskResult Enable()
      I_PlanarTaskResult Halt()
      I_PlanarTaskResult Reset()
    }

    class I_MoveCommands{
      I_PlanarTaskResult FreeMove(LREAL:XPosition, LREAL:YPosition)
      I_PlanarTaskResult JoinClosestTrack(BOOL:UseOrientation)
      I_PlanarTaskResult JoinTrack(I_XPlanarTrack:ipTrack, BOOL:UseOrientation)
      I_PlanarTaskResult LeaveTrack(LREAL:DestinationX, LREAL:DestinationY, BOOL:UseOrientation)
      I_PlanarTaskResult Rotate(LREAL:Position, DINT:AdditionalTurns)
      I_PlanarTaskResult SendToStation(I_XPlanarStation:Destination)
      I_PlanarTaskResult SquareUp()
      I_PlanarTaskResult TiltA(LREAL:Position)
      I_PlanarTaskResult TiltB(LREAL:Position)
      I_PlanarTaskResult TrackMove(LREAL:Position, LREAL:Gap, I_XPlanarTrack:Track, MC_DIRECTION:Direction)
      I_PlanarTaskResult TrackMoveXY(LREAL:XPosition, LREAL:YPosition, LREAL:Gap, I_XPlanarTrack:Track, MC_DIRECTION:Direction)
      I_PlanarTaskResult VerticalMove(LREAL:Position)
    }

    class I_MoveDynamics{
      REFERENCE_TO ST_MoveDynamics Movement
      REFERENCE_TO ST_MoveDynamics Rotation
      REFERENCE_TO ST_MoveDynamics Tilt
    }

    class FB_XPlanarMover{
      CyclicLogic()
      HMICommunication()
    }
    class I_XPlanarStation{
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
      BOOL Reset()
    }
    class FB_XPlanarStation{
      CyclicLogic()
      WatchForMover()
    }
    class I_XPlanarTrack{
      REFERENCE_TO ST_TrackDefinition Definition
      UDINT Index
      UDINT MoverCount
      UDINT MovingMoverCount
      REFERENCE_TO Tc3_MC3PlanarMotion.MC_PlanarTrack pm
      REFERENCE_TO CDT_MCTOPLC_PLANAR_TRACK_STD Status
      LREAL TrackLength
      I_TcIoXPlanarTrack Utility

      I_PlanarTaskResult AddToGroup(PlanarGroup)
      I_PlanarTaskResult AppendLine(LREAL:StartPointX, LREAL:StartPointY, LREAL:EndPointX, LREAL:EndPointY)
      I_PlanarTaskResult AppendPoint(LREAL:PointX, LREAL:PointY)
      I_PlanarTaskResult Build()
      I_PlanarTaskResult Clear()
      I_PlanarTaskResult CloseLoop()
      I_PlanarTaskResult Disable()
      I_PlanarTaskResult Enable()
      LREAL GetTrackPositionAt(PositionXYC:Position)
      I_PlanarTaskResult Reset()

    }
    class FB_XPlanarTrackSegment{
        CyclicLogic()
    }

    class ip{
      Tracks : ARRAY[1..SystemParameters.TRACK_COUNT] of I_XPlanarTrack
      Movers : ARRAY[1..SystemParameters.MOVER_COUNT] of I_XPlanarMover
      Stations : ARRAY[1..SystemParameters.STATION_COUNT] of I_XPlanarStation
    }

```
