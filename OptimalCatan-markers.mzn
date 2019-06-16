include "globals.mzn";

% Parameters
set of int: Number = 1..12;
array[Number] of int: MarkerCounts = [6,1,2,2,2,2, 1, 2,2, 2, 2, 1];
% constraint assert(sum(MarkerCounts) = 25, "Wrong number of markers \(sum(MarkerCounts))");

% Board size
int: nRows = 5;
int: nCols = 5;
set of int: Rows = 1..nRows;
set of int: Cols = 1..nCols;

%              1      2       3      4      5      6      7 
enum Resource={Water, Desert, Brick, Grain, Sheep, Stone, Wood};
set of int: Resources = 1..7;
% uncomment for testing
array [Rows,Cols] of Resources: Board;
% array [Rows,Cols] of Resources: Board = [| 2, 7, 5, 1, 1 |
%    3, 4, 6, 7, 1 |
%    6, 5, 3, 5, 4 |
%    1, 7, 4, 6, 3 |
%    1, 1, 5, 7, 4 |];

% Decision Variables
array[Rows, Cols] of var Number: Marker;

% Constraints

% Constrain marker counts
constraint forall(n in Number)(
  sum(r in Rows)(count(Marker[r,..], n)) = MarkerCounts[n]
);

% No two neighboring markers can be the same
constraint forall(r in 1..nRows-1) (
  forall(c in 1..nCols-1) (
    alldifferent_except_0([Marker[r,c]-1, Marker[r, c+1]-1, 
                           Marker[r+1, c]-1, Marker[r+1,c+1]-1])
  )
);

% 6 and 8 not adjacent
constraint forall(r in 1..nRows-1)(
  forall(c in 1..nCols-1 where Marker[r,c] in {6,8})(
    not(Marker[r+1, c] in {6,8}) 
    /\
    not(Marker[r, c+1] in {6,8})
    /\
    not(Marker[r+1, c+1] in {6,8}) 
  )
);

% Put 1's on water
constraint Marker[1,4] = 1;
constraint Marker[1,5] = 1;
constraint Marker[2,5] = 1;

constraint Marker[4,1] = 1;
constraint Marker[5,1] = 1;
constraint Marker[5,2] = 1;

% Place the 7 on the Desert
constraint forall(r in Rows)(
  forall(c in Cols where Board[r,c] = 2) (
    Marker[r,c] = 7
  )
);

% All resources have different markers
constraint forall(res in {3,4,5,6,7}) (
  % all markers different
  all_different([Marker[r,c] | r in Rows, c in Cols where Board[r,c] = res ])
  /\
  % only one 6 or 8 per resource
  count([Marker[r,c] | r in Rows, c in Cols where Board[r,c] = res ], 8) +
  count([Marker[r,c] | r in Rows, c in Cols where Board[r,c] = res ], 6) <= 1
);

% distribute markers so that the sum of a vertex is under some threshold
constraint forall(r in 1..nRows-1)(
  forall(c in 1..nCols-1 where Marker[r,c] > 1) (
    Marker[r,c] + Marker[r+1,c] + Marker[r+1, c+1] < 23
    /\
    Marker[r,c] + Marker[r,c+1] + Marker[r+1, c+1] < 23
  )
);

% Objective
solve satisfy;

output["{\n"];
output["board: \(showJSON(Board)),\n"];
output["markers: \(showJSON(Marker))\n"];
output["}\n"];

% output[ "   \(Marker[1,1..3])\n" ];
% output[ " \(Marker[2,1..4])\n" ];
% output[ "\(Marker[3,..])\n" ];
% output[ " \(Marker[4,2..])\n" ];
% output[ "   \(Marker[5,3..])\n" ];