	.global	_start

	.section	".vector","ax"
	.long	_start

	.text
_start:	
	mov	#_estack, r0
	mov	#_sdata,r1
	mov	#_edata,r3
	sub	r1,r3
	mov	#_etext,r2
	smovf
	mov	#_sbss,r1
	mov	#_ebss,r3
	sub	r1,r3
	mov	#0,r2
	sstr
	bsr	_rx62n_init
	sub	r1,r1
	sub	r2,r2
	bsr	_main
	bra	.

	.end
