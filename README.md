# arkamips

A clone of the Arkanoid game made with MIPS Assembly.

# Notes

This works with any MIPS simulator (tested on MARS) as long as you do some
modifications on the source.

Go to the data section and change the Memory Addresses to the ones specified by
your simulator.

# Technical definitions

Our Multicycle MIPS processor implementation has several rules that
may differ from yours (or any simulator around there).

Here I'll describe them so anyone can change the source to make it
work on their custom implementation.

## syscalls

At our `.ktext` we have exception-handling routines that has the
following syscalls implemented:

| Service | `$v0` | Arguments | Results |
|:-------:|:-----:|:---------:|:-------:|
| print integer | 1 | `$a0`:int `$a1`=x `$a2`=y `$a3`=color | Prints a signed integer on positions (x, y) with specified color. |

