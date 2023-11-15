%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
%}
%x COMMENT_MULTILINE
%x COMMENT_SINGLELINE
%%
"/*"    { BEGIN COMMENT_MULTILINE; }
<COMMENT_MULTILINE>"*/" {
    BEGIN INITIAL;
}
<COMMENT_MULTILINE>[^*\n]+ {
    /* Inside multiline comment, ignore characters except '*' and newline
*/
}
<COMMENT_MULTILINE>"*" {
    /* Inside multiline comment, ignore '*' characters */
}
<COMMENT_SINGLELINE>\n {
    BEGIN INITIAL;
}
<INITIAL>"//" {
    BEGIN COMMENT_SINGLELINE;
}
<COMMENT_SINGLELINE>[^\n]+ {
    /* Inside single-line comment, ignore characters except newline */
}
[ \t]+  ; /* Ignore whitespace */
[0-9]+  {
    printf("INTEGER: %s\n", yytext);
}
"int|float|double|char" { printf("Datatype");}
"if|else|while|for|return" {printf("Keyword");}
[a-zA-Z_][a-zA-Z0-9_]* {
    printf("IDENTIFIER: %s\n", yytext);
}
"+"|"-"|"*"|"/"|"%" {
    printf("OPERATOR: %s\n", yytext);
}
"=="|"!="|"<"|">"|"<="|">=" {
    printf("RELATIONAL OPERATOR: %s\n", yytext);
}
"{" {
    printf("OPENING CURLY BRACE\n");
}
"}" {
    printf("CLOSING CURLY BRACE\n");
}
[a-zA-Z_][a-zA-Z0-9_]*\([^)]*\) {printf("Function");}
"=" {
    printf("ASSIGNMENT OPERATOR\n");
}
"(" {
    printf("LEFT PARENTHESIS\n");
}
")" {
    printf("RIGHT PARENTHESIS\n");
}
";" {
    printf("SEMICOLON\n");
}
"*" {
    printf("POINTER\n");
}
. {
    printf("INVALID CHARACTER: %s\n", yytext);
}
%%
int main() {
    yyin = fopen("outp.c","r");
    yylex();
    fclose(yyin);
}
