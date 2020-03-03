; includes:

	icl "../base/sys_equates.m65"

	icl "../base/sys_macros.m65"

start =$2000
	org start

	lda #$0f
	sta pcolr0	//Blanco

	lda #$00
	ldy #$02
	sta ($58),y	//Borra cursor
	sta color2	//Fondo negro
	
	lda #$00
	sta gprior	//Prioridades

	lda #$00
	sta sizep0


	lda #$00
	sta grafp0


loop
	lda RTCLOCK
	sta hposp0
loop1	lda vcount
	cmp #$30
	bne loop1
	ldx #$00
loop2
	lda data,x
	sta wsync
	sta grafp0
	inx
	cpx #(.len dibujo)
	bne loop2
	lda #$00
	sta wsync
	sta grafp0
	jmp loop

valor_inicial
	.by $00

data
.proc dibujo
	.by $38,$7C,$38,$18,$3C,$5A,$18,$24,$66,$66,$66
.endp

tablap0 =*
tablap1 =tablap0+256


	run start
