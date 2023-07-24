#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable

#define LOCKED 0
#define UNLOCKED 1

void semaphore_modify(__global int* semaphore, __global int* counter, __global ~* place, ~ value) {
  while (atomic_cmpxchg(semaphore, UNLOCKED, LOCKED) != UNLOCKED) {
    *place = value;
    *counter += 1;
    *semaphore = UNLOCKED;
  }
}

// el buffer que vamos a recibir ya va a ser el resultado de un query
// asi que va a tener indices de la lista global de agentes
__kernel void modify_parameter(__global ~* agents_buffer, __global ~* query_buffer, __global int* semaphore, __global int* counter, ~ value) {
  semaphore_modify(&semaphore, counter)
  agents_buffer[query_buffer[get_global_id(0)]] = value;
}
