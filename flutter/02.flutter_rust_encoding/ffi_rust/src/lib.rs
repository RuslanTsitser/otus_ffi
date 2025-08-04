use std::ffi::{c_char, CStr};
use std::fs;
use std::os::raw::c_int;

use base64::{engine::general_purpose::STANDARD, Engine};

#[no_mangle]
pub extern "C" fn encode_base64_file(
    input_path: *const c_char,
    output_path: *const c_char,
) -> c_int {
    unsafe {
        let input_cstr = CStr::from_ptr(input_path);
        let output_cstr = CStr::from_ptr(output_path);

        let input_path_str = match input_cstr.to_str() {
            Ok(s) => s,
            Err(_) => return -1,
        };

        let output_path_str = match output_cstr.to_str() {
            Ok(s) => s,
            Err(_) => return -1,
        };

        match fs::read(input_path_str) {
            Ok(data) => {
                let encoded = STANDARD.encode(&data);
                match fs::write(output_path_str, encoded) {
                    Ok(_) => 0,
                    Err(_) => -1,
                }
            }
            Err(_) => -1,
        }
    }
}

#[no_mangle]
pub extern "C" fn decode_base64_file(
    input_path: *const c_char,
    output_path: *const c_char,
) -> c_int {
    unsafe {
        let input_cstr = CStr::from_ptr(input_path);
        let output_cstr = CStr::from_ptr(output_path);

        let input_path_str = match input_cstr.to_str() {
            Ok(s) => s,
            Err(_) => return -1,
        };

        let output_path_str = match output_cstr.to_str() {
            Ok(s) => s,
            Err(_) => return -1,
        };

        match fs::read_to_string(input_path_str) {
            Ok(encoded_data) => match STANDARD.decode(encoded_data.trim()) {
                Ok(decoded) => match fs::write(output_path_str, decoded) {
                    Ok(_) => 0,
                    Err(_) => -1,
                },
                Err(_) => -1,
            },
            Err(_) => -1,
        }
    }
}

#[no_mangle]
pub extern "C" fn free_buffer(ptr: *mut u8) {
    if !ptr.is_null() {
        unsafe {
            let _ = Vec::from_raw_parts(ptr, 0, 0);
        }
    }
}
