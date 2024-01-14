# USEFUL INFO

## Order of a function's parameters in register
1. %rdi
2. %rsi
3. %rdx
4. %rcx
5. %8
6. %9
7. 7 and beyond are registered in the pile

## Write syscall parameters

%rax - this indicates wich syscall the OS should call, in the write syscall the
value should be set to 1

%rdi - pointer to an open file in which the syscall will write in. For stdout the
value should be set to 1

%rsi - origin buffer's pointer

%rdx - size of the buffer to be written in the file

## Read syscall parameters

%rax - syscall code. For read call it should be set to 0

%rsi - destiny pointer

%rdi - pointer to file to read from. Stdin is 0

%rdx - size of buffer to be read

# DUMB MISTAKES THAT TOOK ME A LOT OF TIME

## Low byte registers being located in literal register space

I forgot that %cl it equivalent to the lower byte of %rcx, so if i do:
movq (%rcx), %cl
it takes the value at the address stored in rcx and moves it to the last byte of
rcx itself, making the function a complete mess and an entire week lost.

This problem was observed when i was trying to implement readStr function and 
took me A LOT of time to identify. I'm seeing that programming in assembly 
withou gdb is completely impossible.


# INTERESTING THINGS I LEARNED
## fopen and open
fopen is an abstraction of syscall open.

open returns an small integer that represents an index to the stream table in
the process, it's possible to use that return value in %rdi when calling read
syscall. 

I'm really confused by the fact that fopen doesn't return the file
descriptor open syscall does, but a pointer to a FILE variable. I don't get what
is this FILE type or why fopen doesn't simply operates with the file descriptor
directly, maybe is for safety reasons.
