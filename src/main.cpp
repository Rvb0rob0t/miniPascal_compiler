#include <iostream>
#include <fstream>
#include <stdlib.h>
#include "ast.hpp" //TODO remove, should be included below, but it isn't
#include "syntax.tab.hh"
using namespace std;

// extern File* yyin
extern int yyparse();
extern T_program ast_root;

int main(int argc, char* argv[]) {
    // cerr << argc << endl;
    // if (argc != 2) {
    //     cout << "Usage: " << argv[0] << " file.mp\n";
    //     return -1;
    // }
    if (yyparse()) {
        cout << "Syntactic error\n";
    } else {
        cout << "Everthing OK!\n";
        ast_root.print();
    }

    ofstream os("bin/a.llvm");

    ast_root.llvm_output(os);
}

