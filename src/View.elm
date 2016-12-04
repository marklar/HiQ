module View exposing (view)

import Types exposing (..)
import Constants exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ svg [ version "1.1"
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
            if isMovable spot model then
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
            if isReachable spot jumper model then
                Just (JumpTo spot)
            else
                Nothing
                

getColor : Model -> Spot -> String
getColor model spot =
    if Set.member spot model.pegs then
        pegColor
    else
        emptyColor
    

------------------

isReachable : Spot -> Spot -> Model -> Bool
isReachable spot peg model =
    Set.member spot (jumpToSpots peg model)


-- Assumes 'peg' is actually a peg, not open.
jumpToSpots : Spot -> Model -> Set Spot
jumpToSpots peg model =
    [North, South, East, West]
        |> List.filter (canJump peg model)
        |> List.map (spotsAway peg 2)
        |> Set.fromList


isMovable : Spot -> Model -> Bool
isMovable peg model =
    List.any (canJump peg model)
        [North, South, East, West]


canJump : Spot -> Model -> Direction -> Bool
canJump peg model direction =
    let
        oneAway =
            spotsAway peg 1 direction
        twoAway =
            spotsAway peg 2 direction
        isFree s =
            not (Set.member s model.pegs)
    in
        isLegal twoAway && isFree twoAway &&
            isLegal oneAway && not (isFree oneAway)
            

isLegal : Spot -> Bool
isLegal spot =
    Set.member spot Constants.allSpots


{-
Returns coordinate for a spot.
May NOT be a LEGAL spot.
-}
spotsAway : Spot -> Int -> Direction -> Spot
spotsAway (col,row) numSteps direction =
    case direction of
        North ->
            (col - numSteps, row)

        South ->
            (col + numSteps, row)

        East ->
            (col, row + numSteps)

        West ->
            (col, row - numSteps)
            

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

        
