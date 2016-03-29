%{
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()
unsigned long linenum = 0;
%}
%%
[ \t]           ;
\n              { ++linenum; }
[0-9]+\.[0-9]+  { cout << "Found a floating-point number:" << yytext << " on line: " << linenum << endl; }
[0-9]+          { cout << "Found an integer:" << yytext << " on line: " << linenum << endl; }
[a-zA-Z0-9]+    { cout << "Found a string: " << yytext << " on line: " << linenum << endl; }
%%
int main(int, char**) {
    char fileName[] = "test.cl";
    FILE * inputFile = fopen(fileName, "r");
    if (!inputFile) {
        cout << "Failed to open " << fileName << endl;
        return -1;
    }
    // lex through the input:
    yyin = inputFile;
    yylex();
}
