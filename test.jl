include("./src/AgentsGPU.jl")
using .AgentsGPU
using Chain

N_agents = 4
N_iterations = 10

sim_template = PhysicalSimulation(2, true)

agent_definition = ((:age, :Int32), (:state, :Int32))
simulation_object = create_simulation_object(agent_definition, sim_template, N_agents, N_iterations)

# agent_definition =  @reader struct agent
#   a::UInt8
#   b::UInt8
#   c::UInt8
#   d::UInt8
# end

# initialize our values
# age = rand(Int8, N_agents)
# state = rand(UInt8, N_agents)

age = [0, 0, 0, 0]
state = [0, 0, 0, 0]

for i in 1:N_agents
  print(age[i], " ", state[i], "\n")
end

simulation_object.initial_values = (age, state)

println(simulation_object)

age_query = @chain query_maker() begin
  parameter(:age)
  equals()
  parameter(:state)
end

simulation_iteration = @chain create_simulation_iteration() begin
  update_parameter(age_query, :age, 6)
end

println(simulation_iteration)

display(simulation_object.agent_parameters)

println(simulation_object.opencl_code)
returned_list = execute_iteration(simulation_iteration, simulation_object)

# for val in age_query
#   output = ccall((:filter_by_query, "target/release/libmain"), Nothing, (QueryTypes, Cstring,), val[1], Base.unsafe_convert(Cstring, val[2]))
# end

# iteration_object = @chain iteration_maker() begin
#   update_parameter(age_query, :age, 6)
# end

# display(iteration_object)
