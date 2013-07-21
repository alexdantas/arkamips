# # # # # # # # # # # # # # # # # # # # # # # # #
#   __    ___   _      __    _      _   ___   __
#  / /\  | |_) | |_/  / /\  | |\/| | | | |_) ( (`
# /_/--\ |_| \ |_| \ /_/--\ |_|  | |_| |_|   _)_)
#
#               "Arkanoid clone on MIPS Assembly"
#
# Website:  http://github.com/alexdantas/arkamips
# Authors:   Alexandre Dantas <eu@alexdantas.net>
#         Matheus Pimenta <matheuscscp@gmail.com>
#               Ciro Viana <cirotviana@gmail.com>
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

### These are "static" data, like #defines they won't be changed mid-game
        	
## Starting with addresses for input/output devices.
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
## BITMAP_ADDR_LAST: .word   0x800EF13F
		
# MARS Bitmap simulator's settings
#BITMAP_ADDR:      .word   0x10008000

# LCD display
LCD_ADDR:       .word   0x70000000
LCD_ADDR_LAST:  .word   0x70000020

# PS2 keyboard buffer addresses
PS2_BUFFER0_ADDR:   .word   0x10000008
PS2_BUFFER1_ADDR:   .word   0x10000009

# Colors for the bitmap display.
# The raw data format is:
#      (16 zero bits) 0000 0000 bbgg grrr
#      
#
# Label Format: FOREGROUND_BACKGROUND
RED:		.word   0x00000007
BLUE:		.word   0x000000C0
MAGENTA:	.word
BLACK:		.word	0x00000000
YELLOW:		.word	0x0000003F
GREEN:		.word	0x00000038
CYAN:		.word	0x000000F8
		
# Game definitions
GAME_LIVES:	.word   3

# Barrier values
# (all the tiles on the top that constantly drop)
BARR_SPEED:		.word   250
BARR_POSX_INIT:	.word   100
BARR_POSY:		.word   220
BARR_WIDTH:		.word   45
BARR_HEIGHT:	.word   10
BARR_COLOR:		.word   0xFFFF00

BALL_SPEEDX_INIT:	.word   2
BALL_SPEEDY_INIT:	.word   1
BALL_POSX_INIT:		.word   150
BALL_POSY_INIT:		.word   150
BALL_WIDTH:			.word   7
BALL_HEIGHT:		.word	7

PLAYER_SPEEDX_INIT:	.word   2
PLAYER_POSX_INIT:	.word   150
PLAYER_POSY_INIT:	.word   200		
PLAYER_WIDTH:		.word   30
PLAYER_HEIGHT:		.word	7
		
BORDER_SIZE:       .word   5
BORDER_COLOR:      .word   0x00FFFF

BLOCK_POS_OFFSET:         .word 40	 	#
BLOCK_POS_BOTTOM_OFFSET:  .word 100	 	#
BLOCK_SPACING:            .word 8 		# Space between blocks
BLOCK_UPDATE_DELAY:       .word 5000	#
BLOCK_UPDATE_JUMP:        .word 10

# This will get changed on the game to count the ammount
# of columns/rows/pixel width/pixel height of the array
# above.
BLOCKS_COLS:	.word	0
BLOCKS_ROWS:	.word	0
BLOCKS_WIDTH:	.word	0
BLOCKS_HEIGHT:	.word	0
		
# Animation values.
# (when you win or lose, a little animation is displayed)
VICTORY_COLOR:          .word 0x00FF00
DEFEAT_COLOR:           .word 0xFF0000
ANIMATION_DELAY:        .word 5
ANIMATION_DELAY_FINAL:  .word 1000

# Syscall aliases
SYSCALL_EXIT:   .word   10
SYSCALL_TIME:   .word   30

### Now we have the global variables, that we can change during the game

# All the blocks in a 2D array
# This is the whole level.
# -1 marks end of lines and -2 marks end of rows.
BLOCKS:	.word 1, 1, 1, -1, 1, 0, 1, -2

# Things of the ball		
BALL_X:			.word	150
BALL_Y:			.word	70
BALL_SPEEDX:		.word   2
BALL_SPEEDY:		.word   1

PLAYER_X:			.word	150
PLAYER_Y:			.word	70
PLAYER_SPEEDX:		.word   2

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

		jal		init_ball
		jal		init_player
		jal		init_blocks
		jal		clear_screen
		
gameloop:
		jal		wait

		jal		update_ball
		jal		update_player

		j		gameloop
		
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
#                    
# NOTE: I follow the convention of registers preserved across calls.
#       You'll see a lot of use on the temporary registers ($tX)

# 1. INITIALIZATION PROCEDURES

# Resets ball's	position.
# 
# Internal use:
# $ra
# $t0
init_ball:
		add		$sp, $sp, -4
		sw		$ra, ($sp)
		
		lw		$t0, BALL_POSX_INIT
		sw		$t0, BALL_X
		lw		$t0, BALL_POSY_INIT
		sw		$t0, BALL_Y
		lw		$t0, BALL_SPEEDX_INIT
		sw		$t0, BALL_SPEEDX
		lw		$t0, BALL_SPEEDY_INIT
		sw		$t0, BALL_SPEEDY
		lw		$ra, ($sp)
		add		$sp, $sp, 4
		jr		$ra
		
# Initializates information about the blocks based on the array
# BLOCKS at '.data'.
# Will get columns count, rows count and width/heigth in pixels
# of the whole block set.
#
# Internal use:
# $t0 Block columns/rows count
# $t1
# $t2		
# $t3
# $t4
# $t5
# $t6		
init_blocks:
		## We will iterate through the memory region, counting how
		## many columns and rows of blocks there are.
		## We are looking for -1 (that limits the columns) and -2
		## (that limits the rows).
		## 
		## For example:
		## 
		## 	1, 0, 1, 1, 1, -1,
		## 	1, 1, 1, 1, 1, -1,
		## 	1, 1, 0, 0, 1, -2
		##
		## has 5 columns and 3 rows
		
		add		$t0, $zero, $zero # cols = 0
		la		$t3, BLOCKS		  # address of blocks[0]
		addi	$t5, $zero, -1	  # To check later if blocks[cols] == -1
		
init_blocks_loop_cols:
		sll		$t4, $t0, 2			# convert_to_word_address(cols)
		add		$t4, $t4, $t3		# address of blocks[cols]
		lw		$t4, ($t4)			# value of blocks[cols]
		beq		$t4, $t5, init_blocks_loop_cols_end # If equal to -1, get out
		addi	$t0, $t0, 1			# cols++
		j		init_blocks_loop_cols
		
init_blocks_loop_cols_end:
		sw		$t0, BLOCKS_COLS 	# Saving columns count
		add		$t6, $zero, $t0		# cols
		addi	$t0, $zero, 1		# rows = 1
		addi	$t5, $zero, -2		# to check later if something is -2
		
init_blocks_loop_rows:
		sub		$t1, $t0, 1		# a = rows - 1
		add		$t2, $t6, 1		# b = cols + 1
		mult	$t1, $t2
		mflo	$t1				# a *= b
		add		$t1, $t1, $t6   # a += cols
		sll		$t4, $t1, 2		# elements to words address
		add		$t4, $t4, $t3	# address of blocks[a]
		lw		$t4, ($t4)		# value of blocks[a]
		
		## if (blocks[blc_cols + (blc_rows - 1)*(blc_cols + 1)] == -2)
		beq		$t4, $t5, init_blocks_loop_rows_end
		
		add		$t0, $t0, 1			# rows++
		j		init_blocks_loop_rows

init_blocks_loop_rows_end:
		sw		$t0, BLOCKS_ROWS # Saving rows count
		
		## Calculating the width in pixels
		## width = (320 - 2*BLC_POS_OFFSET - (blc_cols - 1)*BLC_SPACING)/blc_cols;
		lw		$t0, BITMAP_WIDTH
		
		lw		$t1, BLOCK_POS_OFFSET
		sll		$t1, $t1, 2
		sub		$t0, $t0, $t1

		sub		$t1, $t6, 1			# cols - 1
		lw		$t2, BLOCK_SPACING
		mult	$t1, $t2
		mflo	$t1	
		sub		$t0, $t0, $t1

		div		$t0, $t6
		mflo	$t0
		
		sw		$t0, BLOCKS_WIDTH # saving, yay!
		
		## Calculating the height in pixels
		## height  = 240 - BLC_POS_OFFSET - BLC_POS_BOTTOM_OFFSET;
		lw		$t0, BITMAP_HEIGHT
		lw		$t1, BLOCK_POS_OFFSET
		sub		$t0, $t0, $t1
		lw		$t1, BLOCK_POS_BOTTOM_OFFSET
		sub		$t0, $t0, $t1

		## height -= (blc_rows - 1)*BLC_SPACING;
		lw		$t1, BLOCKS_ROWS
		sub		$t1, $t1, 1
		lw		$t2, BLOCK_SPACING
		mult	$t1, $t2
		mflo	$t2
		sub		$t0, $t0, $t2

		div		$t0, $t1		   # dividing by the row count
		mflo	$t0
		
		sw		$t0, BLOCKS_HEIGHT # saving, yay!
		jr		$ra

init_player:
		add		$sp, $sp, -4
		sw		$ra, ($sp)
		
		lw		$t0, PLAYER_POSX_INIT
		sw		$t0, PLAYER_X
		lw		$t0, PLAYER_POSY_INIT
		sw		$t0, PLAYER_Y
		lw		$t0, PLAYER_SPEEDX_INIT
		sw		$t0, PLAYER_SPEEDX
		
		lw		$ra, ($sp)
		add		$sp, $sp, 4
		jr		$ra
		
# 2. GAME LOGIC PROCEDURES

update_ball:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)
		
		## Draw black rectangle where the ball is, to clean it's track
		lw		$a0, BALL_X
		lw		$a1, BALL_Y
		lw		$a2, BALL_WIDTH
		lw		$a3, BALL_HEIGHT
		lw		$v0, BLACK
		jal		print_rect

		## Testing if ball is out of bottom of the screen
		lw		$t0, BITMAP_HEIGHT
		lw		$t1, BALL_Y
		slt		$t6, $t0, $t1	# if (ballx > screen_width)
		beq		$t6, $zero, update_ball_continue
		
		lw		$t0, GAME_LIVES		# lifes--
		addi	$t0, $t0, -1
		sw		$t0, GAME_LIVES

		jal		init_ball 		# reset ball
		
update_ball_continue:

		## TEST GAME OVER

		## TEST COLLISION
		## Testing if ball is out of the bounds of the screen,
		## making it bounce.
		
		lw		$t0, BALL_X		# Testing rightmost bound
		lw		$t1, BALL_WIDTH
		add		$t1, $t0, $t1	# x + w
		lw		$t2, BITMAP_WIDTH
		slt		$t3, $t1, $t2	# if x + w < screen_w
		bne		$t3, $zero, update_ball_continue2
		
		## bounce X
		lw		$t0, BALL_SPEEDX
		li		$t1, -1
		mult	$t0, $t1
		mflo	$t0
		sw		$t0, BALL_SPEEDX
		
update_ball_continue2:
		lw		$t0, BALL_X		# Testing leftmost bound
		li		$t1, 0
		slt		$t3, $t1, $t0	# if (x > 0) continue
		bne		$t3, $zero, update_ball_continue3
		
		## bounce X
		lw		$t0, BALL_SPEEDX
		li		$t1, -1
		mult	$t0, $t1
		mflo	$t0
		sw		$t0, BALL_SPEEDX

update_ball_continue3:
		lw		$t0, BALL_Y		# Testing upper bound
		li		$t1, 0
		slt		$t3, $t1, $t0	# if (x > 0) continue
		bne		$t3, $zero, update_ball_continue4
		
		## bounce Y
		lw		$t0, BALL_SPEEDY
		li		$t1, -1
		mult	$t0, $t1
		mflo	$t0
		sw		$t0, BALL_SPEEDY
		
update_ball_continue4:	
		## Make it move
		lw		$t0, BALL_SPEEDX
		lw		$t1, BALL_X
		add		$t1, $t1, $t0
		sw		$t1, BALL_X
		
		lw		$t0, BALL_SPEEDY
		lw		$t1, BALL_Y
		add		$t1, $t1, $t0
		sw		$t1, BALL_Y
		
		## Draw ball fuck yeah
		lw		$a0, BALL_X
		lw		$a1, BALL_Y
		lw		$a2, BALL_WIDTH
		lw		$a3, BALL_HEIGHT
		lw		$v0, CYAN
		jal		print_rect

		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# Waits a little bit.
# How long? It's a mystery.
wait:
		add		$sp, $sp, -8
		sw		$ra, 0($sp)
		sw		$t0, 4($sp)

		add		$ra, $zero, $zero
		addi	$t0, $zero, 50000
		
		## 100000
		
wait_loop:		
		beq		$ra, $t0, wait_loop_end
		addi	$ra, $ra, 1		# i++
		j		wait_loop
		
wait_loop_end:
		lw		$ra, 0($sp)
		lw		$t0, 4($sp)
		add		$sp, $sp, 4
		jr		$ra

# Updates player's position and stuff.
#
# Internal use:
# $t0
# $t1
# $t2
# $t3
# $t4
update_player:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)
		
		## Draw black rectangle where the player is, to clean it's track
		lw		$a0, PLAYER_X
		lw		$a1, PLAYER_Y
		lw		$a2, PLAYER_WIDTH
		lw		$a3, PLAYER_HEIGHT
		lw		$v0, BLACK
		jal		print_rect

		## Testing if ball is out of the bounds of the screen
		
		lw		$t0, PLAYER_X		# Testing rightmost bound
		lw		$t1, PLAYER_WIDTH
		add		$t1, $t0, $t1	# x + w
		lw		$t2, BITMAP_WIDTH
		slt		$t3, $t1, $t2	# if x + w < screen_w
		bne		$t3, $zero, update_player_continue2
		
		## bounce X
		lw		$t0, PLAYER_X
		sub		$t0, $t0, 1
		sw		$t0, PLAYER_X
		
update_player_continue2:
		lw		$t0, PLAYER_X		# Testing leftmost bound
		li		$t1, 0
		slt		$t3, $t1, $t0	# if (x > 0) continue
		bne		$t3, $zero, update_player_continue3
		
		## bounce X
		lw		$t0, PLAYER_X
		add		$t0, $t0, 1
		sw		$t0, PLAYER_X

update_player_continue3:

		li		$v0, 50			# Let's see if the left key is being pressed
		li		$a0, 0
		syscall
		beq		$v0, $zero, update_player_left_key_not_pressed

		## left key pressed
		## Make it move
		lw		$t0, PLAYER_SPEEDX
		lw		$t1, PLAYER_X
		sub		$t1, $t1, $t0
		sw		$t1, PLAYER_X
		j		update_player_continue4
		
update_player_left_key_not_pressed:		
		li		$v0, 50			# Let's see if the right key is being pressed
		li		$a0, 1
		syscall
		beq		$v0, $zero, update_player_continue4

		## right key pressed
		## Make it move
		lw		$t0, PLAYER_SPEEDX
		lw		$t1, PLAYER_X
		add		$t1, $t1, $t0
		sw		$t1, PLAYER_X
		j		update_player_continue4
		
update_player_continue4:
		
		## Draw ball fuck yeah
		lw		$a0, PLAYER_X
		lw		$a1, PLAYER_Y
		lw		$a2, PLAYER_WIDTH
		lw		$a3, PLAYER_HEIGHT
		lw		$v0, RED
		jal		print_rect

		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# Tests if two rectangles collide.
# 
# Arguments:
# $a0 x position of the 1st rectangle
# $a1 y position of the 1st rectangle
# $a2 w of the 1st rectangle
# $a3 h of the 1st rectangle
# $t0 x position of the 2nd rectangle
# $t1 y position of the 2nd rectangle
# $t2 w of the 2nd rectangle
# $t3 h of the 2nd rectangle
#
# Returns:
# $v0 1 if collided, 0 if not
collided_rect:

		## DO THIS SHIT
		
collided_rect_true:
		addi	$v0, $zero, 1
		j		collided_rect_end
		
collided_rect_false:
		add		$v0, $zero, $zero

collided_rect_end:		
		jr		$ra
		
# 3. TIMING PROCEDURES

# 4. DRAWING PROCEDURES

# Prints a single pixel on the screen.
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $t7 VGA starting memory address
# $t8 temporary
# $t9 temporary
print_pixel:
        lw		$t7, BITMAP_ADDR	# VGA memory starting address
		
        ## The VGA address (on which we store the pixel) has
        ## the following format:
        ##                           0x80YYYXXX
        ##
        ## Where YYY are the 3 bytes representing the Y offset
        ##       XXX are the 3 bytes representing the X offset
        ##
        ## So we need to shift Y left 3 bytes (12 bits)

        add     $t8, $t7, $a0	# store X offset on address

        sll     $t9, $a1, 12    # send Y offset to the left
        add     $t8, $t8, $t9   # store Y offset on the address
        sw      $a2, 0($t8)     # Actually print the pixel
        jr      $ra             # GTFO
		
# Prints a rectangle on the screen.
# 
# Arguments:
# $a0 x position
# $a1 y position
# $a2 width
# $a3 height
# $v0 color (format BBGG.GRRR.bbgg.grrr)
#
# Internal use:
# $t0 counter x (i)
# $t1 counter y (j)
# $t2 original x ($a0)
# $t3 original y ($a1)
# $t4 original w ($a2)
# $t5 original h ($a3)
# $t6 temporary
print_rect:
        addi    $sp, $sp, -20
        sw      $ra, 0($sp)
        sw      $a0, 4($sp)
        sw      $a1, 8($sp)
        sw      $a2, 12($sp)
        sw      $a3, 16($sp)            
        
print_rect_start:
        add     $t0, $zero, $a0	  # i = x
        add     $t1, $zero, $a1	  # j = y
        add     $t2, $zero, $a0   # saving original X
        add     $t3, $zero, $a1   # saving original Y
        add     $t4, $a0, $a2     # X + W
        add     $t5, $a1, $a3     # Y + H
        
print_rect_loop1:
        slt     $t6, $t1, $t5                # if (j >= h)
        beq     $t6, $zero, print_rect_exit  # then.. quit!

        add     $t0, $zero, $t2 # reset i to original x
                
print_rect_loop2:
        slt     $t6, $t0, $t4                   # if (x >= w)
        beq     $t6, $zero, print_rect_loop_end # then.. next line!

                                # print pixels on:  
        add     $a0, $zero, $t0 # current x
        add     $a1, $zero, $t1 # current y
        add     $a2, $zero, $v0 # original color (unchanged)
        jal		print_pixel

        addi    $t0, $t0, 1     # i++
        j       print_rect_loop2
        
print_rect_loop_end:
        addi    $t1, $t1, 1     # j++
        j       print_rect_loop1
        
print_rect_exit:
        lw      $ra, 0($sp)
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)            
        addi    $sp, $sp, 20
        
        jr      $ra             # GTFO

# Clears screen to black.
# 
# Internal use:
# $t0
# $a0
# $a1
# $a2
# $a3
# $t4 original w ($a2)
# $t5 original h ($a3)
# $t6 temporary
clear_screen:
		add		$sp, $sp, -4
		sw		$ra, ($sp)
		
		## Print rectangle spanning whole screen
		li		$a0, 0
		li		$a1, 0
		lw		$a2, BITMAP_WIDTH
		sub		$a2, $a2, 1
		lw		$a3, BITMAP_HEIGHT
		sub		$a3, $a3, 1
		lw		$v0, BLACK
		jal		print_rect
		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

		
