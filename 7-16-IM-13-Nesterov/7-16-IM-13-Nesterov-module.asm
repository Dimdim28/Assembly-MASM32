.386
.MODEL flat, stdcall
OPTION casemap :none

PUBLIC NESTER_THIRD_PROC
EXTERN NESTER_ARRAY_C:qword, NESTER_ARRAY_B:qword, NESTER_CONST1:qword

.CODE

NESTER_THIRD_PROC PROC
  FLD NESTER_ARRAY_C[esi*8]   ;c
  FSUB NESTER_ARRAY_B[esi*8]  ; subtractiob b from c
  FADD NESTER_CONST1 ; adding 1 to c-b
  RET

NESTER_THIRD_PROC ENDP
END




