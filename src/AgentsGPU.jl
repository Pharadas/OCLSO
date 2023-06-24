module AgentsGPU

struct Vec2
  x::Float32
  y::Float32
end

abstract type Agent end

abstract type SimulationType end

struct GenericSimulation <: SimulationType
end

struct PhysicalSimulation <: SimulationType
  dimensions::UInt
  should_use_spatial_hashing::Bool
end

abstract type AgentType end

struct PhysicalAgent <: AgentType
  vel::Vec2
  pos::Vec2
end

mutable struct GPUAgent
  id::UInt32
  agent_type_extension::AgentType
  user_agent_extension::Agent
end

julia_to_opencl_types = Dict{Symbol, String}(
  :Bool => "bool",

  :Int8 => "char",
  :UInt8 => "uchar",

  :Int16 => "short",
  :UInt16 => "ushort",

  :Int32 => "int",
  :Uint32 => "uint",

  :Int => "long",
  :Int64 => "long",
  :UInt64 => "ulong",
  :UInt => "ulong",

  :Int128 => "long long",
  :UInt128 => "unsigned long long",

  :Float16 => "half",
  :Float32 => "float",
  :Float64 => "double"
)

mutable struct Simulation
  simulation_type::SimulationType
  opencl_code::String
  opencl_agent_struct::String
  number_of_agents::UInt
  julia_agent_struct
end


function create_simulation(sim_type::SimulationType, number_of_agents::Int)
  simulation_struct = Simulation(sim_type, "", "", number_of_agents, undef)
  return simulation_struct
end

# TODO hacerla de multiple despacho
# preferiria hacerlo en una macro pero creo que termina siendo mas problema
function create_GPU_agent(agent_struct::DataType, simulation::Simulation)
  GPU_agent_struct = "typedef struct __attribute__ ((packed)) AGENT {\nuint id;"

  if typeof(simulation.simulation_type) == PhysicalSimulation
    GPU_agent_struct *= "struct Vec2 vel;"
    GPU_agent_struct *= "struct Vec2 pos;"
  end

  for parameter in fieldnames(agent_struct)
    curr_fieldtype = Symbol(fieldtype(agent_struct, parameter))

    if curr_fieldtype == :Char
      throw(error("Due to differences between OpenCL and Julia Char should be replaced with Int8"))
    end

    if !haskey(julia_to_opencl_types, curr_fieldtype)
      throw(error(string(curr_fieldtype) * " is not a valid OpenCL type"))
    end

    GPU_agent_struct *= julia_to_opencl_types[curr_fieldtype] * " " * string(parameter) * ";\n"
  end

  GPU_agent_struct *= "};"

  simulation.opencl_agent_struct = GPU_agent_struct
  simulation.julia_agent_struct = agent_struct
  return simulation
end

function generate_agents_values(agent_values_generator::Function, simulation::Simulation)
  agents_list::Vector{GPUAgent} = []
  resize!(agents_list, simulation.number_of_agents)

  for agent in 1:simulation.number_of_agents
    agents_list[agent] = GPUAgent(
      rand(UInt32),
      PhysicalAgent(Vec2(0., 0.), Vec2(0., 0.)),
      agent_values_generator()
    )
  end

  return agents_list
end

export create_simulation
export create_GPU_agent
export generate_agents_values
export PhysicalSimulation
export Agent

end # module AgentsGPU
