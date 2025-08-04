#include <string.h>
#include <stdio.h>

char *get_string_length(const char *str)
{
    static char result[100];
    int length = strlen(str);
    sprintf(result, "Длина строки %d символов", length);
    return result;
}
