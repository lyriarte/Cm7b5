#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
;    pop esi\n\
;    call dump32\n\
    mov ebx, 0     ; exit code\n\
    mov eax, 1     ; sys_exit\n\
    int 0X80       ; call kernel\n\
\n"


#ifndef DATA_SIZE
#define DATA_SIZE 4096
#endif
static char data_buf[DATA_SIZE];

#ifndef CODE_SIZE
#define CODE_SIZE 65536
#endif
static char code_buf[CODE_SIZE];

static char temp_buf[256];

void gen_int(int value) {
  sprintf(temp_buf,"    push %d\n", value);
  strcat(code_buf, temp_buf);
};

void gen_intvar(char * name) {
  sprintf(temp_buf,"    push dword [%s]\n", name);
  free(name);
  strcat(code_buf, temp_buf);
};

void assign_intvar(char * name) {
  sprintf(temp_buf,"    pop dword [%s]\n", name);
  free(name);
  strcat(code_buf, temp_buf);
};

void gen_op32(int op) {
  strcat(code_buf, "    pop ebx\n");
  strcat(code_buf, "    pop eax\n");
  switch (op) {
    case '+':
      strcat(code_buf, "    add eax, ebx\n");
      break;
    case '-':
      strcat(code_buf, "    sub eax, ebx\n");
      break;
    case '*':
      strcat(code_buf, "    imul eax, ebx\n");
      break;
    case '/':
      strcat(code_buf, "    idiv eax, ebx\n");
      break;
  }
  strcat(code_buf, "    push eax\n");
};

void gen_negative() {
  strcat(code_buf, "    pop ebx\n");
  strcat(code_buf, "    mov eax, 0\n");
  strcat(code_buf, "    sub eax, ebx\n");
  strcat(code_buf, "    push eax\n");
};

void declare_intvar(char * name) {
  sprintf(temp_buf,"%s dd 0xffffffff\n", name);
  free(name);
  strcat(data_buf, temp_buf);
};

int main()
{
  printf(section_text);
  strcpy(data_buf, section_data);
  strcpy(code_buf, proc_dump32);
  strcat(code_buf, proc_main_start);
  yyparse();
  strcat(code_buf, proc_main_exit);
  printf("%s\n",data_buf);
  printf("%s\n",code_buf);
  return 0;
}
  
