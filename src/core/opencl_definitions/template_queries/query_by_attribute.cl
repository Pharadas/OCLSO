__kernel void query_by_attribute(
  __global int* semaphore,
  __global int* counter,
  __global ~* parameter_buffer,
  __global ~* query_buffer,
  ~ comparison_value
) {
  if (^) {
    while (atomic_cmpxchg(semaphore, UNLOCKED, LOCKED) != UNLOCKED) {

      query_buffer[counter] = get_global_id(0)
      *counter += 1;
      *semaphore = UNLOCKED;

    }
  }
}
