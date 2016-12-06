module Constants exposing (..)

import Set exposing (..)
import Svg.Attributes exposing (version, x, y, width, height)

import Types exposing (..)


centerSpot : Spot
centerSpot =
    (3,3)

allSpots : Set Spot
allSpots =
    Set.fromList
        [               (2,0), (3,0), (4,0)
        ,               (2,1), (3,1), (4,1)
        , (0,2), (1,2), (2,2), (3,2), (4,2), (5,2), (6,2)
        , (0,3), (1,3), (2,3), (3,3), (4,3), (5,3), (6,3)
        , (0,4), (1,4), (2,4), (3,4), (4,4), (5,4), (6,4)
        ,               (2,5), (3,5), (4,5)
        ,               (2,6), (3,6), (4,6)
        ]


numRadiiWide =
    7 * 3 + 4
spotRadius =
    25

svgAttrs =
    [ version "1.1"
    , x "0"
    , y "0"
    , width maxDimStr
    , height maxDimStr
    ]

maxDimStr =
    toString (numRadiiWide * spotRadius)

orangish =
    "#F0AD00"
greenish =
    "#7FD13B"
grayish =
    "#5A6378"
bluish =
    "#60B5CC"

pegColor =
    bluish
jumperColor =
    orangish
openColor =
    grayish
dropColor =
    greenish
