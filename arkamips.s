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
# You control a pad with the keys left and right of
# a PS2 keyboard.
#
# Start Date:        Thu Jul 11 00:12:07 BRT 2013
# Finishing Date:    Tue Jul 23 23:54:18 BRT 2013

# # # # # # # # # # # # # # # # # # # # # # # # #
#  ___    __   _____   __
# | | \  / /\   | |   / /\
# |_|_/ /_/--\  |_|  /_/--\ segment
#
# ...where the "variables" are stored.
        .data

### These are "static" data
### Like #defines they won't be changed mid-game
		
# The bitmap display device (VGA output).
#
# The (x, y) map is made like this:
# 0x80YYYXXX
#             where Y = { 0x000 to 0x0EF }
#             and   X = { 0x000 to 0x13F }
BITMAP_ADDR:      .word   0x80000000
BITMAP_WIDTH:     .word   320
BITMAP_HEIGHT:    .word   240
		
# MARS Bitmap simulator's settings
#BITMAP_ADDR:      .word   0x10008000

# Address of the LCD display, first and second lines.
# By writing anything to LCD_CLEAR, we clear the screen.
LCD_ADDR_LINE1:	.word	0x70000000
LCD_ADDR_LINE2:	.word	0x70000010
LCD_ADDR_CLEAR:	.word	0x70000020
		
# We will print these strings across the game with our custom
# syscall.
# NOTE: Misteriously I couldn't lay down several strings contiguous
#       to each other, the game wouldn't recognize them.
#       That's why I need those random words between each string.

ARKAMIPS_STRING:	.asciiz	"ArkaMIPS"
.word 0xC0FFEE
		
INTRO_STRING:		.asciiz "Press LEFT or RIGHT to play"
.word 0xC0FFEE
		
GAME_OVER_STRING1:	.asciiz "Game Over"
.word 0xC0FFEE
		
GAME_OVER_STRING2:	.asciiz "Press LEFT or RIGHT to restart"
.word 0xC0FFEE

INTRO_SPACING:	.word	4		# Spacing between the squares on the intro
INTRO_SQUARES:	.word	4		# How many squares on the intro screen
		
# Colors for the bitmap display.
# It only uses the last two words with some values
# for the Red, Green and Blue parts.
# 
# The raw data format is:
#      (16 zero bits) 0000 0000 BBGG GRRR
		
ORANGE:			.word	0x0000001F
BLUE:			.word   0x000000C0		
MAGENTA:		.word   0x000000C7
YELLOW:			.word	0x0000003F		
CYAN:			.word	0x000000F8
WHITE:			.word	0x000000FF
LIME_GREEN:		.word	0x0000007B
		
DARK_ORANGE:	.word   0x0000001B
DARK_BLUE:		.word   0x00000040
DARK_MAGENTA:	.word   0x00000043
DARK_YELLOW:	.word	0x0000001B		
DARK_CYAN:		.word	0x0000005B
DARK_WHITE:		.word	0x0000005B
DARK_GREEN:		.word	0x00000038
	
# The colors above are all the colors I use for showing
# the blocks. I choose them "randomly", based on their
# position.
# This ammount is how many colors of those up there
# that we can use to show the blocks.
# 
# NEVER EVER change the first color to other than DARK_RED.
# 
# If you want to add another color, append it AFTER
# the last one and increase this number.
COLOR_AMMOUNT:	.word	7

# Black and Red are here because we don't print any
# blocks with them.
# The pad and the ball gets printed with red but black
# is the main background of the game.
RED:	.word   0x00000007		
BLACK:	.word	0x00000000
		
# Initial values of the player/ball.
# They're all in pixels.
		
BALL_SPEEDX_INIT:	.word   2
BALL_SPEEDY_INIT:	.word   1
BALL_WIDTH:			.word   10
BALL_HEIGHT:		.word	10

PLAYER_SPEEDX_INIT:	.word   3
PLAYER_POSX_INIT:	.word   125
PLAYER_POSY_INIT:	.word   205		
PLAYER_WIDTH:		.word   40
PLAYER_HEIGHT:		.word	10
PLAYER_LIVES_INIT:	.word   3	# How many lives the player has initially
								# (counting from zero)
		
PLAYER_SCORE_INIT:	.word	0	# Initial score is always zero.
PLAYER_SCORE_BLOCK:	.word	1	# How much the player gets by breaking a block.
		
BORDER_SIZE:		.word   1	# Size of the border on all 3 sides

LIVES_WIDTH:		.word	5 	# Width of the life indicator
LIVES_HEIGHT:		.word	10	# Height of the life indicator
LIVES_SPACING:		.word	3	# Spacing between lives
		
BLOCK_POS_OFFSET:         .word 40	 	# The x offset from the left to show blocks
								        # and initial y offset from the top.
BLOCK_POS_BOTTOM_OFFSET:  .word 100	 	# The y offset to check
BLOCK_SPACING:            .word 8 		# Space between blocks
BLOCK_UPDATE_DELAY:       .word 5000	#
BLOCK_UPDATE_JUMP:        .word 10

# Info for individual blocks
BLOCK_WIDTH:	.word	20
BLOCK_HEIGHT:	.word	10
		
# This will get changed on the game to count the ammount
# of columns and rows the whole block array has.
BLOCKS_COLS:	.word	0
BLOCKS_ROWS:	.word	0

# Pixel width/height of the whole block array
BLOCKS_WIDTH:	.word	0
BLOCKS_HEIGHT:	.word	0
		
# Animation values.
# (when you win or lose, a little animation is displayed)
VICTORY_COLOR:          .word 0x00FF00
DEFEAT_COLOR:           .word 0xFF0000
ANIMATION_DELAY:        .word 5
ANIMATION_DELAY_FINAL:  .word 1000

# Syscall aliases, use them to load $v0 when calling 'syscall'
		
# Quits the application		
SYSCALL_EXIT:   		.word   10
		
# Our custom syscall that sees if any of the keys of the game
# are being pressed.
#
# $a0 If it's 0, we see the LEFT key. If it's 1, the RIGHT key.
# $v0 0 if the key's not pressed, 1 if it is.    
SYSCALL_KEYBOARD:		.word	50

# Prints a zero-ended string on the screen.
SYSCALL_PRINT_STRING:	.word	4
		
# Prints an integer on the screen.
SYSCALL_PRINT_INT:		.word	1
		
### Now we have the global "variables",
### that we can change during the game
		
# All the blocks in a 2D array. This is the whole level.
#  2 marks blocks with 2 life points
#  1 marks blocks with 1 life point,
#  0 marks unexisting blocks
# -1 marks end of lines
# -2 marks end of rows.
BLOCKS:	.word	2, 2, 2, 2, 2, 2, 2, 2, 2, -1, 2, 1, 2, 1, 2, 1, 2, 1, 2, -1, 2, 1, 1, 2, 1, 1, 2, 1, 1, -1, 1, 2, 1, 1, 1, 2, 1, 1, 1, -1, 2, 1, 1, 1, 1, 1, 1, 1, 2, -1, 1, 1, 2, 2, 1, 1, 1, 1, 1, -1, 2, 1, 1, 1, 2, 1, 1, 1, 2, -2
		
# The original values to restore when needed
BLOCKS_ORIG:	.word	2, 2, 2, 2, 2, 2, 2, 2, 2, -1, 2, 1, 2, 1, 2, 1, 2, 1, 2, -1, 2, 1, 1, 2, 1, 1, 2, 1, 1, -1, 1, 2, 1, 1, 1, 2, 1, 1, 1, -1, 2, 1, 1, 1, 1, 1, 1, 1, 2, -1, 1, 1, 2, 2, 1, 1, 1, 1, 1, -1, 2, 1, 1, 1, 2, 1, 1, 1, 2, -2
		
BALL_X:			.word	150
BALL_Y:			.word	70
BALL_SPEEDX:	.word   2
BALL_SPEEDY:	.word   1

PLAYER_X:		.word	150
PLAYER_Y:		.word	70
PLAYER_SPEEDX:	.word   2
PLAYER_LIVES:	.word	2
PLAYER_SCORE:	.word	0
		
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
		## Keep showing the intro until player hits a key
		jal		intro

		## Actually starts stuff
		jal		init_score
		jal		init_player		
		jal		init_ball		
		jal		init_blocks

gameloop:
		jal		wait

		jal		print_borders
		jal		update_blocks		
		jal		update_player
		jal		update_ball
		
		j		gameloop
		# # # # # # # # #
		# 
		# Will never actually get here.
		# How sad.
		
end:	lw      $v0, SYSCALL_EXIT
        syscall
		# # # #
		#
		#
		#
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

# Shows some pretty stuff on the screen, while waiting for the
# user to press something.
# Will keep looping forever if the user don't press anything.
# 
# NOTE: It only checks the keys used on the game (left or right)
#
intro:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)		# Saving $ra


		
		## Will clear the screen a lot of times waiting
		## for the user to press any key (left or right)
intro_loop:
		lw		$a0, BLUE 		# bg
		jal		clear_screen


		lw		$a0, RED		# Getting FG/BG color
		lw		$a1, BLUE
		jal		get_color
		move	$a3, $v0
		
		la		$a0, ARKAMIPS_STRING	# Then the text
		li		$a1, 20
		li		$a2, 200
		li		$v0, 4
		syscall

		la		$a0, INTRO_STRING	# Then the text
		li		$a1, 20
		li		$a2, 220
		li		$v0, 4
		syscall
		
		jal		is_any_key_pressed 		# Then the key
		bne		$v0, $zero, intro_quit

		lw		$a0, BLACK
		jal		clear_screen

		lw		$a0, RED
		lw		$a1, BLACK
		jal		get_color
		move	$a3, $v0
		
		la		$a0, ARKAMIPS_STRING
		li		$a1, 20
		li		$a2, 200
		li		$v0, 4
		syscall

		la		$a0, INTRO_STRING	# Then the text
		li		$a1, 20
		li		$a2, 220
		li		$v0, 4
		syscall
		
		jal		is_any_key_pressed 		# if (!getch()) goto intro_loop
		beq		$v0, $zero, intro_loop

intro_quit:		
		lw		$a0, BLACK		# Quitting the intro
		jal		clear_screen
		
		lw		$ra, ($sp)		# Restoring $ra
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # 
# Resets ball's	position, based on the player's.
#
# NOTE: If this is the first time you're calling this, you MUST call
#       init_player first!
# 
# Internal use:
# $ra
# $t0
# 
init_ball:
		add		$sp, $sp, -4
		sw		$ra, ($sp)
		
		## The ball's initial position is right on top and the
		## middle of the bat.
		##                __
		##         ______|__|______   <-- Liek this
		##        |________________|
		##
		## Thus, it will be:
		## ball_x = player_x + player_width/2 - ball_width/2
		## ball_y = player_y - ball_height
		
		lw		$t0, PLAYER_X		# player_x
		lw		$ra, PLAYER_WIDTH	# player_width
		srl		$ra, $ra, 1			# player_width/2
		
		add		$t0, $t0, $ra		# player_x + player_width/2

		lw		$ra, BALL_WIDTH		# ball_width
		srl		$ra, $ra, 1			# ball_width/2
		
		sub		$t0, $t0, $ra		# player_x + player_width/2 - ball_width/2
		sw		$t0, BALL_X			# saving...

		lw		$t0, PLAYER_Y		# player_y
		lw		$ra, BALL_HEIGHT	# ball_height
		
		sub		$t0, $t0, $ra		# player_y - ball_height
		sw		$t0, BALL_Y			# saving...
		
		lw		$t0, BALL_SPEEDX_INIT
		sw		$t0, BALL_SPEEDX
		lw		$t0, BALL_SPEEDY_INIT
		sw		$t0, BALL_SPEEDY
		
		lw		$ra, ($sp)
		add		$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 		
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
		add		$sp, $sp, -4
		sw		$ra, ($sp)
		
		## First, we copy the level from the original part to the
		## new one, efectively restarting the level

		la		$t0, BLOCKS_ORIG
		la		$t1, BLOCKS
		li		$t3, -2
		
init_blocks_copy_loop:
		lw		$t5, ($t0)
		beq		$t5, $t3, init_blocks_continue # while (orig != -2)

		lw		$t4, ($t0)		# a = orig
		sw		$t4, ($t1)		# copy = a
		
		addi	$t0, $t0, 4		# orig++
		addi	$t1, $t1, 4		# copy++
		j		init_blocks_copy_loop
		
init_blocks_continue:	
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
		##
		## NOTE: It means that, yes, you can change the values on .data
		##       and the level will magically build itself.
		
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
		sub		$t1, $t0, 1		# rows - 1
		add		$t2, $t6, 1		# cols + 1
		mult	$t1, $t2
		mflo	$t1				# (rows - 1)*(cols + 1)
		add		$t1, $t1, $t6   # cols + (rows - 1)*(cols + 1)
		sll		$t4, $t1, 2		# [cols + (rows - 1)*(cols + 1)]
		add		$t4, $t4, $t3	# blocks[cols + (rows - 1)*(cols + 1)]
		lw		$t4, ($t4)		# get blocks[cols + (rows - 1)*(cols + 1)]

		## if (blocks[cols + (rows - 1)*(cols + 1)] == -2) then get out
		beq		$t4, $t5, init_blocks_loop_rows_end
		
		add		$t0, $t0, 1				# rows++
		j		init_blocks_loop_rows

init_blocks_loop_rows_end:
		sw		$t0, BLOCKS_ROWS 		# Saving rows count
		
		## Calculating the width in pixels of the WHOLE block set.
		## You know, all the blocks + the offsets inside them.
		
		## width = (320 - 2*BLC_POS_OFFSET - (blc_cols - 1)*BLC_SPACING)/blc_cols;
		
		lw		$t0, BITMAP_WIDTH 		# 320
		
		lw		$t1, BLOCK_POS_OFFSET 	# offset
		sll		$t1, $t1, 1				# offset*2
		sub		$t0, $t0, $t1			# 320 - (offset*2)

		sub		$t1, $t6, 1				# cols-1
		lw		$t2, BLOCK_SPACING
		mult	$t1, $t2				
		mflo	$t1						# (cols-1)*spacing
		sub		$t0, $t0, $t1			# 320 - (offset*2) - (cols-1)*spacing

		div		$t0, $t6				# (320 - (offset*2) - (cols-1)*spacing)/cols
		mflo	$t0
		
		sw		$t0, BLOCKS_WIDTH 		# saving, yay!
		
		## Calculating the height in pixels of the WHOLE block set.

		## height  = 240 - BLC_POS_OFFSET - BLC_POS_BOTTOM_OFFSET;
		
		lw		$t0, BITMAP_HEIGHT 				# 240
		lw		$t1, BLOCK_POS_OFFSET			# offset
		sub		$t0, $t0, $t1					# 240 - offset
		lw		$t1, BLOCK_POS_BOTTOM_OFFSET	# bottom
		sub		$t0, $t0, $t1					# 240 - offset - bottom

		## height -= (blc_rows - 1)*BLC_SPACING;
		
		lw		$t1, BLOCKS_ROWS 	# rows
		sub		$t1, $t1, 1			# rows - 1
		lw		$t2, BLOCK_SPACING
		mult	$t1, $t2
		mflo	$t2					# (rows - 1) * spacing
		sub		$t0, $t0, $t2		# height -= (rows - 1) * spacing

		div		$t0, $t1			# dividing by the row count
		mflo	$t0
		
		sw		$t0, BLOCKS_HEIGHT # saving, yay!

		lw		$ra, ($sp)
		add		$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # #
# Initializes the score and LCD display.
#
# It's on the LCD where we print the score, here we clean
# it and show the score for the first time.
# 
init_score:
		add		$sp, $sp, -4
		sw		$ra, ($sp)

		lw		$t0, PLAYER_SCORE_INIT 	# Reseting logical score value
		sw		$t0, PLAYER_SCORE

		sw		$zero, LCD_ADDR_CLEAR	# Clearing LCD
		
		lw		$t0, LCD_ADDR_LINE1		# Will print some stuff on it...
		
		li		$t1, 0x53				# 'S'
		sw		$t1, 0($t0)

		li		$t1, 0x63				# 'c'
		sw		$t1, 1($t0)
		
		li		$t1, 0x6F				# 'o'
		sw		$t1, 2($t0)

		li		$t1, 0x72				# 'r'
		sw		$t1, 3($t0)

		li		$t1, 0x65				# 'e'
		sw		$t1, 4($t0)

		li		$t1, 0x3A				# ':'
		sw		$t1, 5($t0)

		li		$t1, 0x20				# ' '
		sw		$t1, 6($t0)
		
		## From now on, the current score must be printed from
		## 7(LCD_ADDR_LINE1) up.
		## 
		## It means that the first digit of the score will be
		## at 7(LCD_ADDR_LINE1) and the second digit will be
		## at 8(LCD_ADDR_LINE1).
		##
		## That's what increase_score does.
		
		li		$a0, 0			#
		jal		increase_score	# Printing score for the first time

		## Now we print on the second line
		lw		$t0, LCD_ADDR_LINE2
		
		li		$t1, 0x4C				# 'L'
		sw		$t1, 0($t0)

		li		$t1, 0x69				# 'i'
		sw		$t1, 1($t0)
		
		li		$t1, 0x76				# 'v'
		sw		$t1, 2($t0)

		li		$t1, 0x65				# 'e'
		sw		$t1, 3($t0)

		li		$t1, 0x73				# 's'
		sw		$t1, 4($t0)
		
		li		$t1, 0x3A				# ':'
		sw		$t1, 5($t0)

		li		$t1, 0x20				# ' '
		sw		$t1, 6($t0)

		## And from now on, the current lives ammount should be printed
		## on 7(LCD_ADDR_LINE1) up.
		## 
		## We will initialize it here:

		lw		$t1, PLAYER_LIVES_INIT # Initializing the lives count
		sw		$t1, PLAYER_LIVES	   # from default.
		addi	$t1, $t1, 0x30		   # Also, printing it on LCD (0x30 is
		sw		$t1, 7($t0)			   # the '0' digit on ASCII)
		
		lw		$ra, ($sp)
		add		$sp, $sp, 4
		jr		$ra
		
# # # # # # # # # # # # # # # # #
# Initializes player's variables.
#
# NOTE: You MUST call init_score first, this doesn't take care of
#       the score or lives count!
#       
# Internal Use:
# $t0
# 
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

# # # # # # # # # # # # # # # # # # # # # # # # #
# Updates ball's position and draws it on screen,
# erasing it's previous position.
#
# It uses a lot of temporary registers.
# 
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
		slt		$t6, $t0, $t1			# if (ballx > screen_width)
		beq		$t6, $zero, update_ball_continue

		## If we got here, the ball has left the bottom of the screen
		## Let's decrease number of lives and if it's below zero,
		## show the game over screen.
		
		lw		$t0, PLAYER_LIVES		
		addi	$t0, $t0, -1			# lives--
		sw		$t0, PLAYER_LIVES

										# Refreshing LCD value!
		lw		$a0, LCD_ADDR_LINE2		# Will print on LCD's address
		addi	$a1, $t0, 0x30			# the ASCII character
		sw		$a1, 7($a0)				# of the number of lives
		
		beq		$t0, $zero, game_over	# if (lives == 0) go to game over screen!

		## We lost a life.
		## Let's wait a little, restore the ball's position,
		## load $ra and go back to the start of the game loop.
		
		jal		wait			# I'm kinda ashamed of doing this.
		jal		wait			# 
		jal		wait			# Is this real life?
		jal		wait			# 
		jal		wait			# Or just Fanta sea?
		jal		wait			# 
		jal		wait			# Caught in a landslide...
		jal		wait			# 
		jal		wait			# No escape from reality...
		jal		wait			# 
		
		jal		init_ball		# Reset ball's position

		lw		$ra, ($sp)		# Restorin' $ra
		addi	$sp, $sp, 4		#
		j		gameloop		# Getting us outta here
		# # # # # # # # # # # # #
		
update_ball_continue:
		## Yay, I didn't die!
		
update_ball_test_collision_player:
		## Testing collision with the player		
		lw		$a0, BALL_X
		lw		$a1, BALL_Y
		lw		$a2, BALL_WIDTH
		lw		$a3, BALL_HEIGHT
		lw		$t0, PLAYER_X
		lw		$t1, PLAYER_Y
		lw		$t2, PLAYER_WIDTH
		lw		$t3, PLAYER_HEIGHT
		jal		collided_rect
		beq		$v0, $zero, update_ball_test_rightmost

		## Yes, the ball collided with the player.
		## 
		## We're not treating the cases where it collides with it's sides.
		## So, we're just going to invert the Y axis.

		li		$a0, 1
		jal		invert_ball_axis

		## Testing if ball is outside of the bounds of the screen,
		## making it bounce if it is.
		## 
		## We don't test the bottom one, that was covered before

update_ball_test_rightmost:		
		lw		$t0, BALL_X			# Testing rightmost bound
		lw		$t1, BALL_WIDTH
		add		$t1, $t0, $t1		# x + w
		lw		$t2, BITMAP_WIDTH
		slt		$t3, $t1, $t2		# if (x + w < screen_w)
		bne		$t3, $zero, update_ball_test_leftmost

		li		$a0, 0				# Hit rightmost, bounce on X
		jal		invert_ball_axis
		
update_ball_test_leftmost:
		lw		$t0, BALL_X			# Testing leftmost bound
		li		$t1, 0
		slt		$t3, $t1, $t0		# if (x > 0)
		bne		$t3, $zero, update_ball_test_top
		
		li		$a0, 0				# Hit leftmost, bounce on X
		jal		invert_ball_axis

update_ball_test_top:
		lw		$t0, BALL_Y			# Testing upper bound
		li		$t1, 0
		slt		$t3, $t1, $t0		# if (y > 0)
		bne		$t3, $zero, update_ball_move

		li		$a0, 1				# Hit top, bounce on Y
		jal		invert_ball_axis
		
update_ball_move:	
		## Make it move
		lw		$t0, BALL_SPEEDX
		lw		$t1, BALL_X
		add		$t1, $t1, $t0
		sw		$t1, BALL_X
		
		lw		$t0, BALL_SPEEDY
		lw		$t1, BALL_Y
		add		$t1, $t1, $t0
		sw		$t1, BALL_Y

update_ball_draw:		
		## Draw ball fuck yeah
		lw		$a0, BALL_X
		lw		$a1, BALL_Y
		lw		$a2, BALL_WIDTH
		lw		$a3, BALL_HEIGHT
		lw		$v0, RED
		jal		print_rect

update_ball_end:		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Inverts the ball's moving axis ("Bounces" the ball).
#
# Arguments:
# $a0 If 0, invert it's X axis, if 1, invert the Y one.
#
# Internal use:
# $t0
# $t1
invert_ball_axis:
		addi	$sp, $sp, -4	# Saving $ra
		sw		$ra, ($sp)

		bne		$a0, $zero, invert_ball_axis_y

invert_ball_axis_x:
		lw		$t0, BALL_SPEEDX
		li		$t1, -1
		mult	$t0, $t1
		mflo	$t0
		sw		$t0, BALL_SPEEDX
		j		invert_ball_axis_end
		
invert_ball_axis_y:		
		lw		$t0, BALL_SPEEDY
		li		$t1, -1
		mult	$t0, $t1
		mflo	$t0
		sw		$t0, BALL_SPEEDY
		
invert_ball_axis_end:		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # 		
# Updates player's position and stuff based on input.
#
# Internal use:
# $a0
# $a1
# $a2
# $a3
# $v0
# $t0
# $t1
# $t2
# $t3
# $t4
update_player:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)
		
		## Draw black rectangle where the player currently is to clean it's track.
		lw		$a0, PLAYER_X
		lw		$a1, PLAYER_Y
		lw		$a2, PLAYER_WIDTH
		lw		$a3, PLAYER_HEIGHT
		lw		$v0, BLACK
		jal		print_rect

		## Testing if player is out of the bounds of the screen

update_player_test_right_bound:	
		lw		$t0, PLAYER_X		# Testing rightmost bound
		lw		$t1, PLAYER_WIDTH	#
		add		$t1, $t0, $t1		# x + w
		lw		$t2, BITMAP_WIDTH	#
		slt		$t3, $t1, $t2		# if (x + w < screen_w)
		bne		$t3, $zero, update_player_test_left_bound
		
		li		$a0, 0				# Push it back (moving left)
		jal		move_player
		
update_player_test_left_bound:
		lw		$t0, PLAYER_X		# Testing leftmost bound
		li		$t1, 0				#
		slt		$t3, $t1, $t0		# if (x > 0) continue
		bne		$t3, $zero, update_player_test_left_key

		li		$a0, 1				# Push it back (moving right)
		jal		move_player

update_player_test_left_key:
		## We're using our custom syscall to see if the left key is being pressed
		lw		$v0, SYSCALL_KEYBOARD
		li		$a0, 0
		syscall
		beq		$v0, $zero, update_player_test_right_key

		## Left key pressed, make it move!
		li		$a0, 0
		jal		move_player

		## If left key was pressed, don't check the right!
		j		update_player_draw
		
update_player_test_right_key:
		## We're using our custom syscall to see if the right key is being pressed
		lw		$v0, SYSCALL_KEYBOARD
		li		$a0, 1
		syscall
		beq		$v0, $zero, update_player_draw

		## right key pressed, make it move!
		li		$a0, 1
		jal		move_player

		lw		$a0, 1
		move	$s0, $a0	# The value we will increase
		
update_player_draw:		
		## Draw player fuck yeah
		lw		$a0, PLAYER_X
		lw		$a1, PLAYER_Y
		lw		$a2, PLAYER_WIDTH
		lw		$a3, PLAYER_HEIGHT
		lw		$v0, RED
		jal		print_rect

update_player_end:		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #	
# Moves the player by one step (defined by PLAYER_SPEEDX).
#
# Arguments:
# $a0 If 0, moves left, if 1 moves right
#
# Internal Use:
# $t0
# $t1
move_player:
		addi	$sp, $sp, -4		
		sw		$ra, ($sp)

		lw		$t0, PLAYER_SPEEDX
		lw		$t1, PLAYER_X

		beq		$a0, $zero, move_player_left

move_player_right:		
		add		$t1, $t1, $t0
		j		move_player_continue

move_player_left:
		sub		$t1, $t1, $t0

move_player_continue:	
		sw		$t1, PLAYER_X

		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # #
# Increases the player's score and redraws it
# on the screen.
#
# Arguments:
# $a0 How much we will increase the score
#
# Internal Use:
# $s0
increase_score:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)

		move	$s0, $a0	# The value we will increase
		
		## First, clearing the two digits after 'Score: '
		lw		$t0, LCD_ADDR_LINE1		
		li		$t1, 0x20				# ' '
		sw		$t1, 7($t0)
		sw		$t1, 8($t0)		
		
		## Then, increasing the logical value
		lw		$a1, PLAYER_SCORE 		# current
		add		$a1, $s0, $a1			# current += increase
		sw		$a1, PLAYER_SCORE		# storing it
		
		## Finally, print the updated score
		## Will print two digits.
		## The left one is (score/10), the right one is (score%10)
		li		$a0, 10					# 10
		lw		$a1, PLAYER_SCORE		# score
		div		$a1, $a0				#
		mfhi	$a0						# score % 10 
		mflo	$a1						# score / 10
		
		## Remember that when storing the digit on the LCD, we
		## must store it's ASCII value. Thus, we add to the first
		## ASCII digit, '0' (that is 0x30)
		addi	$a1, $a1, 0x30
		addi	$a0, $a0, 0x30
		
		sw		$a1, 7($t0)				# first digit
		sw		$a0, 8($t0)				# second digit
		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra
		
# # # # # # # # # # # # # #		
# Waits a little bit.
# How long? It's a mystery.
wait:
		add		$sp, $sp, -8
		sw		$ra, 0($sp)
		sw		$t0, 4($sp)

		add		$ra, $zero, $zero
		addi	$t0, $zero, 9000

		## 50000
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

# # # # # # # # # # # # # # # # # 		
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
# Internal Use:
# $v0 Temporary for sums
# $s7 Temporary for sums (NOT RECOMMENDED, MUST FIND A WAY AROUND IT)
# 
# Returns:
# $v0 0 if not collided, 1 if collided, 2 if laterally collided
#
# By laterally collided I mean like this:
#  _   _____________           _____________   _
# |_|>|_____________|    or   |_____________|<|_|
#
collided_rect:
		
		## Need to test 4 conditions.
		## If ALL OF THEM are true, then we've collided.
		## 
        ## if (x1 <= x2 + w2 &&
        ##     x2 <= x1 + w1 &&
        ##     y1 <= y2 + h2 &&
        ##     y2 <= y1 + h1)    { collided fuck yeah }
		##
		## NOTE: In our case, we're not testing 'less than or equal', only
		##       'less than'.
		
		add		$v0, $t0, $t2	# x1 < x2 + w2 which means...
		slt		$v0, $a0, $v0	# a0 < t0 + t2
		beq		$v0, $zero, collided_rect_false

		add		$v0, $a0, $a2	# x2 < x1 + w1 which means...
		slt		$v0, $t0, $v0	# t0 < a0 + a2
		beq		$v0, $zero, collided_rect_false

		add		$v0, $t1, $t3	# y1 < y2 + h2 which means...
		slt		$v0, $a1, $v0	# a1 < t1 + t3
		beq		$v0, $zero, collided_rect_false

		add		$v0, $a1, $a3	# y2 < y1 + h1 which means...
		slt		$v0, $t1, $v0	# t1 < a1 + a3
		beq		$v0, $zero, collided_rect_false
		
collided_rect_true:
		## Now that we know we've collided, let's see if they've
		## collided from the side.
		##
		## On our game, we test if the BALL has collided with the
		## BLOCK. If it has collided from up or down we simply
		## invert the Y axis.
		## If it collides with the block from left or right,
		## we invert it's X axis.
		## Here's where we diferentiate those cases.

		## First, to have collided from the side, we have one of those:
		## * x1      < x2
		## * x1 + w1 > x2 + w2

collided_rect_true_test1:		
		add		$v0, $zero, $a0	# x1 < x2 which means...
		slt		$v0, $v0, $t0	# a0 < t0
		beq		$v0, $zero, collided_rect_true_test2
		j		collided_rect_true_test3
		
collided_rect_true_test2:
		add		$v0, $a0, $a2	# x1 + w1 > x2 + w2 which means...
		add		$s7, $t0, $t2
		slt		$v0, $s7, $v0	# a0 + a2 > t0 + t2
		beq		$v0, $zero, collided_rect_true_not_laterally
		
		## Then, we also need one of those:
		## * y1 < y2
		## * y1 > y2 && y1 < y2 + h2
		
collided_rect_true_test3:
		add		$v0, $zero, $a1	# y1 < y2 which means...
		slt		$v0, $v0, $t1	# a1 < t1
		beq		$v0, $zero, collided_rect_true_test4
		j		collided_rect_true_laterally
		
collided_rect_true_test4:
		add		$v0, $zero, $a1	# y1 < y2 + h2 which means...
		add		$s7, $t1, $t3
		slt		$v0, $s7, $v0	# a1 < t1 + t3
		beq		$v0, $zero, collided_rect_true_not_laterally
				
collided_rect_true_laterally:
		## Woopity fucking doo, we did it!		
		li		$v0, 2
		j		collided_rect_end
		
collided_rect_true_not_laterally:
		li		$v0, 1
		j		collided_rect_end
		
collided_rect_false:
		li		$v0, 0

collided_rect_end:		
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # #		
# Updates all the blocks and shows them on the screen.
# 
# It also checks collision between each block and the ball.
# If the ball has collided with any block, we change it's direction too.
#
# Internal use:
# Pretty much everything.
# 
update_blocks:
        addi    $sp, $sp, -4	# saving $ra
        sw      $ra, 0($sp)
		
		li		$t0, 0			# i = 0
		
update_blocks_loop1:
		lw		$t1, BLOCKS_ROWS
		slt		$t7, $t0, $t1
		beq		$t7, $zero, update_blocks_end	# if (i >= blocks_rows) end loop

		li		$t1, 0				# j = 0
		
update_blocks_loop2:
		lw		$t2, BLOCKS_COLS
		slt		$t7, $t1, $t2		# if (j >= blocks_cols) end sub loop
		beq		$t7, $zero, update_blocks_loop1_end

		## Get x/y of the current block

		lw		$t4, BLOCK_WIDTH
		lw		$t5, BLOCK_SPACING
		add		$t4, $t4, $t5			# x = width + spacing
		mult	$t4, $t1				#
		mflo	$t4						# x = j*(width + spacing)
		lw		$t5, BLOCK_POS_OFFSET	#
		add		$t4, $t4, $t5			# x = pos_offset + j*(width + spacing)

		lw		$t5, BLOCK_HEIGHT
		lw		$t6, BLOCK_SPACING
		add		$t5, $t5, $t6			# y = height + spacing
		mult	$t5, $t0				# y = i*(height + spacing)
		mflo	$t5						#
		lw		$t6, BLOCK_POS_OFFSET	# blc_posy, CHANGE THIS
		add		$t5, $t5, $t6			# y = posy + i*(height + spacing)

		## Get value of the current block
		## If it's 0, the block is invisible,
		## otherwise it will be shown.
		##
		## (if somehow things get screwed, it might be -1 or -2)
		
		addi	$t2, $t2, 1		# cols + 1
		mult	$t2, $t0		# i * (cols + 1)
		mflo	$t2				#
		add		$t2, $t2, $t1	# j + i * (cols + 1)
		sll		$t2, $t2, 2		# [j + i * (cols + 1)]
		la		$t3, BLOCKS		#
		add		$t2, $t2, $t3	# blocks[j + i * (cols + 1)]
		lw		$t2, ($t2)		# a = blocks[j + i * (cols + 1)]

		beq		$t2, $zero, update_blocks_invisible	# if (a == 0) get out, the
													# block is invisible

		## Here the block "exists" and will be printed
		##
		## Need to see if it's value is 1 or 2.
		
		li		$t3, 1
		beq		$t2, $t3, update_blocks_block1

update_blocks_block2:
		## Here the block has value 2, which means I will print it with a
		## lighter color
		##
		## Will get a random color between all available on .data (except black)
		## to show this block, based on it's i and j.
		
		add		$t6, $t0, $t1		# i + j
		lw		$t7, COLOR_AMMOUNT	# (C is the max number of colors I have)
		div		$t6, $t7			#
		mfhi	$t6					# (i + j) % C
		sll		$t6, $t6, 2			# [(i + j) % C]
		la		$t7, DARK_ORANGE	# address of the first color
		add		$t6, $t6, $t7		# colors[(i + j) % C]
		lw		$t6, ($t6)			# get colors[(i + j) % C]
		j		update_blocks_print
		
update_blocks_block1:	
		## Will get a random color between all available on .data (except black)
		## to show this block, based on it's i and j.
		
		add		$t6, $t0, $t1		# i + j
		lw		$t7, COLOR_AMMOUNT	# (C is the max number of colors I have)
		div		$t6, $t7			#
		mfhi	$t6					# (i + j) % C
		sll		$t6, $t6, 2			# [(i + j) % C]
		la		$t7, ORANGE			# address of the first color
		add		$t6, $t6, $t7		# colors[(i + j) % C]
		lw		$t6, ($t6)			# get colors[(i + j) % C]
		
update_blocks_print:	
		## Printing block
		
		move	$a0, $t4		# x
		move	$a1, $t5		# y
		lw		$a2, BLOCK_WIDTH
		lw		$a3, BLOCK_HEIGHT
		move	$v0, $t6		# It's custom color
		jal		print_rect

		## And since the block exists, let's check it's collision with
		## the ball!

		addi	$sp, $sp, -24	# Saving all before sending to collided_rect
		sw		$t0, 0($sp)
		sw		$t1, 4($sp)
		sw		$t2, 8($sp)
		sw		$t3, 12($sp)		
		sw		$t4, 16($sp)
		sw		$t5, 20($sp)		
		
		lw		$a0, BALL_X
		lw		$a1, BALL_Y
		lw		$a2, BALL_WIDTH
		lw		$a3, BALL_HEIGHT
		move	$t0, $t4		# x
		move	$t1, $t5		# y
		lw		$t2, BLOCK_WIDTH
		lw		$t3, BLOCK_HEIGHT
		jal		collided_rect

		beq		$v0, $zero, update_blocks_collided_end	# not collided, get us
														# out of here

		## Collided! Let's make the ball bounce!
		## Depending on the side of the collision we will make the
		## ball bounce on the Y axis or X axis.

		li		$a0, 1			# If the return was 1, collided not on the side
		beq		$v0, $a0, update_blocks_collided_top
		
update_blocks_collided_side:
		li		$a0, 0
		jal		invert_ball_axis
		j		update_blocks_collided_increase_score
		
update_blocks_collided_top:		
		li		$a0, 1
		jal		invert_ball_axis

update_blocks_collided_increase_score:	
		## Increasing player's score
		lw		$a0, PLAYER_SCORE_BLOCK
		jal		increase_score			
		
		## Oh boy, we have to destroy ourselves.
		## And by destruction I mean:
		## 0. Decrease our value. If we are a '2' block we won't get
		##    destroyed immediately. If we are a '1' block, keep going.
		## 1. Painting a black rectangle on where I was
		## 2. Putting 0 on the blocks array

		lw		$t0, 0($sp)		# restorin' our values - we will need them now
		lw		$t1, 4($sp)		# Since we will also restore later,
		lw		$t2, 8($sp)		# don't add to $sp
		lw		$t3, 12($sp)
		lw		$t4, 16($sp)
		lw		$t5, 20($sp)		

		## Decrease value of the current block
		lw		$t2, BLOCKS_COLS	# DIS NIGGA RUINED MAH DAY
		addi	$t2, $t2, 1			# cols + 1
		mult	$t2, $t0			# i * (cols + 1)
		mflo	$t2					#
		add		$t2, $t2, $t1		# j + i * (cols + 1)
		sll		$t2, $t2, 2			# [j + i * (cols + 1)]
		la		$t3, BLOCKS			#
		add		$t2, $t2, $t3		# blocks[j + i * (cols + 1)]
		lw		$t3, ($t2)			# a = blocks[j + i * (cols + 1)]
		addi	$t3, $t3, -1		# a--
		sw		$t3, ($t2)			# blocks[j + i * (cols + 1)] = a

		## If we're not '0' now, skip this.
		bne		$t3, $zero, update_blocks_collided_end
		
		## Painting a black rectangle
		move	$a0, $t4		# x
		move	$a1, $t5		# y
		lw		$a2, BLOCK_WIDTH
		lw		$a3, BLOCK_HEIGHT
		lw		$v0, BLACK
		jal		print_rect
		
update_blocks_collided_end:		
		lw		$t0, 0($sp)		# restorin'
		lw		$t1, 4($sp)
		lw		$t2, 8($sp)
		lw		$t3, 12($sp)
		lw		$t4, 16($sp)
		lw		$t5, 20($sp)		
		
		addi	$sp, $sp, 24
		
		j update_blocks_loop2_end
		
update_blocks_invisible:
		## Block doesn't exist, don't do shit.

		## ## quando chega aqui, printa num bloco super estranho la pra cima
		## ## BLOCOS invisiveis sao bugados AS FUCK
		## move	$a0, $t4		# x
		## move	$a1, $t5		# y
		## lw		$a2, BLOCK_WIDTH
		## lw		$a3, BLOCK_HEIGHT
		## lw		$v0, RED
		## jal		print_rect
		
		
update_blocks_loop2_end:
		addi	$t1, $t1, 1		# j++
		j		update_blocks_loop2

update_blocks_loop1_end:
		addi	$t0, $t0, 1		# i++
		j		update_blocks_loop1
		
update_blocks_end:
        lw      $ra, 0($sp)
        addi    $sp, $sp, 4
		jr		$ra
		
# # # # # # # # # # # # # # # # # # #
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

# # # # # # # # # # # # # # # # # #		
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
        addi    $sp, $sp, -60	# Enterprise-quality code
        sw      $ra, 0($sp)
        sw      $a0, 4($sp)
        sw      $a1, 8($sp)
        sw      $a2, 12($sp)
        sw      $a3, 16($sp)            
        sw      $t0, 20($sp)
        sw      $t1, 24($sp)
        sw      $t2, 28($sp)
        sw      $t3, 32($sp)
        sw      $t4, 36($sp)
        sw      $t5, 40($sp)
        sw      $t6, 44($sp)
        sw      $t7, 48($sp)
        sw      $t8, 52($sp)
        sw      $t9, 56($sp)		
		
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

                                # Print pixel on:  
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
        lw      $ra, 0($sp)		# Good lord, look at this performance!
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)            
        lw      $t0, 20($sp)
        lw      $t1, 24($sp)
        lw      $t2, 28($sp)
        lw      $t3, 32($sp)	# Carry on my wayward son,
        lw      $t4, 36($sp)	# There'll be peace when you are done
        lw      $t5, 40($sp)	# Lay your weary head to rest
        lw      $t6, 44($sp)	# Don't you cry no more
        lw      $t7, 48($sp)	# (drums)
        lw      $t8, 52($sp)	# (awesome guitar licks)
        lw      $t9, 56($sp)	# (some guitar solos)
		
        addi    $sp, $sp, 60
        jr      $ra             # GTFO

# # # # # # # # # # # # # #		
# Clears screen to a color.
#
# It takes a long time, not feasible for frame-to-frame screen cleaning.
#
# Arguments:
# $a0 The color to clear screen to.
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
		move	$v0, $a0		# Color
		li		$a0, 0
		li		$a1, 0
		lw		$a2, BITMAP_WIDTH
		sub		$a2, $a2, 1
		lw		$a3, BITMAP_HEIGHT
		sub		$a3, $a3, 1
		jal		print_rect
		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # #		
# Shows the borders on all four sides.
#
#
print_borders:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)
		
		li		$a0, 0			# top border
		li		$a1, 0
		lw		$a2, BITMAP_WIDTH
		lw		$a3, BORDER_SIZE
		lw		$v0, YELLOW
		jal		print_rect
		
		li		$a0, 0			# left border
		li		$a1, 0
		lw		$a2, BORDER_SIZE
		lw		$a3, BITMAP_HEIGHT
		lw		$v0, YELLOW
		jal		print_rect

		lw		$a0, BITMAP_WIDTH	# right border
		
		lw		$a1, BORDER_SIZE 	# width - border_size
		sub		$a0, $a0, $a1
		
		li		$a1, 0
		lw		$a2, BORDER_SIZE
		lw		$a3, BITMAP_HEIGHT
		lw		$v0, YELLOW
		jal		print_rect

		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # #
# Tells if any key is being pressed right now.
#
# NOTE: It only checks the keys used on the game (left or right)
#
# Return:
# $v0 0 if none is being pressed, 1 if any one is
is_any_key_pressed:
		li		$a0, 0			# Checking if left is being pressed
		lw		$v0, SYSCALL_KEYBOARD
		syscall
		bne		$v0, $zero, is_any_key_pressed_true

		li		$a0, 1			# Checking if right is being pressed
		lw		$v0, SYSCALL_KEYBOARD
		syscall
		bne		$v0, $zero, is_any_key_pressed_true
		
is_any_key_pressed_false:
		li		$v0, 0
		jr		$ra
		
is_any_key_pressed_true:
		li		$v0, 1
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # 		
# Makes an infinite loop while any key's not pressed.
#
# Not used right now.
# 
wait_for_input:
		add		$sp, $sp, -4
		sw		$ra, ($sp)

wait_for_input_loop:
		jal		is_any_key_pressed
		beq		$v0, $zero, wait_for_input_loop
		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # 		
# Shows game over screen and waits for input to reset.
# 
game_over:
		
		## Will clear the screen a lot of times waiting
		## for the user to press any key (left or right)
game_over_loop:
		lw		$a0, RED 			# First the bg
		jal		clear_screen

		lw		$a0, BLACK			# Getting FG/BG color
		lw		$a1, RED
		jal		get_color
		move	$a3, $v0
		
		la		$a0, GAME_OVER_STRING1
		li		$a1, 20
		li		$a2, 200
		li		$v0, 4
		syscall
		la		$a0, GAME_OVER_STRING2
		li		$a1, 20
		li		$a2, 220
		li		$v0, 4
		syscall
		
		jal		is_any_key_pressed 		# Then the key
		bne		$v0, $zero, game_over_quit

		lw		$a0, YELLOW
		jal		clear_screen

		lw		$a0, BLACK		# Getting FG/BG color
		lw		$a1, YELLOW
		jal		get_color
		move	$a3, $v0
		
		la		$a0, GAME_OVER_STRING1
		li		$a1, 20
		li		$a2, 200
		li		$v0, 4
		syscall
		la		$a0, GAME_OVER_STRING2
		li		$a1, 20
		li		$a2, 220
		li		$v0, 4
		syscall
		
		jal		is_any_key_pressed 		# if (!getch()) goto game_over_loop
		beq		$v0, $zero, game_over_loop

game_over_quit:		
		lw		$a0, BLACK		# Quitting the game_over
		jal		clear_screen
		
		# Resetting whole game
		j		main

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Returns a foreground/background color based on parameters.
#
# Arguments:
# $a0 Foreground
# $a1 Background
#
# Return:
# $v0 Composed color
get_color:
		addi	$sp, $sp, -4
		sw		$ra, ($sp)

		sll		$v0, $a1, 8		# BG
		or		$v0, $a0, $v0	# FG
		
		lw		$ra, ($sp)
		addi	$sp, $sp, 4		
		jr		$ra

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # END OF IT ALL
# THANKS FOR WATCHING
