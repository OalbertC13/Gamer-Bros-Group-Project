.386

.model flat, stdcall
option casemap:none

include\masm32\include\windows.inc	; Calls data structures and constant identifiers
include\masm32\include\kernel32.inc	; functions in kernel32.dll
include\masm32\include\user32.inc	; functions in user32.dll

includelib\masm32\lib\kernel32.lib	; Requirement to invoke ExitProcess api.
includelib\masm32\lib\user32.lib	; Requirement to invoke MessageBox api.


.data

MsgBoxCaption db "Daily Planet's Quote of the Day",0 ; Displays the title 
MsgBoxText	db "Not all heroes were born with capes.",0 ; Displays the message on the window screen


.code

start:
invoke MessageBox, NULL, addr MsgBoxText, addr MsgBoxCaption, MB_OK  ; Call messagebox function at Center, Message, Title, Button Type
invoke ExitProcess,NULL ; Ends the program

end start	
