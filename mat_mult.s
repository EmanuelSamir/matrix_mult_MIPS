
# Variables globales
# filaA = $s3, colA = $s4,      , filaB = $s5, colB = $s6,
# flag  = $s0 (Salida, leds), flag_ceros = $s1, flag_unos = $s2
# i = $t1, j = $t2, k = $t3, multiplicacion_size = $t3
# multiplicacion_resultado = $s7
# $t0 = temporal

# Dirección base de los registros
# $a0 = 0x00000000 -> A
# $a1 = 0x00000030 -> B
# $a2 = 0x00000060 -> C


# $t4, $t5, $t6 para los valores instantaneos de cada matriz (A,B,C)
# $t7, $t8, $t9 para los valores instantaneos de dirección de cada matriz (C,B,A)


j main
main:
# Dirección base de los registros
# A
addi $a0, $zero, 0x1001
sll  $a0, $a0, 16
# B
addi $a1, $zero, 0x1001
sll $a1, $a1, 16
addi $a1, $a1, 0x0030
# C
addi $a2, $zero, 0x1001
sll $a2, $a2, 16
addi $a2, $a2, 0x0060

# Cargamos los valores de la matriz A y lo ponemos en memoria
# A = {{2,1},{1,2}}
addi $t0, $zero, 2		# a: A[a-1][b-1]
sw $t0, 0($a0)		# $t0 -> 0x00000000
addi $t0, $zero, 2		# b: A[a-1][b-1]
sw $t0, 4($a0)		# $t0 -> 0x00000004  
addi $t0, $zero, 1		# A[0][0]
sw $t0, 8($a0)		# $t0 -> 0x00000008 
addi $t0, $zero, 3		# A[0][1]
sw $t0, 12($a0)		# $t0 -> 0x0000000C 
addi $t0, $zero, 5		# A[0][2]
sw $t0, 16($a0)		# $t0 -> 0x00000010 
addi $t0, $zero, 7		# A[1][0]
sw $t0, 20($a0)		# $t0 -> 0x00000014
addi $t0, $zero, 0		# A[1][1]
sw $t0, 24($a0)		# $t0 -> 0x00000018 
addi $t0, $zero, 0		# A[1][2]
sw $t0, 28($a0)		# $t0 -> 0x0000001C 
addi $t0, $zero, 0		# A[2][0]
sw $t0, 32($a0)		# $t0 -> 0x00000020 
addi $t0, $zero, 0		# A[2][1]
sw $t0, 36($a0)		# $t0 -> 0x00000024
addi $t0, $zero, 0		# A[2][2]
sw $t0, 40($a0)		# $t0 -> 0x00000028


# Cargamos los valores de la matriz B y lo ponemos en memoria
# B = {{3,1},{1,3}}
addi $t0, $zero, 2		# a: B[a-1][b-1]
sw $t0, 0($a1)		# $t0 -> 0x00000030
addi $t0, $zero, 2		# b: B[a-1][b-1]
sw $t0, 4($a1)		# $t0 -> 0x00000034  
addi $t0, $zero, -7		# B[0][0]
sw $t0, 8($a1)		# $t0 -> 0x00000038 
addi $t0, $zero, -5		# B[0][1]
sw $t0, 12($a1)		# $t0 -> 0x0000003C 
addi $t0, $zero, -3		# B[0][2]
sw $t0, 16($a1)		# $t0 -> 0x00000040 
addi $t0, $zero, -1		# B[1][0]
sw $t0, 20($a1)		# $t0 -> 0x00000044
addi $t0, $zero, 0		# B[1][1]
sw $t0, 24($a1)		# $t0 -> 0x00000048 
addi $t0, $zero, 0		# B[1][2]
sw $t0, 28($a1)		# $t0 -> 0x0000004C 
addi $t0, $zero, 0		# B[2][0]
sw $t0, 32($a1)		# $t0 -> 0x00000050 
addi $t0, $zero, 0		# B[2][1]
sw $t0, 36($a1)		# $t0 -> 0x00000054
addi $t0, $zero, 0		# B[2][2]
sw $t0, 40($a1)		# $t0 -> 0x00000058

# Tamaño de las matrices
lw $s3, 0($a0) 		# filaA = 2
lw $s4, 4($a0) 		# colA = 2

lw $s5, 0($a1) 		# filaB = 2
lw $s6, 4($a1)		# colB = 2

# Verifica si colA = filaB
bne $s4, $s5, NO_POSIBLE
#addi $s7, $zero, 1		# flag_puede = 1, es posible
addi $s0, $s0, 0		# Bit 2 es flag para led de no posible (alto: NO POSIBLE)

# Inicializo i, j, k
addi $t1, $zero, 0		# i = 0
L1:						
addi $t2, $zero, 0		# j = 0	
L2: 
addi $t3, $zero, 0		# k = 0


# ---- PRIMERO SE CALCULA LA DIRECCIÓN DE C[i][j] ---- %
# SUMAS SUCESIVAS 
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $t7, $zero, 0		# inicializas $t7 = 0 para el loop
LOOP1:
beq $t0, $s6, LOOP1_out # si $t0 = colB sale del loop 
add $t7,$t7, $t1 # $t7 = i * colC(colB) -> determina la fila
addi $t0, $t0, 1 # $t0 = $t0 + 1
j LOOP1
LOOP1_out:

add $t7, $t7, $t2   # $t7 = i * colC(colB) + j -> determina la columna
sll $t7, $t7, 2		# $t7 = $t7 * 4
add $t7, $a2, $t7   # $t7 = dirección de c[i][j] -> $a2 = dirección base de C
addi $t7, $t7, 8 	# Offset de arg
lw $t6, 0($t7)		# $t6 = valor de c[i][j]

L3:
# ---- SEGUNDO SE CALCULA LA DIRECCIÓN DE B[k][j] ---- %
# SUMAS SUCESIVAS 
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $t8, $zero, 0		# inicializas $t8 = 0 para el loop
LOOP2:
beq $t0, $s6, LOOP2_out # si $t0 = colB sale del loop
add $t8,$t8, $t3 # $t8 = k * colB -> determina la fila
addi $t0, $t0, 1 # $t0 = $t0 + 1
j LOOP2
LOOP2_out:

add $t8, $t8, $t2   # $t8  = k * colB + j -> determina la columna
sll $t8, $t8, 2		# $t8 = $t8 * 4
add $t8, $a1, $t8   # $t8  = dirección de B[k][j] -> $a1 = dirección base de B
addi $t8, $t8, 8 	# Offset de arg
lw $t5, 0($t8)		# $t5  = valor de B[k][j]

# ---- TERCERO SE CALCULA LA DIRECCIÓN DE A[i][k] ---- %
# SUMAS SUCESIVAS 
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $t9, $zero, 0	 	# inicializas $t9 = 0 para el loop

LOOP3:
beq $t0, $s4, LOOP3_out  # si $t0 = colA sale del loop
add $t9,$t9, $t1	# $t9 = i * colA -> determina la fila
addi $t0, $t0, 1	# $t0 = $t0 + 1 
j LOOP3
LOOP3_out:

add $t9, $t9, $t3   # $t8  = i * colA + k -> determina la columna
sll $t9, $t9, 2		# $t9 = $t9 * 4
add $t9, $a0, $t9   # $t8  = dirección de A[i][k] -> $a0 = dirección base de A
addi $t9, $t9, 8 	# Offset de arg
lw $t4, 0($t9)		# $t4  = valor de A[i][k]

# ---- REALIZA LA MULTIPLICACIÓN ---- %

slt $t0, $t5, $zero
beq $t0, $zero, b_positivo
b_negativo:
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $s7, $zero, 0	 	# inicializas $s7 = 0 para el loop
Multiplicacion_a_b_negativob:
# PRUEBA PARA SALIR DEL BUCLE
beq $t0, $t5, Multiplicacion_a_b_negativob_out 	# si $t0 = b[k][j] sale del loop
add $s7, $s7, $t4		# $s7 = a[i][k] * b[k][j]
addi $t0, $t0, -1	 	# $t0 = $t0 + 1   
j Multiplicacion_a_b_negativob

b_positivo:
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $s7, $zero, 0	 	# inicializas $s7 = 0 para el loop
Multiplicacion_a_b_positivob:
# PRUEBA PARA SALIR DEL BUCLE
beq $t0, $t5, Multiplicacion_a_b_positivob_out 	# si $t0 = b[k][j] sale del loop
add $s7, $s7, $t4		# $s7 = a[i][k] * b[k][j]
addi $t0, $t0, 1	 	# $t0 = $t0 + 1   
j Multiplicacion_a_b_positivob

Multiplicacion_a_b_negativob_out:
# Complemento a 2
nor $s7, $s7, $s7		# NOT($s7)
addi $s7, $s7, 1		# $s7 = $s7 + 1

Multiplicacion_a_b_positivob_out:


add $t6, $t6, $s7	# $t6 = c[i][j] + a[i][k] * b[k][j]

addi $t3, $t3, 1 		# k = k + 1
bne $t3, $s4, L3 		# if (k != colA) go to L3
sw $t6, 0($t7)		# c[i][j] = $t6 guarda en valor en memoria

bne $t6, $zero, NO_ES_IGUAL_A_CERO
addi $s1, $s1, 1
NO_ES_IGUAL_A_CERO:

bne $t1, $t2, NO_ES_PARA_IDENT
bne $s6, $s3, NO_ES_PARA_IDENT
addi $t0, $zero, 1
bne $t6, $t0, NO_ES_PARA_IDENT 
addi $s2, $s2, 1
NO_ES_PARA_IDENT:

addi $t2, $t2, 1 		# j = j + 1
bne $t2, $s6, L2 		# if (j != colB) go to L2
addi $t1, $t1, 1 		# i = i + 1
bne $t1, $s3, L1 		# if (i != filaA) go to L1


sw $s3, 0($a2)			# Guarda a de C[a][b]
sw $s6, 4($a2)			# Guarda b de C[a][b]
# --------------- Calcula para la multiplicación filaA*colB ---------------- #
addi $t0, $zero, 0	 	# inicializas $t0 = 0 para el loop
addi $t3, $zero, 0	 	# inicializas $t3 = 0 para el loop
Multiplicacion_fila_col:
add $t3, $t3, $s3		# $t3 = filaA * colB -> determina la fila
# PRUEBA PARA SALIR DEL BUCLE
addi $t0, $t0, 1	 	# $t0 = $t0 + 1   
bne $t0,$s6, Multiplicacion_fila_col       	# si $s6 = colB sale del loop


# --------------- VERIFICAS SI ES MATRIZ DE CEROS ---------------- #
bne $s1, $t3, NO_ES_MATRIZ_DE_CEROS
addi $s0, $s0, 1		# Bit 0 es flag para led si es matriz de ceros
NO_ES_MATRIZ_DE_CEROS:


# --------------- VERIFICAS SI ES MATRIZ IDENTIDAD ---------------- #
bne $s6, $s2, NO_ES_MATRIZ_IDENT
addi $s0, $s0, 2		# Bit 1 es flag para led si es identidad
NO_ES_MATRIZ_IDENT:

j FIN

NO_POSIBLE: 			# Ingresa aqui si no se puede realizar la mul 
addi $s0, $zero, 4		# flag_puede = 0

FIN: 					# AQUI ACABA EL PROCESO
j FIN