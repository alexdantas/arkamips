# # # # # # # # # # # # # # # # # # # # # # # # #
#   __    ___   _      __    _      _   ___   __
#  / /\  | |_) | |_/  / /\  | |\/| | | | |_) ( (`
# /_/--\ |_| \ |_| \ /_/--\ |_|  | |_| |_|   _)_)
#
#               "Arkanoid clone on MIPS Assembly"
#
# Website:  http://github.com/alexdantas/arkamips
# Authors:  Alexandre Dantas <eu@alexdantas.net>
#           Matheus Pimenta <>
#
# "This project was made as an assignment for
#  the discipline of 'Computer Architecture
#  and Organization', 1st semester of 2013 at
#  Universidade de Brasilia (UnB), Brazil"
#
# Start Date:        Thu Jul 11 00:12:07 BRT 2013
# Finishing Date:

# # # # # # # # # # # # # # # # # # # # # # # # #
#  ___    __   _____   __
# | | \  / /\   | |   / /\
# |_|_/ /_/--\  |_|  /_/--\
#
# Data segment, where the values is stored.
        .data

        ## These are addresses for input/output devices.
        ## HIGLY implementation-specific (see README for more info)

BITMAP_ADDR:    .word   0x8000  # Bitmap (VGA, Video)
LCD_ADDR:       .word   0x7000  # LCD

        ## Color definitions for the Bitmap display.
        ## Label Format: FOREGROUND_BACKGROUND
        ## Data format: (16'b0) 0000 0000 BBGG GRRR

RED_BLACK:    .word   0x00000007
BLUE_BLACK:   .word   0x000000C0



# # # # # # # # # # # # # # # # # # # # # # # # #
# _____  ____  _    _____
#  | |  | |_  \ \_/  | |
#  |_|  |_|__ /_/ \  |_|
#
# Text segment, where the code starts.
#
# Documentation standard:
# 'Arguments'       Expected values inside specific registers.
#                   Preserved across calls, use of $sp.
# 'Internal use'    Registers saved, used internally and restored.
#                   Preserved across calls, use of $sp.
# 'External use'    Registers used internally but changed.
#                   NOT preserved across calls.
        .text

        li      $a0, 30
        li      $a1, 40




        li      $v0, 10
        syscall
#
# # # # #
        #  ____  _      ___
        # | |_  | |\ | | | \
        # |_|__ |_| \| |_|_/  of code.
        #
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

### Prints a single pixel on the screen
### Arguments:
### $a0 x position
### $a1 y position
### $a2 color (format BBGG.GRRR.bbgg.grrr)
###
### Internal use:
### $t0 VGA starting memory address
### $t1 temporary
### $t2 temporary
print_pixel:
        addi    $sp, $sp, -12
        sw      $t0, 0($sp)
        sw      $t1, 4($sp)
        sw      $t2, 8($sp)

        lui     $t0, 0x8000     # VGA memory starting address

        ## The VGA address (on which we store the pixel) has
        ## the following format:
        ##                           0x80YYYXXX
        ##
        ## Where YYY are the 3 bytes representing the Y offset
        ##       XXX are the 3 bytes representing the X offset
        ##
        ## So we need to shift Y left 3 bytes (12 bits)

        add     $t1, $t0, $a0   # store X offset on address
        sll     $t2, $a1, 12    # send Y offset to the left
        add     $t1, $t1, $t2   # store Y offset on the address
        sw      $a2, 0($t1)     # Actually print the pixel

        lw      $t0, 0($sp)
        lw      $t1, 4($sp)
        lw      $t2, 8($sp)
        addi    $sp, $sp, 12
        jr      $ra             # GTFO


