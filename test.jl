include("./src/AgentsGPU.jl")
using .AgentsGPU

struct Person <: Agent
  age::UInt
end

sim_template = PhysicalSimulation(2, true)

simulation_object = create_simulation(sim_template, 10)
simulation_object = create_GPU_agent(Person, simulation_object)
display(simulation_object)

function c()
  return Person(rand(UInt))
end

dump(generate_agents_values(c, simulation_object))

# iteration_function = @iteration_function function iteration()
#   # :query_agents_by_id
#   # :run_for_all_agents
#   # :run_for_all_agents
# end

