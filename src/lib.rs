extern crate ocl;
use std::fs;
use std::slice;
use std::ffi::CStr;

use std::os::raw::c_char;

use ocl::{ProQue, OclPrm};

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
  Parameter,
  Equality,
  Value,
  Range,
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
#[no_mangle]
fn get_query(query: *const c_char) {
    unsafe {println!("we are {:?} up in this bitch (this bitch is rust)", CStr::from_ptr(query).to_str()) };

    // match ocl_type {
    //     _ => {}
    // }
}

#[no_mangle]
fn trivial(f: i32) -> i32 {
    let src: String = fs::read_to_string("/home/pharadas/Repos/GPU-accelerated-agents-simulations/AgentsGPU/src/core/opencl_definitions/function_definitions.cl").unwrap();

    let pro_que = ProQue::builder()
        .src(src)
        .dims(1 << 20)
        .build().unwrap();

    let buffer = pro_que.create_buffer::<f32>().unwrap();

    let kernel = pro_que.kernel_builder("add")
        .arg(&buffer)
        .arg(10.0f32)
        .build().unwrap();

    unsafe { kernel.enq(); }

    let mut vec = vec![0.0f32; buffer.len()];
    buffer.read(&mut vec).enq();

    println!("The value at index [{}] is now '{}'!", 2, vec[2]);
    1
}
