%{
#include "parser.tab.h" 
%}

%%
[[:alpha:]]      { return LETTER; }
[[:space:]]      { return WHITESPACE; }
.                 { return ERROR; }
%%

int yywrap(void) {
    return 1;
}
