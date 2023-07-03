.386
.MODEL flat, stdcall
OPTION casemap :none
INCLUDE \masm32\include\masm32rt.inc

PATTERNS segment
 nestMsgBoxTitle db "Lab 1 - Nesterov Dmytro", 0
 nestMsgBoxPattern db 9, "MY BIRTHDAY = %s", 10, 10, 10,
   "positive nums", 9, 9, "negative nums", 10, 10,
   "A =  %d", 9, 9, 9, "-A =  %d", 10,
   "B =  %d", 9, 9, 9, "-B =  %d",  10,
   "C =  %d", 9, 9, "-C =  %d", 10,
   "D =  %s", 9, 9, "-D =  %s", 10,
   "E =  %s", 9, 9, "-E =  %s", 10,
   "F =  %s", 9, 9, "-F =  %s", 10
PATTERNS ends

INPUTDATA segment
    nestBirthday db "01032004", 0

    nestPositiveA db 01
    nestPositiveA1 dw 01
    nestPositiveA2 dd 01
    nestPositiveA3 dq 01

    nestNegativeA db -01
    nestNegativeA1 dw -01
    nestNegativeA2 dd -01
    nestNegativeA3 dq -01

    nestPositiveB dw 0103
    nestPositiveB1 dd 0103
    nestPositiveB2 dq 0103
    nestNegativeB dw -0103
    nestNegativeB1 dd -0103
    nestNegativeB2 dq -0103

    nestPositiveC dd 01032004
    nestPositiveC1 dq 01032004
    nestNegativeC dd -01032004
    nestNegativeC1 dq -01032004

    nestPositiveD dq 0.001
    nestNegativeD dq -0.001
    nestPositiveD1 dd 0.001
    nestNegativeD1 dd -0.001

    nestPositiveE dq 0.078
    nestNegativeE dq -0.078

    nestPositiveF dq 781.821
    nestNegativeF dq -781.821

    nestPositiveF1 dt 781.821
    nestNegativeF1 dt -781.821
INPUTDATA ends

.data?
    MsgBoxNestText db 512 dup(?)
    buffNestPositiveD db 256 dup(?)
    buffNestPositiveE db 256 dup(?)
    buffNestPositiveF db 256 dup(?)
    buffNestNegativeD db 256 dup(?)
    buffNestNegativeE db 256 dup(?)
    buffNestNegativeF db 256 dup(?)

.code
NesterovLab1:
    invoke FloatToStr2, nestPositiveD, addr buffNestPositiveD
    invoke FloatToStr2, nestPositiveE, addr buffNestPositiveE
    invoke FloatToStr2, nestPositiveF, addr buffNestPositiveF
    invoke FloatToStr2, nestNegativeD, addr buffNestNegativeD
    invoke FloatToStr2, nestNegativeE, addr buffNestNegativeE
    invoke FloatToStr2, nestNegativeF, addr buffNestNegativeF

    invoke wsprintf, addr MsgBoxNestText, addr nestMsgBoxPattern,
     addr nestBirthday, nestPositiveA2, nestNegativeA2,
     nestPositiveB1, nestNegativeB1,
     nestPositiveC, nestNegativeC,
     addr buffNestPositiveD, addr buffNestNegativeD,
     addr buffNestPositiveE, addr buffNestNegativeE,
     addr buffNestPositiveF, addr buffNestNegativeF
    invoke MessageBox, 0, addr MsgBoxNestText, addr nestMsgBoxTitle, 0
    invoke ExitProcess, 0
end NesterovLab1