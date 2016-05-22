%{
#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "cool.tab.h"

unsigned long linenum = 1;

#define MAX_STRING_LITERAL_LENGTH 1025
char string_literal_buffer[MAX_STRING_LITERAL_LENGTH];
unsigned long string_literal_length;

void add_char_to_string_literal(char c) {
    if (string_literal_length < MAX_STRING_LITERAL_LENGTH) {
        string_literal_buffer[string_literal_length] = c;
        ++string_literal_length;
    } else {
        cout << "String constant too long" << endl;
    }
}

%}

%x MULTILINE_COMMENT
%x STRING_LITERAL

TRUE        t[Rr][Uu][Ee]
FALSE       f[Aa][Ll][Ss][Ee]
INTEGER     [0-9]+
IDENTIFIER  [a-zA-Z0-9_]+
END_MULTILINE_COMMENT \*\)

%%

\"                 { string_literal_length = 0; BEGIN(STRING_LITERAL); }
<STRING_LITERAL>{
    \\b  { add_char_to_string_literal('\b'); }
    \\t  { add_char_to_string_literal('\t'); }
    \\n  { add_char_to_string_literal('\n'); }
    \\f  { add_char_to_string_literal('\f'); }
    \\0  { add_char_to_string_literal(0); }
    \\\n { add_char_to_string_literal('\n'); ++linenum; }
    \n   { cout << "Unterminated string literal" << endl; BEGIN(INITIAL); }
    \\   ;
    \"   { add_char_to_string_literal('\0'); cout << "string literal: " << string_literal_buffer << endl; BEGIN(INITIAL); }
    \x00 { cout << "Invalid null in string literal" << endl; }
    .           { add_char_to_string_literal(yytext[0]); }
}

\(\* { BEGIN(MULTILINE_COMMENT); }
<MULTILINE_COMMENT>{
    <<EOF>>  { BEGIN(INITIAL); cout << "EOF in comment" << endl; }
    {END_MULTILINE_COMMENT}     { BEGIN(INITIAL); }
    \n       { ++linenum; }
    .        ;
}

{END_MULTILINE_COMMENT} { cout << "Unmatched *)" << endl; }

[\.\,\;\{\}\(\)\:\@\+\-\*\/\~\<\>\=\[\]] { cout << yytext[0] << endl; }

--[^\n]       { cout << "single line comment" << endl; }
(?i:CLASS)    { cout << "class keyword" << endl; }
(?i:ELSE)     { cout << "else keyword" << endl; }
{FALSE}       { cout << "false keyword" << endl; }
(?i:FI)       { cout << "fi keyword" << endl; }
(?i:IF)       { cout << "if keyword" << endl; }
(?i:IN)       { cout << "in keyword" << endl; }
(?i:INHERITS) { cout << "inherits keyword" << endl; }
(?i:ISVOID)   { cout << "isvoid keyword" << endl; }
(?i:LET)      { cout << "let keyword" << endl; }
(?i:LOOP)     { cout << "loop keyword" << endl; }
(?i:POOL)     { cout << "pool keyword" << endl; }
(?i:THEN)     { cout << "then keyword" << endl; }
(?i:WHILE)    { cout << "while keyword" << endl; }
(?i:CASE)     { cout << "case keyword" << endl; }
(?i:ESAC)     { cout << "esac keyword" << endl; }
(?i:NEW)      { cout << "new keyword" << endl; }
(?i:OF)       { cout << "of keyword" << endl; }
(?i:NOT)      { cout << "not keyword" << endl; }
{TRUE}        { cout << "true keyword" << endl; }

{INTEGER}     { yylval.int_literal = atoi(yytext); return INT; }
{IDENTIFIER}  { cout << "identifier (" << yytext << ")" << endl; }

[ \t\f\r\v]                 ;
\n                          { ++linenum; }
.                           { cout << "error: " << yytext << "on line: " << linenum << endl; }

%%
int not_main(int, char**) {
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
