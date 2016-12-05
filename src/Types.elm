module Types exposing (..)

import Set exposing (..)
import Mouse exposing (Position)


-- (Column, Row)
type alias Spot = (Int,Int)


type alias Model =
  { state : State
  , drag : Maybe Drag
  , pegs : Set Spot
  } 


{-
This establishes relative distance.
Determine how far the mouse have moved (since DrageStart).
Add this to the draggable's orig position.
-}
type alias Drag =
    { start : Position
    , current : Position
    }


type State = Jumper Spot
           | NoJumper
           | GameOver


type Msg = DragStart Spot Position
         | DragAt Position
         | DragEnd Position


-- Needed?
type Direction = North
               | South
               | East
               | West
