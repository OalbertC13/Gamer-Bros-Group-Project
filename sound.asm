; This program uses the call and invoke command
; to play sounds based on frequency and duration.
; Together, these sounds create the first three
; verses of the song, Last Surprise, by Shoji Meguro
; from the game, Persona 5.

; Below are the libraries and files referenced for
; the program to work properly.

include\masm32\include\masm32rt.inc

.data

; --------------------------------------------------;
; These window prompts ask the user if they can hear;
; the music played by the program before and after  ;
; the music plays.                                  ;
; --------------------------------------------------;

windowmessage   db "Can you hear the music?",0
windowtitle     db "LAST SURPRISE, verses 1-3",0

msg     db  'RET simulator',0

.code

start:
   
; --------------------------------------------------;
; The values following the 'Beep' line, refer to the;
; pitch and duration of the sound produced by the   ;
; program. The pitch is recorded in Hertz, while    ;
; duration is noted in milliseconds.The octave and  ;
; note which each 'Beep' corresponds to is also     ;
; noted.                                            ;
; Due to certain limitations, only 36 "notes" may   ;
; be invoked in a single process. In addition, the  ;
; volume of this particular program cannot be       ;
; adjusted from the program itself, thus the program;
; may seem like it is not working at first. The     ;
; internal volume of the computer will need to be   ;
; raised in order to hear the sounds.               ;
; --------------------------------------------------;
    J1:
   call    verse
    ; verse 1
    invoke  Beep,1320,200   ; E(6)
    invoke  Beep,1400,200   ; F(6)
    invoke  Beep,1320,200   ; E(6)
    invoke  Beep,1175,200   ; D(6)

    invoke  Beep,0,10       ; REST

    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,1175,200   ; D(6)
    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,880,200    ; A(5)

    invoke  Beep,0,10       ; REST
    
    invoke  Beep,785,200    ; G(5)
    invoke  Beep,880,450    ; A(5)

    invoke  Beep,0,60       ;REST

    ; verse 2
    invoke  Beep,1320,200   ; E(6)
    invoke  Beep,1400,200   ; F(6)
    invoke  Beep,1320,200   ; E(6)
    invoke  Beep,1175,200   ; D(6)

    invoke  Beep,0,10       ; REST

    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,1175,200   ; D(6)
    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,880,200    ; A(5)

    invoke  Beep,0,10       ; REST
    
    invoke  Beep,830,650    ; G sharp (5)

    ; verse 3
    invoke  Beep,1320,200   ; E(6) 
    invoke  Beep,1400,200   ; F(6)
    invoke  Beep,1320,200   ; E(6)
    invoke  Beep,1175,200   ; D(6)

    invoke  Beep,0,10       ; REST
    
    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,1175,200   ; D(6)
    invoke  Beep,1050,200   ; C(6)
    invoke  Beep,880,200    ; A(5)

    invoke  Beep,0,10       ; REST
        
    invoke  Beep,780,200    ; G(5)
    invoke  Beep,885,450    ; A(5)

; ------------------------------------------------------------------------;
; The following asks the user if they could hear the music played earlier,;
; if they select "Yes", the program ends. If they select "No", they will  ;
; be asked to turn up system volume and the program will repeat.          ;
; ------------------------------------------------------------------------;
    
    invoke  Sleep,500
    invoke MessageBox,0,ADDR windowmessage,ADDR windowtitle,MB_YESNO
    .if eax==IDYES
           MsgBox 0, "Awesome!", ADDR windowtitle,MB_OK
    .else
           MsgBox 0, "Turn up your volume and try again!", ADDR windowtitle,MB_OK
        jmp    J1       
    .endif
     
    invoke ExitProcess,0

verse    PROC
    invoke  StdOut,ADDR msg
    pop     eax ; Gets the return address from the stack
    jmp     eax ; Jumps back to the main procedure
                ; The execution continues from the 
                ; invoke lines.

verse    ENDP

END start

