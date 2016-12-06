module Model exposing (..)

import Set exposing (..)

import Types exposing (..)
import Constants exposing (..)


initModel =
    { gameOver = False
    , pegs = initPegs
    , jumper = Nothing
    , dropSpot = Nothing
    }


initPegs : Set Spot
initPegs =
    Set.remove Constants.centerSpot Constants.allSpots


