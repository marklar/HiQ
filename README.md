
# Hi-Q Game

## Intro

Hi-Q is a single-player game, the goal of which is to remove as many
pieces from the board as you can. To remove a piece one must jump it
with another. The game starts with only the center spot unoccupied,
and a perfect execution leaves only a single piece, in that same
center spot.

The board has 33 (= 4*6 + 9) spots and 32 pieces. It looks like this:

```
    O O O
    O O O
O O O O O O O
O O O + O O O
O O O O O O O
    O O O
    O O O
```


## User Interaction

### Jumper vs. Jumpee

The game play is straightforward. There is no AI against which to
play, nor any randomness in the setup or execution of the game. The
user makes a move, the board changes, she makes another move, and so
on.

The main questions involve how the user makes her moves. She needs to
choose both a piece to move and a legal spot to move it to. (Illegal
moves must be disallowed.)

In many cases simply indicating which piece is to be jumped (rather
than which is to jump) would be unequivocal, because there are at most
two options for jumps to effect its removal. But in those equivocal
cases, how would she then indicate which she meant?

In any case, I suspect that the user would find it unnatural to
indicate the to-be-jumped piece, as her focus is on the pieces which
do the jumping. The most intuitive UI involves moving the jumper.

### Dragging vs. Clicks

The best way to move the jumper is probably by dragging. Once you
"pick it up", its legal drop spots could change color, indicating
their availability. And once you hold the piece over a legal drop
spot, it changes color yet again to indicate "if you let go, we're
good". If the user lets go anywhere other than over a legal drop spot,
the piece reverts to its previous spot.

While dragging may be best, I don't know how to do it.

Instead, our workable (if inferior) alternative will be for the user
to click first on the jumper and then on its landing spot. The first
click causes the legal landing spots to change color, and selecting
one of them completes the move. Clicking anywhere else starts the turn
over.

#### Update: Dragging

To know when dragging begins, we'll set 'mousedown' attributes on only
those particular spots eligible to be jumpers. That way, we don't have
to figure out whether a click somewhere corresponds to a potential
jumper (i.e. by calculating from the mouse position -> peg). That's
exactly what they do in the
['drag' example](http://elm-lang.org/examples/drag).

Then, using subscriptions, one can get the following relevant mouse
activity:

+ moves
+ ups

Each provides the Msg with its Mouse.Position ({x,y}).

We'll still need to know whether the user is dragging a jumper or not,
and if so, from which spot. When drawing the peg that corresponds to
that spot, instead of using the default display, we'll calculate its
center from our info about the mouse position. We should *also* draw
an empty spot in the standard place.


## Implementation

### Msgs

Clicks produce the following message types:

+ Jumper Coord
  - To start turn, user clicked a jumper (movable piece).
+ Landing Coord
  - To end turn, user selected a legal landing spot.
+ CancelJumper
  - To revert selection, user clicked a non-legal landing spot. (We
    don't care which.)

### Model

The game can be in a number of different states:

+ Done
  - When no legal jumps remaining.
  - Expressing this explicitly in the model allows computing it in
    'update' rather than during 'view'.
+ NoJumper
  - User is between turns. (About to select a jumper.)
+ Jumper Coord
  - User is 1/2-way thru her turn.
  - Clicked a jumper but hasn't yet chosen its landing spot.


Each spot on the board can be in one of a few states:

+ Open (Free? Hole?)
  - Reachable - selectable for dropping
  - Unreachable - not selectable for dropping
+ Filled (Taken? Peg?)
  - Stuck - not selectable for moving
  - Movable - selectable for moving
  - Moving - selected for movement

We can probably store only the Peg spots in one Dict, indicating for
each whether it's Stuck or Movable.

