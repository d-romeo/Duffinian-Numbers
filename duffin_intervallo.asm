# Daniele Romeo
# Dato un numero restituisce i numero duffiniani nell'intervalo [1-n] 


.text               
main:   la      $s0, dati	
        la      $s1, ris_intermedi	
        la      $s2, risultati	              
        move    $t3, $s2 
        lbu     $s3, 0($s0)             # intervallo 
        lbu     $t5, 1($s0)
        addi    $t5, $t5, -1
        beq	    $s3, $zero, fine 
        move    $s0, $zero              
        
ciclo: 
        beq     $s3, $t5, stampa      
        
        addi    $s7, $zero, 1
        sb      $s3, 0($s1)
        srl     $s5, $s3, 1		# n/2 = divisore
        move    $s6, $s1                  
        addu    $s6, $s1, $s7
        addu    $s4, $zero, $s3         # contine somma tot
        move    $v0, $zero              # resetto v0

divisori:  
        slti    $t1, $s5, 1		       
        bne     $t1, $zero, duff  
        div	$s3, $s5                # n/(divisore)
        mfhi	$t0		        # resto 
        beq	$t0, $zero, agg	 
        addi    $s5, $s5, -1             
        j divisori

agg:        
        sb	$s5, 0($s6)		        
        addu    $s4, $s5, $s4           # incrementa somma
        addi    $s5, $s5, -1            # divisore - 1
        addi    $s7, $s7, 1             # contatore elementi in memoria
        addu    $s6, $s7, $s1           # incrementa cella puntata
        j divisori 

duff:           
        addi    $t9, $s7, -2            # tolgo l'uno
        move    $a0, $s3                # passo numero
        move    $a1, $t9                # passo count_div
        move    $a2, $s1                # indirizzo ram 
        addi    $sp, $sp, -12
        sw	$t3, 0($sp)
        sw	$t9, 4($sp)
        sw  $t5, 8($sp)
        jal	check_composto          # check se è un numero composto 
        lw	$t3, 0($sp)
        lw	$t9, 4($sp)
        lw  $t5, 8($sp)
        addi    $sp, $sp, 12
        beq	$v0, $zero, nonok      
                    
ciclo_duff:        
        slt     $t0, $t9, $zero         # arrivo fino allo zero
        bne     $t0, $zero, ok 
        addu    $t0, $t9, $s1           # mi posiziono sull'elemento memoria
        lbu     $t6, 0($t0)             # carico in $se risultati
        div     $s4, $t6	        # somma/(divisore)
        mfhi	$t0		        # resto 
        beq	$t0, $zero, nonok	
        addi    $t9, $t9, -1
        j ciclo_duff

nonok:  
        addi    $s3, $s3, -1            # decrementa il numero e passa a numero successivo
        j clear

ok:     sb      $s3, 0($t3)		# t3 indirizzo duff
        addi    $s0, $s0, 1             # count-duff
        addu    $t3, $s0, $s2           
        addi    $s3, $s3, -1
        j clear

clear:          
        move    $t1, $zero
ciclo_clear:    
        slt     $t0, $t1, $s7        
        beq     $t0, $zero, end_ciclo_clear
        addu    $t2, $t1, $s1
        sb      $zero, 0($t2)
        addiu   $t1, $t1, 1 
        j ciclo_clear

end_ciclo_clear: 
        j ciclo

check_composto:  		
        addi    $a1, $a1, 1                # imposto fine cilco quando c'è uno
        addi    $t0, $zero, 1              # imposto t0 a uno per saltare il numero        
        move    $t1, $t0                    
for1:            
        slt     $t2, $t0, $a1             
        beq     $t2, $zero, end_for_false
        addu    $t6, $a2, $t0
        lbu     $t4, 0($t6)                # primo numero
for2:            
        slt     $t2, $t1, $a1
        beq     $t2, $zero, incrase_for1
        addu    $t7, $a2, $t1			
        lbu     $t5, 0($t7)                 # secondo numero	
        mul     $t2, $t4,$t5               
        beq     $t2, $a0, end_for_true			
        addi    $t1, $t1, 1
        j for2		
                    
incrase_for1:      
        addi    $t0, $t0, 1
        addi    $t1, $zero, 1 
        j  for1

end_for_true:       
        addi	$v0, $zero, 1	        # si tratta di un numero composto
        j $ra

end_for_false:      
        move    $v0, $zero              # si tratta di un numero NON composto
        j $ra

stampa:             move    $t1, $zero
ciclo_stampa:       slt     $t0, $t1, $s0  
                    beq     $t0, $zero, fine
                    addu    $t3, $s2, $t1	
                    li      $v0, 1           # service 1 is print integer
                    lbu	    $a0, 0($t3)
                    syscall    
                    addi    $t1, $t1, 1
                    j ciclo_stampa

error: 
j error
fine:               
j fine

.data 
dati: .byte 27, 10

.data 0x10010200
ris_intermedi: 
.space 256

risultati: 
.space 1024


# $s1 ram
# $s2 risultati
# $s3 numero

# $s4 contiene somma divisori
# $v0 (se composto 1 altrimenti 0)

# $s5 divisore
# $s7 count-div
# $s0 count-duff

# $t0 = i
# $t1 = j                    
# $a0 numero
