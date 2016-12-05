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
        [ svg svgAttrs (board model)
        , Html.text <| statusStr model
        ]


statusStr : Model -> String
statusStr model =
    let
        n =
            numPegs model
    in
        String.concat [ toString n
                      , if n == 1 then " peg" else " pegs"
                      , if model.gameOver then " - DONE!" else ""
                      ]


numPegs : Model -> Int
numPegs model =
    (Set.size model.pegs) +
        case model.jumper of
            Just j ->
                1
            Nothing ->
                0


board : Model -> List (Svg Msg)
board model =
    let
        spotsSvg =
            Constants.allSpots
                |> Set.toList
                |> List.map (oneSpot model)
        jumperSvg =
            case model.jumper of
                Nothing ->
                    []

                Just j ->
                    [viewJumper j model]
    in
        -- Put jumper "on top".
        spotsSvg ++ jumperSvg



viewJumper : Jumper -> Model -> Svg Msg
viewJumper jumper model =
    circle jumperColor
        Constants.spotRadius
            (Peg.jumperPosition jumper)
            Nothing


oneSpot : Model -> Spot -> Svg Msg
oneSpot model spot =
    circle (getColor model spot)
        Constants.spotRadius
            (Peg.spotCenter spot)
            (getMousedownMsg model spot)


-- If there's no jumper, include 'mousedown' attribute
-- on those pegs which are currently movable.
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
                

getColor : Model -> Spot -> String
getColor model spot =
    if Set.member spot model.pegs then
        pegColor
    else
        openColor
    

-----------------


circle : String -> Float -> Position -> Maybe (Attribute Msg) -> Svg Msg
circle color size {x,y} attrMsg =
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
