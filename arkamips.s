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
# |_|_/ /_/--\  |_|  /_/--\ segment
#
# ...where the "variables" are stored.
        .data

## These are addresses for input/output devices.
## HIGLY implementation-specific (see README for more info)

# The bitmap display device (VGA output)
#
# The (x, y) map is made like this:
# 0x80YYYXXX
#             where Y = { 0x000 to 0x0EF }
#             and   X = { 0x000 to 0x13F }
BITMAP_ADDR:      .word   0x80000000
BITMAP_WIDTH:     .word   320
BITMAP_HEIGHT:    .word   240
BITMAP_ADDR_LAST: .word   0x800EF13F

# LCD display
LCD_ADDR:       .word   0x70000000
LCD_ADDR_LAST:  .word   0x70000020

# PS2 keyboard buffer addresses
PS2_BUFFER0_ADDR:   .word   0x10000008
PS2_BUFFER1_ADDR:   .word   0x10000009

# Colors for the bitmap display.
# The raw data format is:
#      (16 zero bits) BBGG GRRR bbgg grrr
# where B/G/R are background colors and b/g/r the foreground
#
# Magenta foreground on black background would be:
#      (16 zero bits) 0000 0000 1100 0111
#
# Label Format: FOREGROUND_BACKGROUND
RED_BLACK:    .word   0x00000007
BLUE_BLACK:   .word   0x000000C0

# Game definitions
GAME_LIVES:     .word   3

# Barrier values
# (all the tiles on the top that constantly drop)
BARR_SPEED:     .word   250
BARR_POSX_INIT: .word   100
BARR_SPEED:     .word   250
BARR_POSX_INIT: .word   100
BARR_POSY:      .word   220
BARR_WIDTH:     .word   45
BARR_HEIGHT:    .word   10
BARR_COLOR:     .word   0xFFFF00

BALL_SPEEDX_INIT:  .word   80
BALL_SPEEDY_INIT:  .word   80
BALL_SPEEDX:       .word   200
BALL_POSX_INIT:    .word   150
BALL_POSY_INIT:    .word   150
BALL_RADIUS:       .word   7
BALL_COLOR:        .word   0xFF00FF

BORDER_SIZE:       .word   5
BORDER_COLOR:      .word   0x00FFFF

BLOCK_POS_OFFSET:         .word 40
BLOCK_POS_BOTTOM_OFFSET:  .word 100
BLOCK_SPACING:            .word 8
BLOCK_UPDATE_DELAY:       .word 5000
BLOCK_UPDATE_JUMP:        .word 10

# Animation values.
# (when you win or lose, a little animation is displayed)
VICTORY_COLOR:          .word 0x00FF00
DEFEAT_COLOR:           .word 0xFF0000
ANIMATION_DELAY:        .word 5
ANIMATION_DELAY_FINAL:  .word 1000

# Syscall aliases
SYSCALL_EXIT:   .word   10
SYSCALL_TIME:   .word   30

# # # # # # # # # # # # # # # # # # # # # # # # #
# _____  ____  _    _____
#  | |  | |_  \ \_/  | |
#  |_|  |_|__ /_/ \  |_|  segment.
#
# ...the actual game code.
        .text

# Here's where it all starts.
# First, it initializes some stuff and then it all gets
# trapped on the game loop.
main:
        li      $a0, 30
        li      $a1, 40

## game_loop:


##         j       game_loop

        li      $v0, 10         # Exiting the game.
        syscall                 # "return 0"
#
# # # # #
        #  ____  _      ___
        # | |_  | |\ | | | \
        # |_|__ |_| \| |_|_/  of code. Here comes the...
        #
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
                                                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#  ___   ___   ___   __    ____  ___   _     ___   ____  __
# | |_) | |_) / / \ / /`  | |_  | | \ | | | | |_) | |_  ( (`
# |_|   |_| \ \_\_/ \_\_, |_|__ |_|_/ \_\_/ |_| \ |_|__ _)_)
#
# All the "functions" of the game.
#
# They're documented by the following standard:
#
# 'Arguments'       Expected values inside specific registers.
#                    Preserved across calls, use of $sp.
# 'Internal use'    Registers saved, used internally and restored.
#                    Preserved across calls, use of $sp.
# 'External use'    Registers used internally but changed.
#                    NOT preserved across calls.

# 1. INITIALIZATION PROCEDURES

# 2. GAME LOGIC PROCEDURES

# 3. TIMING PROCEDURES

# 4. DRAWING PROCEDURES

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


