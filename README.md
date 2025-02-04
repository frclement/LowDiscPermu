Low Discrepancy Permutations

This repository contains the base model to obtain point sets with low discrepancies by reusing models from "Constructing Optimal L_infty Discrepancy Sets" (https://arxiv.org/abs/2311.17463). Here, we fix the permutation to be able to obtain larger point sets as in https://arxiv.org/abs/2407.11533. 

The file vdc_permu contains the model, that should be run in Julia with the JuMP package and Gurobi optimizer. It contains the basic model with the default Fibonacci +1 shift permutation. There are comments outlining where elements need to be changed (output file, permutation choice, number of points for example).

read_output.py provides basic code to read the output point files and plot the heatmaps.

The other files are sample outputs for the Fibonacci+1 permutation.
