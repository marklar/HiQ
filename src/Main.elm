module Main exposing (..)

import Set exposing (..)
import Html exposing (Html, button, div, text)
import Mouse exposing (Position)

import Types exposing (..)
import Model exposing (..)
import View exposing (view)
import Update exposing (update)


main =
    Html.program { init = (initModel, Cmd.none)
                 , view = View.view
                 , update = Update.update
                 , subscriptions = subscriptions
                 }


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
