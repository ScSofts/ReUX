#define asm(code) __asm__(#code)
int kernel_main(void){
    asm(hlt);
    return 0;
}