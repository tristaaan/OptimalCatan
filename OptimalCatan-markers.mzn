include "globals.mzn";

% Parameters
% Resources
%              1      2       3      4      5      6      7 
enum Resource={Water, Desert, Brick, Grain, Sheep, Stone, Wood};
set of int: Resources = 1..7;
set of int: Number = 1..12;

array[Number] of int: MarkerCounts = [6,1,2,2,2,2, 1, 2,2, 2, 2, 1];
% constraint assert(sum(MarkerCounts) = 25, "Wrong number of markers \(sum(MarkerCounts))");

% Board size
int: nRows = 5;
int: nCols = 5;
set of int: Rows = 1..nRows;
set of int: Cols = 1..nCols;

% Decision Variables
array[Rows, Cols] of var Number: Marker;

% Constraints

constraint forall(r in 1..nRows-1) (
  forall(c in 1..nCols-1) (
    alldifferent_except_0([Marker[r,c]-1, Marker[r, c+1]-1, 
                           Marker[r+1, c]-1, Marker[r+1,c+1]-1])
  )
);

% Constrain marker counts
constraint forall(n in Number)(
  sum(r in Rows)(count(Marker[r,..], n)) = MarkerCounts[n]
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
constraint Marker[3,3] = 7;

% Objective
solve satisfy;

% output[show2d(Board)];
output[ "   \(Marker[1,1..3])\n" ];
output[ " \(Marker[2,1..4])\n" ];
output[ "\(Marker[3,..])\n" ];
output[ " \(Marker[4,2..])\n" ];
output[ "   \(Marker[5,3..])\n" ];