use std::ffi::c_char;
use std::os::raw::c_int;

#[cfg(target_os = "macos")]
use pyo3::prelude::*;

#[cfg(target_os = "macos")]
use std::ffi::CStr;

#[cfg(target_os = "macos")]
use std::sync::Once;

#[cfg(target_os = "macos")]
static INIT: Once = Once::new();

/// Выполняет Python код и возвращает результат в виде строки
///
/// # Arguments
/// * `python_code` - строка с Python кодом для выполнения
///
/// # Returns
/// * Указатель на строку с результатом (нужно освободить через free_python_result)
/// * `null` - в случае ошибки
#[no_mangle]
pub extern "C" fn execute_python_code_with_output(python_code: *const c_char) -> *mut c_char {
    #[cfg(target_os = "macos")]
    {
        // Инициализируем Python интерпретатор один раз
        INIT.call_once(|| {
            pyo3::prepare_freethreaded_python();
        });

        // Безопасно конвертируем C строку в Rust строку
        let code_str = match unsafe { CStr::from_ptr(python_code).to_str() } {
            Ok(s) => s,
            Err(_) => return std::ptr::null_mut(),
        };

        // Инициализируем Python интерпретатор
        Python::with_gil(|py| {
            // Импортируем io и sys модули
            let io = py.import("io").unwrap();
            let sys = py.import("sys").unwrap();

            // Создаем отдельные StringIO для stdout и stderr
            let stdout_io = io.getattr("StringIO").unwrap().call0().unwrap();
            let stderr_io = io.getattr("StringIO").unwrap().call0().unwrap();

            // Сохраняем оригинальные stdout и stderr
            let original_stdout = sys.getattr("stdout").unwrap();
            let original_stderr = sys.getattr("stderr").unwrap();

            // Перенаправляем stdout и stderr в StringIO
            sys.setattr("stdout", &stdout_io).unwrap();
            sys.setattr("stderr", &stderr_io).unwrap();

            // Конвертируем Rust строку в C-строку для PyO3
            let c_string = match std::ffi::CString::new(code_str) {
                Ok(s) => s,
                Err(_) => return std::ptr::null_mut(),
            };

            // Выполняем Python код (используем exec для многострочного кода)
            let result = match py.run(c_string.as_c_str(), None, None) {
                Ok(_) => {
                    // Получаем захваченный вывод
                    let stdout_output = stdout_io.call_method0("getvalue").unwrap();
                    let stderr_output = stderr_io.call_method0("getvalue").unwrap();

                    let stdout_str = stdout_output.str().unwrap().to_string();
                    let stderr_str = stderr_output.str().unwrap().to_string();

                    // Объединяем stdout и stderr
                    let mut combined_output = String::new();
                    if !stdout_str.is_empty() {
                        combined_output.push_str(&stdout_str);
                    }
                    if !stderr_str.is_empty() {
                        if !combined_output.is_empty() {
                            combined_output.push_str("\n");
                        }
                        combined_output.push_str(&stderr_str);
                    }

                    if combined_output.is_empty() {
                        "Код выполнен успешно (нет вывода)".to_string()
                    } else {
                        combined_output
                    }
                }
                Err(e) => {
                    format!("Ошибка выполнения Python кода: {}", e)
                }
            };

            // Восстанавливаем оригинальные stdout и stderr
            sys.setattr("stdout", original_stdout).unwrap();
            sys.setattr("stderr", original_stderr).unwrap();

            // Выделяем память для результата и копируем строку
            let c_string = match std::ffi::CString::new(result) {
                Ok(s) => s,
                Err(_) => return std::ptr::null_mut(),
            };
            let ptr = c_string.into_raw();
            ptr
        })
    }

    #[cfg(not(target_os = "macos"))]
    {
        let _ = python_code; // Игнорируем неиспользуемый параметр
        let error_msg = "Python выполнение поддерживается только на macOS";
        let c_string = match std::ffi::CString::new(error_msg) {
            Ok(s) => s,
            Err(_) => return std::ptr::null_mut(),
        };
        c_string.into_raw()
    }
}

/// Освобождает память, выделенную для результата выполнения Python кода
///
/// # Arguments
/// * `ptr` - указатель на строку, которую нужно освободить
#[no_mangle]
pub extern "C" fn free_python_result(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe {
            let _ = std::ffi::CString::from_raw(ptr);
        }
    }
}

/// Выполняет Python код, переданный в виде строки (без возврата вывода)
///
/// # Arguments
/// * `python_code` - строка с Python кодом для выполнения
///
/// # Returns
/// * `0` - успешное выполнение
/// * `-1` - ошибка выполнения
#[no_mangle]
pub extern "C" fn execute_python_code(python_code: *const c_char) -> c_int {
    #[cfg(target_os = "macos")]
    {
        // Инициализируем Python интерпретатор один раз
        INIT.call_once(|| {
            pyo3::prepare_freethreaded_python();
        });

        // Безопасно конвертируем C строку в Rust строку
        let code_str = match unsafe { CStr::from_ptr(python_code).to_str() } {
            Ok(s) => s,
            Err(_) => return -1,
        };

        // Инициализируем Python интерпретатор
        Python::with_gil(|py| {
            // Конвертируем Rust строку в C-строку для PyO3
            let c_string = match std::ffi::CString::new(code_str) {
                Ok(s) => s,
                Err(_) => return -1,
            };

            // Выполняем Python код (используем exec для многострочного кода)
            match py.run(c_string.as_c_str(), None, None) {
                Ok(_) => 0,
                Err(e) => {
                    eprintln!("Ошибка выполнения Python кода: {}", e);
                    -1
                }
            }
        })
    }

    #[cfg(not(target_os = "macos"))]
    {
        // На других платформах возвращаем ошибку
        let _ = python_code; // Игнорируем неиспользуемый параметр
        eprintln!("Python выполнение поддерживается только на macOS");
        -1
    }
}
