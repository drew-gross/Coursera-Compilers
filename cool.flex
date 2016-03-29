%{
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "cool.tab.h"

unsigned long linenum = 0;
%}
%%
[ \t]           ;
\n              { ++linenum; }
[0-9]+\.[0-9]+  { yylval.float_literal = atof(yytext); return FLOAT; }
[0-9]+          { yylval.int_literal = atoi(yytext); return INT; }
[a-zA-Z0-9]+    { yylval.string_literal = strdup(yytext); return STRING; }
.               ;
%%
