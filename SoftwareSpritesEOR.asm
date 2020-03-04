
; includes:

	icl "../base/sys_equates.m65"
	icl "../base/sys_macros.m65"

start =$2000
screen =$8010
pt1 = $80
pttemp =$cb

pos_x_inicial =20
pos_y_inicial =80
min_x =00
max_x =37
min_y =00
max_y =170

ancho_player=$03

	org start
	mwa #dl SDLSTL
	mwa pos_abs pos_abs_nuevo
	ldx #$04
loop_colores
	lda tabla_colores,x
	sta color0,x
	dex
	bpl loop_colores

//Vamos a  llenar de datos random la pantalla
	ldx #$00
loop_random
	lda random
	sta screen,x
	lda random
	sta screen+$100,x
	lda random
	sta screen+$200,x
	lda random
	sta screen+$300,x
	lda random
	sta screen+$400,x
	lda random
	sta screen+$500,x
	lda random
	sta screen+$600,x
	lda random
	sta screen+$700,x
//	lda random
//	sta screen+$800,x
//	lda random
//	sta screen+$900,x
//	lda random
//	sta screen+$a00,x
//	lda random
//	sta screen+$b00,x
//	lda random
//	sta screen+$c00,x
//	lda random
//	sta screen+$d00,x
//	lda random
//	sta screen+$e00,x
//	lda random
//	sta screen+$f00,x
//	lda random
//	sta screen+$1000,x
//	lda random
//	sta screen+$1100,x
//	lda random
//	sta screen+$1200,x
//	lda random
//	sta screen+$1300,x
	lda random
	sta screen+$1400,x
	lda random
	sta screen+$1500,x
	lda random
	sta screen+$1600,x
	lda random
	sta screen+$1700,x
	lda random
	sta screen+$1800,x
	lda random
	sta screen+$1900,x
	lda random
	sta screen+$1a00,x
	lda random
	sta screen+$1b00,x
	lda random
	sta screen+$1c00,x
	lda random
	sta screen+$1d00,x
	inx
	jne loop_random
	

	jsr coloca_player
	
loop_stick
	lda stick0
	lsr
	bcs no_arriba
	ldx pos_y
	cpx #min_y
	beq no_arriba
	tay
	dec pos_y
	sec
	lda pos_abs
	sbc #40
	sta pos_abs_nuevo
	tya
	bcs no_arriba
	dec pos_abs_nuevo+1
no_arriba
	lsr
	bcs no_abajo
	ldx pos_y
	cpx #max_y
	beq no_abajo
	tay
	inc pos_y
	clc
	lda pos_abs
	adc #40
	sta pos_abs_nuevo
	tya
	bcc no_abajo
	inc pos_abs_nuevo+1
no_abajo
	lsr
	bcs no_izquierda
	ldx pos_x
	cpx #min_x
	beq no_izquierda
	dec pos_x
	dec pos_abs_nuevo
	ldx pos_abs_nuevo
	cpx #$ff
	bne no_izquierda
	dec pos_abs_nuevo+1
no_izquierda
	lsr
	bcs no_derecha
	ldx pos_x
	cpx #max_x
	beq no_derecha
	inc pos_x
	inc pos_abs_nuevo
	bne no_derecha
	inc pos_abs_nuevo+1
no_derecha
	jsr coloca_player	//Borra el personaje
	mwa pos_abs_nuevo pos_abs	//reemplazamos la posición absoluta a la nueva.
	jsr coloca_player
	lda rtclock
loop_tiempo
	cmp rtclock
	beq loop_tiempo
	jmp loop_stick
	
	


.proc coloca_player
	lda pos_abs
	sta pt1
	lda pos_abs+1
	sta pt1+1
	ldy #$00
	ldx #$00
loop
	lda (pt1),y
	eor tabla_player,x
	sta (pt1),y
	iny
	cpy #ancho_player
	bne noincpt1
	ldy #$00
	clc
	lda pt1
	adc #40
	sta pt1
	bcc noincpt1
	inc pt1+1
noincpt1
	inx
	cpx #(.len datosp0)
	bne loop
	rts
.endp

	
pos_x
	.by pos_x_inicial
pos_y
	.by pos_y_inicial
pos_abs
	.word (screen + ((pos_y_inicial*40) + pos_x_inicial))
pos_abs_nuevo
	.word (screen + ((pos_y_inicial*40) + pos_x_inicial))
	
dl
	.by $70,$70,$70
	.by $4E
	.word screen
	:101 .by $0E
	.by $4e
	.word screen+$ff0
	:89 .by $0E
	.by $41
	.word dl

tabla_colores
	.by $42,$54,$66,$00,$00	

tabla_player
.proc datosp0
	.by $05,$50,$00
	.by $15,$54,$00
	.by $0A,$A0,$00
	.by $00,$A0,$00
	.by $80,$F0,$00
	.by $33,$FF,$00
	.by $3C,$F0,$C0
	.by $00,$F0,$30
	.by $00,$F0,$30
	.by $00,$F2,$C0
	.by $01,$45,$00
	.by $01,$45,$00
	.by $01,$45,$00
	.by $01,$45,$00
	.by $05,$45,$40
	.by $05,$45,$40
.endp

	org screen
	.sav $1e00
	
	run start