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

## pile implemented in assembly

Because of "[" and "]" operators in BrainF*ck, it is necessary to have some sort
of pile to save addresses at "[" and to return to them in "]", so i implemented
a push and a pop function in interpreter.s that operates over a PILE variable 
statically allocated at data section.

These functions won't be accessible from external files as they are meant to be
called inside execute_bf function, which is accessbile in every interpreter lib
import.

## About switch statement and lookup tables

### Sequential possibilities
If you got something like a sequential switch case, as follows:

```
switch(x){
	case 0:
		do_case_0();
	case 1:
		do_case_1();
	case 2:
		do_case_2();
	...
	...
	case 9:
		do_case_9();
	default:
}
```

This could be transformed in a lookup table when compiled into assembly. The 
compiler will create a label's array that could be simplified as:

```
ARR = [do_case_0(), do_case_1(), ..., do_case_9()];
```

With this, you could use the address of the array and x entry as an offset or
index to the label you should jump to. It's very efficient because you don't 
compare the entry to each one of the possible cases, instead, you use the value
itself to simply jump to the correct part of the executable. Futhermore, the 
inconditional jump instruction is one of the fastest instructions in x86-64
architeture, as it takes just 3 or something cicles of the processor to finish 
it's execution.

### Discrete possibilities
In this project's case, the switch statement isn't sequential as the previous 
example, instead, what will be implemented is a lookup table equivalent to the
following code:

```
switch(BrainFuck_instruction){
	case 43:				// char(43) is '+'
		summ();
	case 45:				// char(45) is '-'
		subtract();
	case 46:				// char(46) is '.'
		print();
	case 60:				// char(60) is '<'
		pointer_left();
	case 62:				// char(62) is '>'
		pointer_right();
	case 91:				// char(91) is '['
		push_address();
	case 93:				// char(93) is ']'
		pop_address();
	default:
}
```

So, how can you translate the entry as an index to a label array, as it's done
in sequential case?

I stumbled in this problem and thought about it for an entire day, i came with 
the ideia do write it in C and see how the compiler treats it. What i discovered
is that you should use a lookup table in this case too, but with some extra
steps:

1. subtract 43 from the entry, so the lowest entry is correspondent to index 0 
of the array. Anything negative that results from this operation should be 
considered as default case.

2. The biggest entry is 93, when you subtract 43 it results in 50. So you also 
have to compare the result of the subtraction to 50, anything above 50 should 
also be treated as default case

3. Now you have an index to the lookup table, it's size is equivalent to 93-43,
which are the biggest and lowest possible entries. The lookup table could be 
represented as follows:

| INDEX | LABEL             	|
|-------|-----------------------|
| 0		| summ()  				|
| 1     | DEFAULT				|
| 2		| subtract()			|
| 3-16  | DEFAULT				|
| 17    | pointer_left()		|
| 18    | DEFAULT				|
| 19	| pointer_right			|
| 20-47 | DEFAULT				|
| 48	| push_address()		|
| 49	| DEFAULT				|
| 50	| pop_address()			|


So, you need more memory to fill all the "holes" in the table with default label
, but it should still be much more efficient then just comparing the entry with
every possibility
