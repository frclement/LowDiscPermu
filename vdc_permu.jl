using DelimitedFiles
using JuMP
using Gurobi
Lstar = Model()
set_optimizer(Lstar,Gurobi.Optimizer)
set_optimizer_attribute(Lstar, "NonConvex", 2)

#Change log path here
#log_file_path = " "

# Change file path here
solution_file_path = " "
solution_save_interval_secs = 150
function save_solution_to_file(x, y, a, z, file_path)
output_file = open(file_path, "w")
write(output_file, "x = ")
show(output_file, JuMP.value.(x))
write(output_file, "\n")
write(output_file, "y = ")
show(output_file, JuMP.value.(y))
write(output_file, "\n")
write(output_file, "a = ")
show(output_file, JuMP.value.(a))
write(output_file, "\n")
write(output_file, "z = ")
show(output_file, JuMP.value.(z))
write(output_file, "\n")
close(output_file)
end
#set_optimizer_attribute(Lstar, "LogFile", log_file_path)

#Change the number of points here
m =279
epsi=0.00001

# You can pass a desired permutation by changing the adress here. The permutation should be given as a sequence of integers.
#c=readdlm(" ")

#Default setup takes the Fibonacci set shifted by 1
phi=(1+sqrt(5))/2
grid=zeros((m))
for i=1:m 
grid[i]=mod(phi*i,1)
end
grid=sortperm(grid)
a = zeros((m+1,m+1))


# Change the commented/uncommented lines here depending on the input permutation
for i=1:m
a[i,grid[i]]=1
#a[i,Int(c[i])] = 1
end


a[1,m+1]=1
a[m+1,1]=1



@variable(Lstar, 0.00001<=x[1:m+1]<=1)
@variable(Lstar, 0.00001<=y[1:m+1]<=1)
#a=readdlm("Per100_10000_Perm.txt")
@variable(Lstar, z>=0)
@constraint(Lstar, [i in 1:m, j in 1:m], 1/m* sum(a[u,v] for u in 1:i, v in 1:j) - x[i]*y[j] <= z + (2- sum(a[u,j] for u in 1:i)-sum(a[i,v] for v in 1:j)))
@constraint(Lstar, [i in 1:m+1, j in 1:m+1], -1/m* sum(a[u,v] for u in 1:i-1, v in 1:j-1) + x[i]*y[j] <= z + (2- sum(a[u,j] for u in 1:i-1)-sum(a[i,v] for v in 1:j-1)))
@constraint(Lstar, [i in 1:m-1], x[i+1] - x[i] >= epsi)
@constraint(Lstar, [i in 1:m-1], y[i+1] - y[i] >= epsi)
@constraint(Lstar, x[m+1] == 1)
@constraint(Lstar, y[m+1] == 1)
@constraint(Lstar, z>= 1/m)
@constraint(Lstar, [i in 1:m-1, j in i+1:m,k in 1:m], x[j]-x[i] >= 1/m - (1-sum(a[i,u]-a[j,u] for u in 1:k)))
@constraint(Lstar, [i in 1:m-1, j in i+1:m,k in 1:m], y[j]-y[i] >= 1/m - (1-sum(a[u,i]-a[u,j] for u in 1:k)))
@constraint(Lstar, [i in 1:m], x[i] <= z + (i-1)/m)
@constraint(Lstar, [i in 1:m], x[i] >= i/m -z)
@constraint(Lstar, [i in 1:m], y[i] <= z + (i-1)/m)
@constraint(Lstar, [i in 1:m], y[i] >= i/m -z)
@objective(Lstar, Min, z)
JuMP.set_optimizer_attribute(Lstar, "TimeLimit", solution_save_interval_secs)
JuMP.optimize!(Lstar)
term_status = JuMP.termination_status(Lstar)
if term_status == MOI.OPTIMAL
println("Optimal solution found!")
save_solution_to_file(x, y, a,z, solution_file_path)
elseif term_status == MOI.TIME_LIMIT
println("TIME_LIMIT happened, saving current solution...")
save_solution_to_file(x, y, a,z, solution_file_path)
else
println("Solver finished with status: ", term_status)
end