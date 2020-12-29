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
    if(args.size() < 3){
        help();
    }else{
        std::string path = get_path();
        std::string gcc_args = "";
        if(args.size() > 3){
            for(int i = 2;i<args.size();i++){
                gcc_args += args.at(i) + " ";
            }
        }
        system(
            (
                path + "ld -Ttext " + argv[1] + "  --section-alignment 1 --file-alignment 1 -nostdlib  " + gcc_args
            ).c_str()
            );
    }
    return 0;
}

void help(){
    std::cerr << "LdBin V1.0.0 By ScSofts" << std::endl;
    std::cerr << "Usage: ldbin [origin]  (LD Args...)";
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