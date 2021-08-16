;Copyright Liquid Unicorn Productions, 2013
;Coded by Jennifer "Ryn Inaba" Stears

;TODO:	Realistic odds
;		Test on Windows 8
	  	

.686p
.mmx
.model flat,stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc
include ntdll.inc
include masm32.inc
includelib masm32.lib
includelib kernel32.lib
includelib user32.lib
includelib ntdll.lib

.data
caption		db	"Russian Roluette",0
text		db	"Do you want to play a game? Hit YES to go on or hit NO to exit.",0
aClick		db	"CLICK! Chamber empty!",0
aBang		db	"BANG! You're dead. Game over.",0
aPlayagain	db	"Do you want to play again?",0

.data?
chambers dd ?
random_init dd ?

.code
start:
;We'll seed the random number generator here just to get
; our random numbers random on start and all that
; it isn't the best way since everytime we jump here
; it'll give us a new number, instead of the old one
; this will fuck up our odds, but hell.
invoke GetTickCount
invoke nseed, eax

;If user clicks yes it'll jump to the simulated gun
; generating a random number and checking it against
; a chosen static number(05h).

;If user clicks no the program will just exit
invoke MessageBox,NULL,addr text,addr caption,MB_YESNO
.if eax==IDYES
	jmp @gun
.elseif eax==IDNO
	jmp @exit
.endif

@gun:
invoke nrandom, 06h ;Six chambers, 00h to 05h.
;Looking for our number.
;TODO: "Realistic odds"
cmp eax, 05h
je @bang
jne @click


@bang:
invoke MessageBoxEx,NULL,addr aBang,addr caption,MB_OK,NULL
push esp
invoke RtlAdjustPrivilege,19,2,0,esp ;Not needed but still works in Win9X, suprisingly works on Vista/7.
invoke ExitWindowsEx,EWX_SHUTDOWN,NULL ;Call shutdown
jmp @exit 

;Does nothing but asks the user to either play again or quit.
@click:
invoke MessageBox,NULL,addr aClick,addr aPlayagain,MB_YESNO
.if eax==IDYES
	jmp start
.elseif eax==IDNO
	jmp @exit
.endif

@exit:
invoke ExitProcess,0
end start