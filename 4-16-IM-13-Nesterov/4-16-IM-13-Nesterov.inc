.386
.MODEL flat, stdcall
OPTION casemap :none
INCLUDE \masm32\include\masm32rt.inc

NESTER_XOR_ENCRYPTING MACRO
 ; comment in the encrypting
  XOR AL, NesterKey[BX]
 ;; hidden comment in the encrypting
ENDM

NESTER_XOR_CHECKING MACRO
  LOCAL checkPass
  CMP EBX, EAX
  JNE not_equal
  CLD ; common comment
      MOV BX, 0
      checkPass:
      CMP BX, NesterPasswLength
      JZ equal
  MOV AH, NesterPassw[BX]
  MOV AL, NesterTryPassw[BX]
    NESTER_XOR_ENCRYPTING
       CMP AH, AL
  JNE not_equal ;; hidden comment
       INC BX
    JMP checkPass
ENDM

NESTER_DISPLAY_MESSAGE_WINDOW MACRO message, TITLE
  INVOKE MessageBox, 0, addr message, addr TITLE, 0 ; common comment
ENDM

NESTER_EQUAL_PASSWORDS MACRO
  ; this is common comment
NESTER_DISPLAY_MESSAGE_WINDOW NesterFullName, NesterInfoTitle
NESTER_DISPLAY_MESSAGE_WINDOW NesterBirthday, NesterInfoTitle
NESTER_DISPLAY_MESSAGE_WINDOW NesterGradeBook, NesterInfoTitle
  ;; this is hidden comment
ENDM

NESTER_NOT_EQUAL_PASSWORDS MACRO
  ; common comment
  NESTER_DISPLAY_MESSAGE_WINDOW NesterIncorrectPasswMessage, NesterErrorTitle
  ;; hidden comment
ENDM
