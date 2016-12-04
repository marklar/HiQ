module Update exposing (..)

import Set exposing (..)
import Debug exposing (log)

import Types exposing (..)
import Peg exposing (isMovable)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        JumpFrom spot ->
            jumpFrom spot model

        JumpTo spot ->
            jumpTo spot model

        ReleaseJumper ->
            releaseJumper model


jumpFrom : Spot -> Model -> (Model, Cmd Msg)
jumpFrom spot model =
    let
        model_ =
            { state = Jumper spot
            , pegs = model.pegs
            }
    in
        (model_, Cmd.none)


jumpTo : Spot -> Model -> (Model, Cmd Msg)
jumpTo spot model =
    let
        pegs_ =
            case model.state of
                Jumper jumper ->
                    model.pegs
                        |> Set.remove jumper
                        |> Set.insert spot
                        |> Set.remove (spotBetween jumper spot)

                otherwise ->  -- This shouldn't happen
                    model.pegs
                           
        model_ =
            { state = if isDone pegs_ then Done else NoJumper
            , pegs = pegs_
            }
    in
        (model_, Cmd.none)


isDone : Set Spot -> Bool
isDone pegs =
    pegs
        |> Set.filter (\p -> isMovable p pegs)
        |> Set.isEmpty


spotBetween : Spot -> Spot -> Spot
spotBetween (c1,r1) (c2,r2) =
    if c1 == c2 then
        (c1, (min r1 r2) + 1)   -- vertical
    else
        ((min c1 c2) + 1, r1)   -- horizontal
    
            
releaseJumper : Model -> (Model, Cmd Msg)
releaseJumper model =
    ({ model | state = NoJumper }, Cmd.none)
