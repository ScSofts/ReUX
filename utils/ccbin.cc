#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include <vector>
#include<windows.h>

void help();
inline std::string get_path();
int main(int argc,char *argv[]){
    std::vector<std::string> args(argv,argv+argc);
    if(args.size() < 4 || args[2] != "-o"){
        help();
    }else{
        std::string path = get_path();
        std::string gcc_args = "";
        if(args.size() > 4){
            for(int i = 4;i<args.size();i++){
                gcc_args += args[i] + " ";
            }
        }
        system(
            (
                path + "gcc -c -masm=intel -nostdlib -fno-ident " + gcc_args + argv[1] + " -o " + argv[3]
            ).c_str()
            );
    }
    return 0;
}

void help(){
    std::cerr << "CCBin V1.0.0 By ScSofts" << std::endl;
    std::cerr << "Usage: ccbin [.cfile] -o [.o file] (GCC Options...)";
}

inline std::string get_path(){
    char buf[1024];
    GetModuleFileNameA(NULL, buf, 1024);
    char *p = strrchr(buf,'\\');
    int pos = p - buf;
    char path[1024] = {0};
    strncpy(path,buf,pos);
    std::string result = path;
    result += '\\';
    return result;
}