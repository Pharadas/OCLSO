module AgentsGPU

struct Vec2
  x::Float32
  y::Float32
end

abstract type SimulationType end

struct GenericSimulation <: SimulationType
end

struct PhysicalSimulation <: SimulationType
  dimensions::UInt
  should_use_spatial_hashing::Bool
end

@enum QueryTypes begin
  Equality
  Value
  Parameter
  Range
end

@enum SimExtension begin
  Generic
  Physics
end

@enum CLTypes begin
	char
	char2
	char3
	char4
	char8
	char16

	uchar
	uchar2
	uchar3
	uchar4
	uchar8
	uchar16

	short
	short2
	short3
	short4
	short8
	short16

	ushort
	ushort2
	ushort3
	ushort4
	ushort8
	ushort16

	int
	int2
	int3
	int4
	int8
	int16

	uint
	uint2
	uint3
	uint4
	uint8
	uint16

	long
	long2
	long3
	long4
	long8
	long16

	ulong
	ulong2
	ulong3
	ulong4
	ulong8
	ulong16

	float
	float2
	float3
	float4
	float8
	float16

	double
	double2
	double3
	double4
	double8
	double16
end

mutable struct Simulation
  sim_details::SimulationType
  sim_agent_extension::SimExtension
  number_of_agents::UInt
  agent_parameters::Tuple
  number_of_iterations::Int
  initial_values::Tuple
end

function generate_agents()
  return 
end

function create_simulation_object(user_agent_values::Tuple, sim_type::SimulationType, number_of_agents::Int, number_of_iterations::Int)
  simulation_struct = Simulation(sim_type, Generic, number_of_agents, user_agent_values, number_of_iterations, ())

  if typeof(sim_type) == PhysicalSimulation
    simulation_struct.sim_agent_extension = Physics
  end

  return simulation_struct
end

function simulation_iteration()

end

function is_within_range_of(query::Vector{Pair{QueryTypes, String}})
  push!(query, Pair(Range::QueryTypes, "range")) # placeholder string
end

function equals(query::Vector{Pair{QueryTypes, String}}, parameter::Symbol)
  push!(query, Pair(Equality::QueryTypes, "=="))
  push!(query, Pair(:Parameterr, string(parameter)))
end

function equals(query::Vector{Pair{QueryTypes, String}}, value)
  push!(query, Pair(Equality::QueryTypes, "=="))
  push!(query, Pair(Value::QueryTypes, string(value)))
end

function equals(query::Vector{Pair{QueryTypes, String}})
  push!(query, Pair(Equality::QueryTypes, "=="))
end

function parameter(query::Vector{Pair{QueryTypes, String}}, parameter::Symbol)
  push!(query, Pair(Parameter::QueryTypes, string(parameter)))
end

function query_maker()
  return Vector{Pair{QueryTypes, String}}()
end

export create_simulation_object
export CLTypes
export PhysicalSimulation

export equals, parameter, query_maker

export simulation_iteration

export char
export char2
export char3
export char4
export char8
export char16
export uchar
export uchar2
export uchar3
export uchar4
export uchar8
export uchar16
export short
export short2
export short3
export short4
export short8
export short16
export ushort
export ushort2
export ushort3
export ushort4
export ushort8
export ushort16
export int
export int2
export int3
export int4
export int8
export int16
export uint
export uint2
export uint3
export uint4
export uint8
export uint16
export long
export long2
export long3
export long4
export long8
export long16
export ulong
export ulong2
export ulong3
export ulong4
export ulong8
export ulong16
export float
export float2
export float3
export float4
export float8
export float16
export double
export double2
export double3
export double4
export double8
export double16

export QueryTypes

export Vec2

end # module AgentsGPU
