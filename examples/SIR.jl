using AgentsGPU

# PhysicalAgent tiene los siguientes
# atributos:
# pos::vec{float32}
# vel::vec{float32}
# state::uint8
# id::uint32

# id::uint32 viene implicito por usar la macro
@agent person begin
  pos::vec{float32}
  vel::vec{float32}
  state::uint8
end

model = create_model()
model.with_spatial_grid()
model.borders("loop_around")
model.interaction_rules("funcion de gpu aqui")

@model_parameters parameters begin
  infection_probability::float32
  infection_radius::float32
end



