    org 100h

.data
    
    result db 0ah,0dh, "Your expression result is: $"
    invalid_mesg db 0ah,0dh, "invalid input$"
    mesg1 db 0ah,0dh, "Enter 1st  number :  $"                                                   
    mesg2 db 0ah,0dh, "Enter 2nd number :  $"                                                      
    mesg3 db 0ah,0dh, "Enter operator (+,-,%,*,/) NO FACTORIAL :  $"    
    number1 dw 00h
    number2 dw 00h
    over db 00h
   
.code       
           
 calc:
      mov ax,@data            
      mov ds,ax               
      call input              
      call parse             
      call op        
      mov [si],'#'            
      call reverce   
      call print_res      
 
input  proc                        
                
     mov [si],'#'        
     lea dx,mesg1         
     mov ah,09h          
     int 21h             
               
       
                        
   inp1:          
    mov ah,01h          
    int 21h 
    mov ah,al           
    cmp al,13d                       
    jz  print_mesg2
    mov ah,al 
    mov dh,'9'         
    jc inval        
    sub al,'0'         
    inc si              
    mov [si],al       
    jmp inp1         
                
               
                
   print_mesg2:
    inc si             
    mov [si],'#'        
    lea dx,mesg2         
    mov ah,09h          
    int 21h             
                                   
  inp2:
    mov ah,01h         
    int 21h           
    cmp al,13d         
    jz exit           
    mov ah,al
    sub ah,'0'         
    jc inval        
    mov ah,al 
    mov dh,'9'
    sub dh,ah          
    jc inval         
    sub al,'0'        
    inc si           
    mov [si],al        
    jmp inp2         
    exit:              
       ret
                
       inval: lea dx,invalid_mesg
       mov ah,09h         
       int 21h            
        hlt
 endp                              
 
  reverce proc               
     
    rparse:
    mov dx,00h         
    mov bx,10d          
    div bx           
    add dl,'0'          
    inc si             
    mov [si],dl         
    add ax,00h          
    jnz rparse         
                           
            
 endp                              
 
 
 print_res proc                  
              
    lea dx,result   ;printing the resulkt      
    mov ah,09h          
    int 21h              
    mov cl,01h            
    cmp cl,[over]    
    mov [over],00h
    jz minus        
    jnz print           
  minus: mov dl,'-'           
  mov ah,02h    ;minus if needed      
 int 21h              

  print: 
    mov dl,[si]          
    mov ah,02h           
    int 21h               
    dec si             
    cmp [si],'#'         
    jnz print          
            
             
       
 op proc                    
    mov cx,ax        
    lea dx,mesg3         
    mov ah,09h           
    int 21h                        
    mov ah,01h          
    int 21h            
    cmp al,'-'        ;if sub 
    jz subtract       
    cmp al,'+'         ;if add
    jz addision
    cmp al,'/'         ;if div
    jz divis      
    cmp al,'%'         ;if mod
    jz modulo      
    cmp al,'*'         ;if multi
    jz multiply 
    lea dx,invalid_mesg               
    mov ah,09h           
    int 21h              
    hlt
       
       
  subtract:
    mov ax,cx           
    sub ax,bx           
    jc of 
    jnc nof
    of:neg ax             ;if o - f
    mov [over],01h
    ret
    nof:ret                ;no o-f
  addision:
    mov ax,bx         
    mov dx,00h         
    add ax,cx         
    adc ax,dx         
    ret         
   
    divis:                    
    mov dx,00h
    add bx,dx
    mov ax,cx                   
    div bx             
    ret
    jmp calc        ;jump calculator
    modulo:
                        
    mov dx,00h
    mov ax,cx          
    add bx,dx
    jz divbyz     ;if div by 0 happen
    div bx              
    mov ax,dx          
  divbyz: ret
                                    
 multiply:
    mov ax,cx          
    mov dx,00h        
    mul bx              
        ret                           
 endp
 
  parse proc                       

   mov cx,01d        
   mov bx,00h          
               
   parse1:  
    mov ax,00h       ;parser1    
    mov al,[si]        
    mul cx              
    add bx,ax           
    mov ax,cx        ;parser1   
    mov cx,10d         
    mul cx              
    mov cx,ax        ;parser1 
    dec si             
    cmp [si],'#'      
    jnz parse1                  
    mov [number2],bx       
    mov bx,00h                
    mov dx,00h         
    dec si             
    mov cx,01d         
               
    parse2:  
    mov ax,00h         
    mov al,[si]         
    mul cx            
    add bx,ax        
    mov ax,cx          
    mov cx,10d        
    mul cx            
    mov cx,ax         
    dec si            
    cmp [si],'#'      
    jnz parse2                     
    mov [number1],bx      
    mov ax,[number1]     
    mov bx,[number2]    
               
                
    ret                                                                                                     
 endp                              

 
  endp                        