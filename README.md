# arkamips

A clone of the Arkanoid game made with MIPS Assembly.

It was made as a practical assignment for a class of Computer Organization and
Architecture. During our course we studied the MIPS architecture and had to
improve existing Unicycle, Multicycle and Pipeline processors on Verilog.

There were also lots of programming in Assembly, coming to this final project on
a processor of our choice (on our case, the Unicycle).

I'm proud to say the code is very well-commented and anyone should not have any
problems understanding the code (as long as they have a medium understanding on
MIPS Assembly). 

# Features

All of the following works on the Altera DE2-70 board:

* Full-colored game on the VGA display.
* Score and lives show on the LCD display.
* Intro and game over screens.
* Controllable with any PS2 keyboard.
* Bug-ridden gameplay! No, seriously!
* Well-commented code with most features tweakable at `.data`.

# Notes

This currently works on the DE2-70 Altera programmable board only. We use
specific stuff of our Unicycle processor implementation so it's not open for
general usage.

The good news is that the whole game logic can be reused on your MIPS simulator,
provided you make some changes on specific parts.

# Technical definitions

Our Multicycle MIPS processor implementation has several rules that
may differ from yours (or any simulator around there). Please do check
the source code because I explain inline what may need to be changed
on different implementations.

## syscalls

At our `.ktext` (on the file `syscall.s`) we have custom exception-handling routines
for our PS2 keyboard and VGA hardware.

We use them througout the code and they're very specific to our setup (memory
addresses and stuff), but if you can change them to work on your simulator,
the code won't complain.

| Service             | `$v0` | Arguments                             | Results |
|:-------------------:|:-----:|:-------------------------------------:|:-------:|
| print integer       |     1 | `$a0`:int `$a1`=x `$a2`=y `$a3`=color | Prints a signed integer on positions (x, y) with specified color. |
| print string        |     4 | `$a0`:string address `$a1`=x `$a2`=y `$a3`=color | Prints a zero-ended string on positions (x, y) with specified color. |
| get keyboard input  |    50 | `$a0`:left/right | Returns 0/1 if a the left/right key is being pressed. |


# Authors

The whole project was made by two awesome guys:

Alexandre Dantas <eu@alexdantas.net>

Matheus Pimenta <matheuscscp@gmail.com>

