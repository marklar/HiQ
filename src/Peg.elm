module Peg exposing (canReach, isMovable)

import Set exposing (..)

import Types exposing (..)
import Constants exposing (..)


canReach : Spot -> Spot -> Set Spot -> Bool
canReach peg spot pegs =
    Set.member spot (jumpToSpots peg pegs)


isMovable : Spot -> Set Spot -> Bool
isMovable peg pegs =
    List.any (canJump peg pegs)
        [North, South, East, West]


----------------


-- Assumes 'peg' is actually a peg, not open.
jumpToSpots : Spot -> Set Spot -> Set Spot
jumpToSpots peg pegs =
    [North, South, East, West]
        |> List.filter (canJump peg pegs)
        |> List.map (spotsAway peg 2)
        |> Set.fromList


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
