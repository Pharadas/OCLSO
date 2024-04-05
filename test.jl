include("./src/AgentsGPU.jl")
using .AgentsGPU
# using Chain

N_agents = 3
N_iterations = 10

sim_template = PhysicalSimulation(2, true)

agent_definition = ((:age, :UInt8), (:state, :UInt32))
simulation_object = create_simulation_object(agent_definition, sim_template, N_agents, N_iterations)

# initialize our values
age = rand(Int8, N_agents)
state = rand(UInt32, N_agents)

display(age)

simulation_object.initial_values = (age, state)

age_query = @chain query_maker() begin
  parameter(:age)
  equals()
  parameter(:state)
end

simulation_iteration = @chain create_simulation_iteration() begin
  update_parameter(age_query, :age, 6)
end

display(simulation_object.agent_parameters)

execute_iteration(simulation_iteration, simulation_object)

for val in age_query
  output = ccall((:filter_by_query, "target/release/libmain"), Nothing, (QueryTypes, Cstring,), val[1], Base.unsafe_convert(Cstring, val[2]))
end

iteration_object = @chain iteration_maker() begin
  update_parameter(age_query, :age, 6)
end

display(iteration_object)
