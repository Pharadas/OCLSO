/* #include "CL/cl.h" */
#include <cstdint>
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

#include <cstdlib>

/* #ifdef __APPLE__ */
/*   #include <OpenCL/cl.hpp> */
/* #else */
/*   #include <CL/cl.hpp> */
/* #endif */

extern "C" {

// UPDATE FUNCTION SIGNATURE ON CHANGE IN src/AgentsGPU.jl function 'execute_iteration'
uint8_t* gaming(uint8_t *x, unsigned int length) {
  /* // opencl boilerplate */
  /* std::vector<cl::Platform> all_platforms; */
  /* cl::Platform::get(&all_platforms); */

  /* if (all_platforms.size() == 0) { */
  /*   std::cout<<" No platforms found. Check OpenCL installation!\n"; */
  /*   exit(1); */
  /* } */

  /* for (int i = 0; i < all_platforms.size(); i++) { */
  /*   std::cout << all_platforms[i].getInfo<CL_PLATFORM_NAME>() << std::endl; */
  /* } */

  /* cl::Platform default_platform = all_platforms[1]; */
  /* std::cout << "Using platform: "<<default_platform.getInfo<CL_PLATFORM_NAME>()<<"\n"; */

  /* std::vector<cl::Device> all_devices; */
  /* default_platform.getDevices(CL_DEVICE_TYPE_ALL, &all_devices); */
  /* if(all_devices.size()==0){ */
  /*   std::cout<<" No devices found. Check OpenCL installation!\n"; */
  /*   exit(1); */
  /* } */

  /* for (int i = 0; i < all_devices.size(); i++) { */
  /*   std::cout << std::to_string(i) << " " << all_devices[i].getInfo<CL_DEVICE_NAME>() << "\n"; */
  /* } */

  /* cl::Device default_device=all_devices[0]; */
  /* std::cout<< "Using device: "<<default_device.getInfo<CL_DEVICE_NAME>()<<"\n"; */

  /* // create the program that we want to execute on the device */
  /* cl::Program::Sources sources; */

  /* // calculates for each element; C = A + B */
  /* std::string kernel_code= */
  /* "struct agente {" */
  /* "  char age;" */
  /* "  unsigned char state;" */
  /* "};" */
  /* "   void kernel simple_add(global struct agente *A, global struct agente *C) {" */
  /* "       int i = get_global_id(0);" */
  /* "       C[i].age = A[i].age;" */
  /* "       C[i].state = A[i].state;" */
  /* "   }"; */

  /* sources.push_back({kernel_code.c_str(), kernel_code.length()}); */

  /* cl::Context context({default_device}); */

  /* cl::Program program(context, sources); */
  /* if (program.build({default_device}) != CL_SUCCESS) { */
  /*   std::cout << "Error building: " << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(default_device) << std::endl; */
  /*   exit(1); */
  /* } */

  /* // create buffers on device (allocate space on GPU) */
  /* cl::Buffer buffer_A(context, CL_MEM_READ_WRITE, sizeof(int8_t) * length); */
  /* cl::Buffer buffer_C(context, CL_MEM_READ_WRITE, sizeof(int8_t) * length); */

  /* // create a queue (a queue of commands that the GPU will execute) */
  /* cl::CommandQueue queue(context, default_device); */

  /* // push write commands to queue */
  /* queue.enqueueWriteBuffer(buffer_A, CL_TRUE, 0, sizeof(int8_t)*length, x); */

  /* cl::Kernel simple_add(program, "simple_add"); */
  /* simple_add.setArg(0, buffer_A); */
  /* simple_add.setArg(1, buffer_C); */
  /* queue.enqueueNDRangeKernel(simple_add,cl::NullRange,cl::NDRange(100),cl::NullRange); */
  /* queue.finish(); */

  std::cout << "address " << static_cast<void*>(x) << std::endl;

  auto first_value = (uint8_t*)malloc(sizeof(uint8_t));
  /* memcpy(first_value, x, sizeof(uint8_t)); */

  std::cout << "gaming " << *first_value - '0' << std::endl;

  for (int i = 0; i < length; i += 2) {
    std::cout << "'" << x[i] - '0' << "' ";
    std::cout << "'" << (uint8_t)x[i + 1] - '0' << "'" << std::endl;
  }

  std::cout << "==========================" << std::endl;

  // recordar liberar la memoria en julia porque no lo vamos a hacer en C
  uint8_t* C = new uint8_t[length];
  // read result from GPU to here
  /* queue.enqueueReadBuffer(buffer_C, CL_TRUE, 0, sizeof(uint8_t)*length, C); */

  for (int i = 0; i < length; i++) {
    std::cout << "'" << C[i] - '0' << "'" << std::endl;
  }

  int f;

  std::cout << "waiting ";
  std::cin >> f;

  return C;
}
}

int main() {
  /* // opencl boilerplate */
  /* std::vector<cl::Platform> all_platforms; */
  /* cl::Platform::get(&all_platforms); */

  /* if (all_platforms.size() == 0) { */
  /*   std::cout<<" No platforms found. Check OpenCL installation!\n"; */
  /*   exit(1); */
  /* } */

  /* for (int i = 0; i < all_platforms.size(); i++) { */
  /*   std::cout << all_platforms[i].getInfo<CL_PLATFORM_NAME>() << std::endl; */
  /* } */

  /* cl::Platform default_platform = all_platforms[1]; */
  /* std::cout << "Using platform: "<<default_platform.getInfo<CL_PLATFORM_NAME>()<<"\n"; */

  /* std::vector<cl::Device> all_devices; */
  /* default_platform.getDevices(CL_DEVICE_TYPE_ALL, &all_devices); */
  /* if(all_devices.size()==0){ */
  /*   std::cout<<" No devices found. Check OpenCL installation!\n"; */
  /*   exit(1); */
  /* } */

  /* for (int i = 0; i < all_devices.size(); i++) { */
  /*   std::cout << std::to_string(i) << " " << all_devices[i].getInfo<CL_DEVICE_NAME>() << "\n"; */
  /* } */

  /* cl::Device default_device=all_devices[0]; */
  /* std::cout<< "Using device: "<<default_device.getInfo<CL_DEVICE_NAME>()<<"\n"; */


  /* // create the program that we want to execute on the device */
  /* cl::Program::Sources sources; */

  /* // calculates for each element; C = A + B */
  /* std::string kernel_code= */
  /* "   void kernel simple_add(global const int* A, global const int* B, global int* C) {" */
  /* "       int i = get_global_id(0);" */
  /* "       C[i] = A[i] + B[i];" */
  /* "   }"; */

  /* sources.push_back({kernel_code.c_str(), kernel_code.length()}); */

  /* cl::Context context({default_device}); */

  /* cl::Program program(context, sources); */
  /* if (program.build({default_device}) != CL_SUCCESS) { */
  /*   std::cout << "Error building: " << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(default_device) << std::endl; */
  /*   exit(1); */
  /* } */

  /* // apparently OpenCL only likes arrays ... */
  /* // N holds the number of elements in the vectors we want to add */
  /* int N[1] = {100}; */
  /* int n = N[0]; */

  /* // create buffers on device (allocate space on GPU) */
  /* cl::Buffer buffer_A(context, CL_MEM_READ_WRITE, sizeof(int) * n); */
  /* cl::Buffer buffer_B(context, CL_MEM_READ_WRITE, sizeof(int) * n); */
  /* cl::Buffer buffer_C(context, CL_MEM_READ_WRITE, sizeof(int) * n); */
  /* cl::Buffer buffer_N(context, CL_MEM_READ_ONLY,  sizeof(int)); */

  /* // create things on here (CPU) */
  /* int A[n], B[n]; */
  /* for (int i=0; i<n; i++) { */
  /*   A[i] = 1; */
  /*   B[i] = 2; */
  /* } */

  /* // create a queue (a queue of commands that the GPU will execute) */
  /* cl::CommandQueue queue(context, default_device); */

  /* // push write commands to queue */
  /* queue.enqueueWriteBuffer(buffer_A, CL_TRUE, 0, sizeof(int)*n, A); */
  /* queue.enqueueWriteBuffer(buffer_B, CL_TRUE, 0, sizeof(int)*n, B); */
  /* // queue.enqueueWriteBuffer(buffer_N, CL_TRUE, 0, sizeof(int),   N); */

  /* // RUN ZE KERNEL */
  /* cl::Kernel simple_add(program, "simple_add"); */
  /* simple_add.setArg(0, buffer_A); */
  /* simple_add.setArg(1, buffer_B); */
  /* simple_add.setArg(2, buffer_C); */
  /* queue.enqueueNDRangeKernel(simple_add,cl::NullRange,cl::NDRange(100),cl::NullRange); */
  /* queue.finish(); */

  /* int C[n]; */
  /* // read result from GPU to here */
  /* queue.enqueueReadBuffer(buffer_C, CL_TRUE, 0, sizeof(int)*n, C); */

  /* std::cout << "result: {"; */
  /* for (int i=0; i<n; i++) { */
  /*   std::cout << C[i] << " "; */
  /* } */
  /* std::cout << "}" << std::endl; */

  /* return 0; */
}
