#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable

struct Vec2 {
  float x;
  float y;
};

struct PhysicalAgentExtension {
    struct Vec2 vel;
    struct Vec2 pos;
};

