; includes:

	icl "../base/sys_equates.m65"

	icl "../base/sys_macros.m65"

base=$6000
missiles=base+768
player0=missiles+256
player1=player0+256
player2=player1+256
player3=player2+256

start =$2000
	org start

//	lda #$00
//	ldy #$02
//	sta ($58),y	//Borra cursor
//	sta color2	//Fondo negro
	
//Vamos primero a limpiar la zona de missiles y players
	ldx #$00
	txa
loop_blanqueo
	sta missiles,x
	sta player0,x
	sta player1,x
	sta player2,x
	sta player3,x
	inx
	bne loop_blanqueo

//Habilitamos el chip ANTIC para controlar los players del GTIA.	
	lda #>base
	sta pmbase
	lda #$03
	sta gractl
	lda #$3e
	sta SDMCTL

//Activamos una interrupción Vertical Blank para controlar los players.	
	lda #$07	//Interrupción VB diferida
	ldx #>vbd
	ldy #<vbd
	jsr SETVBV
	
	
	lda #$0f
	sta pcolr0	//Blanco
	lda #$00
	sta pcolr1
	lda #$00
	sta gprior	//Prioridades

	lda #$00
	sta sizep0

loop
	lda stick0
	lsr
	bcs no_arriba
	dec pos_y
no_arriba
	lsr
	bcs no_abajo
	inc pos_y
no_abajo
	lsr
	bcs no_izquierda
	dec pos_x
no_izquierda
	lsr
	bcs no_derecha
	inc pos_x
no_derecha

	lda rtclock
loop_time
	cmp rtclock
	beq loop_time
	jmp loop

vbd
	ldx #$00
	txa
vbd_loop1
	sta player0,x
	sta player1,x
	inx
	bne vbd_loop1

	ldx pos_y
	ldy #$00
vbd_loop2
	lda data,y
	sta player0,x
	lda data2,y
	sta player1,x
	inx
	iny
	cpy #(.len dibujo)
	bne vbd_loop2
	lda pos_x
	sta hposp0
	sta hposp1
	jmp XITVBV
pos_x
	.by $40
pos_y
	.by $40
data
.proc dibujo
	.by $00,$40,$60,$70,$78,$7C,$7E,$58,$5C,$0C,$0C,$00
.endp
data2
.proc dibujo2
	.by $E0,$B0,$98,$8C,$86,$83,$81,$A7,$A2,$F2,$12,$1E
.endp
	
	run start