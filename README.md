
# Hi-Q Game

## Intro

Hi-Q (aka "Peg Solitaire") is a single-player game, the goal of which
is to remove as many pegs from the board as you can. To remove a peg
one must jump it with another. The game starts with only the center
spot unoccupied, and a perfect execution leaves only a single peg, in
that same center spot.

The board has 33 (= 4*6 + 9) spots and 32 peg. It looks like this:

```
    O O O             O = peg
    O O O             + = open space
O O O O O O O
O O O + O O O
O O O O O O O
    O O O
    O O O
```


## To Play

One-time install. Thereafter, just play it.

### Installation

+ [Install Elm](https://guide.elm-lang.org/install.html)
+ `$ git clone git@github.com:marklar/HiQ.git`

### Playing

```
$ cd HiQ
$ elm-reactor &
$ open http://localhost:8000/src/Main.elm
```


## Game Logic

There is no AI against which to play, nor any randomness in the setup
or execution of the game. The user makes a move, the board changes,
she makes another move, and so on.

Most of the logic is easily described and involves determining which
pegs (if any) can be moved and to which open spots, and recognizing
when a peg is over such a spot.


## User Interaction

The user moves a peg by dragging and dropping. When the selected peg
is dragged over a legal drop spot, that spot changes color to reflect
that a target has been reached (and it's okay to release it). If the
user lets go anywhere other than over a legal drop spot, the peg
returns to its starting point.

### Dragging Details

To know when dragging begins, we'll set 'mousedown' attributes on only
those particular spots eligible to be jumpers. That way, we don't have
to figure out whether a click somewhere corresponds to a potential
jumper (i.e. by calculating from the mouse position -> peg).

Then, using subscriptions, one can get the following relevant mouse
activity:

+ moves
+ ups

Each provides the Msg with its Mouse.Position ({x,y}).


## TODO

+ Undo. Add an 'undo' button, to walk back one or more turns.
+ Animation. Upon the user's dropping of the peg, animate both:
  - the peg's occupation of that drop spot, and
  - the removal of the jumped-over peg (fading?).
+ Advanced: visual indication of which pegs (if any) are
  stranded. That would provide real-time feedback on mistakes.
+ Page title, instructions, and other decorative oddments.
+ Leader board (or other visual record of past attempts).
