include "globals.mzn";

% Decision variables
array [1..9] of var 1..9: n;

% Constraints
% all must be unique
constraint alldifferent([n[i] | i in 1..9]);

% rows
constraint sum(n[1..3]) = sum(n[4..6]);
constraint sum(n[4..6]) = sum(n[7..9]);

% columns
constraint n[1]+n[4]+n[7] = n[2]+n[5]+n[8];
constraint n[2]+n[5]+n[8] = n[3]+n[6]+n[9];

% search space reduction
constraint n[1] = 9;
constraint n[3] = 1;

% first row descending in value
constraint n[1] > n[2];
constraint n[2] > n[3];

% first column descending in value
constraint n[1] > n[4];
constraint n[4] > n[7];

% solve!
solve satisfy;

% output
output[ "\(n[1..3])\n" ];
output[ "\(n[4..6])\n" ];
output[ "\(n[7..9])\n" ];