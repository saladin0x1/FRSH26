%{
#include "parser.tab.h"  // Ensure that this is properly quoted

%option noyywrap  // Avoid generating the yywrap function
%option nounput   // Avoid generating the 'input' function
%option noyyunput // Avoid generating the 'yyunput' function
%}

%%
[[:alpha:]]      { return LETTER; }
[[:space:]]      { return WHITESPACE; }
.                 { return ERROR; }
%%

int yywrap(void) {
    return 1;
}
