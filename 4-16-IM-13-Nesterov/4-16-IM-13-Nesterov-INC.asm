.386
.MODEL flat, stdcall
OPTION casemap :none
INCLUDE \masm32\include\masm32rt.inc

include 4-16-IM-13-Nesterov.inc

DialogProcess	PROTO :DWORD,:DWORD,:DWORD,:DWORD
.DATA
	NesterInfoTitle db "Information", 0
    NesterFullName db "Full Name:", 9, 9, 9, "Nesterov Dmytro Vasylovych", 0
	NesterBirthday db	"Birthday date:", 9, 9, 9, "01.03.2004", 0
	NesterGradeBook db	"Gradebook number:", 9, 9, "IM-1320", 0
	NesterErrorTitle db "Error occured", 0
	NesterIncorrectPasswMessage  db "Incorrect password", 10, 13, 0
	NesterTryPassw  db 32 dup (0)
	NesterPassw db "8$?173",0
	NesterKey db "vaLera",0
	NesterPasswLength dw 6
.CODE
start:
	Dialog "Lab3 - IM-13 - Nesterov", "MS Arial",12, \
        WS_OVERLAPPED OR WS_SYSMENU OR DS_CENTER, \
        4,7,7,200,100,1024
		DlgStatic "Enter your password",SS_CENTER,20,15,160,10,66
		DlgEdit WS_BORDER,20,30,160,11,666
		DlgButton "Accept", WS_TABSTOP,20,50,50,20,IDOK
		DlgButton "Deny", WS_TABSTOP,130,50,50,20,IDCANCEL

	CallModalDialog 0,0,DialogProcess,NULL

CheckPass PROC
  PUSH OFFSET NesterPassw
  CALL StrLen
  mov EBX, EAX
  PUSH OFFSET NesterTryPassw
  CALL StrLen
  NESTER_XOR_CHECKING
  equal:
    NESTER_EQUAL_PASSWORDS
    JMP exit_compare_function
  not_equal:
    NESTER_NOT_EQUAL_PASSWORDS
    JMP exit_compare_function
  exit_compare_function:
    INVOKE ExitProcess,NULL
  RET
CheckPass ENDP

DialogProcess PROC hWindow:DWORD,userMessage:DWORD,wParam:DWORD,lParam:DWORD
	.IF userMessage == WM_INITDIALOG
       .ELSEIF userMessage == WM_COMMAND
      		.IF wParam == IDOK
	   			INVOKE GetDlgItemText, hWindow, 666, addr NesterTryPassw,512
				CALL CheckPass
      		.ELSEIF wParam == IDCANCEL
				INVOKE ExitProcess,NULL
      		.ENDIF
    .ELSEIF userMessage == WM_CLOSE
       INVOKE ExitProcess,NULL
    .ENDIF
    return 0
DialogProcess ENDP

END start