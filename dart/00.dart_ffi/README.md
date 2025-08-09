# FFI C

## Build as executable

```bash
clang ffi_c/sum.c -o ffi_c/sum
./ffi_c/sum 1 2
```

## Build as shared library

```bash
clang ffi_c/sum.c -o ffi_c/sum -fPIC -shared 
```
