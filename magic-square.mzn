include "globals.mzn";

% Decision variables
array [1..9] of var 1..9: sq;

% Constraints
% all must be unique
constraint alldifferent(sq);

% rows
constraint sum(sq[1..3]) = sum(sq[4..6]);
constraint sum(sq[4..6]) = sum(sq[7..9]);

% columns
constraint sq[1]+sq[4]+sq[7] = sq[2]+sq[5]+sq[8];
constraint sq[2]+sq[5]+sq[8] = sq[3]+sq[6]+sq[9];

% diagonals
constraint sq[1]+sq[5]+sq[9] = sq[3] + sq[5] + sq[7];

% search space reduction
constraint sq[1] = 2;
constraint sq[3] = 4;

% solve!
solve satisfy;

% output
output[ "\(sq[1..3])\n" ];
output[ "\(sq[4..6])\n" ];
output[ "\(sq[7..9])\n" ];