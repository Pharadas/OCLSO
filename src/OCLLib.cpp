/* #include "CL/cl.h" */
#include <iostream>
#include <ostream>
#include <string>
#include <vector>

/* #ifdef __APPLE__ */
/*   #include <OpenCL/cl.hpp> */
/* #else */
/*   #include <CL/cl.hpp> */
/* #endif */

extern "C" {

int gaming(const char* src_code, char *x, unsigned long amount_of_agents, char *agents_starting_values) {
  for (int i = 0; i < amount_of_agents; i++) {
    std::cout << x[i] << " " << std::endl;
  }

  std::cout << "src code:" << std::endl;
  std::cout << src_code << std::endl;

  std::string src_code_string = std::string(src_code);

  /* // opencl boilerplate */
  /* std::vector<cl::Platform> all_platforms; */
  /* cl::Platform::get(&all_platforms); */

  /* if (all_platforms.size() == 0) { */
  /*   std::cout<<" No platforms found. Check OpenCL installation!\n"; */
  /*   exit(1); */
  /* } */

  /* cl::Platform default_platform=all_platforms[0]; */
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

  /* cl::Context context({default_device}); */

  /* cl::Program::Sources sources; */

  /* sources.push_back({src_code_string.c_str(), src_code_string.length()}); */

  /* cl::Program program(context, sources); */
  /* if (program.build({default_device}) != CL_SUCCESS) { */
  /*   std::cout << "Error building: " << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(default_device) << std::endl; */
  /*   exit(1); */
  /* } */
  return 1;
}

int main() {
  // // create the program that we want to execute on the device
  // cl::Program::Sources sources;

  // // calculates for each element; C = A + B
  // std::string kernel_code=
  //   "   void kernel simple_add(global const int* A, global const int* B, global int* C) {"
  //   "       int i = get_global_id(0);"
  //   "       C[i] = A[i] + B[i];"
  //   "   }";

  // sources.push_back({kernel_code.c_str(), kernel_code.length()});

  // cl::Program program(context, sources);
  // if (program.build({default_device}) != CL_SUCCESS) {
  //   std::cout << "Error building: " << program.getBuildInfo<CL_PROGRAM_BUILD_LOG>(default_device) << std::endl;
  //   exit(1);
  // }

  // // apparently OpenCL only likes arrays ...
  // // N holds the number of elements in the vectors we want to add
  // int N[1] = {100};
  // int n = N[0];

  // // create buffers on device (allocate space on GPU)
  // cl::Buffer buffer_A(context, CL_MEM_READ_WRITE, sizeof(int) * n);
  // cl::Buffer buffer_B(context, CL_MEM_READ_WRITE, sizeof(int) * n);
  // cl::Buffer buffer_C(context, CL_MEM_READ_WRITE, sizeof(int) * n);
  // cl::Buffer buffer_N(context, CL_MEM_READ_ONLY,  sizeof(int));

  // // create things on here (CPU)
  // int A[n], B[n];
  // for (int i=0; i<n; i++) {
  //   A[i] = 1;
  //   B[i] = 2;
  // }

  // // create a queue (a queue of commands that the GPU will execute)
  // cl::CommandQueue queue(context, default_device);

  // // push write commands to queue
  // queue.enqueueWriteBuffer(buffer_A, CL_TRUE, 0, sizeof(int)*n, A);
  // queue.enqueueWriteBuffer(buffer_B, CL_TRUE, 0, sizeof(int)*n, B);
  // // queue.enqueueWriteBuffer(buffer_N, CL_TRUE, 0, sizeof(int),   N);

  // // RUN ZE KERNEL
  // cl::Kernel simple_add(program, "simple_add");
  // simple_add.setArg(0, buffer_A);
  // simple_add.setArg(1, buffer_B);
  // simple_add.setArg(2, buffer_C);
  // queue.enqueueNDRangeKernel(simple_add,cl::NullRange,cl::NDRange(100),cl::NullRange);
  // queue.finish();

  // int C[n];
  // // read result from GPU to here
  // queue.enqueueReadBuffer(buffer_C, CL_TRUE, 0, sizeof(int)*n, C);

  // std::cout << "result: {";
  // for (int i=0; i<n; i++) {
  //   std::cout << C[i] << " ";
  // }
  // std::cout << "}" << std::endl;

  // return 0;
}
}
