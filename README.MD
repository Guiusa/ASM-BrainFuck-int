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
%rdi - pointer to an open file in which the syscall will write in. For stdin the
value should be set to 1
%rsi - origin buffer's pointer
%rdx - size of the buffer to be written in the file

