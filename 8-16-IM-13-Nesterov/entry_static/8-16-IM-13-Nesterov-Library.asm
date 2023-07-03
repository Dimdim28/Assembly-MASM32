.386
.MODEL flat, stdcall
OPTION casemap :none

.CODE

NESTER_ENTRY_POINT PROC hInstDLL: DWORD, reason: DWORD, unused: DWORD
    MOV eax, 1
    RET
NESTER_ENTRY_POINT ENDP

NESTER_CALCULATE_LIBRARY_EXPR proc NESTER_ARRAY_A: ptr qword, NESTER_ARRAY_B: ptr qword, NESTER_ARRAY_C: ptr qword,
  NESTER_ARRAY_D: ptr qword, NESTER_CONST3: ptr qword, NESTER_CONST2: ptr qword,
  NESTER_CONST1: ptr qword, NESTER_RESULT: ptr qword

FINIT

MOV ebx, NESTER_ARRAY_A
FLD QWORD PTR [ebx] ;a

MOV ebx, NESTER_CONST3
FMUL QWORD PTR [ebx] ; multiplying 3 and a

MOV ebx, NESTER_CONST2
FDIV QWORD PTR [ebx] ; dividing 3a on 2

FLDln2
FXCH  st(1)
FYL2X  ;ln(3a/2)

MOV ebx, NESTER_ARRAY_C
FLD QWORD PTR [ebx] ;c

MOV ebx, NESTER_ARRAY_D
FLD QWORD PTR [ebx] ;d

FDIV ; dividing c on d

FADD  ; adding c/d to ln(3a/2)

MOV ebx, NESTER_ARRAY_C
FLD QWORD PTR [ebx] ;c

MOV ebx, NESTER_ARRAY_B
FLD QWORD PTR [ebx] ;b

FSUB ; subtraction b from c

MOV ebx, NESTER_CONST1
FADD QWORD PTR [ebx] ; adding 1 to c-b

FDIV ; final dividing

MOV ebx, NESTER_RESULT
FSTP QWORD PTR [ebx] ; received result

RET


NESTER_CALCULATE_LIBRARY_EXPR ENDP
END NESTER_ENTRY_POINT
