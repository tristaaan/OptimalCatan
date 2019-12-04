# !/bin/bash

# the output from minizinc is not fit for minizinc consumption
# this is fixed on line 6.
SEED=$1
minizinc OptimalCatan-tiles.mzn -r $SEED > board.dzn \
  && head -n 6 board.dzn > in_board.dzn \
  && minizinc OptimalCatan-markers.mzn in_board.dzn > full_board.dzn \
  && head -n 4 full_board.dzn > complete.json \
  && python BoardViz.py
