.686
.MODEL flat, C
.STACK 100h
.DATA
	textAdr DWORD ?
	wordAdr DWORD ?
	textLen DWORD ?
	wordLen DWORD ?
	prefFuncAdr DWORD ?
	i DWORD 0
	j DWORD 0
	found WORD 0
	maxI DWORD ?
	tempTextLen DWORD 0
	tempTextLenAdr DWORD ?
	tempTextAdr DWORD ?
.CODE
	PUBLIC _asmSearch

_asmSearch PROC 
	PUSHAD
	PUSHF
	MOV ebp,esp
	MOV edx,[ebp+38]
	MOV textAdr,edx
	MOV edx,[ebp+42]
	MOV textLen,edx
	MOV edx,[ebp+46]
	MOV wordAdr,edx
	MOV edx,[ebp+50]
	MOV wordLen,edx
	MOV edx,[ebp+54]
	MOV prefFuncAdr,edx
	MOV edx,[ebp+58]
	MOV tempTextAdr,edx
	MOV edx,[ebp+62]
	MOV tempTextLenAdr,edx
	MOV i,0
	MOV j,0
	MOV found,0
	MOV tempTextLen,0

	MOV edx, textLen
	SUB edx, wordlen
	DEC edx
	MOV maxI,edx
	
cyc:MOV eax,i
	CMP eax,maxI
	JE searchEnd
	MOV j,0h
cyc2:	MOV eax, j
		MOV ebx,wordLen
		CMP eax,ebx
		JE cycEnd
compare:	MOV eax,i
			ADD eax,j
			ADD eax,textAdr
			MOV ah,BYTE PTR [eax]
			MOV ebx,wordAdr
			ADD ebx,j
			MOV al,BYTE PTR [ebx]
			CMP ah,al
			JE jCheck
lineEndCheck:	CMP ah,0Ah
				JE foundToZero
				CMP ah,0Dh
				JE foundToZero
				JMP cyc3
foundToZero:	MOV found,0h

cyc3:			MOV edx,prefFuncAdr
				ADD edx,j
				MOV ecx,j
				XOR eax,eax
				MOV ax,WORD PTR [edx]
				SUB ecx,eax
				MOV esi,textAdr
				ADD esi,i
				MOV edi,tempTextAdr
				ADD edi,tempTextLen
				MOV ecx,wordLen
				CLD
			rep MOVSB 	

next:			
				MOV ebx,prefFuncAdr
				ADD ebx,j
				MOV edx,j
				XOR eax,eax
				MOV ax,WORD PTR [ebx]
				SUB edx,eax
				MOV eax,tempTextLen
				ADD eax,edx
				INC eax
				MOV tempTextLen,eax
				MOV eax,i
				ADD eax,edx
				MOV i,eax
				JMP cycEnd
				
jCheck:		MOV eax,wordLen
			DEC eax
			CMP eax, j
			JNE cyc2End
			MOV ax,found
			INC ax
			MOV found,ax
				CMP ax,1
				JNE jCheckEnd
					
					MOV esi,wordAdr
					MOV edi,tempTextAdr
					ADD edi,tempTextLen
					MOV ecx,wordLen
					CLD
				rep MOVSB 

next2:			MOV eax,tempTextLen
				ADD eax,wordLen
				MOV tempTextLen,eax
				MOV eax,wordLen
				DEC eax
				ADD eax,i
				MOV i,eax
				JMP cycEnd
			
jCheckEnd:	MOV eax,wordLen
			DEC eax
			ADD eax,i
			MOV i,eax
			
cyc2End:MOV eax,j
		INC eax
		MOV j,eax
		JMP cyc2
cycEnd:
	MOV eax,i
	INC eax
	MOV i,eax
	JMP cyc
		
searchEnd:
	MOV esi,textAdr
	ADD esi,i
	MOV edi,tempTextAdr
	ADD edi,tempTextLen
	MOV ecx,wordLen
	INC ecx
	CLD
rep MOVSB
	XOR ch,ch
	MOV [edi],ch

	MOV eax,tempTextLen
	ADD eax,wordLen
	INC eax
	MOV ebx,tempTextLenAdr
	MOV [ebx],eax

	POPF
	POPAD
	ret
_asmSearch ENDP
END