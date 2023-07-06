// no conocemos como se ve AGENT sino hasta runtime,
// asi que esto va a dar warning :/

__kernel void add(__global float* buffer, float scalar) {
    buffer[get_global_id(0)] += scalar;
}

// __kernel void apply_force(
//   __global struct AGENT *agents,
//   const struct Vec2 force
// ) {
//     int g = get_global_id(0);
//     agents[g].physical_extension.vel.x += force.x;
//     agents[g].physical_extension.vel.y += force.y;
// }

// __kernel void update_agents_physical_extension(
//     __global struct AGENT *agents
// ) {
//     int g = get_global_id(0);
//     agents[g].physical_extension.pos.x += agents[g].physical_extension.vel.x;
//     agents[g].physical_extension.pos.y += agents[g].physical_extension.vel.y;
// }
