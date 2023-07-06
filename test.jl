include("./src/AgentsGPU.jl")
using .AgentsGPU
using Chain

sim_template = PhysicalSimulation(2, true)

agent_definition = ((:age, :UInt32), (:state, :UInt32))
simulation_object = create_simulation_object(agent_definition, sim_template, 100, 1)

# initialize our values
age = rand(UInt32, 1)
state = zeros(UInt32, 1)

simulation_object.initial_values = (age, state)

age_query = @chain query_maker() begin
  parameter(:age)
  equals(5)
end

x = age_query[1][2] * age_query[2][2] * age_query[3][2]

t = Base.unsafe_convert(Cstring, x)

output = ccall((:get_query, "target/release/libmain"), Nothing, (Cstring,), t)
