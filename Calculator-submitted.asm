          
          
          
  ;sara aljurf 20180205
  ;hala farraj 20180664      
 
;----------------------------NOTE------------------------------------- 
;use space button after entering the expression to get the answer
;use underscore as a negative sign for negative numbers; NOT AS MINUS
;---------------------------------------------------------------------

org 100h  

    .data
    
    i db 1          ;to use it in the factorial procedure
    fact db 1    ;to use it in the factorial procedure
    signflag db 0  
    signflagnum2 db 0      
    output db "Please enter your expression: "   
    output2 db 0ah,0dh,"The result of",8 dup( ' ') ,"   is "  
    F db 0   ;as a flag                                
    num1 db 0
    num2 db 0
    op db 0
    result db 0
    msg db 0dh,0ah,"Error: The operation isn't valid"  
    
    
    .code
    
     mov ax,@data
     mov ds,ax
  
     mov di,18                     
     mov si,0
     mov cx,30 
            
     printingoutput:      ;printing "Please Enter your expression"
     mov ah,2
     mov dl,output[si]
     inc si 
     int 21h
     loop printingoutput     
    
     
     LL1:
     call get1 
     cmp ax,0    ; this means that the user entered a value not between 0 and 9
     je printerror
     cmp F,0
     je LL1 
     
     LL2:
     call get2 
     cmp ax,0
     je printerror
     cmp F,1
     je LL2 
     
     
     choosingOperation: 

     cmp op,'+'
     je addition
     
     
     cmp op,'*'
     je multiplication 
     
    
     cmp op,'/'
     je division
        
    
     cmp op,'-'
     je subtraction 
    
    
       
     cmp op,'!'
     je factorial
    
    
     cmp op,'%'
     je modulation 
      
     
;-----------------------Choosing operation Labels--------------

        addition:
        call addpro 
        ret
        
        multiplication:
        call mulpro 
        ret 
        
        division:
        call divpro
        ret
        
        subtraction:
        call subpro
        ret
        
        factorial:
        call facpro 
        ret 
        
        
        modulation:
        call modpro
        ret

;-------------------------Mathmatical Procedures---------------
       
;-------------------------Addition-----------------------------       
        addpro proc 
            
        cmp signflag,1
        jne  addd
        neg num1
        addd:
        mov bl, num1
        add bl,num2
        mov result,bl 
        jmp printresult 
        ret
         
        endp 
        
;-------------------------Subtraction-------------------------
        subpro proc
             
            cmp signflag,1
            jne  subb
            neg num1
            subb:
            mov bl, num1
            sub bl,num2
            mov result,bl 
            jmp printresult
            ret
    
        endp  
        
     
;-------------------------Multiplication------------------------
     mulpro proc
    
            cmp signflag,1
            jne  mull
            neg num1 
    
            mull:
            cmp signflagnum2,1
            jne mulll
            neg num2  
    
             mulll:
             
             cmp num1,0
             je printzero 
             cmp num2,0
             je printzero
             
             
             mov al,num2 
             mov dl,num1
             
             cmp num2,1
             je printone2 
             
             cmp num1,1
             je printone1
               
             mov dl,num2
             mov dh,0
             mov cx,dx
             sub cx,1   
             mov bl,num1 
                             
             L22:  
             add bl,num1        
             mov result,bl
             loop L22  
             jmp printresult 
             ret  
             
             printzero:
             mov result,0
             jmp printresult
             ret 
             
             printone2:
             mov result,dl
             jmp printresult 
              
             printone1:
             mov result,al
             jmp printresult  
             
             ret
     
                 
     endp  
     
     
;--------------------------Division--------------------------------
            
         divpro proc  
             
               mov dl,0    ;Result of division
               mov cl, 0   ;modulus of dividion
               mov bl,num1  
                    
               cmp num2,0       ;the denominator cannot be zero
               je printerror   
                    
               cmp bl,num2
               jb L2222
                    
               L1:    
                sub bl,num2
                js donne
                inc dl
                jmp L1
               donne:
                 add bl,num2
                 mov cl,bl    
                 mov result,dl    
                       
                 cmp signflag,1            ;if num1 and num2 are negative
                 je checknum2
                       
                              
                 cmp signflag,1            ;if num1 is negative and num2 is positive
                 je negativeresult
                     
                 cmp signflagnum2,1         ;if num2 is negative and num1 is positive
                 je negativeresult
                         
                       
                 letsprint:  jmp printresult
                 ret
                       
               L2222:
                mov cl,bl 
                mov result,dl
                jmp printresult                  
                ret
                                                                                                                
     
        endp

             negativeresult:             
             neg result
             jmp printresult          
             ret
             
             checknum2:
             cmp signflagnum2,1
             je letsprint
             jmp negativeresult
             ret
            
;-----------------------Factorial-------------------------------            
      facpro proc 
            
            cmp signflag,1      ;-no factorial for negative numbers
            je printerror 
       
    
            mov bh,0
            mov bl,num1
            mov cx,0
            mov dx,0   
             
            cmp num1,0     ; 0!=1
            je  return1 
                         
            mov cx,bx
            Biggg:   
            
            cmp cx,0
            je L666
            push cx
            mov dl,fact
            
            Smalll:
            cmp cx,1
            je exitttt
            add fact,dl
            loop Smalll 
            
            exitttt:
            mov dl,fact
            pop cx
            loop Biggg 
            
            L666:
            mov result,dl
            jmp printresult
            ret 
            
       endp  
          
          
          
        return1:
        mov result,1
        jmp printresult
        ret 
        
;----------------------Modulation--------------------------        
 modpro proc 
           
         mov ah,0          
         mov al,num1
         mov bl,num2 
         mov bh,0  
               
         cmp bx,0
         je smaller1
          
         cmp ax,bx       
         jb smaller2 
      
      l111111:
        sub ax,bx
        cmp ax,bx         
        jae l111111    
         
        mov result,al 
         
        cmp signflag,1            ;if num1 and num2 are negative
        je checknum2
   
        cmp signflag,1            ;if num1 is negative and num2 is positive
        je negativeresult
   
        cmp signflagnum2,1         ;if num2 is negative and num1 is positive
        je negativeresult
      
        jmp printresult
         ret
        
      
      smaller1:
         jmp printerror
         ret
      
      smaller2: 
         mov result,al  
         cmp signflag,1
         je negggg
         jmp printresult
         ret
         
         negggg:
         neg result 
         jmp printresult
         ret  
         
 endp    
 
;---------------------Printing statements-------------------  
    printresult:  ; add code to print result
  
           mov si,0
           mov cx,29 
                    
           printingoutput2:           ;to print Please Enter your expression statement
           mov ah,2
           mov dl,output2[si]
           inc si 
           int 21h
           loop printingoutput2 
           
           
           
           checkNegative: ; to check if the number is negative 
            cmp result,0
            jge skip
            mov dl,'-'
            mov ah,2
            int 21h   
            neg result
       
           skip:
            mov ch,1 ; to check if the result consists of 3 digits
            mov dh,0
            mov cl,result 
            
          getMSB:
            cmp cl,10
            jae count
            cmp dh,9
            ja threeDigits
            cmp dh,0
            je pr
            mov dl,dh
            add dl,30h
            mov ah,2
            int 21h 
            
          pr:
            mov dl,cl
            add dl,30h
            mov ah,2
            int 21h
            cmp ch,0 ; check the flag (0 => 3 digits, 1 => not 3 digits)
            je getLSB
            jmp done  
            
          count:  ; getting the MSB
            inc dh
            sub cl,10
            jmp getMSB
            
          threeDigits:  ;getting the second digit if the result has 3 digits 
            mov ch,0 ; setting the flag to 0 means that the result consists of 3 digits
            push cx
            mov cl,dh
            mov dh,0
            jmp getMSB
            
          getLSB:  ;       ; getting the LSB digit if we have result with three digits
            pop cx
            mov dl,cl
            add dl,30h
            mov ah,2
            int 21h
            jmp done                                                                     
        
          printerror:      ;prints error message
            mov cx,34
            mov si,0  
            
          screen:
            mov dl,msg[si]
            mov ah,2
            int 21h
            inc si
            loop screen
            
            
           done:
            ret


;-----------------------getting the first number--------------
   get1 proc
     
        mov ah,1      ;take an input from the user
        int 21h
            
        cmp al,'+'
        je L4 
        cmp al,'-'
        je L5 
        
        cmp al,'*'
        je multop
        
        cmp al,'/'
        je divop
        
        cmp al,'%'
        je modop 
        
         cmp al,'!'
        je facop
          
        ;------to use it in the printing statement-----------  
          mov output2[di],al
          inc di 
        ;----------------------------------------------------
        
        cmp al,'_'         ;to check if the user entered a negative number 
        jne L55
        mov signflag,1 
        ret   
        
        L55:
        
        sub al,30h         
        cmp al,0
        jb L2
        cmp al,9
        ja L2         
        mov cx,10
        mov bh,0
        L3:
        add bh,num1
        loop L3
        add bh,al
        mov num1,bh
        ret 
        
        L4:
            mov op,'+'
            ;------to use it in the printing statement-----------
            mov output2[di],'+'
            inc di 
            ;----------------------------------------------------
            mov F,1
          ret 
        
        L5:
            mov op,'-' 
            ;------to use it in the printing statement-----------
            mov output2[di],'-'
            inc di 
            ;----------------------------------------------------
            mov F,1
        ret 
        
        
        multop:
            mov op,'*' 
            ;------to use it in the printing statement-----------
            mov output2[di],'*'
            inc di 
            ;----------------------------------------------------
            mov F,1 
        ret
        
        divop:
            mov op,'/' 
            ;------to use it in the printing statement-----------
            mov output2[di],'/'
            inc di 
            ;----------------------------------------------------
            mov F,1 
         ret  
        
        modop:
           mov op,'%' 
            ;------to use it in the printing statement-----------
            mov output2[di],'%'
            inc di 
            ;----------------------------------------------------
            mov F,1 
        ret
        
        facop:
            mov op,'!' 
            ;------to use it in the printing statement-----------
            mov output2[di],'!'
            inc di 
            ;----------------------------------------------------
            mov F,1           
         ret
        
        L2:
        mov ax,0         
        ret
        
    endp   
    
;-----------------------getting the second number-------------- 

 get2 proc
     
        mov ah,1       ;take an input from the user
        int 21h
            
        cmp al,032  ;to know when the user presses space button to get the result
        je L41 
    
    
    
      ;------to use it in the printing statement-----------
        mov output2[di],al
        inc di 
      ;----------------------------------------------------
    
   
        cmp al,'_'         ;to check if the user entered a negative number 
        jne L555
        mov signflagnum2,1 
        ret
      
        L555:  
        sub al,30h         
        cmp al,0
        jb L21     ;the input is under 0 
        cmp al,9
        ja L21    ;the input is above 0        
        mov cx,10
        mov bh,0  
        
        L31:                        
        add bh,num2
        loop L31
        add bh,al
        mov num2,bh
        ret 
        
        L41:
        mov F,2
        ret
        
        L21:
        mov ax,0
        ret
endp 


  
ret




