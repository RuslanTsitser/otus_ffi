package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"fmt"
	"math/rand"
	"strings"
	"time"
	"unsafe"
)

//export Sum
func Sum(a C.int, b C.int) C.int {
	return a + b
}

//export Multiply
func Multiply(a C.int, b C.int) C.int {
	return a * b
}

//export GetStringLength
func GetStringLength(str *C.char) *C.char {
	goStr := C.GoString(str)
	return C.CString(fmt.Sprintf("Длина строки %d символов", len(goStr)))
}

//export FreeString
func FreeString(str *C.char) {
	if str == nil {
		return
	}
	C.free(unsafe.Pointer(str))
}

func printString(str string, ch chan<- string) {
	time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	ch <- str
}

//export GetArrayOfStrings
func GetArrayOfStrings(str *C.char) *C.char {
	goStr := C.GoString(str)

	parts := strings.Fields(goStr)
	if len(parts) == 0 {
		return C.CString("")
	}

	ch := make(chan string, len(parts))
	for _, value := range parts {
		go printString(value, ch)
	}

	result := ""
	for i := 0; i < len(parts); i++ {
		result += <-ch + "\n"
	}
	return C.CString(result)
}

func main() {
	hello := C.CString("Hello, World!")
	defer FreeString(hello)

	stringLength := GetStringLength(hello)
	defer FreeString(stringLength)
	result := C.GoString(stringLength)
	fmt.Println(result)

	arrayOfStrings := GetArrayOfStrings(hello)
	defer FreeString(arrayOfStrings)
	arrayOfStringsResult := C.GoString(arrayOfStrings)
	fmt.Println(arrayOfStringsResult)
}
