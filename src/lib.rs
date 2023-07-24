extern crate ocl;
use std::{fs, collections::HashMap};
use std::ffi::CStr;
use std::io::BufReader;

use std::{ptr, slice};

use std::os::raw::c_char;

use ocl::{ProQue, OclPrm};

use std::collections;

#[derive(Debug)]
#[allow(dead_code)]
enum CLTypes {
    Char, Char2, Char3, Char4, Char8, Char16,
    Uchar, Uchar2, Uchar3, Uchar4, Uchar8, Uchar16,
    Short, Short2, Short3, Short4, Short8, Short16,
    Ushort, Ushort2, Ushort3, Ushort4, Ushort8, Ushort16,
    Int, Int2, Int3, Int4, Int8, Int16,
    Uint, Uint2, Uint3, Uint4, Uint8, Uint16,
    Long, Long2, Long3, Long4, Long8, Long16,
    Ulong, Ulong2, Ulong3, Ulong4, Ulong8, Ulong16,
    Float, Float2, Float3, Float4, Float8, Float16,
    Double, Double2, Double3, Double4, Double8, Double16
}

#[derive(Debug)]
#[allow(dead_code)]
enum QueryTypes {
  Equality = 0,
  Value = 1,
  Parameter = 2,
  Range = 3,
}

#[allow(dead_code)]
#[derive(Debug)]
struct Vec2 {
    x: f32,
    y: f32
}

#[allow(dead_code)]
#[derive(Debug)]
struct PhysicalAgentExtension {
    vel: Vec2,
    pos: Vec2
}

#[allow(dead_code)]
#[derive(Debug)]
enum SimExtension {
    Generic,
    Physics
}

#[allow(dead_code)]
enum OpenCLOperations {
  ApplyForce = 0,
  UpdateParameter = 1
}

#[no_mangle]
fn trivial(src: *const c_char, parameters: &u32, amount_of_parameters: u32) {
    unsafe {
        let src = CStr::from_ptr(src).to_str().unwrap().to_owned();

        let pro_que = ProQue::builder()
            .src(src)
            .dims(6)
            .build().unwrap();

        let x: Vec<u32> = slice::from_raw_parts(parameters, amount_of_parameters as usize).to_vec();

        let buffer = pro_que.buffer_builder().copy_host_slice(&x).build().expect("error building first buffer");
        let second_buffer = pro_que.buffer_builder().copy_host_slice(&x).build().expect("error building second buffer");

        // let context = ocl::builders::ContextBuilder::new().build().unwrap();

        // let pro_que = ocl::builders::BufferBuilder::new().context(&context);
        // pro_que.copy_host_slice(&vec![1, 2, 3, 4]).build().unwrap();

        // let buffer = pro_que.create_buffer::<u32>
        // let second_buffer = pro_que.create_buffer::<u32>().unwrap();

        let kernel = pro_que.kernel_builder("cain")
            .arg(&buffer)
            .arg(&second_buffer)
            .build().expect("error creating kernel");

        kernel.enq();

        let mut vec = vec![1u32; buffer.len()];
        buffer.read(&mut vec).enq();

        // println!("The value at index [{}] is now '{}'!", 0, vec[0]);
        println!("{:?}", vec)
    }
}
