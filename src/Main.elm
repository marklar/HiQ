module Main exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)

import Types exposing (..)
import Constants exposing (..)
import View exposing (view)
import Update exposing (update)


main =
    Html.program { init = (initModel, Cmd.none)
                 , view = View.view
                 , update = Update.update
                 , subscriptions = always Sub.none
                 }


{- MODEL -}

initModel =
    { state = NoJumper
    , pegs = initPegs
    }


initPegs : Set Spot
initPegs =
    Set.remove (3,3) Constants.allSpots
