#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int sum(int a, int b)
{
    return a + b;
}

int multiply(int a, int b)
{
    return a * b;
}

char *get_string_length_with_static(const char *str)
{
    if (!str)
        return NULL;
    size_t length = strlen(str);

    // Выделяем статическую память с фиксированным размером
    static char result[100];

    snprintf(result, sizeof result, "Длина строки %zu символов", length);
    return result;
}

char *get_string_length_with_malloc(const char *str)
{
    if (!str)
        return NULL;
    size_t length = strlen(str);

    // Сколько нужно символов для строки
    int need = snprintf(NULL, 0, "Длина строки %zu символов", length);
    if (need < 0)
        return NULL;

    // Выделяем память, которая нужна для строки
    char *result = (char *)malloc((size_t)need + 1);
    if (!result)
        return NULL;

    snprintf(result, (size_t)need + 1, "Длина строки %zu символов", length);
    return result;
}

void lib_free(char *ptr)
{
    free(ptr);
}
