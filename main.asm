; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso b�sico de microcontroladores en ensamblador	    
;
;   Pr�ctica 6: Uso de interrupciones externas
;   Objetivo: Conocer la configuraci�n y uso de las interrupciones
;   externas.
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hern�ndez Rodr�guez
; ************************************************************

    LIST    P = 18F87J50	;PIC a utilizar
    INCLUDE <P18F87J50.INC>

;************************************************************
;Configuraci�n de fusibles
    CONFIG  FOSC = HS
    CONFIG  DEBUG = OFF
    CONFIG  XINST = OFF

;***********************************************************
;C�digo
    CBLOCK  0x000
    recibido
	ret1	;variables para crear un retardo de 1 segundo
	ret2
	ret3
    ENDC
    
    ORG 0x00    ;vector de reset
    goto 	INICIO

    ORG	0x0008	;Vector de las interrupciones
	goto	ISR


INICIO
	;INICIALIZACI�N DE PUERTOS A UTILIZAR
	movlw	0xFF
	movwf	TRISB	;Puerto B como entrada
	movlw	0x00
	movwf	TRISJ	;Puerto E como salida
	;INICIALIZACI�N DE INTERRUPCI�N EXTERNA
	bsf		INTCON,INT0IE	;Habilitamos bit enable
	bcf		INTCON,INT0IF	;Limpiamos bit bandera
	bsf		INTCON2,INTEDG0	;Habilitamos interrupcion en flancos de subida
	bsf		INTCON,7	;Habilita interrupciones de alta prioridad
	
BUCLE
	goto	BUCLE	;Bucle infinito

ISR
	bcf	INTCON,INT0IF	;Limpiar bandera de interrupci�n externa
	movlw	0xFF		
	movwf	PORTJ		;Encendemos led verde
	call	RETARDO1s	;Esperamos 1 segundo
	movlw	0x00
	movwf	PORTJ		;Apagamos led verde
	bsf	INTCON,7	    ;Activo interrupciones alta prioridad
	return


RETARDO1s	;Se crea un retardo de 1 segundo
	movlw 	D'255'
	movwf 	ret1
	movlw 	D'255'
	movwf	ret2
	movlw	D'11'
	movwf	ret3
Ret1s
	decfsz	ret1, F
	goto	Ret1s
	decfsz	ret2, F
	goto	Ret1s
	decfsz	ret3, F
	goto	Ret1s
	return

    END