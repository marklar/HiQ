module Types exposing (..)

import Set exposing (..)


-- (Column, Row)
type alias Spot = (Int,Int)


type alias Model =
  { state : State
  , pegs : Set Spot
  } 


type State = Jumper Spot
           | NoJumper
           | Done


type Msg = JumpFrom Spot
         | JumpTo Spot
         | ReleaseJumper


type Direction = North
               | South
               | East
               | West
