#ifndef IMAGE_PROCESSING_FFI_H
#define IMAGE_PROCESSING_FFI_H

// Автоматически сгенерировано с помощью cbindgen. Не редактируйте вручную.

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

int encode_base64_file(const char *input_path, const char *output_path);

int decode_base64_file(const char *input_path, const char *output_path);

void free_buffer(uint8_t *ptr);

#endif  /* IMAGE_PROCESSING_FFI_H */
