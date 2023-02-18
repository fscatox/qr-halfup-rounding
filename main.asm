.model small
.stack
.data

X   DW  33  ; choose the dividend
D   DB  2   ; choose the divisor
Q   DB  ?   ; rounded quotient

.code
.startup

MOV AX, X
DIV D       ; AL := AX / D, AH := R
MOV Q, AL

; rounding block
MOV AL, D
SHR AL, 1   ; compute floor(D/2), LSB ready in the CF
CMC         ; !CF for the auxiliary variable
SBB AL, AH  ; AL := auxiliary variable
SHL AL, 1   ; MSB ready in the CF for addition
ADC Q, 0    ; apply the rounding

.exit
end