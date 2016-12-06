module Update exposing (update)

import Set exposing (..)
import Debug exposing (log)
import Mouse exposing (Position)
import Debug exposing (..)

import Types exposing (..)
import Peg exposing (isMovable, canReach, spotCenter)
import Constants exposing (..)
import Model exposing (..)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        model_ =
            case msg of
                Restart ->
                    Model.initModel

                DragStart spot position ->
                    createJumper spot position model

                DragAt position ->
                    updateJumperAndDrop position model

                DragEnd position ->
                    dragEnd position model
    in
        (model_, Cmd.none)


---------------

createJumper : Spot -> Position -> Model -> Model
createJumper spot position model =
    { model
        | pegs = Set.remove spot model.pegs
        , jumper = Just { spot = spot
                        , dragInit = position
                        , dragNow = position
                        }
    }


updateJumperAndDrop : Position -> Model -> Model
updateJumperAndDrop position model =
    case model.jumper of
        Nothing ->
            model  -- Debug.crash "This should never happen"

        Just jumper ->
            let
                j =
                    { jumper
                        | dragNow = position }
                ds =
                    getDropSpot j model
            in
                { model
                    | jumper = Just j
                    , dropSpot = ds
                }


-- Update pegs
dragEnd : Position -> Model -> Model
dragEnd position model =
    let
        model_ =
            updateJumperAndDrop position model
        pegs_ =
            pegsAfterDrop position model_
    in
        { gameOver = isGameOver pegs_
        , pegs = pegs_
        , jumper = Nothing
        , dropSpot = Nothing
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
                    Set.insert j.spot model.pegs

                Just dropSpot ->
                    model.pegs
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
        |> Set.filter (flip Peg.isMovable pegs)
        |> Set.isEmpty


spotBetween : Spot -> Spot -> Spot
spotBetween (c1,r1) (c2,r2) =
    if c1 == c2 then
        -- vertical
        ( c1
        , (min r1 r2) + 1
        )
    else
        -- horizontal
        ( (min c1 c2) + 1
        , r1
        )
