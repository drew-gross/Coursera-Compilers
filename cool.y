%{
#include <cstdio>
#include <iostream>
using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE* yyin;

void yyerror(const char *s);

%}

%union {
    int int_literal;
    float float_literal;
    char* string_literal;
}

%token <int_literal> INT
%token <float_literal> FLOAT
%token <string_literal> STRING

%%

cool:
    cool INT { cout << "bison found int: " << $2 << endl; }
    | cool FLOAT { cout << "bison found float: " << $2 << endl; }
    | cool STRING { cout << "bison found str: " << $2 << endl; }
    | INT { cout << "bison found int: " << $1 << endl; }
    | FLOAT { cout << "bison found float: " << $1 << endl; }
    | STRING { cout << "bison found str: " << $1 << endl; }
    ;

%%

int main(int, char**) {
    char fileName[] = "test.cl";
    FILE * inputFile = fopen(fileName, "r");
    if (!inputFile) {
        cout << "Failed to open " << fileName << endl;
        return -1;
    }

    yyin = inputFile;

    do {
        yyparse();
    } while (!feof(yyin));
}

void yyerror(const char *s) {
    cout << "Parse Error! Message " << s << endl;
    exit(-1);
}
