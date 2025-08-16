package main

import (
	"C"
	"fmt"
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

func main() {
}
