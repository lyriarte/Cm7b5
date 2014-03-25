#include <stdio.h>

#define section_text "\
section .text\n\
\n\
    global  _start\n\
\n"

#define section_data "\
section .data\n\
\n\
buf times 64 db 0\n\
\n"

#define proc_dump32 "\
dump32:\n\
    mov edi, buf + 7\n\
    mov ebx, 8\n\
\n\
loop8:\n\
    mov eax, esi\n\
    and eax, 0xF\n\
    add eax, '0'\n\
    cmp al, '9'\n\
    jle dump4\n\
    add eax, 7\n\
dump4:\n\
    mov byte [edi], al\n\
    shr esi, 4\n\
    dec edi\n\
    dec ebx\n\
    jnz loop8\n\
\n\
    mov edx, 8     ; arg3 len\n\
    mov ecx, buf   ; arg2 ptr\n\
    mov ebx, 1     ; arg1 stdio\n\
    mov eax, 4     ; sys_write\n\
    int 0X80       ; call kernel\n\
    ret\n\
\n"

#define proc_main "\
_start:\n\
\n\
    mov esi, 0XDEADF00D\n\
    call dump32\n\
    mov ebx, 0     ; exit code\n\
    mov eax, 1     ; sys_exit\n\
    int 0X80       ; call kernel\n\
\n"

int main()
{
  printf(section_text);
  printf(section_data);
  printf(proc_dump32);
  printf(proc_main);
  return 0;
}
  
