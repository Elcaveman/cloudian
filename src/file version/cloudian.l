
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include "y.tab.h"

int column = 0;
void count();
void comment();
int check_type();
void yyerror();
%}

%option noyywrap

%%
"/*"			{ comment(); }
"//"			{ comment(); }
"ManagerSetup"			{ count(); return(MANAGER_SETUP); }
"ServiceSetup"			{ count(); return(SERVICE_SETUP); }
"ProxySettings" 		{ count(); return(PROXY_SETTINGS); }
"GatewaySettings"		{ count(); return(GATEWAY_SETTINGS); }
"communicationProtocol"	{ count(); return(COMMUNICATION_PROTOCOL); }
"networkConf"			{ count(); return(NETWORK); }
"apiDescriptor"			{ count(); return(API_DESCRIPTOR); }
"run"					{ count(); return(RUN); }
"communicationSecurity"	{ count(); return(COMMUNICATION_SECURITY); }
"serviceSecurity"		{ count(); return(SERVICE_SECURITY); }
"gatewaySecurity"		{ count(); return(GATEWAY_SECURITY); }
"routingTable"			{ count(); return(ROUTING_TABLE); }
"containerConf"			{ count(); return(CONTAINER_CONF); }
"databaseConf"			{ count(); return(DATABASE_CONF); }
"CHAIN"			{ count(); return(CHAIN); }
"GATEWAY"		{ count(); return(GATEWAY); }
"PLUGIN"		{ count(); return(PLUGIN); }
"DAEMON"		{ count(); return(DAEMON); }
"TRACK"			{ count(); return(TRACK); }
"ENABLE"		{ count(); return(ENABLE); }
"DISABLE"		{ count(); return(DISABLE); }
"Proxy"			{ count(); return(PROXY); }
"Protocol"		{ count(); return(PROTOCOL); }
"Atom"			{ count(); return(ATOM); }
"Service"		{ count(); return(SERVICE); }
"Service_bus"	{ count(); return(SERVICE_BUS); }
"Delivery"		{ count(); return(DELIVERY); }
"XML"			{ count(); return(XML); }
"HTML"			{ count(); return(HTML); }
"JSON"			{ count(); return(JSON); }
"HTTP"			{ count(); return(HTTP); }
"HTTPS"			{ count(); return(HTTPS); }
"BOB"			{ count(); return(BOB); }
"BLOB"			{ count(); return(BLOB); }
"ENCB"			{ count(); return(ENCB); }
"FRAME"			{ count(); return(FRAME); }
"string"		{ count(); return(STRING); }
"double"		{ count(); return(DOUBLE); }
"float"			{ count(); return(FLOAT); }
"int"			{ count(); return(INT); }
"bool"			{ count(); return(BOOLEAN); }
"list"			{ count(); return(LIST); }
"map"			{ count(); return(MAP); }
"const"			{ count(); return(CONST); }
"econst"		{ count(); return(ECONST); }
"xconst"		{ count(); return(XCONST); }
"var"			{ count(); return(VAR); }
"evar"			{ count(); return(EVAR); }
"xvar"			{ count(); return(XVAR); }
"import"		{ count(); return(IMPORT); }
"simport"		{ count(); return(SIMPORT); }
"as"			{ count(); return(AS);}
"this"			{ count(); return(THIS); }
"GET"			{ count(); return(GET); }
"POST"			{ count(); return(POST); }
"PUT"			{ count(); return(PUT); }
"DEL"			{ count(); return(DEL); }
"CGET"			{ count(); return(CGET); }
"CPOST"			{ count(); return(CPOST); }
"CPUT"			{ count(); return(CPUT); }
"CDEL"			{ count(); return(CDEL); }
"LOG"			{ count(); return(LOG); }
"READ"			{ count(); return(READ); }
"TOOL"			{ count(); return(TOOL); }
"LANGUAGE"		{ count(); return(LANGUAGE); }
"WRITE"			{ count(); return(WRITE); }

"switch"		{ count(); return(SWITCH); }
"case"			{ count(); return(CASE); }
"default"		{ count(); return(DEFAULT); }

"if"			{ count(); return(IF); }
"else"			{ count(); return(ELSE); }
"continue"		{ count(); return(CONTINUE); }

"for"			{ count(); return(FOR); }
"while"			{ count(); return(WHILE); }
"do"			{ count(); return(DO); }
"break"			{ count(); return(BREAK); }

"function"		{ count(); return(FUNCTION); }
"return"		{ count(); return(RETURN); }
{L}({L}|{D})*		{ count(); return(check_type()); }

0[xX]{H}+{IS}?		{ count(); return(HEXA); }/*hexa*/
0{D}+{IS}?		{ count(); return(NUMBER); }/*float 0.157*/
{D}+{IS}?		{ count(); return(NUMBER); }/*float .1548*/

{D}+{E}{FS}?		{ count(); return(NUMBER); }/*int expo version*/
{D}*"."{D}+({E})?{FS}?	{ count(); return(NUMBER); }/*float expo 0.12 E15*/
{D}+"."{D}*({E})?{FS}?	{ count(); return(NUMBER); }/*float expo .15 E15*/

"(\"[^\"]*\"|\'[^\']*\')" { count(); return(STRING_LITERAL); }

"..."			{ count(); return(ELLIPSIS); }/*used to spread list*/
"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&="			{ count(); return(AND_ASSIGN); }
"^="			{ count(); return(XOR_ASSIGN); }
"|="			{ count(); return(OR_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }/*PTR OP used for CHAIN!*/
"&&"			{ count(); return(AND_OP); }/*and op*/
"||"			{ count(); return(OR_OP); }/*or op*/
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"				{ count(); return(';'); }
("{"|"<%")		{ count(); return('{'); }
("}"|"%>")		{ count(); return('}'); }
","				{ count(); return(','); }
":"				{ count(); return(':'); }
"="				{ count(); return('='); }
"("				{ count(); return('('); }
")"				{ count(); return(')'); }
("["|"<:")		{ count(); return('['); }
("]"|":>")		{ count(); return(']'); }
"."				{ count(); return('.'); }
"&"				{ count(); return('&'); }
"!"				{ count(); return('!'); }
"~"				{ count(); return('~'); }
"-"				{ count(); return('-'); }
"+"				{ count(); return('+'); }
"*"				{ count(); return('*'); }
"/"				{ count(); return('/'); }
"%"				{ count(); return('%'); }
"<"				{ count(); return('<'); }
">"				{ count(); return('>'); }
"^"				{ count(); return('^'); }
"|"				{ count(); return('|'); }
"?"				{ count(); return('?'); }

[ \t\v\n\f]		{ count(); }/*escape characters*/
.				{ ECHO;yyerror("unexpected character"); }

%%



void comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}

int check_type()
{
	/*might be usefull when working on
	* code generation
	*/
	return(IDENTIFIER);
}

void yyerror(char* s){
	fprintf(stderr,"error in column %d line %d : %s\n", column,yylineno,s);
}