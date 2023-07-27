module AgentsGPU

using StaticArrays

abstract type OpenCLOperation end

abstract type SimulationType end

struct GenericSimulation <: SimulationType
end

struct PhysicalSimulation <: SimulationType
  dimensions::UInt
  should_use_spatial_hashing::Bool
end

@enum OpenCLOperations begin
  ApplyForce
  UpdateParameter
  ExecuteQuery
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

const julia_opencl_type_map = Dict(
  :Int8 => "char",
  :Float64 => "double",
  :Float32 => "float",
  :Int32 => "int",
  :Int64 => "long",
  :Int16 => "short",
  :UInt8 => "uchar",
  :UInt32 => "uint",
  :UInt64 => "ulong",
  :UInt16 => "ushort"
)

mutable struct Simulation
  sim_details::SimulationType
  sim_agent_extension::SimExtension
  number_of_agents::UInt64
  agent_parameters::Dict
  number_of_iterations::Int
  initial_values::Tuple
  opencl_code::String
end

mutable struct Query
  definition::Vector{Pair{QueryTypes, String}}
  opencl_function_string::String
end

mutable struct Operation
  operation::OpenCLOperation
  query::Query
  values
end

mutable struct Iteration
  operations::Vector{OpenCLOperation}
end

mutable struct UpdateParameterOperation <: OpenCLOperation
  query::Query
  parameter::Symbol
  value
  opencl_code::String
end

function create_simulation_iteration()
  return Iteration([])
end

# prepare an iteration for the GPU
function execute_iteration(iteration::Iteration, sim_object::Simulation)
  static_parameters = []

  N::Int = sim_object.number_of_agents

  objeto_array = SVector{N}(sim_object.initial_values[1])

  # # no metemos los pointers directamente al array
  # # para evitar problemas por el garbage collector 
  # for parameter in sim_object.agent_parameters
  #   # display(parameter)
  #   push!(static_parameters, SVector{N}(julia_opencl_type_map[parameter[2]]))
  # end

  # static_parameters_p_arr = []

  # for static_param_vector in static_parameters
  #   push!(static_parameters_p_arr, Ptr{i8}(pointer_from_objref(Ref(static_param_vector))))
  # end

  # static_parameters_pointers = SVector{N}(static_parameters_p_arr)

  for i in iteration.operations
    process_operation(i)
  end

  # create kernel function 
  src = "
__kernel void cain(~) {
  ^
}
  "

  input_buffers_opencl_string = ""

  for (name, type) in sim_object.agent_parameters
    input_buffers_opencl_string *= "__global " * julia_opencl_type_map[type] * "* " * string(name) * ", "
  end

  # Change the parameters passed to the function
  match_index = match(r"\~", src).offset
  src = src[1:match_index - 1] * input_buffers_opencl_string[1:end-2] * src[match_index + 1:end]

  # Change the function body
  match_index = match(r"\^", src).offset
  src = src[1:match_index - 1] * iteration.operations[1].opencl_code * src[match_index + 1:end]

  # finally, Finally, FINALLY call the rust library
  display("sendin to rust")
  # ccall((:trivial, "target/release/libmain"), Nothing, (Cstring, Ptr{Int8}, UInt32), Base.unsafe_convert(Cstring, src), pointer_from_objref(Ref(objeto_array)), convert(UInt32, sim_object.number_of_agents * sizeof(sim_object.initial_values[1][1])))
end

function process_operation(operation::UpdateParameterOperation)
  if (length(operation.query.opencl_function_string) == 0)
    process_query(operation.query)
  end

  match_index = match(r"\^", operation.query.opencl_function_string).offset
  query_string = operation.query.opencl_function_string
  operation_string = query_string[1:match_index - 1] * string(operation.parameter) * "[get_global_id(0)] = " * string(operation.value) * query_string[match_index + 1:length(query_string)]
  operation.opencl_code = operation_string
end

function process_query(query::Query)
  query.opencl_function_string = "if ("

  for part in query.definition
    if part[1] == Parameter::QueryTypes
      query.opencl_function_string *= part[2] * "[get_global_id(0)] "
    else
      query.opencl_function_string *= part[2] * " "
    end
  end

  query.opencl_function_string *= ") {^;}"
end

function create_simulation_object(user_agent_values::Tuple, sim_type::SimulationType, number_of_agents::Int, number_of_iterations::Int)
  base_definitions = read(open("./src/core/opencl_definitions/macro_definitions.cl", "r"), String)
  name_type_map = Dict()

  for (parameter, type) in user_agent_values
    name_type_map[parameter] = type
  end

  simulation_struct = Simulation(sim_type, Generic, number_of_agents, name_type_map, number_of_iterations, (), base_definitions)

  if typeof(sim_type) == PhysicalSimulation
    simulation_struct.sim_agent_extension = Physics
  end

  return simulation_struct
end

function update_parameter(simulation_iteration::Iteration, query::Query, parameter::Symbol, value)
  new_operation = UpdateParameterOperation(query, parameter, value, "")
  push!(simulation_iteration.operations, new_operation)
  return simulation_iteration
end

function apply_force()

end

function execute_queries(simulation_iteration::Iteration, queries::Query...)
  push!(simulation_iteration.operations, Pair(ExecuteQuery, [queries]))

  return simulation_iteration
end

function is_within_range_of(query::Query)
  push!(query.definition, Pair(Range::QueryTypes, "range")) # placeholder string
  return query
end

function equals(query::Query, parameter::Symbol)
  push!(query.definition, Pair(Equality::QueryTypes, "=="))
  push!(query.definition, Pair(Parameter::QueryTypes, string(parameter)))
  return query
end

function equals(query::Query, value)
  push!(query.definition, Pair(Equality::QueryTypes, "=="))
  push!(query.definition, Pair(Value::QueryTypes, string(value)))
  return query
end

function equals(query::Query)
  push!(query.definition, Pair(Equality::QueryTypes, "=="))
  return query
end

function parameter(query::Query, parameter::Symbol)
  push!(query.definition, Pair(Parameter::QueryTypes, string(parameter)))
  return query
end

function query_maker()
  return Query([], "")
end

export create_simulation_object
export CLTypes
export PhysicalSimulation

export equals, parameter, query_maker

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
export Equality
export Value
export Parameter
export Range

export execute_iteration
export execute_queries
export update_parameter

export process_query

export create_simulation_iteration

export Vec2

end # module AgentsGPU
