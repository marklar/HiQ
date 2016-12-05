module View exposing (view)

import Types exposing (..)
import Constants exposing (..)
import Peg exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)
import Json.Decode as Decode
import Mouse exposing (Position)


view : Model -> Html Msg
view model =
    div []
        [ Html.text <|
              toString (Set.size model.pegs)
              ++ " pegs"
              ++ if model.gameOver then
                     " - DONE!"
                 else
                     ""
        , svg [ version "1.1"
              , x "0"
              , y "0"
              , viewBox "0 0 200 200"
              ]
              (board model)
        ]


board : Model -> List (Svg Msg)
board model =
    Constants.allSpots
        |> Set.toList
        |> List.map (oneSpot model) 


oneSpot : Model -> Spot -> Svg Msg
oneSpot model spot =
    circle (getColor model spot)
        Constants.spotRadius
            (getCenter spot)
            (getMousedownMsg model spot)


getMousedownMsg : Model -> Spot -> Maybe (Attribute Msg)
getMousedownMsg model spot =
    case model.jumper of
        Just j ->
            Nothing

        Nothing ->
            if isMovable spot model.pegs then
                Just (on "mousedown" (Decode.map (DragStart spot) Mouse.position))
            else
                Nothing
                

-- if canReach jumper spot model.pegs then
-- if Set.member spot model.pegs then
                
getColor : Model -> Spot -> String
getColor model spot =
    if Set.member spot model.pegs then
        getPegColor model spot
    else
        openColor
    

getPegColor : Model -> Spot -> String
getPegColor model spot =
    case model.jumper of
        Just j ->
            if spot == j.spot then
                jumperColor
            else
                pegColor
        otherwise ->
            pegColor


-----------------

-- (x,y)
type alias Pt = (Float,Float)


circle : String -> Float -> Pt -> Maybe (Attribute Msg) -> Svg Msg
circle color size (x,y) attrMsg =
    let
        baseAttrs =
            [ fill color
            , cx (toString x)
            , cy (toString y)
            , r (toString size)
            ]
      
        attrs =
            case attrMsg of
                Just m ->
                    m :: baseAttrs

                Nothing ->
                    baseAttrs
    in
        Svg.circle attrs []


getCenter : Spot -> Pt
getCenter (col, row) =
    let
        dist i =
            (toFloat i * 3.0 * Constants.spotRadius) +
                (1.5 * Constants.spotRadius)
    in
        (dist col, dist row)
