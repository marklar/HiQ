module Update exposing (update)

import Set exposing (..)
import Debug exposing (log)
import Mouse exposing (Position)
import Debug exposing (..)

import Types exposing (..)
import Peg exposing (isMovable, canReach, spotCenter)
import Constants exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        model_ =
            case msg of
                DragStart spot position ->
                    createJumper spot position model

                DragAt position ->
                    updateJumper position model

                DragEnd position ->
                    dragEnd position model
    in
        (model_, Cmd.none)


---------------

createJumper : Spot -> Position -> Model -> Model
createJumper spot position model =
    { model |
          jumper = Just { spot = spot
                        , dragInit = position
                        , dragNow = position
                        }
    }


updateJumper : Position -> Model -> Model
updateJumper position model =
    case model.jumper of
        Nothing ->
            model  -- Debug.crash "This should never happen"

        Just jumper ->
            { model |
                  jumper = Just { jumper |
                                      dragNow = position }
            }


-- Update pegs
dragEnd : Position -> Model -> Model
dragEnd position model =
    let
        model_ =
            updateJumper position model
        pegs_ =
            pegsAfterDrop position model_
    in
        { gameOver = isGameOver pegs_
        , jumper = Nothing
        , pegs = pegs_
        }


---------------


pegsAfterDrop : Position -> Model -> Set Spot
pegsAfterDrop mousePos model =
    case model.jumper of
        Nothing ->
            model.pegs  -- Debug.crash "This should never happen"

        Just j ->
            case getDropSpot j model of
                Nothing ->
                    model.pegs

                Just dropSpot ->
                    model.pegs
                        |> Set.remove j.spot
                        |> Set.insert dropSpot
                        |> Set.remove (spotBetween j.spot dropSpot)


getDropSpot : Jumper -> Model -> Maybe Spot
getDropSpot jumper model =
    let
        droppables =
            getHoverSpots (Peg.jumperPosition jumper)
                |> Set.filter (\s -> Peg.canReach jumper.spot s model.pegs)
    in
        case Set.toList droppables of
            [] ->
                Nothing
            s :: _ ->
                Just s


-- Determine which Spots (if any) we're hovering over.
-- As it happens, there will be at most two.
getHoverSpots : Position -> Set Spot
getHoverSpots jumperPos =
    -- Set.fromList [(3,3)]
    Set.toList Constants.allSpots
        |> List.filter (Peg.spotCenter >> Peg.isThereOverlap jumperPos)
        |> Set.fromList


---------------


isGameOver : Set Spot -> Bool
isGameOver pegs =
    pegs
        |> Set.filter (\p -> Peg.isMovable p pegs)
        |> Set.isEmpty


spotBetween : Spot -> Spot -> Spot
spotBetween (c1,r1) (c2,r2) =
    if c1 == c2 then
        -- vertical
        (c1, (min r1 r2) + 1)
    else
        -- horizontal
        ((min c1 c2) + 1, r1)
