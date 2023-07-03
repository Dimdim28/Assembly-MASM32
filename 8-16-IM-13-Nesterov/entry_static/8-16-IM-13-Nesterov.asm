.386
.MODEL flat, stdcall
OPTION casemap :none
INCLUDE \masm32\include\masm32rt.inc
INCLUDELIB 8-16-IM-13-Nesterov-Library.lib
NESTER_CALCULATE_LIBRARY_EXPR proto :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword, :ptr qword
.DATA
  NESTER_ARRAY_A dq  2.4, -0.4,  2.8, 9.2, 0.6, 4.2
  NESTER_ARRAY_B dq  3.2, 2.4,  7.5, 5.6, 1.4, -9.9  ;;my arrays with a b с and d =)
  NESTER_ARRAY_C dq  2.2, 2.6,  8.5, -5.2, -8.6, -6.9
  NESTER_ARRAY_D dq  0.2, 1.3,  1.7, -2.6, 0.2, 0.3
  NESTER_RESULT dq 0.0
  NESTER_CONST3 dq 3.0
  NESTER_CONST2 dq 2.0
  NESTER_CONST1 dq 1.0
  NESTER_TEXT_ARRAY_A db 64 dup(?)
  NESTER_TEXT_ARRAY_B db 64 dup(?)
  NESTER_TEXT_ARRAY_C db 64 dup(?)
  NESTER_TEXT_ARRAY_D db 64 dup(?)
  NESTER_TEXT_RESULT db 32 dup(?)
  NESTER_MESSAGE db 512 dup(?)
  NESTER_WINDOW_TITLE db "8 laborathory work of System programming, Nesterov Dima IM-13", 0
  NESTER_MESSAGE_FORMAT db "Lab Variant: 16", 10, 10, 10,
                "Formula:", 10, 10, "(c / d + ln(3 *  a / 2))", 10, "-------------------------,", "      where: a = %s, b = %s, c = %s, d = %s", 10, "     (c - b + 1)", 10, 10, 10,
                "Calculation:", 10, 10,
                "(%s / %s + ln(3 * %s / 2))", 10, "---------------------------- =  %s", 10, "     (%s - %s + 1)", 10, 10, 10,0
  NESTER_ZERO_DENOMITATOR_FORMAT db "Lab Variant: 16", 10, 10, 10,
                "Formula:", 10, 10, "(c / d + ln(3 *  a / 2))", 10, "-------------------------,", "      where: a = %s, b = %s, c = %s, d = %s", 10, "     (c - b + 1)", 10, 10, 10,
                "Calculation:", 10, 10,
                "(%s / %s + ln(3 * %s / 2))", 10, "---------------------------- = ERROR because division by 0 is not allowed", 10, "      ( %s - %s + 1 )", 10, 10, 10, 0
  NESTER_INCORRECT_AREA_FORMAT db "Lab Variant: 16", 10, 10, 10,
                "Formula:", 10, 10, "(c / d + ln(3 *  a / 2))", 10, "-------------------------,", "      where: a = %s, b = %s, c = %s, d = %s", 10, "     (c - b + 1)", 10, 10, 10,
                "Calculation:", 10, 10,
                "(%s / %s + ln(3 * %s / 2))", 10, "---------------------------- = ERROR, num under logarifm must be > 0", 10, "      ( %s - %s + 1 )", 10, 10, 10, 0
.CODE
NESTER_TO_STR MACRO
  INVOKE FloatToStr2, NESTER_ARRAY_A[esi*8], addr NESTER_TEXT_ARRAY_A[esi*8]
  INVOKE FloatToStr2, NESTER_ARRAY_B[esi*8], addr NESTER_TEXT_ARRAY_B[esi*8]
  INVOKE FloatToStr2, NESTER_ARRAY_C[esi*8], addr NESTER_TEXT_ARRAY_C[esi*8]
  INVOKE FloatToStr2, NESTER_ARRAY_D[esi*8], addr NESTER_TEXT_ARRAY_D[esi*8]
  INVOKE FloatToStr2, NESTER_RESULT, addr NESTER_TEXT_RESULT

ENDM

NESTER_CREATE_MESSAGE MACRO
  NESTER_TO_STR
INVOKE wsprintf, addr NESTER_MESSAGE, addr NESTER_MESSAGE_FORMAT,
          addr NESTER_TEXT_ARRAY_A[esi * 8], addr NESTER_TEXT_ARRAY_B[esi * 8], addr NESTER_TEXT_ARRAY_C[esi * 8],  addr NESTER_TEXT_ARRAY_D[esi * 8],
          addr NESTER_TEXT_ARRAY_C[esi * 8], addr NESTER_TEXT_ARRAY_D[esi * 8], addr NESTER_TEXT_ARRAY_A[esi * 8],
          addr NESTER_TEXT_RESULT,addr NESTER_TEXT_ARRAY_C[esi * 8], addr NESTER_TEXT_ARRAY_B[esi * 8]

ENDM

NESTER_CREATE_ERROR_MESSAGE MACRO param
NESTER_TO_STR
INVOKE wsprintf, addr NESTER_MESSAGE, param ,
          addr NESTER_TEXT_ARRAY_A[esi * 8], addr NESTER_TEXT_ARRAY_B[esi * 8], addr NESTER_TEXT_ARRAY_C[esi * 8],  addr NESTER_TEXT_ARRAY_D[esi * 8],
          addr NESTER_TEXT_ARRAY_C[esi * 8], addr NESTER_TEXT_ARRAY_D[esi * 8], addr NESTER_TEXT_ARRAY_A[esi * 8],
          addr NESTER_TEXT_ARRAY_C[esi * 8], addr NESTER_TEXT_ARRAY_B[esi * 8]
ENDM

NESTER_CREATE_ZERO_DENOMINATOR_ERROR_MESSAGE MACRO
  NESTER_CREATE_ERROR_MESSAGE addr NESTER_ZERO_DENOMITATOR_FORMAT
ENDM

NESTER_CREATE_INVALID_AREA_ERROR_MESSAGE MACRO
  NESTER_CREATE_ERROR_MESSAGE addr NESTER_INCORRECT_AREA_FORMAT
ENDM

NESTER_CALCULATE MACRO

  fld NESTER_ARRAY_D[esi * 8]     ;d
  FTST
  FNSTSW ax
  SAHF
  JZ NESTER_ZERO_DENOMINATOR_ERROR ; checking for zero denominator for c/d expression

  FLD NESTER_ARRAY_A[esi*8]   ;a
  FTST
  FSTSW AX
  SAHF
  JBE NESTER_INCORRECT_AREA ; checking if a <= 0

  FLD NESTER_ARRAY_C[esi*8]   ;c
  FSUB NESTER_ARRAY_B[esi*8]  ; subtraction b from c
  FADD NESTER_CONST1 ; adding 1 to c-b
  FTST
  FNSTSW ax
  SAHF
  JZ NESTER_ZERO_DENOMINATOR_ERROR ;checking if denominator c-b+1 = 0

;all checking were made before invoke library procedure to avoid useless operations

	invoke NESTER_CALCULATE_LIBRARY_EXPR, addr NESTER_ARRAY_A[esi * 8], addr NESTER_ARRAY_B[esi * 8], addr NESTER_ARRAY_C[esi * 8], addr NESTER_ARRAY_D[esi * 8], 
	addr NESTER_CONST3, addr NESTER_CONST2, addr NESTER_CONST1,
	addr NESTER_RESULT

NESTER_CREATE_MESSAGE
  INVOKE MessageBox, 0, addr NESTER_MESSAGE, addr NESTER_WINDOW_TITLE, 0
  JMP NESTER_SKIP_ERRORS

  NESTER_ZERO_DENOMINATOR_ERROR:
  NESTER_CREATE_ZERO_DENOMINATOR_ERROR_MESSAGE
  INVOKE MessageBox, 0, addr NESTER_MESSAGE, addr NESTER_WINDOW_TITLE, 0
  JMP NESTER_SKIP_ERRORS

  NESTER_INCORRECT_AREA:
  NESTER_CREATE_INVALID_AREA_ERROR_MESSAGE
  INVOKE MessageBox, 0, addr NESTER_MESSAGE, addr NESTER_WINDOW_TITLE, 0

  NESTER_SKIP_ERRORS:
    MOV NESTER_MESSAGE, 0h

ENDM

NESTER_SIXTH_LAB:
  MOV esi, 0
  .WHILE esi < 6
    NESTER_CALCULATE
    ADD esi, 1
  .ENDW
  INVOKE ExitProcess, NULL
END NESTER_SIXTH_LAB