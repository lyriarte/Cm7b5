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

#define proc_main_start "\
_start:\n\
\n"

#define proc_main_exit "\
\n\
    pop esi\n\
    call dump32\n\
    mov ebx, 0     ; exit code\n\
    mov eax, 1     ; sys_exit\n\
    int 0X80       ; call kernel\n\
\n"

void gen_int(int value) {
  printf("    push %d\n", value);
};

void gen_op32(int op) {
  printf("    pop ebx\n");
  printf("    pop eax\n");
  switch (op) {
    case '+':
      printf("    add eax, ebx\n");
      break;
    case '-':
      printf("    sub eax, ebx\n");
      break;
    case '*':
      printf("    imul eax, ebx\n");
      break;
    case '/':
      printf("    idiv eax, ebx\n");
      break;
  }
  printf("    push eax\n");
};

void gen_negative() {
  printf("    pop ebx\n");
  printf("    mov eax, 0\n");
  printf("    sub eax, ebx\n");
  printf("    push eax\n");
};

int main()
{
  printf(section_text);
  printf(section_data);
  printf(proc_dump32);
  printf(proc_main_start);
  yyparse();
  printf(proc_main_exit);
  return 0;
}
  
