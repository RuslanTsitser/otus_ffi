package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"fmt"
	"unsafe"
)

//export sum
func sum(a C.int, b C.int) C.int {
	return a + b
}

//export multiply
func multiply(a C.int, b C.int) C.int {
	return a * b
}

//export get_string_length
func get_string_length(str *C.char) *C.char {
	goStr := C.GoString(str)
	return C.CString(fmt.Sprintf("Длина строки %d символов", len(goStr)))
}

//export lib_free
func lib_free(str *C.char) {
	if str == nil {
		return
	}
	C.free(unsafe.Pointer(str))
}

func main() {
	hello := C.CString("Hello, World!")
	defer lib_free(hello)
	value := get_string_length(hello)
	defer lib_free(value)
	result := C.GoString(value)
	fmt.Println(result)
}
