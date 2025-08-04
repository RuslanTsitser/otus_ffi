#ifndef IMAGE_PROCESSING_FFI_H
#define IMAGE_PROCESSING_FFI_H

// Автоматически сгенерировано с помощью cbindgen. Не редактируйте вручную.

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

/**
 * Изменяет размер изображения до 128x128 пикселей
 *
 * # Arguments
 *
 * * `input_path` - Путь к входному файлу изображения
 * * `output_path` - Путь для сохранения измененного изображения
 *
 * # Returns
 *
 * 0 в случае успеха, -1 в случае ошибки
 *
 * # Safety
 *
 * Функция небезопасна, так как работает с C строками.
 * Вызывающий код должен обеспечить корректность путей.
 */
int32_t resize_image_file(const char *input_path,
                          const char *output_path);

/**
 * Поворачивает изображение на 90 градусов по часовой стрелке
 *
 * # Arguments
 *
 * * `input_path` - Путь к входному файлу изображения
 * * `output_path` - Путь для сохранения повернутого изображения
 *
 * # Returns
 *
 * 0 в случае успеха, -1 в случае ошибки
 *
 * # Safety
 *
 * Функция небезопасна, так как работает с C строками.
 * Вызывающий код должен обеспечить корректность путей.
 */
int32_t rotate_image_90_file(const char *input_path,
                             const char *output_path);

/**
 * Преобразует RGBA данные в JPEG изображение
 *
 * # Arguments
 *
 * * `rgba_ptr` - Указатель на RGBA данные (4 байта на пиксель)
 * * `width` - Ширина изображения в пикселях
 * * `height` - Высота изображения в пикселях
 * * `quality` - Качество JPEG (1-100)
 * * `output_len` - Указатель для сохранения размера выходных данных
 *
 * # Returns
 *
 * Указатель на JPEG данные или NULL в случае ошибки
 *
 * # Safety
 *
 * Функция небезопасна, так как работает с сырыми указателями.
 * Вызывающий код должен обеспечить корректность входных данных.
 */
unsigned char *rgba_to_jpeg(const unsigned char *rgba_ptr,
                            uint32_t width,
                            uint32_t height,
                            uint8_t quality,
                            uintptr_t *output_len);

/**
 * Освобождает память, выделенную для изображения
 *
 * # Arguments
 *
 * * `ptr` - Указатель на данные изображения
 * * `len` - Размер данных в байтах
 *
 * # Safety
 *
 * Функция небезопасна, так как работает с сырыми указателями.
 * Указатель должен быть получен из функций `resize_image`, `rotate_image_90` или `rgba_to_jpeg`.
 */
void free_image(void *ptr,
                uintptr_t len);

#endif  /* IMAGE_PROCESSING_FFI_H */
