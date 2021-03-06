%{ /* Pre declarations */
#include<stdio.h>
extern int yylex();
void yyerror(const char* msg);
extern int yylineno;
int reg[10];
%} /* Grammar tokens */

%token EQUAL     "="
%token PLUS      "+"
%token MINUS     "-"
%token MULT      "*"
%token DIV       "/"
%token LPAR      "("
%token RPAR      ")"
%token SEMICOLON ";"
%token <str> REGISTER  "register"
%token <num> INT       "integer"

%start sentence_block
%define parse.error verbose

%type <num> expression term factor

%union {
    int num;
    char* str;
}

%% /* Production Rules */

sentence_block : result ";" sentence_block          {  }
               | assignment ";" sentence_block      {  }
               | result ";"                         {  }
               | result                             {  }
               ;

result         : expression                         { printf("r = %d\n", $1); }
               |                                    { printf("EMPTY\n"); }

assignment     : "register" "=" expression          {
                                                      printf("Stored %d in %s\n", $3, $1);
                                                      reg[(int)($1[1]-'0')] = $3;
                                                    }

expression     : expression "+" term                { $$ = $1+$3; }
               | expression "-" term                { $$ = $1-$3; }
               | term                               { $$ = $1; }
               ;

term           : term "*" factor                    { $$ = $1*$3; }
               | term "/" factor                    { $$ = $1/$3; }
               | factor
               ;

factor         : "integer"                          { $$ = $1; }
               | "register"                         { $$ = reg[(int)($1[1]-'0')]; }
               | "(" expression ")"                 { $$ = $2; }
               | "-" factor                         { $$ = $2; }
               ;


%%

void yyerror(const char* msg) {
    printf("%d: ERROR: %s\n", yylineno, msg);
}
