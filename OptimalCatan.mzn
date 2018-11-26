include "globals.mzn";

% Parameters
% Resources
%              1      2       3      4      5      6      7 
enum Resource={Water, Desert, Brick, Grain, Sheep, Stone, Wood};
set of int: Resources = 1..7;
array[Resources] of int: ResourceCounts = [6, 1, 3, 4, 4, 3, 4];

set of int: Number = 1..12;
                                    % 1,2,3,4,5,6, 7, 8,9,10,11,12
array[Number] of int: MarkerCounts = [6,1,2,2,2,2, 1, 2,2, 2, 2, 1];
% constraint assert(sum(MarkerCounts) = 25, "Wrong number of markers \(sum(MarkerCounts))");

% Board size
int: nRows = 5;
int: nCols = 5;
set of int: Rows = 1..nRows;
set of int: Cols = 1..nCols;

% Decision Variables
array[Rows, Cols] of var Resources: Board;
array[Rows, Cols] of var Number: Marker;

% Constraints
% None of the same resources adjacent below
constraint forall(r in 1..nRows - 1)(
  % Ignore water
  forall(c in 1..nCols - 1 where Board[r,c] != 1)(
    Board[r,c] != Board[r+1, c]
    /\
    Board[r,c] != Board[r+1, c+1]
    /\
    % No same markers adjacent
    Marker[r,c] != Marker[r+1, c]
    /\
    Marker[r,c] != Board[r+1, c+1]
  )
);

% None of the same resources adjacent to the right
constraint forall(r in 1..nRows) (
  forall(c in 1..nCols - 1 where Board[r,c] != 1)(
    Board[r,c] != Board[r, c + 1]
    /\
    Marker[r,c] != Marker[r, c + 1]
  )
);

% Resource counts
constraint forall(re in Resources)(
  sum(r in Rows)(count(Board[r,..], re)) = ResourceCounts[re]
);

% Wood and brick cannot be adjacent
constraint forall(r in 1..nRows - 1)(
  forall(c in 1..nCols - 1 where Board[r,c] in {3, 7}) (
    not(Board[r, c+1] in {3, 7})
    /\
    not(Board[r+1, c] in {3, 7})
    /\
    not(Board[r+1, c+1] in {3, 7})
  )
);

% Place the water on the edges
constraint Board[1,4] = 1;
constraint Board[1,5] = 1;
constraint Board[2,5] = 1;

constraint Board[4,1] = 1;
constraint Board[5,2] = 1;
constraint Board[5,1] = 1;

% Constrain marker counts
constraint forall(n in Number)(
  sum(r in Rows)(count(Marker[r,..], n)) = MarkerCounts[n]
);

% 6 and 8 not adjacent
constraint forall(r in 1..nRows - 1)(
  % Ignore water
  forall(c in 1..nCols - 1 where Marker[r,c] in {6,8})(
    not(Marker[r+1, c] in {6,8})
    /\
    not(Board[r+1, c+1] in {6,8})
  )
);

% Put 1's on water
constraint Marker[1,4] = 1;
constraint Marker[1,5] = 1;
constraint Marker[2,5] = 1;

constraint Marker[4,1] = 1;
constraint Marker[5,1] = 1;
constraint Marker[5,2] = 1;

% Place the 7 on the Desert, this is a strange constraint to write
constraint forall(r in Rows) (
  forall(c in Cols where Board[r,c] = 2)(
    Marker[r,c] = 7
  )
);

% Objective
solve satisfy;

output[show2d(Board)];
output[ "   \(Marker[1,1..3])\n" ];
output[ " \(Marker[2,1..4])\n" ];
output[ "\(Marker[3,..])\n" ];
output[ " \(Marker[4,2..])\n" ];
output[ "   \(Marker[5,3..])\n" ];