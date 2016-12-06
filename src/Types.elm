module Types exposing (..)

import Set exposing (..)
import Mouse exposing (Position)


-- (Column, Row)
type alias Spot = (Int,Int)


type alias Model =
    { gameOver : Bool
    , pegs : Set Spot
    , jumper : Maybe Jumper
    , dropSpot : Maybe Spot  -- put inside Jumper?
    }


type alias Jumper =
    { spot : Spot
    {- Drag establishes relative distance.
    Determine how far the mouse have moved (since DragStart).
    Add this to the draggable's orig position. -}
    , dragInit : Position
    , dragNow : Position
    }


type Msg = DragStart Spot Position
         | DragAt Position
         | DragEnd Position
         | Restart


-- Needed?
type Direction = North
               | South
               | East
               | West
