%{ void yyerror(char *s);
#include <stdio.h>
#include <stdlib.h>

extern int yylex();

 %}


%token MANAGER_SETUP SERVICE_SETUP PROXY_SETTINGS GATEWAY_SETTINGS

%token COMMUNICATION_PROTOCOL NETWORK API_DESCRIPTOR RUN COMMUNICATION_SECURITY SERVICE_SECURITY
%token GATEWAY_SECURITY ROUTING_TABLE CONTAINER_CONF DATABASE_CONF

%token CHAIN GATEWAY PLUGIN DAEMON TRACK ENABLE DISABLE

%token PROXY PROTOCOL ATOM SERVICE SERVICE_BUS DELIVERY

%token XML HTML JSON HTTP HTTPS BOB BLOB ENCB FRAME

%token STRING DOUBLE FLOAT INT BOOLEAN LIST MAP

%token CONST ECONST XCONST VAR EVAR XVAR

%token IMPORT SIMPORT AS THIS GET POST PUT DEL CGET CPOST CPUT CDEL LOG READ WRITE

%token SWITCH CASE DEFAULT IF ELSE CONTINUE FOR WHILE DO BREAK FUNCTION RETURN

%token IDENTIFIER STRING_LITERAL HEXA NUMBER
%token TOOL LANGUAGE
%token ELLIPSIS ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN RIGHT_OP LEFT_OP
%token INC_OP DEC_OP PTR_OP AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP

%start translation_unit
%%

primary_expression
	: IDENTIFIER
	| HEXA
	| NUMBER
	| STRING_LITERAL
	| '(' expression ')'
	| import_statement
	;
import_statement
	:IMPORT STRING_LITERAL AS IDENTIFIER
	|SIMPORT STRING_LITERAL AS IDENTIFIER

postfix_expression
	: primary_expression
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| postfix_expression PTR_OP compound_statement
	;

argument_expression_list
	: assignment_expression
	| type_name
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator cast_expression
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' argument_expression_list ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression
	| multiplicative_expression '/' cast_expression
	| multiplicative_expression '%' cast_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression
	| relational_expression '>' shift_expression
	| relational_expression LE_OP shift_expression
	| relational_expression GE_OP shift_expression
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exclusive_or_expression
	: and_expression
	| exclusive_or_expression '^' and_expression
	;

inclusive_or_expression
	: exclusive_or_expression
	| inclusive_or_expression '|' exclusive_or_expression
	;

logical_and_expression
	: inclusive_or_expression
	| logical_and_expression AND_OP inclusive_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	;

declaration_specifiers
	: type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
	;

type_specifier
	: PROXY
	| PROTOCOL
	| ATOM
	| SERVICE
	| SERVICE_BUS
	| DELIVERY
	| XML
	| HTML
	| JSON
	| HTTP
	| HTTPS
	| BOB
	| BLOB
	| ENCB
	| FRAME
	| STRING
	| DOUBLE
	| FLOAT
	| INT
	| BOOLEAN
	| LIST
	| MAP
	| Tag_specifier
	| map_specifier
	;

Tag_specifier
	: Tag IDENTIFIER '{' compound_statement '}'
	| Tag '{' compound_statement '}'
	| Tag IDENTIFIER utility init_declarator_list
	| Tag utility init_declarator_list
	;
utility
	: TOOL
	| DAEMON
	| LANGUAGE
	| GATEWAY
	;

Tag
	: CHAIN
	| PLUGIN
	;


specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

map_specifier
	: MAP '{' enumerator_list '}'
	| MAP IDENTIFIER '{' enumerator_list '}'
	| MAP IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: map_key ':' constant_expression
	;
map_key
	:IDENTIFIER
	|HEXA
	|NUMBER
	|STRING_LITERAL
	;

type_qualifier
	: CONST
	| ECONST
	| XCONST
	| VAR
	| EVAR
	| XVAR
	;

declarator
	: direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: direct_abstract_declarator

	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	| special_function
	;
special_function
	: GET
	| POST
	| PUT
	| DEL
	| CGET
	| CPOST
	| CPUT
	| CDEL
	| LOG {printf("Prints variable from SymbolTable");}
	| READ{char text[30];scanf("%s",text);printf("adds variable from strin to the SymbolTable");}
	| WRITE

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| initializer_list ',' initializer
	;

statement
	: labeled_statement
	| compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	;

jump_statement
	: CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement
	| FUNCTION declarator declaration_list compound_statement
	| FUNCTION declarator compound_statement
	| declarator declaration_list compound_statement
	| declarator compound_statement
	;

%%
extern char* yytext;
extern int yylineno;
extern int column;

int main(void){
	yyparse();
}
