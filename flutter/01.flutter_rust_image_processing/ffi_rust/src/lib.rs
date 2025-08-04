use std::ffi::{c_char, c_uchar, c_void, CStr};
use std::slice;
use std::io::Cursor;
use std::fs;
use image::{ImageFormat, load_from_memory, DynamicImage, RgbaImage};

/// Изменяет размер изображения до 128x128 пикселей
/// 
/// # Arguments
/// 
/// * `input_path` - Путь к входному файлу изображения
/// * `output_path` - Путь для сохранения измененного изображения
/// 
/// # Returns
/// 
/// 0 в случае успеха, -1 в случае ошибки
/// 
/// # Safety
/// 
/// Функция небезопасна, так как работает с C строками.
/// Вызывающий код должен обеспечить корректность путей.
#[no_mangle]
pub extern "C" fn resize_image_file(
    input_path: *const c_char,
    output_path: *const c_char,
) -> i32 {
    let input_path = match unsafe { CStr::from_ptr(input_path).to_str() } {
        Ok(path) => path,
        Err(_) => return -1,
    };
    
    let output_path = match unsafe { CStr::from_ptr(output_path).to_str() } {
        Ok(path) => path,
        Err(_) => return -1,
    };

    let input_data = match fs::read(input_path) {
        Ok(data) => data,
        Err(_) => return -1,
    };

    let img = match load_from_memory(&input_data) {
        Ok(img) => img,
        Err(_) => return -1,
    };

    let resized = img.resize(128, 128, image::imageops::FilterType::Triangle);

    let mut buf = Vec::new();
    let mut cursor = Cursor::new(&mut buf);
    if resized.write_to(&mut cursor, ImageFormat::Png).is_err() {
        return -1;
    }

    if fs::write(output_path, buf).is_err() {
        return -1;
    }

    0
}

/// Поворачивает изображение на 90 градусов по часовой стрелке
/// 
/// # Arguments
/// 
/// * `input_path` - Путь к входному файлу изображения
/// * `output_path` - Путь для сохранения повернутого изображения
/// 
/// # Returns
/// 
/// 0 в случае успеха, -1 в случае ошибки
/// 
/// # Safety
/// 
/// Функция небезопасна, так как работает с C строками.
/// Вызывающий код должен обеспечить корректность путей.
#[no_mangle]
pub extern "C" fn rotate_image_90_file(
    input_path: *const c_char,
    output_path: *const c_char,
) -> i32 {
    let input_path = match unsafe { CStr::from_ptr(input_path).to_str() } {
        Ok(path) => path,
        Err(_) => return -1,
    };
    
    let output_path = match unsafe { CStr::from_ptr(output_path).to_str() } {
        Ok(path) => path,
        Err(_) => return -1,
    };

    let input_data = match fs::read(input_path) {
        Ok(data) => data,
        Err(_) => return -1,
    };

    let img = match load_from_memory(&input_data) {
        Ok(img) => img,
        Err(_) => return -1,
    };

    let rotated = img.rotate90();

    let mut buf = Vec::new();
    let mut cursor = Cursor::new(&mut buf);
    if rotated.write_to(&mut cursor, ImageFormat::Png).is_err() {
        return -1;
    }

    if fs::write(output_path, buf).is_err() {
        return -1;
    }

    0
}

/// Преобразует RGBA данные в JPEG изображение
/// 
/// # Arguments
/// 
/// * `rgba_ptr` - Указатель на RGBA данные (4 байта на пиксель)
/// * `width` - Ширина изображения в пикселях
/// * `height` - Высота изображения в пикселях
/// * `quality` - Качество JPEG (1-100)
/// * `output_len` - Указатель для сохранения размера выходных данных
/// 
/// # Returns
/// 
/// Указатель на JPEG данные или NULL в случае ошибки
/// 
/// # Safety
/// 
/// Функция небезопасна, так как работает с сырыми указателями.
/// Вызывающий код должен обеспечить корректность входных данных.
#[no_mangle]
pub extern "C" fn rgba_to_jpeg(
    rgba_ptr: *const c_uchar,
    width: u32,
    height: u32,
    quality: u8,
    output_len: *mut usize,
) -> *mut c_uchar {
    let rgba_data = unsafe { slice::from_raw_parts(rgba_ptr, (width * height * 4) as usize) };

    // Создаем RGBA изображение из сырых данных
    let img = match RgbaImage::from_raw(width, height, rgba_data.to_vec()) {
        Some(img) => DynamicImage::ImageRgba8(img),
        None => return std::ptr::null_mut(),
    };

    let mut buf = Vec::new();
    let mut cursor = Cursor::new(&mut buf);
    
    // Используем JPEG формат с указанным качеством
    let jpeg_encoder = image::codecs::jpeg::JpegEncoder::new_with_quality(&mut cursor, quality);
    if img.write_with_encoder(jpeg_encoder).is_err() {
        return std::ptr::null_mut();
    }

    unsafe { *output_len = buf.len(); }

    let ptr = buf.as_mut_ptr();
    std::mem::forget(buf);
    ptr
}

/// Освобождает память, выделенную для изображения
/// 
/// # Arguments
/// 
/// * `ptr` - Указатель на данные изображения
/// * `len` - Размер данных в байтах
/// 
/// # Safety
/// 
/// Функция небезопасна, так как работает с сырыми указателями.
/// Указатель должен быть получен из функций `resize_image`, `rotate_image_90` или `rgba_to_jpeg`.
#[no_mangle]
pub extern "C" fn free_image(ptr: *mut c_void, len: usize) {
    unsafe {
        let _ = Vec::from_raw_parts(ptr as *mut u8, len, len);
    }
}
