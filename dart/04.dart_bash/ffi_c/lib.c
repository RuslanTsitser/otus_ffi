#include <string.h>
#include <stdio.h>

int sum(int a, int b)
{
    return a + b;
}

int multiply(int a, int b)
{
    return a * b;
}

char *get_string_length(const char *str)
{
    static char result[100];
    int length = strlen(str);
    sprintf(result, "Длина строки %d символов", length);
    return result;
}
