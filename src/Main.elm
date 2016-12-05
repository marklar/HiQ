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
    { state = NoJumper
    , drag = Nothing
    , pegs = initPegs
    }


initPegs : Set Spot
initPegs =
    Set.remove (3,3) Constants.allSpots


{- SUBS -}

subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch [ Mouse.moves DragAt
                      , Mouse.ups DragEnd
                      ]
