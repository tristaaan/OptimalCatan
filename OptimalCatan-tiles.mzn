include "globals.mzn";

% Parameters
% Resources
%              1      2       3      4      5      6      7 
enum Resource={Water, Desert, Brick, Grain, Sheep, Stone, Wood};
set of int: Resources = 1..7;
array[Resources] of int: ResourceCounts = [6, 1, 3, 4, 4, 3, 4];

% 5-6 players, 6x6 board
% array[Resources] of int: ResourceCounts = [12, 2, 5, 6, 6, 5, 6];


% Board size
int: nRows = 5;
int: nCols = 5;
set of int: Rows = 1..nRows;
set of int: Cols = 1..nCols;

% Decision Variables
array[Rows, Cols] of var Resources: Board;

% Constraints
% Resource counts
constraint forall(re in Resources)(
  sum(r in Rows)(count(Board[r,..], re)) = ResourceCounts[re]
);

constraint forall(r in 1..nRows - 1)(
  % None of the same resources adjacent below
  forall(c in 1..nCols where Board[r,c] != 1) (
    Board[r,c] != Board[r+1, c]
  )
  /\
  % None of the same resources adjacent diagonal
  forall(c in 1..nCols - 1 where Board[r,c] != 1)(
    Board[r,c] != Board[r+1, c+1]
  )
);

% None of the same resources adjacent to the right
constraint forall(r in 1..nRows) (
  forall(c in 1..nCols - 1 where Board[r,c] != 1)(
    Board[r,c] != Board[r, c + 1]
  )
);

% Wood and brick cannot be adjacent, constrained similar to the above.
constraint forall(r in 1..nRows - 1)(
  forall(c in 1..nCols where Board[r,c] in {3, 7}) (
    not(Board[r+1, c] in {3, 7})
   )
  /\
  forall(c in 1..nCols - 1 where Board[r,c] in {3, 7})(
    not(Board[r+1, c+1] in {3, 7})
  )
);

constraint forall(r in 1..nRows) (
  forall(c in 1..nCols - 1 where Board[r,c] in {3, 7})(
    not(Board[r, c+1] in {3, 7})
  )
);

% Place the water on the edges
constraint Board[1,4] = 1;
constraint Board[1,5] = 1;
constraint Board[2,5] = 1;

constraint Board[4,1] = 1;
constraint Board[5,2] = 1;
constraint Board[5,1] = 1;

% break rotational symm
constraint Board[1,1] < Board[5,5];
constraint Board[1,1] < Board[3,5];

% break reflective symm


% Objective
solve satisfy;

% output[show2d(Board)];

output[ "   \(Board[1,1..3])\n" ];
output[ " \(Board[2,1..4])\n" ];
output[ "\(Board[3,..])\n" ];
output[ " \(Board[4,2..])\n" ];
output[ "   \(Board[5,3..])\n" ];
