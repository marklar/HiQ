module View exposing (view)

import Types exposing (..)
import Constants exposing (..)
import Peg exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ Html.text <|
              toString (Set.size model.pegs)
              ++ " pegs"
              ++ if model.state == Done then
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
            (getClickMsg model spot)


getClickMsg : Model -> Spot -> Maybe Msg
getClickMsg model spot =
    case model.state of
        Jumper jumper ->
            clickMsgWhenThereIsJumper model jumper spot
                            
        NoJumper ->
            if isMovable spot model.pegs then
                Just (JumpFrom spot)
            else
                Nothing
                                        
        Done ->
            Nothing
                

clickMsgWhenThereIsJumper : Model -> Spot -> Spot -> Maybe Msg
clickMsgWhenThereIsJumper model jumper spot =
    if spot == jumper then
        Nothing
    else
        if Set.member spot model.pegs then
            Just ReleaseJumper
        else
            if canReach jumper spot model.pegs then
                Just (JumpTo spot)
            else
                Nothing
                

getColor : Model -> Spot -> String
getColor model spot =
    if Set.member spot model.pegs then
        getPegColor model spot
    else
        openColor
    

getPegColor : Model -> Spot -> String
getPegColor model spot =
    case model.state of
        Jumper jumper ->
            if spot == jumper then
                jumperColor
            else
                pegColor
        otherwise ->
            pegColor


-----------------

-- (x,y)
type alias Pt = (Float,Float)


circle : String -> Float -> Pt -> Maybe Msg -> Svg Msg
circle color size (x,y) clickMsg =
    let
        baseAttrs =
            [ fill color
            , cx (toString x)
            , cy (toString y)
            , r (toString size)
            ]
      
        attrs =
            case clickMsg of
                Just m ->
                    (onClick m) :: baseAttrs

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

        
