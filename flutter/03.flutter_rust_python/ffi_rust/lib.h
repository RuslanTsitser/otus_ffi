#ifndef IMAGE_PROCESSING_FFI_H
#define IMAGE_PROCESSING_FFI_H

// Автоматически сгенерировано с помощью cbindgen. Не редактируйте вручную.

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * Выполняет Python код и возвращает результат в виде строки
 *
 * # Arguments
 * * `python_code` - строка с Python кодом для выполнения
 *
 * # Returns
 * * Указатель на строку с результатом (нужно освободить через free_python_result)
 * * `null` - в случае ошибки
 */
char *execute_python_code_with_output(const char *python_code);

/**
 * Освобождает память, выделенную для результата выполнения Python кода
 *
 * # Arguments
 * * `ptr` - указатель на строку, которую нужно освободить
 */
void free_python_result(char *ptr);

/**
 * Выполняет Python код, переданный в виде строки (без возврата вывода)
 *
 * # Arguments
 * * `python_code` - строка с Python кодом для выполнения
 *
 * # Returns
 * * `0` - успешное выполнение
 * * `-1` - ошибка выполнения
 */
int execute_python_code(const char *python_code);

#endif  /* IMAGE_PROCESSING_FFI_H */
