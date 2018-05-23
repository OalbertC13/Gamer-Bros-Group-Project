.386 
.model flat,stdcall 
option casemap:none 
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc 
include \masm32\include\comctl32.inc 
include \masm32\include\gdi32.inc 
includelib \masm32\lib\gdi32.lib 
includelib \masm32\lib\comctl32.lib 
includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib
WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
.const 
IDB_TREE equ 4006                ; ID of the bitmap resource 
.data 
ClassName  db "Heroes Tree",0 
AppName    db "Tree View Demo",0 
TreeViewClass  db "SysTreeView32",0 
Parent  db "Superman",0 
Child1  db "Super Boy",0 
Child2  db "Jimmy Olsen",0 
Parent2 db "Batman",0
Child3 db "Batgirl",0
Child4 db "Robin",0
Parent3 db "Wonder Woman",0
Child5 db "Wonder Girl",0
Parent4 db "The Flash",0
Child6 db "Kid Flash",0
Child7 db "Kid Flash II",0
Child8 db "Kid Flash III",0
Parent5 db "Spider-Man",0
Child9 db "Alpha",0
Parent6 db "Captain America",0
Child10 db "Winter Soldier",0
Child11 db "Demolition Man",0
Child12 db "Falcon",0
Child13 db "Jack Flag",0
Parent7 db "Hulk",0
Child14 db "Rick Jones",0
DragMode  dd FALSE                ; a flag to determine if we are in drag mode

.data? 
hInstance  HINSTANCE ? 
hwndTreeView dd ?            ; handle of the tree view control 
hParent  dd ?					   ; handles the first root of the tree view item
hParent2 dd ?					   ; handles the second root of the tree view item
hParent3 dd ?					   ; handles the third root of the tree view item
hParent4 dd ?					   ; handles the fourth root of the tree view item
hParent5 dd ?                      ; handles the fifth root of the tree view item 
hParent6 dd ?					   ; handles the sixth root of the tree view item 
hParent7 dd ?					   ; handles the seventh root of the tree view item 
hImageList dd ?                    ; handle of the image list used in the tree view control 
hDragImageList  dd ?        ; handle of the image list used to store the drag image

.code 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke WinMain, hInstance,NULL,NULL, SW_SHOWDEFAULT 
    invoke ExitProcess,eax 
    invoke InitCommonControls

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
    LOCAL wc:WNDCLASSEX 
    LOCAL msg:MSG 
    LOCAL hwnd:HWND 
    mov   wc.cbSize,SIZEOF WNDCLASSEX
    mov   wc.style, CS_HREDRAW or CS_VREDRAW 
    mov   wc.lpfnWndProc, OFFSET WndProc 
    mov   wc.cbClsExtra,NULL 
    mov   wc.cbWndExtra,NULL 
    push  hInst 
    pop   wc.hInstance 
    mov   wc.hbrBackground,COLOR_APPWORKSPACE 
    mov   wc.lpszMenuName,NULL 
    mov   wc.lpszClassName,OFFSET ClassName 
    invoke LoadIcon,NULL,IDI_APPLICATION 
    mov   wc.hIcon,eax 
    mov   wc.hIconSm,eax 
    invoke LoadCursor,NULL,IDC_ARROW 
    mov   wc.hCursor,eax 
    invoke RegisterClassEx, addr wc 
    invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR AppName,          WS_OVERLAPPED+WS_CAPTION+WS_SYSMENU+WS_MINIMIZEBOX+WS_MAXIMIZEBOX+WS_VISIBLE,CW_USEDEFAULT,
           CW_USEDEFAULT,200,400,NULL,NULL,\
           hInst,NULL 
    mov   hwnd,eax 
    .while TRUE 
        invoke GetMessage, ADDR msg,NULL,0,0 
        .BREAK .IF (!eax) 
        invoke TranslateMessage, ADDR msg 
        invoke DispatchMessage, ADDR msg 
    .endw 
    mov eax,msg.wParam 
    ret 
WinMain endp

		;------------------------;
;-------|   Image      Window    |-------;
		;------------------------;

WndProc proc uses edi hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
    LOCAL tvinsert:TV_INSERTSTRUCT 
    LOCAL hBitmap:DWORD 
    LOCAL tvhit:TV_HITTESTINFO 
    .if uMsg==WM_CREATE 
        invoke CreateWindowEx,NULL,ADDR TreeViewClass,NULL,\ 
            WS_CHILD+WS_VISIBLE+TVS_HASLINES+TVS_HASBUTTONS+TVS_LINESATROOT,0,\ 
            0,200,400,hWnd,NULL,\ 
            hInstance,NULL            ; Creates the tree view control 
        mov hwndTreeView,eax 
        invoke ImageList_Create,10,10,ILC_COLOR16,2,10    ; create the associated image list 
        mov hImageList,eax 
        invoke LoadBitmap,hInstance,IDB_TREE        ; load the bitmap from the resource 
        mov hBitmap,eax 
        invoke ImageList_Add,hImageList,hBitmap,NULL    ; Add the bitmap into the image list 
        invoke DeleteObject,hBitmap    ; always delete the bitmap resource 
        invoke SendMessage,hwndTreeView,TVM_SETIMAGELIST,0,hImageList 

        mov tvinsert.hParent,NULL											; This line creates the main tree branch for its children
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		;----------------------;
;-------|       Parent 		   |-------;
		;----------------------;
        mov hParent,eax														
        mov tvinsert.hParent,eax												
        mov tvinsert.hInsertAfter,TVI_LAST											
        mov tvinsert.item.pszText,offset Child1											
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert						
        mov tvinsert.item.pszText,offset Child2													
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent2							; In this case the first parent handles and allows the other parent's branch 
																			;to produce children in a different tree branch 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		;----------------------;
;-------|      Parent 2		   |-------;
		;----------------------;
        mov hParent2,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST 
        mov tvinsert.item.pszText,offset Child3 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
	    mov tvinsert.item.pszText,offset Child4 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent3 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		;----------------------;
;-------|      Parent 3		   |-------;
		;----------------------;
        mov hParent3,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST 
        mov tvinsert.item.pszText,offset Child5 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent4 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		;----------------------;
;-------|      Parent 4		   |-------;
		;----------------------;
        mov hParent4,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST 
        mov tvinsert.item.pszText,offset Child6 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.item.pszText,offset Child7 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.item.pszText,offset Child8 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent5 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
		;----------------------;
;-------|      Parent 5		   |-------;
		;----------------------;
        mov hParent5,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST  
		  mov tvinsert.item.pszText,offset Child9 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert
 		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent6 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert	
		;----------------------;
;-------|      Parent 6		   |-------;
		;----------------------;
        mov hParent6,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST 
        mov tvinsert.item.pszText,offset Child10 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.item.pszText,offset Child11 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.item.pszText,offset Child12 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.item.pszText,offset Child13 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		mov tvinsert.hParent,NULL
        mov tvinsert.hInsertAfter,TVI_ROOT 
        mov tvinsert.item.imask,TVIF_TEXT+TVIF_IMAGE+TVIF_SELECTEDIMAGE 
        mov tvinsert.item.pszText,offset Parent7 
        mov tvinsert.item.iImage,0 
        mov tvinsert.item.iSelectedImage,1 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert 
		;----------------------;
;-------|      Parent 7		   |-------;
		;----------------------;
        mov hParent7,eax 
        mov tvinsert.hParent,eax
        mov tvinsert.hInsertAfter,TVI_LAST  
	    mov tvinsert.item.pszText,offset Child14 
        invoke SendMessage,hwndTreeView,TVM_INSERTITEM,0,addr tvinsert

    .elseif uMsg==WM_MOUSEMOVE ;Drag path locator
        .if DragMode==TRUE 
            mov eax,lParam 
            and eax,0ffffh 
            mov ecx,lParam 
            shr ecx,16 
            mov tvhit.pt.x,eax 
            mov tvhit.pt.y,ecx 
            invoke ImageList_DragMove,eax,ecx 
            invoke ImageList_DragShowNolock,FALSE 
            invoke SendMessage,hwndTreeView,TVM_HITTEST,NULL,addr tvhit 
            .if eax!=NULL 
                invoke SendMessage,hwndTreeView,TVM_SELECTITEM,TVGN_DROPHILITE,eax 
            .endif 
            invoke ImageList_DragShowNolock,TRUE 
        .endif 
    .elseif uMsg==WM_LBUTTONUP ; message
        .if DragMode==TRUE 
            invoke ImageList_DragLeave,hwndTreeView 
            invoke ImageList_EndDrag 
            invoke ImageList_Destroy,hDragImageList 
            invoke SendMessage,hwndTreeView,TVM_GETNEXTITEM,TVGN_DROPHILITE,0 
            invoke SendMessage,hwndTreeView,TVM_SELECTITEM,TVGN_CARET,eax 
            invoke SendMessage,hwndTreeView,TVM_SELECTITEM,TVGN_DROPHILITE,0 
            invoke ReleaseCapture 
            mov DragMode,FALSE 
        .endif 
    .elseif uMsg==WM_NOTIFY 
        mov edi,lParam 
        assume edi:ptr NM_TREEVIEW 
  .if [edi].hdr.code==TVN_BEGINDRAG 
            invoke SendMessage,hwndTreeView,TVM_CREATEDRAGIMAGE,0,[edi].itemNew.hItem 
            mov hDragImageList,eax 
            invoke ImageList_BeginDrag,hDragImageList,0,0,0 
            invoke ImageList_DragEnter,hwndTreeView,[edi].ptDrag.x,[edi].ptDrag.y 
            invoke SetCapture,hWnd 
            mov DragMode,TRUE 
        .endif 
        assume edi:nothing 
    .elseif uMsg==WM_DESTROY 
        invoke PostQuitMessage,NULL 
    .else 
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
        ret 
    .endif 
    xor eax,eax 
    ret 
WndProc endp 
end start