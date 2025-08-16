use std::ffi::{c_char, CStr, CString};

#[no_mangle]
pub extern "C" fn sum(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub extern "C" fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

#[no_mangle]
pub extern "C" fn get_string_length(str: *const c_char) -> *const c_char {
    let s = unsafe { CStr::from_ptr(str) };
    let length = s.to_string_lossy().len() as i32;
    let result = CString::new(format!("Длина строки {} символов", length)).unwrap();
    result.into_raw()
}
