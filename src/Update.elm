module Update exposing (..)

import Set exposing (..)
import Debug exposing (log)
import Mouse exposing (Position)
import Debug exposing (..)

import Types exposing (..)
import Peg exposing (isMovable, canReach, spotCenter)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let
        model_ =
            case msg of
                DragStart spot position ->
                    dragStart spot position model

                DragAt position ->
                    dragAt position model

                DragEnd position ->
                    dragEnd position model
    in
        (model_, Cmd.none)


-- Create jumper
dragStart : Spot -> Position -> Model -> Model
dragStart spot position model =
    { model |
          jumper = Just { spot = spot
                        , dragInit = position
                        , dragNow = position
                        }
    }


-- Update jumper's position
dragAt : Position -> Model -> Model
dragAt position model =
    case model.jumper of
        Nothing ->
            Debug.crash "This should never happen"

        Just jumper ->
            { model |
                  jumper = Just { jumper |
                                      dragNow = position }
            }


-- Update pegs
dragEnd : Position -> Model -> Model
dragEnd position model =
    let
        pegs_ =
            pegsAfterDrop position model
    in
        { gameOver = isGameOver pegs_
        , jumper = Nothing
        , pegs = pegs_
        }


---------------


pegsAfterDrop : Position -> Model -> Set Spot
pegsAfterDrop position model =
    case model.jumper of
        Nothing ->
            Debug.crash "This should never happen"

        Just j ->
            case getDropSpot position j.spot model of
                Nothing ->
                    model.pegs

                Just dropSpot ->
                    model.pegs
                        |> Set.remove j.spot
                        |> Set.insert dropSpot
                        |> Set.remove (spotBetween j.spot dropSpot)


getDropSpot : Position -> Spot -> Model -> Maybe Spot
getDropSpot position jumper model =
    case getHoverSpot position of
        Nothing ->
            Nothing

        Just hoverSpot ->
            if Peg.canReach jumper hoverSpot model.pegs then
                Just hoverSpot
            else
                Nothing


-- Determine which Spot (if any) we're hovering over.
getHoverSpot : Position -> Maybe Spot
getHoverSpot position =
    -- Debug.crash "TODO"
    Just (3,3)
    -- Nothing


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
