.386
.MODEL flat, stdcall
OPTION casemap :none

.CODE

NESTER_CALCULATE_LIBRARY_EXPR proc NESTER_ARRAY_A: ptr qword, NESTER_ARRAY_B: ptr qword, NESTER_ARRAY_C: ptr qword,
  NESTER_ARRAY_D: ptr qword, NESTER_CONST3: ptr qword, NESTER_CONST2: ptr qword,
  NESTER_CONST1: ptr qword, NESTER_RESULT: ptr qword

FINIT

MOV eax, NESTER_ARRAY_A
FLD QWORD PTR [eax] ;a

MOV eax, NESTER_CONST3
FMUL QWORD PTR [eax] ; multiplying 3 and a

MOV eax, NESTER_CONST2
FDIV QWORD PTR [eax] ; dividing 3a on 2

FLDln2
FXCH  st(1)
FYL2X  ;ln(3a/2)

MOV eax, NESTER_ARRAY_C
FLD QWORD PTR [eax] ;c

MOV eax, NESTER_ARRAY_D
FLD QWORD PTR [eax] ;d

FDIV ; dividing c on d

FADD  ; adding c/d to ln(3a/2)

MOV eax, NESTER_ARRAY_C
FLD QWORD PTR [eax] ;c

MOV eax, NESTER_ARRAY_B
FLD QWORD PTR [eax] ;b

FSUB ; subtraction b from c

MOV eax, NESTER_CONST1
FADD QWORD PTR [eax] ; adding 1 to c-b

FDIV ; final dividing

MOV eax, NESTER_RESULT
FSTP QWORD PTR [eax] ; received result

RET


NESTER_CALCULATE_LIBRARY_EXPR ENDP
END
