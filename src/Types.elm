module Types exposing (..)

import Set exposing (..)


-- (Column, Row)
type alias Spot = (Int,Int)


-- (x,y)
type alias Pt = (Float,Float)


type alias Model =
  { state : State
  , pegs : Set Spot
  , movablePegs : Set Spot     -- subset of pegs
  , jumper : Maybe Spot
  } 


type Direction = North
               | South
               | East
               | West


type State = NoJumper
           | Jumper Spot
           | Done


type Msg = JumpFrom Spot
         | JumpTo Spot
         | ReleaseJumper

