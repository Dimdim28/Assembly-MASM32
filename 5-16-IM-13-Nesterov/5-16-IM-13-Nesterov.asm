.386
.MODEL flat, stdcall
OPTION casemap :none
INCLUDE \masm32\include\masm32rt.inc

.DATA
  NESTER_WINDOW_TITLE db "5 laborathory work of System programming, Nesterov Dima IM-13", 0
  NESTER_MESSAGEFormat db "Lab Variant: 16", 10, 10, 10,
                "Formula:", 10, 10, "(b + c * b - a / 4)", 10, "---------------------,", "      where: a = %i, b = %i, c = %i", 10, "     (a * b - 1)", 10, 10, 10,
                "Calculation:", 10, 10,
                "(%i + %i * %i - %i/4)", 10, "------------------------ =  %i", ",    Recieved result = %i", 10, "     (%i * %i - 1)", 10, 10, 10,0
  errorFormat db "Lab Variant: 16", 10, 10, 10,
                "Formula:", 10, 10, "(b + c * b - a / 4)", 10, "---------------------,", "  where: a = %i, b = %i, c = %i", 10, "     (a * b - 1)", 10, 10, 10,
                "Calculation:", 10, 10,
                "( %i + %i * %i - %i / 4 )",10, "------------------------ = ERROR because division by 0 is not allowed", 10, "      ( %i * %i - 1 )", 10, 10, 10,
                "Recieved result = ERROR", "    (DIVISION BY 0 IS NOT ALLOWED)", 10, 10, 0
  NESTER_ARRAY_A dd 1, -64, -8, 4, 4
  NESTER_ARRAY_B dd 1, -5, -3, -14, -9  ;;my arrays with a b and c =)
  NESTER_ARRAY_C dd 3, 66, -54, 60, -34

.DATA?
  NESTER_RESULT dd 5 dup(?)
  NESTER_NUMERATOR dd 1 dup(?)
  NESTER_DENOMINATOR dd 1 dup(?)
  NESTER_MESSAGE db 512 dup(?)

.CODE

NESTER_CREATE_MESSAGE MACRO
INVOKE wsprintf, addr NESTER_MESSAGE, addr NESTER_MESSAGEFormat,
          NESTER_ARRAY_A[esi * 4], NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_C[esi * 4],
          NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_C[esi * 4], NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_A[esi * 4],
          NESTER_RESULT, eax,NESTER_ARRAY_A[esi * 4], NESTER_ARRAY_B[esi * 4]

ENDM

NESTER_CREATE_INVALID_NUMBER_ERROR_MESSAGE MACRO
INVOKE wsprintf, addr NESTER_MESSAGE, addr errorFormat,
        NESTER_ARRAY_A[esi * 4], NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_C[esi * 4],
        NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_C[esi * 4], NESTER_ARRAY_B[esi * 4], NESTER_ARRAY_A[esi * 4], NESTER_ARRAY_A[esi * 4], NESTER_ARRAY_B[esi * 4]
ENDM

NESTER_FIFTH_LAB:
  MOV esi, 0
  .WHILE esi < 5


    ;;calculation denominator, we have here a * b - 1
    MOV edx, NESTER_ARRAY_A[esi * 4]
    MOV ecx, NESTER_ARRAY_B[esi * 4]
    imul edx, ecx ;; multiplying a and b
    sub edx, 1 ;; subtraction  1 from recieved result

    MOV NESTER_DENOMINATOR, edx

    .IF NESTER_DENOMINATOR != 0 ;; we have here not allowed case, 0 in the denominator


      ;; calculation numerator, we have here b + c * b - a / 4
      MOV ebx, NESTER_ARRAY_C[esi * 4]
      MOV ecx, NESTER_ARRAY_B[esi * 4]
      IMUL ebx, ecx ;; multiplying c and b

      MOV eax, NESTER_ARRAY_A[esi * 4]
      MOV ecx, 4
      CDQ
      IDIV ecx ;; dividing a on  4

      SUB ebx, eax ;; c * b - a / 4
      MOV ecx, NESTER_ARRAY_B[esi * 4]
      ADD ebx, ecx ;; adding recieved results, I will have here now b + c * b - a / 4

      MOV NESTER_NUMERATOR, ebx

      MOV eax, NESTER_NUMERATOR
      MOV ecx, NESTER_DENOMINATOR
      CDQ
      IDIV ecx ;; final dividing, result is : (b + c * b - a / 4) / (a * b - 1)

      MOV NESTER_RESULT, eax



      TEST eax, 1  ;; checking for result, if it is odd or even one
      JNZ FOR_ODD_NUMBER
      JZ FOR_EVEN_NUMBER

      FOR_EVEN_NUMBER:
        MOV ecx, 2  ;; for even numbers
        CDQ ;; should divide result on 2
        IDIV ecx
        JMP DISPLAY_MESSAGE

      FOR_ODD_NUMBER:
        IMUL eax, 5 ;; for odd numbers
        JMP DISPLAY_MESSAGE ;; should multiply result on 5

      DISPLAY_MESSAGE:       ;; displaying our result with final calc.
        NESTER_CREATE_MESSAGE
        INVOKE MessageBox, 0, addr NESTER_MESSAGE, addr NESTER_WINDOW_TITLE, 0

    .ELSE
      NESTER_CREATE_INVALID_NUMBER_ERROR_MESSAGE
      INVOKE MessageBox, 0, addr NESTER_MESSAGE, addr NESTER_WINDOW_TITLE, 0
    .ENDIF


    MOV NESTER_MESSAGE, 0h
    INC esi
  .ENDW

INVOKE ExitProcess, NULL

END NESTER_FIFTH_LAB
