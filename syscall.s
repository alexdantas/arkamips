### This implements a lot of syscalls and stuff that must happen at
### the kernel mode.
### 
### We also get to see interruptions (for the keyboard, mainly).

# All the kernel data
.kdata  

inicioKdata:

# Endereço da Tabela de Caracteres 0x00004000 x 4 = 0x00010000
.word 0x00000000, 0x00000000, 0x10101010, 0x00100010, 0x00002828, 0x00000000, 0x28FE2828, 0x002828FE, 0x38503C10, 0x00107814, 0x10686400, 0x00004C2C, 0x28102818, 0x003A4446, 0x00001010, 0x00000000, 0x20201008, 0x00081020, 0x08081020, 0x00201008, 0x38549210, 0x00109254, 0xFE101010, 0x00101010, 0x00000000, 0x10081818, 0xFE000000, 0x00000000, 0x00000000, 0x18180000, 0x10080402, 0x00804020, 0x54444438, 0x00384444, 0x10103010, 0x00381010, 0x08044438, 0x007C2010, 0x18044438, 0x00384404, 0x7C482818, 0x001C0808, 0x7840407C, 0x00384404, 0x78404438, 0x00384444, 0x1008047C, 0x00202020, 0x38444438, 0x00384444, 0x3C444438, 0x00384404, 0x00181800, 0x00001818, 0x00181800, 0x10081818, 0x20100804, 0x00040810, 0x00FE0000, 0x000000FE, 0x04081020, 0x00201008, 0x08044438, 0x00100010, 0x545C4438, 0x0038405C, 0x7C444438, 0x00444444, 0x78444478, 0x00784444, 0x40404438, 0x00384440, 0x44444478, 0x00784444, 0x7840407C, 0x007C4040, 0x7C40407C, 0x00404040, 0x5C404438, 0x00384444, 0x7C444444, 0x00444444, 0x10101038, 0x00381010, 0x0808081C, 0x00304848, 0x70484444, 0x00444448, 0x20202020, 0x003C2020, 0x92AAC682, 0x00828282, 0x54546444, 0x0044444C, 0x44444438, 0x00384444, 0x38242438, 0x00202020, 0x44444438, 0x0C384444, 0x78444478, 0x00444850, 0x38404438, 0x00384404, 0x1010107C, 0x00101010, 0x44444444, 0x00384444, 0x28444444, 0x00101028, 0x54828282, 0x00282854, 0x10284444, 0x00444428, 0x10284444, 0x00101010, 0x1008047C, 0x007C4020, 0x20202038, 0x00382020, 0x10204080, 0x00020408, 0x08080838, 0x00380808, 0x00442810, 0x00000000, 0x00000000, 0xFE000000, 0x00000810, 0x00000000, 0x3C043800, 0x003A4444, 0x24382020, 0x00582424, 0x201C0000, 0x001C2020, 0x48380808, 0x00344848, 0x44380000, 0x0038407C, 0x70202418, 0x00202020, 0x443A0000, 0x38043C44, 0x64584040, 0x00444444, 0x10001000, 0x00101010, 0x10001000, 0x60101010, 0x28242020, 0x00242830, 0x08080818, 0x00080808, 0x49B60000, 0x00414149, 0x24580000, 0x00242424, 0x44380000, 0x00384444, 0x24580000, 0x20203824, 0x48340000, 0x08083848, 0x302C0000, 0x00202020, 0x201C0000, 0x00380418, 0x10381000, 0x00101010, 0x48480000, 0x00344848, 0x44440000, 0x00102844, 0x82820000, 0x0044AA92, 0x28440000, 0x00442810, 0x24240000, 0x38041C24, 0x043C0000, 0x003C1008, 0x2010100C, 0x000C1010, 0x10101010, 0x00101010, 0x04080830, 0x00300808, 0x92600000, 0x0000000C, 0x243C1818, 0xA55A7E3C, 0x99FF5A81, 0x99663CFF, 0x10280000, 0x00000028, 0x10081020, 0x00081020

 # scancode -> ascii     
.word 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x71, 0x31, 0x00, 0x00, 0x00, 0x7a, 0x73, 0x61, 0x77, 0x32, 0x00,0x00, 0x63, 0x78, 0x64, 0x65, 0x34, 0x33, 0x00, 0x00, 0x00, 0x76, 0x66, 0x74, 0x72, 0x35, 0x00,0x00, 0x6e, 0x62, 0x68, 0x67, 0x79, 0x36, 0x00, 0x00, 0x00, 0x6d, 0x6a, 0x75, 0x37, 0x38, 0x00,0x00, 0x2c, 0x6b, 0x69, 0x6f, 0x30, 0x39, 0x00, 0x00, 0x2e, 0x2f, 0x6c, 0x3b, 0x70, 0x2d, 0x00,0x00, 0x00, 0x27, 0x00, 0x00, 0x3d, 0x00, 0x00, 0x00, 0x00, 0x00, 0x5b, 0x00, 0x5d, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x31, 0x00, 0x34, 0x37, 0x00, 0x00, 0x00,0x30, 0x2e, 0x32, 0x35, 0x36, 0x38, 0x00, 0x00, 0x00, 0x2b, 0x33, 0x2d, 0x2a, 0x39, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x00

# scancode -> ascii (com shift)
.word 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x51, 0x21, 0x00, 0x00, 0x00, 0x5a, 0x53, 0x41, 0x57, 0x40, 0x00,0x00, 0x43, 0x58, 0x44, 0x45, 0x24, 0x23, 0x00, 0x00, 0x00, 0x56, 0x46, 0x54, 0x52, 0x25, 0x00,0x00, 0x4e, 0x42, 0x48, 0x47, 0x59, 0x5e, 0x00, 0x00, 0x00, 0x4d, 0x4a, 0x55, 0x26, 0x2a, 0x00,0x00, 0x3c, 0x4b, 0x49, 0x4f, 0x29, 0x28, 0x00, 0x00, 0x3e, 0x3f, 0x4c, 0x3a, 0x50, 0x5f, 0x00,0x00, 0x00, 0x22, 0x00, 0x00, 0x2b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7b, 0x00, 0x7d, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0x00	   

instructionMessage: .asciiz "Instrucao reservada ou invalida!"

# variaveis para implementar a fila de eventos de input
eventQueueBeginAddr: .word 0x90000E00
eventQueueEndAddr: .word 0x90001000
eventQueueBeginPtr: .word 0x90000E00
eventQueueEndPtr: .word 0x90000E00

# Essas sao as duas teclas que vamos usar no nosso jogo.
# Se alguma delas for apertada, vamos setar a flag
# respectiva como 1 enquanto estiver sendo apertada.
# 
# TeclaA e a letra H
# TeclaB e a letra K
teclaA:		.word	0
teclaB:		.word	0

.ktext

exceptionHandling:
	mfc0 $k0, $13
	andi $k0, $k0, 0x007C
	srl $k0, $k0, 2
	
	addi $k1, $zero, 12 # overflow na ULA
	beq $k1, $k0, ALUOverflowException
	
	addi $k1, $zero, 15 # excecao de ponto flutuante
	beq $k1, $k0, FPALUException
	
	addi $k1, $zero, 0 # interrupcao
	beq $k1, $k0, interruptException
	
	addi $k1, $zero, 10 # instrucao reservada ou invalida
	beq $k1, $k0, instructionException
	
	addi $k1, $zero, 8 # syscal
	beq $k1, $k0, syscallException
	
	eret
	
ALUOverflowException:
	# escolhi nao fazer nada, ja que ate hoje nunca vi um SO tratar esse tipo de excecao...
	
	eret
	
FPALUException:
	# escolhi nao fazer nada, ja que ate hoje nunca vi um SO tratar esse tipo de excecao...
	
	eret
	
interruptException: 
	mfc0 $k0, $13
	andi $k0, $k0, 0xFF00
	srl $k0, $k0, 8
	
	andi $k1, $k0, 0x0080
	bne $k1, $zero, counterInterrupt
	
	andi $k1, $k0, 0x0002
	bne $k1, $zero, audioInterrupt
	
	andi $k1, $k0, 0x0001
	bne $k1, $zero, keyboardInterrupt
	
	eret
	
counterInterrupt:
	# nenhum tratamento para a interrupcao de contagem eh necessario ate agora

	# meu penis esta
	eret
	
audioInterrupt:
	# TODO
	# NADA
	eret

### Aqui vamos receber os eventos do teclado e atualizar nossas flags
### teclaA e teclaB
keyboardInterrupt:
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	
	# FIXME preparar o evento de teclado no registrador $k0
	la $k0, 0x40000020
	lw $k0, 0($k0)
		
# If we want to debug the key register, uncomment below and check
# for $v1 on the board
move $v1, $k0
		
	# Verificando se alguma tecla for apertada com o teclado maroto do LINF
		addi	$t0, $zero, 0x0000FF00 # Usando uma mascara pra ver se alguma
		and		$t1, $t0, $k0		   # tecla foi apertada.
		addi	$t0, $zero, 0x0000F000
		bne		$t0, $t1, keyboardInterruptPressed

		## Se chegou ate aqui significa que alguma tecla foi solta
		addi	$t0, $zero, 0x000000FF # Mascara pra ver qual tecla foi solta
		and		$t1, $t0, $k0
		addi	$t0, $zero, 0x00000033 # tecla 'a'
		bne		$t1, $t0, keyboardInterruptNotPressedContinue

		addi	$t0, $zero, 0	# TECLA A FOI SOLTA
		sw		$t0, teclaA
		j		keyboardInterruptEnd
		
keyboardInterruptNotPressedContinue:
		addi	$t0, $zero, 0x000000FF # Mascara pra ver qual tecla foi solta
		and		$t1, $t0, $k0
		addi	$t0, $zero, 0x00000042 # tecla 'd'
		bne		$t1, $t0, keyboardInterruptEnd

		addi	$t0, $zero, 0	# TECLA D FOI SOLTA
		sw		$t0, teclaB
		j		keyboardInterruptEnd
		
keyboardInterruptPressed:
		## Se chegou aqui alguma tecla foi apertada!
		addi	$t0, $zero, 0x000000FF # Mascara pra ver qual tecla foi apertada
		and		$t1, $t0, $k0
		addi	$t0, $zero, 0x00000042 # tecla 'd'
		bne		$t1, $t0, keyboardInterruptPressedContinue

		addi	$t0, $zero, 1	# TECLA B FOI APERTADA
		sw		$t0, teclaB
		j		keyboardInterruptEnd

keyboardInterruptPressedContinue:
		addi	$t0, $zero, 0x000000FF # Mascara pra ver qual tecla foi apertada
		and		$t1, $t0, $k0
		addi	$t0, $zero, 0x00000033 # tecla 'a'
		bne		$t1, $t0, keyboardInterruptEnd
		
		addi	$t0, $zero, 1	# TECLA A FOI APERTADA
		sw		$t0, teclaA
		j		keyboardInterruptEnd
		
keyboardInterruptEnd:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp, $sp, 16	
	eret
	
eventQueueIncrementPointer:	# $a0 = endereco (ou ponteiro) a ser incrementado. $v0 = valor incrementado
	addi $v0, $a0, 4
	
	la $t0, eventQueueEndAddr
	lw $t0, 0($t0)
	beq $t0, $v0, eventQueueIncrementPointerIf
	
	jr $ra
	
eventQueueIncrementPointerIf:
	la $v0, eventQueueBeginAddr
	lw $v0, 0($v0)
	
	jr $ra
	
instructionException:
	# mostra mensagem de erro no display LCD
	
	la $t0, instructionMessage
	lui $t9, 0x7000
	sw $zero, 0x20($t9)
	
	move $s0,$zero
	li $s1,8

instructionExceptionLoop:
	beq $s0,$s1, goToExit
	lw $t4,0($t0)

	sw $t4,0($t9)
	addi $t9,$t9,1
	srl $t4,$t4,8

	sw $t4,0($t9)
	addi $t9,$t9,1
	srl $t4,$t4,8

	sw $t4,0($t9)
	addi $t9,$t9,1
	srl $t4,$t4,8

	sw $t4,0($t9)
	addi $t9,$t9,1
	addi $t0,$t0,4
	addi $s0,$s0,1
	j instructionExceptionLoop
	
syscallException:
	addi $sp, $sp, -44   			# Salva $ra e $ts na pilha
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	sw $t6, 28($sp)
	sw $t7, 32($sp)
	sw $t8, 36($sp)
	sw $t9, 40($sp)
	
	addi $t0,$zero, 10				# syscall 10 = exit
	beq $t0,$v0,goToExit		

	addi $t0, $zero, 1				# sycall 1 = print int
	beq $t0, $v0, goToPrintInt

	addi $t0, $zero, 4				# syscall 4 = print string
	beq $t0, $v0, goToPrintString

	addi $t0, $zero, 11				# syscall 11 = print char
	beq $t0, $v0, goToPrintChar

	addi $t0,$zero,45				# syscall 45 = plot
	beq $t0,$v0, goToPlot

	addi $t0,$zero,46				# syscall 46 = getplot
	beq $t0,$v0, goToGetPlot

	addi $t0, $zero, 12				# syscall 12 = read char
	beq $t0, $v0, goToReadChar

	addi $t0, $zero, 5				# syscall 5 = read int
	beq $t0, $v0, goToReadInt

	addi $t0, $zero, 8				# syscall 8 = read string
	beq $t0, $v0, goToReadString

	addi $t0, $zero, 47				# syscall 47 = inkey
	beq $t0, $v0, goToInKey

	addi $t0,$zero, 48				# syscall 48 = CLS		
	beq $t0, $v0, goToCLS

	addi $t0,$zero, 50				# syscall 50 = check key state
	beq $t0, $v0, goToPopEvent

	# syscall 30 = time     syscall 32 = sleep    syscall 41 = random

endSyscall:
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	lw $t6, 28($sp)
	lw $t7, 32($sp)
	lw $t8, 36($sp)
	lw $t9, 40($sp)
	addi $sp, $sp, 44
	eret

goToExit:  j goToExit		# colocar algo mais criativo aqui!
						
goToPrintInt: jal printInt					# chama printInt
		j endSyscall

goToPrintString: jal printString			# chama printString
		  j endSyscall			

goToPrintChar: jal printChar				#chama printChar
		j endSyscall

goToPlot: jal Plot
	    j endSyscall

goToGetPlot: jal GetPlot
		j endSyscall

goToReadChar: jal readChar			#chama readChar
		j endSyscall

goToReadInt: jal readInt			#chama readInt
		j endSyscall

goToReadString: jal readString			#chama readString
		j endSyscall

goToInKey: jal inKey			#chama inKey
		j endSyscall
		
goToCLS: jal CLS			#chama CLS
		j endSyscall

goToPopEvent: jal popEvent			#chama popEvent
		j endSyscall

############################
#  PrintInt				   #
#  $a0	=	valor inteiro  #
#  $a1	=	x			   #
#  $a2	=	y			   #
############################

printInt: addi $sp, $sp, -4   				# salva $ra
		sw $ra, 0($sp)

		beq $a0, $zero, printZero	
		j printNotZero						# chama printNotZero

printZero: addi $a0, $a0, 48				# Imprime 0
		jal printChar

		lw $ra, 0($sp)						#retorna
		addi $sp, $sp, 4
		jr $ra

printNotZero: add $t0, $zero, $a0			# $t0 contem o valor do inteiro a ser impresso
		addi $t1, $zero, 10					# $t1 eh uma constante 10
		slt $t9, $t0, $zero					# $t0 < 0 ?
		beq $t9, $zero, PrintIntContinue	# verifica se o valor eh negativo. 

		addi $a0, $zero, 45					# Negativo, imprime um '-' na tela

		addi $sp, $sp, -12
		sw $t0, 0($sp)						# salva regs
		sw $t1, 4($sp)
		sw $ra, 8($sp)

		jal printChar						# imprime ASCII 45

		lw $ra, 8($sp)						# recupera regs
		lw $t1, 4($sp)
		lw $t0, 0($sp)
		addi $sp, $sp, 12

		sub $t0, $zero, $t0					# Torna $t0 positivo
		addi $a1, $a1, 8					# incrementa a coluna
		add $t3, $zero, $zero				# $t3=0

PrintIntContinue: beq $t0, $zero, PrintIntPop		# se $t0 é zero, nao há mais digitos para imprimir

		div $t0, $t1					# divide o valor por 10
		mflo $t0						# $t0 contem o valor dividido por 10
		mfhi $t2						# $t2 contem o ultimo digito a ser impresso

		addi $sp, $sp, -4
		sw $t2, 0($sp)					# empilha $t2

		addi $t3, $t3, 1				# conta quantos elementos (digitos) estão na pilha
		j PrintIntContinue				# volta para ser dividido e empilhado de novo

PrintIntPop: beq $t3, $zero, endPrintInt	# ultimo digito endPrintInt

		lw $a0, 0($sp)					# le valor da pilha e coloca em $a0
		addi $sp, $sp, 4

		addi $a0, $a0, 48				# código ASCII do dígito = numero + 48

		addi $sp, $sp, -8				# salva regs
		sw $t3, 0($sp)
		sw $ra, 4($sp)

		jal printChar					# imprime digito

		lw $ra, 4($sp)					# recupera regs
		lw $t3, 0($sp)
		addi $sp, $sp, 8

		addi $a1, $a1, 8				# incrementa a coluna
		addi $t3, $t3, -1				# decrementa contador
		j PrintIntPop					# volta

endPrintInt: lw $ra, 0($sp)				# recupera $ra
		addi $sp, $sp, 4
		jr $ra							# fim printInt




# PrintSring
# Shows a string on the screen. It uses PrintChar a lot.
# 
# $a0	String address
# $a1	x
# $a2	y
# $a3   Color
#  
printString:
		addi $sp, $sp, -4		# Saving $ra
		sw $ra, 0($sp)

		move $t0, $a0					# $t0 = string addtress

ForPrintString:
		lw $a0, 0($t0)			# le em $a0 o caracter a ser impresso

		move $k0,$zero		# contador 4 bytes
		
Loop4bytes:
		slti $k1,$k0,4
		beq $k1,$zero, Fim4bytes
			
		andi $k1,$a0,0x00FF
		beq $k1, $zero, EndForPrintString	# string ASCIIZ termina com NULL

		addi $sp, $sp, -8				# salva $t0
		sw $t0, 0($sp)
		sw $a0, 4($sp)
		andi $a0,$a0,0x00FF

		jal printChar					# imprime char

		lw $a0, 4($sp)
		lw $t0, 0($sp)					# recupera $t0				
		addi $sp, $sp, 8

		
		addi $a1, $a1, 8				# incrementa a coluna
		slti $k1,$a1,313   #320-8
		bne $k1,$zero,NaoPulaLinha
		addi $a2,$a2,8					#incrementa a linha
		move $a1,$zero
						
NaoPulaLinha:
		srl $a0,$a0,8		# proximo byte
		addi $k0,$k0,1    #incrementa contador 4 bytes
		j Loop4bytes
		
Fim4bytes:
		addi $t0, $t0, 4				# Proxima word da memoria
		j ForPrintString				# loop

EndForPrintString:
		lw $ra, 0($sp)		# recupera $ra
		addi $sp, $sp, 4
		jr $ra							# fim printString



#################################
#  PrintChar			  		#
#  $a0	=	char(ASCII)		    #
#  $a1	=	x			   		#
#  $a2	=	y			   		#
#  $a3	=	cor
#$t0	=	i
#$t1	=	j
#$t2	=	endereco do char na memoria
#$t3	=	metade do char (2ï¿½ e depois 1ï¿½)
#$t4	=	endereco para impressao
#$t5	=	background color
#$t6	=	foreground color
#$t7	=	2


#################################


 		#li $t7, 2					# iniciando $t7=2
printChar:
		andi $t5,$a3,0xFF00				# cor fundo
		andi $t6,$a3,0x00FF				# cor frente
		srl $t5,$t5,8

#		addi $t4, $a2, 0				# t4 = y
#		sll $t4, $t4, 8					# t4 = 256(y)
		sll $t4, $a2, 12
		add $t4, $t4, $a1				# t4 = 256(y) + x
		addi $t4, $t4, 7				# t4 = 256(y) + (x+7)
		lui $t8, 0x8000				# Endereco de inicio da memoria VGA
		add $t4, $t4, $t8				# t4 = endereco de impressao do ultimo pixel da primeira linha do char

		addi $t2, $a0, -32				# indice do char na memoria
		sll $t2, $t2, 3					# offset em bytes em relacao ao endereco inicial

		addi $t2,$t2, 0x10000  #pseudo .kdata		
#		addi $t2, $t2, 0x00004b40		# endereco do char na memoria  ###########################################################

		lw $t3, 0($t2)					# carrega a primeira word do char

		addi $t0, $zero, 4				# i = 4

forChar1I: beq $t0, $zero, endForChar1I	# if(i == 0) end for i
		addi $t1, $zero, 8				# j = 8

     forChar1J: beq $t1, $zero, endForChar1J	# if(j == 0) end for j

#		div $t3, $t7
		andi $t9,$t3,0x0001
		srl $t3, $t3, 1				# t3 = t3/2  ???????????????????
#		mfhi $t9					# t9 = t3%
		beq $t9, $zero, printCharPixelbg1
		sw $t6, 0($t4)		#imprime pixel com cor de frente
		j endCharPixel1	
printCharPixelbg1:	sw $t5, 0($t4)  #imprime pixel com cor de fundo
endCharPixel1:  addi $t1, $t1, -1				# j--
		addi $t4, $t4, -1				# t4 aponta um pixel para a esquerda
		j forChar1J

endForChar1J:  addi $t0, $t0, -1				# i--
	     #  addi $t4, $t4, 264				# t4 = t4 + 8 + 256 (t4 aponta para o ultimo pixel da linha de baixo)
		addi $t4,$t4,4104   # 2**12 + 8
		j forChar1I

endForChar1I: lw $t3, 4($t2)					# carrega a segunda word do char

		addi $t0, $zero, 4				# i = 4

forChar2I:	 beq $t0, $zero, endForChar2I	# if(i == 0) end for i
		addi $t1, $zero, 8				# j = 8

	forChar2J: beq $t1, $zero, endForChar2J	# if(j == 0) end for j

	#		div $t3, $t7
			andi $t9,$t3,0x0001
			srl $t3, $t3, 1					# t3 = t3/2
	#		mfhi $t9						# t9 = t3%2
			beq $t9, $zero, printCharPixelbg2
			sw $t6, 0($t4)
			j endCharPixel2
	
printCharPixelbg2: sw $t5, 0($t4)
		
 endCharPixel2:	addi $t1, $t1, -1				# j--
		addi $t4, $t4, -1				# t4 aponta um pixel para a esquerda
		j forChar2J
	
	endForChar2J:	addi $t0, $t0, -1				# i--
	#		addi $t4, $t4, 264				# t4 = t4 + 8 + 256 (t4 aponta para o ultimo pixel da linha de baixo)
			addi $t4,$t4,4104
		j forChar2I

endForChar2I: jr $ra



############################
#  Plot				   #
#  $a0	=	x  #
#  $a1	=	y			   #
#  $a2	=	cor			   #
# Obs.: Eh muito mais rapido usar diretamente no codigo!
############################
Plot:   sll $a1,$a1,12
	add $a0,$a0,$a1
	lui $a1, 0x8000   #endereco VGA
	or $a0,$a0,$a1
	sw $a2,0($a0)
	jr $ra
	
	
############################
#  GetPlot				   #
#  $a0	=	x  #
#  $a1	=	y			   #
#  $a2	=	cor			   #
# Obs.: Eh muito mais rapido usar diretamente no codigo!
############################
GetPlot:sll $a1,$a1,12
	add $a0,$a0,$a1
	lui $a1,0x8000  #endereco VGA
	or $a0,$a0,$a1
	lw $a2,0($a0)
	jr $ra
	
	

#########################
#	ReadChar	#
# $v0 = valor do char	#
#			#
#########################

readChar:
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	

#endereco buffer1
	lui $t0, 0x1000		
	ori $t0, $t0, 0x0008
	sll $t0, $t0, 2

#endereco buffer 2
	lui $t1, 0x1000		
	ori $t1, $t1, 0x0009
	sll $t1, $t1, 2

# carrega buffers e o shift
	addi $t7, $zero, 0x12 #carrega o shift
	addi $t8, $zero, 0xF0 #carrega o F0
	add $t9, $zero, $zero #shif precionado

	lw $t6, 0($t0)
loopReadChar:
	lw $t2, 0($t0)
	beq $t2, $t6, atualizaBufferChar # testa se o buffer foi modificado
	j modificado

atualizaBufferChar:
	add $t6, $t2, $zero
	j loopReadChar

modificado:
	andi $t4, $t2, 0xFF
	addi $t5, $zero, 0x12
	beq $t4, $t5, shiftindahouse

#testa se for F0
	andi $t4, $t2, 0xFF
	beq $t4, $t8, atualizaBufferChar

#testa se a tecla foi pressionada e solta
	andi $t4, $t2, 0xFF00
	addi $t5, $zero, 0xF000
	beq $t4, $t5, continua	#tecla foi solta
	add $t6, $t2, $zero
	j loopReadChar

continua:
#testa se a tecla foi solta
	andi $t4, $t2, 0xFF #ultima tecla inserida
	beq $t4, $t7, shiftindahouse #se valor é shift

	addi $t5, $zero, 1
	beq $t9, $t5, enderecoShift

	sll $t4, $t4, 2 #mult 4
	addi $t4, $t4, 0x10000 #inicio endereco na memoria .kdata
	addi $t4, $t4, 0x318 #final da string para o printChar sem shit
	lw $t5, 0($t4)
	beq $t5, $zero, atualizaBufferChar
	
	j ReadCharEnd

enderecoShift:
	andi $t4, $t2, 0xFF #ultima tecla inserida
	#srl $t4, $t4, 16
	sll $t4, $t4, 2 #mult 4
	addi $t4, $t4, 0x10000 #inicio endereco na memoria .kdata
	addi $t4, $t4, 0x530 #final da string para o printChar com shift
	lw $t5, 0($t4)
	beq $t5, $zero, atualizaBufferChar

	j ReadCharEnd

shiftindahouse:
	addi, $t9, $zero, 1
	j atualizaBufferChar

ReadCharEnd:
	add $v0, $zero, $t5 #coloca em v0 o valor em ascii da tecla

	jr $ra

#########################
#	ReadInt		#
# $v0 = valor do inteiro#
#			#
#########################

readInt:
#iniciando variaveis
	addi $v0, $zero, 0
	addi $t7, $zero, 0
	addi $s3, $s3, 1

#endereco buffer1
	lui $t0, 0x1000
	ori $t0, $t0, 0x0008
	sll $t0, $t0, 2

#endereco buffer 2
	lui $t1, 0x1000
	ori $t1, $t1, 0x0009
	sll $t1, $t1, 2

#leitura inical do buffer
	lw $t8, 0($t0)	#buffer inicial
	lw $t9, 0 ($t0)	#buffer inicial

loopReadInt:
	lw $t2, 0($t0)
	beq $t2, $t8, atualizaBuffer
	lw $t3, 0($t1)
	#beq $t3, $t9, atualizaBuffer --------------- Nao sei se precisa desta linha

#testa se a tecla foi pressionada e solta
	andi $t4, $t2, 0xFF00
	addi $t5, $zero, 0xF000
	beq $t4, $t5, continuaInt
	j atualizaBuffer

continuaInt:
	andi $t4, $t2, 0x000000FF

#verifica se os ultimos digitos sao F0
	addi $t5, $zero, 0xF0
	beq $t4, $t5, atualizaBuffer

#verifica se o enter foi pressionado
	addi $t5, $zero, 0x5a
	beq $t4, $t5, fimReadInt1 #pressionado o enter

#pega o codigo ascii baseado no sacn code
	sll $t4, $t4, 2 #mult 4
	addi $t4, $t4, 0x10000 #inicio endereco na memoria .kdata
	addi $t4, $t4, 0x318 #final da string para o printChar
	lw $t5, 0($t4) #posicao na memoria

# testa se o valor esta entre 0x30 <= x <= 0x39
	addi $t6, $zero, 0x2f #inicio dos inteiros - 1
	slt $t4, $t6, $t5
	beq $t4, $zero, naoInteiro
	addi $t6, $t6, 0xB #final dos inteiros
	slt $t4, $t5, $t6
	beq $t4, $zero, naoInteiro

# retorna o valor inteiro para $v0
	andi $t5, $t5, 0xF #0x31 = 1, so depende dos bits finais
	addi $t4, $zero, 10 
	mult $v0, $t4 #numero vezes 10 (unidade, dezena, centena...)
	mflo $v0
	add $v0, $v0, $t5

	j atualizaBuffer

naoInteiro:
	addi $t4, $zero, 0x2D
	beq $t4, $t5, negativo
	
	j atualizaBuffer

negativo:
	slt $t7, $zero, $v0
	addi $t6, $zero, 1
	beq $t7, $t6, atualizaBuffer
	addi $t7, $zero, 1 #1 para negativo

atualizaBuffer:
	add $t8, $zero, $t2	#copia o buffer atual para variavel de buffer anterior
	add $t9, $zero, $t3	#copia o buffer atual para variavel de buffer anterior

	j loopReadInt

fimReadInt1:
	beq $t7, $zero, fimReadInt2
	sub $v0, $zero, $v0

fimReadInt2:
	add $t8, $zero, $t2	#copia o buffer atual para variavel de buffer anterior
	add $t9, $zero, $t3	#copia o buffer atual para variavel de buffer anterior

	jr $ra #fim readInt

#########################
#	ReadString	#
# $a0 = end Inicio	#
# $a1 = tam Max String	#			
#			#
#########################

readString:
	add $t6, $zero, $a0 	#end inicial string
	sub $t7, $a1, 1 	#tamanho maximo menos 1 (guarda para 0x00)
	sll $t7, $t7, 2		#tamanho maximo multiplicado por 4
	add $t1, $zero, $zero	#contador de caracteres (de 4 em 4)
	move $k0,$zero	#contador de 4
	li $v0,0  #flag de ultimo zero
	
#endereco buffer1
	lui $t0, 0x1000
	ori $t0, $t0, 0x0008
	sll $t0, $t0, 2

#leitura inical do buffer
	lw $t8, 0($t0)		#buffer1 inicial

loopReadString:
	beq $t7, $t1, fimReadString

	lw $t2, 0($t0)
	beq $t2, $t8, atualizaBufferString

#testa se a tecla foi pressionada e solta
	andi $t4, $t2, 0xFF00
	addi $t5, $zero, 0xF000
	beq $t4, $t5, continuaString
	j atualizaBufferString

continuaString:
	andi $t4, $t2, 0x00FF

#verifica se os ultimos digitos sao F0
	addi $t5, $zero, 0xF0
	beq $t4, $t5, atualizaBufferString

#verifica se o enter foi pressionado
	addi $t5, $zero, 0x5a
	beq $t4, $t5, fimReadString #pressionado o enter



#pega o codigo ascii baseado no scan code
	sll $t4, $t4, 2 	#mult 4
	addi $t4, $t4, 0x10000 	#inicio endereco na memoria
	addi $t4, $t4, 0x318 	#final da string para o printChar
	lw $t5, 0($t4) 		#posicao na memoria
	beq $t5, $zero, atualizaBufferString

VoltaZeroString:	add $t4, $t6, $t1 	#endereco para escrita
	
	#sw $t5, 0($t4) 		#guarda char valido
	#li $a3,4
	#j PPULA    Original 1 caractere por Word
	lw $t9, 0($t4)	#le o que tem no endereco
	# o que faz a falta do sllv !!!!
	li $a2,0
	beq $k0,$a2,Jzero
	li $a2,1
	beq $k0,$a2,Jum
	li $a2,2
	beq $k0,$a2,Jdois
	
Jtres:	lui $k1,0x00FF
	ori $k1,0xFFFF
	sll $t5,$t5,24
	li $k0,0
	li $a3,4
	j Jsai
Jdois:	lui $k1,0xFF00
	ori $k1,0xFFFF
	sll $t5,$t5,16
	li $k0,3
	li $a3,0
	j Jsai
Jum:	lui $k1,0xFFFF
	ori $k1,0x00FF
	sll $t5,$t5,8
	li $a3,0
	li $k0,2
	j Jsai
Jzero:	lui $k1,0xFFFF
	ori $k1,0xFF00
	sll $t5,$t5,0 
	li $k0,1
	li $a3,0

Jsai:	and $t9,$t9,$k1
	or $t5,$t5,$t9
		

PPULA:	sw $t5, 0($t4) 		#guarda char valido
	
	add $t1, $t1, $a3 	#caractere inserido, atualiza contador

atualizaBufferString:
	add $t8, $zero, $t2	#copia o buffer atual para variavel de buffer anterior
	beq $v0,$zero,loopReadString
#	add $t1, $t1, 4
#	add $t4, $t6, $t1
#	sw $zero, 0($t4)
	jr $ra

fimReadString:
	#fim da string 0x00
	li $v0,1 #ultimo
	li $t5,0 #zero
	j VoltaZeroString
	


#################################
#	InKey			#
# $v0 = primeira tecla 		#
# $v1 = ultima tecla 		#
#				#
#################################

inKey:
#iniciando variaveis
	addi $v0, $zero, 0
	addi $v1, $zero, 0

#endereco buffer1
	lui $t0, 0x1000
	ori $t0, $t0, 0x0008
	sll $t0, $t0, 2

#endereco buffer 2
	lui $t1, 0x1000
	ori $t1, $t1, 0x0009
	sll $t1, $t1, 2

#leitura inical do buffer
	lw $t8, 0($t0)	#buffer inicial
	lw $t9, 0 ($t1)	#buffer inicial

loopInKey:
	lw $t2, 0($t0)
#	beq $t2, $t8, atualizaBufferInKey
	lw $t3, 0($t1)
#
#	andi $t4, $t2, 0xFF00FF00 # queremos ver se duas teclas foram soltas
#	addi $t5, $zero, 0xF000F000
#	beq $t4, $t5, continuaInKey
#
#atualizaBufferInKey:
#	add $t8, $zero, $t2	#copia o buffer atual para variavel de buffer anterior
#	add $t9, $zero, $t3	#copia o buffer atual para variavel de buffer anterior
#
#	j loopInKey
#	
#continuaInKey:
	andi $t4, $t2, 0xFF0000     #pseudo
	srl $t4, $t4, 16
	sll $t4, $t4, 2 #mult 4
	addi $t4, $t4, 0x10000 #inicio endereco na memoria
	addi $t4, $t4, 0x318 #final da string para o printChar
	lw $t5, 0($t4) #posicao na memoria
	add $v0, $zero, $t5
	
	andi $t4, $t2, 0xFF
	sll $t4, $t4, 2 #mult 4
	addi $t4, $t4, 0x10000 #inicio endereco na memoria
	addi $t4, $t4, 0x318 #final da string para o printChar
	lw $t5, 0($t4) #posicao na memoria
	add $v1, $zero, $t5

	jr $ra






#################################
#	CLS			#
#  Clear Screen			#
#				#
#################################


CLS:	lui $t6,0x8000  # Memoria VGA
	li $t2,320
	li $t4,240

	li $t1,0
	li $t3,0
Fort3: beq $t3,$t4, Endt3
	li $t1,0
Fort1: beq $t1,$t2, Endt1
	add $t7,$t6,$t1   #soma X
	sll $t8,$t3,12
	add $t7,$t7,$t8	   #soma Y*2^12
	sw $a0,0($t7)
	addi $t1,$t1,1
	j Fort1
Endt1: addi $t3,$t3,1
	j Fort3
Endt3:  jr $ra




#################################
#  Is Key Pressed
#  $a0 if 0 then teclaA else teclaB
#  
#  $v0 = sucesso ? 1 : 0
#################################

popEvent:
		beq	$a0, $zero, popEventTeclaA
		
		## Se chegou ate aqui vamos ver tecla B
		lw	$v0, teclaB
		j	popEventEnd
		
popEventTeclaA:
		lw	$v0, teclaA
		
popEventEnd:
		jr	$ra
	
