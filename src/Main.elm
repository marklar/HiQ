module Main exposing (..)

import Set exposing (..)

import Types exposing (..)
import Html exposing (Html, button, div, text)
import Svg exposing (..)
import Svg.Events exposing (..)
import Svg.Attributes exposing (..)

main =
    Html.program { init = (initModel, Cmd.none)
                 , view = view
                 , update = update
                 , subscriptions = always Sub.none
                 }


{- UPDATE -}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        JumpFrom spot ->
            (model, Cmd.none)

        JumpTo spot ->
            (model, Cmd.none)

        ReleaseJumper ->
            (model, Cmd.none)


{- VIEW -}

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
    List.map (oneSpot model.pegs) (Set.toList allSpots)


oneSpot : Set Spot -> Spot -> Svg Msg
oneSpot pegs spot =
    -- color depends on whether in model.pegs
    let
        canMove =
            isMovable spot pegs
        color =
            if Set.member spot pegs then
                if canMove then
                    orangish
                else
                    grayish
            else
                greenish
        msg =
            if canMove then
                Just (JumpFrom spot)
            else
                Nothing
    in                
        circle color spotRadius (getCenter spot) msg
    
            
circle : String -> Float -> Pt -> Maybe Msg -> Svg Msg
circle color size (x,y) msg =
    let
        baseAttrs =
            [ fill color
            , cx (toString x)
            , cy (toString y)
            , r (toString size)
            ]
      
        attrs =
            case msg of
                Just msg ->
                    (onClick msg) :: baseAttrs

                Nothing ->
                    baseAttrs
    in
        Svg.circle attrs []


spotRadius =
    5
orangish =
    "#F0AD00"
greenish =
    "#7FD13B"
bluish =
    "#60B5CC"
grayish =
    "#5A6378"


getCenter : Spot -> Pt
getCenter (col, row) =
    let
        x =
            (toFloat col * 3.0 * spotRadius) + spotRadius

        y =
            (toFloat row * 3.5 * spotRadius) + spotRadius
    in
        (x,y)

        
{- MODEL -}

initModel =
    { state = NoJumper
    , pegs = initPegs
    , movablePegs = getMovables initPegs
    , jumper = Nothing
    }


allSpots : Set Spot
allSpots =
    Set.fromList
        [               (2,0), (3,0), (4,0)
        ,               (2,1), (3,1), (4,1)
        , (0,2), (1,2), (2,2), (3,2), (4,2), (5,2), (6,2)
        , (0,3), (1,3), (2,3), (3,3), (4,3), (5,3), (6,3)
        , (0,4), (1,4), (2,4), (3,4), (4,4), (5,4), (6,4)
        ,               (2,5), (3,5), (4,5)
        ,               (2,6), (3,6), (4,6)
        ]


initPegs : Set Spot
initPegs =
    Set.remove (3,3) allSpots


isLegal : Spot -> Bool
isLegal spot =
    Set.member spot allSpots


getMovables : Set Spot -> Set Spot
getMovables pegs =
    Set.filter (\p -> isMovable p pegs) pegs


isMovable : Spot -> Set Spot -> Bool
isMovable peg pegs =
    List.any (canJump peg pegs) [North, South, East, West]


canJump : Spot -> Set Spot -> Direction -> Bool
canJump peg pegs direction =
    let
        oneAway =
            spotsAway peg 1 direction
        twoAway =
            spotsAway peg 2 direction
        isFree s =
            not (Set.member s pegs)
    in
        isLegal twoAway && isFree twoAway &&
            isLegal oneAway && not (isFree oneAway)
            

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
