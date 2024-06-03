INCLUDE Irvine32.inc
INCLUDE macros.inc
BUFFER_SIZE = 501
.data
matrix byte '1','2','3','4','5','6','7','8','9'
empty byte ' ',' ',' ',' ',' ',' ',' ',' ',' '
player1 byte 25 DUP(?),0
player2 byte 25 DUP(?),0
option1 byte ?
option2 byte ?
choice dword ?
move dword 0
validation dword ?
player1wins byte '0'
player1draw byte '0'
player1loss byte '0'
player2wins byte '0'
player2draw byte '0'
player2loss byte '0'
buffer byte BUFFER_SIZE DUP(?)
m1 dword 0
filename byte 100 DUP(?),".txt",0
filehandle handle ?
back34 dword 0
.code
drawboard proc,ptrarray:dword
call clrscr
mov dl,30
mov dh,2
call gotoxy
mov edx,offset player1
call writestring
mwrite"("
mov al,option1
call writechar
mwrite")"
mwrite" VS "
mov edx,offset player2
call writestring
mwrite"("
mov al,option2
call writechar
mwrite")"
mov dl,26
mov dh,10
call gotoxy
mov esi,ptrarray
add dh,1
call gotoxy
mwrite" "
mov al,[esi]
call writechar
mwrite" | "
mov al,[esi+1]
call writechar
mwrite" | "
mov al,[esi+2]
call writechar
add dh,1
call gotoxy
mwrite"___|___|___"
add dh,1
call gotoxy
add dh,1
call gotoxy
add dh,1
call gotoxy
mwrite" "
mov al,[esi+3]
call writechar
mwrite" | "
mov al,[esi+4]
call writechar
mwrite" | "
mov al,[esi+5]
call writechar
add dh,1
call gotoxy
add dh,0
call gotoxy
mwrite"___|___|____"
add dh,1
call gotoxy
add dh,1
call gotoxy
mwrite" "
mov al,[esi+6]
call writechar
mwrite" | "
mov al,[esi+7]
call writechar
mwrite" | "
mov al,[esi+8]
call writechar
add dh,1
call gotoxy
add dh,4
call gotoxy
ret
drawboard endp
cleareverything proc
mov ecx,9
mov esi,0
mov al,'1'
l1:
mov matrix[esi],al
mov bl,' '
mov empty[esi],bl
inc al
inc esi
loop l1
mov bl,'0'
mov player1wins,bl
mov player1loss,bl
mov player1draw,bl
mov player2wins,bl
mov player2loss,bl
mov player2draw,bl
mov m1,0
ret
cleareverything endp
filingofoutputplayer1 proc
mov esi,offset player1
mov ecx,lengthof player1
sub ecx,1
mov edi,0
l1:
mov al,[esi]
mov filename[edi],al
inc esi
inc edi
loop l1
mov edx,offset filename
call CreateOutputFile
mov filehandle,eax
mov eax,lengthof filename
mov eax,filehandle
mov edx,offset player1wins
mov ecx,lengthof player1wins
call WritetoFile
mov eax,filehandle
mov edx,offset player1loss
mov ecx,lengthof player1loss
call WritetoFile
mov eax,filehandle
mov edx,offset player1draw
mov ecx,lengthof player1draw
call WritetoFile
mov eax,filehandle
call closefile
ret
filingofoutputplayer1 endp
inputplayer1data proc
mov edx,offset player1
call openinputfile
mov filehandle,eax
mov edx,offset buffer
mov ecx,BUFFER_SIZE
call readfromfile
mov al,buffer[0]
mov bl,'0'
cmp al,bl
je endd
mov player1wins,al
mov al,buffer[1]
mov player1loss,al
mov al,buffer[2]
mov player1draw,al
mov eax,filehandle
call closefile
jmp e1
endd:
mov eax,filehandle
call closefile
e1:
ret
inputplayer1data endp
inputplayer2data proc
mov edx,offset player2
call openinputfile
mov filehandle,eax
mov edx,offset buffer
mov ecx,BUFFER_SIZE
call readfromfile
mov al,buffer[0]
mov bl,'0'
cmp al,bl
je endd
mov player2wins,al
mov al,buffer[1]
mov player2loss,al
mov al,buffer[2]
mov player2draw,al
mov eax,filehandle
call closefile
jmp e1
endd:
mov eax,filehandle
call closefile
e1:
ret
inputplayer2data endp
filingofoutputplayer2 proc
mov esi,offset player2
mov ecx,lengthof player2
sub ecx,1
mov edi,0
l1:
mov al,[esi]
mov filename[edi],al
inc esi
inc edi
loop l1
mov edx,offset filename
call CreateOutputFile
mov filehandle,eax
mov eax,lengthof filename
mov eax,filehandle
mov edx,offset player2wins
mov ecx,lengthof player2wins
call WritetoFile
mov eax,filehandle
mov edx,offset player2loss
mov ecx,lengthof player2loss
call WritetoFile
mov eax,filehandle
mov edx,offset player2draw
mov ecx,lengthof player2draw
call WritetoFile
mov eax,filehandle
call closefile
ret
filingofoutputplayer2 endp
filingofinputplayer2 proc
mov ebx,eax
mov edx,offset player2
call openinputfile
mov filehandle,eax
mov edx,offset buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov buffer[eax],0
movzx eax,buffer[0]
cmp eax,0
je endd
mwrite "Wins : "
movzx eax,buffer[0]
sub eax,48
call writedec
call crlf
mwrite "Losses : "
movzx eax,buffer[1]
sub eax,48
call writedec
call crlf
mwrite "Draw : "
movzx eax,buffer[2]
sub eax,48
call writedec
ad:
mov eax,filehandle
call closefile
jmp finish
endd:
mov eax,filehandle
cmp ebx,20
jne t1
mwrite "New file created "
call closefile
mov eax,7
jmp finish
t1:
mwrite "File does not exists"
call closefile
finish:
ret
filingofinputplayer2 endp
filingofinputplayer1 proc
mov ebx,eax
mov edx,offset player1
call openinputfile
mov filehandle,eax
mov edx,offset buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov buffer[eax],0
movzx eax,buffer[0]
cmp eax,0
je endd
mwrite "Wins : "
movzx eax,buffer[0]
sub eax,48
call writedec
call crlf
mwrite "Losses : "
movzx eax,buffer[1]
sub eax,48
call writedec
call crlf
mwrite "Draw : "
movzx eax,buffer[2]
sub eax,48
call writedec
ad:
mov eax,filehandle
call closefile
jmp finish
endd:
mov eax,filehandle
cmp ebx,20
jne t1
mwrite "New file created "
call closefile
mov eax,7
jmp finish
t1:
mwrite "File does not exists"
call closefile
finish:
ret
filingofinputplayer1 endp
filingofinput proc
mov ebx,eax
mov edx,offset filename
mov ecx,sizeof filename
call readstring
mov edx,offset filename
call openinputfile
mov filehandle,eax
mov edx,offset buffer
mov ecx,BUFFER_SIZE
call ReadFromFile
mov buffer[eax],0
movzx eax,buffer[0]
cmp eax,0
je endd
mwrite "Wins : "
movzx eax,buffer[0]
sub eax,48
call writedec
call crlf
mwrite "Losses : "
movzx eax,buffer[1]
sub eax,48
call writedec
call crlf
mwrite "Draw : "
movzx eax,buffer[2]
sub eax,48
call writedec
ad:
mov eax,filehandle
call closefile
jmp finish
endd:
mov eax,filehandle
cmp ebx,20
jne t1
mwrite "New file created "
call closefile
mov eax,7
jmp finish
t1:
mwrite "File does not exists"
call closefile
finish:
ret
filingofinput endp
movesleft proc
mov eax,5
mov ecx,lengthof matrix
mov esi,0
a1:
mov bl,' '
cmp empty[esi],bl
je a2
inc esi
loop a1
mov ebp,0
jmp endd
a2:
mov ebp,1
jmp endd
endd:
mov eax,ebp
ret
movesleft endp
checkwin proc
mov ebp,40
mov esi,0
mov ebx,0
mov ecx,3
c1:
mov al,matrix[esi+ebx]
cmp al,matrix[esi+ebx+1]
je c2
jne cendd
c2:
mov al,matrix[esi+ebx+1]
cmp al,matrix[esi+ebx+2]
je c3
jne cendd
c3:
cmp al,option1
je c6
jne c7
c6:
mov ebp,10
jmp cenddd
c7:
mov ebp,20
jmp cenddd
cendd:
add esi,3
loop c1
mov esi,0
mov ebx,0
mov ecx,3
c11:
mov al,matrix[esi+ebx]
cmp al,matrix[esi+ebx+3]
je c12
jne c1endd
c12:
mov al,matrix[esi+ebx+3]
cmp al,matrix[esi+ebx+6]
je c13
jne c1endd
c13:
cmp al,option1
je c16
jne c17
c16:
mov ebp,10
jmp cenddd
c17:
mov ebp,20
jmp cenddd
c1endd:
add esi,1
loop c11
mov esi,0
mov ebx,0
mov al,matrix[esi+ebx]
cmp al,matrix[esi+ebx+4]
je c23
jne z1
c23:
mov al,matrix[esi+ebx+8]
cmp al,matrix[esi+ebx+4]
je c43
jne z1
c43:
cmp al,option1
je c36
jne c37
c36:
mov ebp,10
jmp cenddd
c37:
mov ebp,20
jmp cenddd
z1:
mov esi,2
mov ebx,0
t1:
mov al,matrix[esi+ebx+4]
cmp al,matrix[esi+ebx+2]
je t41
jne z2
t41:
mov al,matrix[esi+ebx+2]
cmp al,matrix[esi+ebx]
je t42
jne z2
t42:
cmp al,option1
je t6
jne t7
t6:
mov ebp,10
jmp cenddd
t7:
mov ebp,20
jmp cenddd
z2:
cenddd:
add dh,2
call gotoxy
mov eax,ebp
cmp eax,10
je b1
jne b2
b1:
mwrite" Congratulations! "
mov edx,offset player1
call writestring
mwrite " Wins "
inc player1wins
inc player2loss
call readchar
mov ecx,3
jmp finisher
b2:
cmp eax,20
je b3
jne b4
b3:
mwrite"Congratulations! "
mov edx,offset player2
call writestring
mwrite " Wins "
inc player2wins
inc player1loss
call readchar
mov ecx,3
jmp finisher
b4:
call movesleft
cmp eax,0
je y2
jne y1
y2:
mwrite" Game is Drawn"
inc player1draw
inc player2draw
call readchar
mov ecx,3
jmp finisher
y1:
mov ecx,2
jmp finisher
finisher:
ret
checkwin endp
possibleoptions proc
mwrite "Possible options are : "
mov ecx,9
mov esi,0
l1:
mov bl,' '
cmp empty[esi],bl
jne finish
mov al,matrix[esi]
call writechar
cmp ecx,1
je finish
mwrite" , "
finish:
inc esi
loop l1
ret
possibleoptions endp
Multiplayer proc,ptrarray:dword
call clrscr
mov esi,ptrarray
cmp m1,1
je l100
mwrite "Enter player 1 name : "
mov ecx,sizeof player1
mov edx,offset player1
call readstring
call crlf
mwrite "Current record"
call crlf
mov eax,20
invoke filingofinputplayer1
cmp eax,7
je ft
invoke inputplayer1data
jmp as
ft:
invoke filingofoutputplayer1
as:
call crlf
mwrite "Enter player 2 name : "
mov ecx,sizeof player2
mov edx,offset player2
call readstring
call crlf
mwrite "Current record"
call crlf
mov eax,20
invoke filingofinputplayer2
cmp eax,7
je ft1
invoke inputplayer2data
jmp as1
ft1:
invoke filingofoutputplayer2
as1:
l2 :
call crlf
mwrite "Enter which option player 1 want to choose(X/O) : "
call readchar
call writechar
mov bl,al
mov al,'X'
cmp al,bl
je l2out1
mov al,'O'
cmp al,bl
je l2out2
mov al,'x'
cmp al,bl
je l2out1
mov al,'o'
cmp al,bl
je l2out2
call crlf
call crlf
mwrite "Invalid Entry! Try again"
call crlf
jmp l2
l2out1 :
mov al,'X'
mov option1,al
mov al,'O'
mov option2,al
jmp endd
l2out2 :
mov al,'O'
mov option1,al
mov al,'X'
mov option2,al
jmp endd
endd :
l100:
mov m1,1
 invoke drawboard,addr matrix
mov eax,move
cmp eax,0
je l1800
jne l1801
l1800:
mov edx,offset player1
call writestring
mwrite" ! Its your turn. Choose your option : "
call readdec
mov validation,eax
mov esi,0
mov ebx,validation
cmp empty[esi+ebx-1],' '
jne l1807
mov ebx,validation
mov al,option1
mov esi,0
mov matrix[esi+ebx-1],al
mov empty[esi+ebx-1],al
inc move
jmp last
l1801:
mov edx,offset player2
call writestring
mwrite" ! Its your turn. Choose your option : "
call readdec
mov validation,eax
mov edi,0
mov ebx,validation
cmp empty[edi+ebx-1],' '
jne l1807
mov al,option2
mov [esi+ebx-1],al
mov empty[edi+ebx-1],al
dec move
jmp last
l1807:
call clrscr
mwrite"Invalid Entry! Try again "
call crlf
invoke possibleoptions
call readchar
invoke drawboard,addr matrix
jmp l100
last:
ret
Multiplayer endp
menu proc
call clrscr
mov dh,8
mov dl,30
call gotoxy
mwrite "1. Multiplayer "
add dh,2
call gotoxy
mwrite "2. View Overall Record of player "
add dh,2
call gotoxy
mwrite"3. Exit "
add dh,2
call gotoxy
mwrite "Enter a choice you want to choose : "
call readdec
cmp eax,1
jne l11
l21:
invoke Multiplayer,addr matrix
invoke drawboard,addr matrix
invoke checkwin
cmp ecx,3
jne l21
invoke filingofoutputplayer1
invoke filingofoutputplayer2
invoke cleareverything
invoke menu
l10 :
cmp eax,2
jne l11
l988:
invoke menu
l11:
cmp eax,2
jne l12
call clrscr
mwrite "Enter a username whose record you want to find : "
invoke filingofinput
call crlf
call waitmsg
invoke menu
l12:
cmp eax,3
jne l23
jmp endd
l23:
add dh,2
call gotoxy
mwrite " Invalid entry "
call readchar
invoke menu
endd:
ret
menu endp
main proc
mov eax, green+(black*16)
call settextcolor
mov dl,35
mov dh,15
call gotoxy
mWrite"WELCOME TO OUR TIC TAC TOE PROJECT"
mov eax, 3000
call delay
invoke menu
exit
main endp
end main