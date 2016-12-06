module Main exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)
import Mouse exposing (Position)

import Types exposing (..)
import Constants exposing (..)
import View exposing (view)
import Update exposing (update)


main =
    Html.program { init = (initModel, Cmd.none)
                 , view = View.view
                 , update = Update.update
                 , subscriptions = subscriptions
                 }


{- MODEL -}

initModel =
    { gameOver = False
    , pegs = initPegs
    , jumper = Nothing
    , dropSpot = Nothing
    }


initPegs : Set Spot
initPegs =
    Set.remove Constants.centerSpot Constants.allSpots


{- SUBS -}

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.jumper of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt
                      , Mouse.ups DragEnd
                      ]
