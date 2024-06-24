grammar MT22;

@lexer::header {
from lexererr import *
}

options{
	language=Python3;
}

program:  EOF ;

WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines

//Comment 
BLOCK_COMMENT:'/*' .*? '*/'->skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;

NEWLINE: '\n';

//Keyword
AUTO: 'auto';
BREAK: 'break';
BOOLEAN: 'boolean';
CONTINUE: 'continue';
DO: 'do';
ELSE: 'else';
FALSE: 'false';
FLOAT: 'float';
FOR: 'for';
FUNCTION: 'function';
IF: 'if';
INHERIT: 'inherit';
INTEGER: 'integer';
OF: 'of';
OUT: 'out';
RETURN: 'return';
STRING: 'string';
TRUE: 'true';
VOID: 'void';
WHILE: 'while';
ARRAY: 'array';

//Operators
PLUS : '+';
MINUS : '-';
MULTIPLY : '*';
DIVIDE : '/';
MODULO : '%';
NOT : '!';
AND : '&&';
OR : '||';
EQUAL : '==';
NOT_EQUAL : '!=';
LESS_THAN : '<';
LESS_THAN_OR_EQUAL : '<=';
GREATER_THAN : '>';
GREATER_THAN_OR_EQUAL : '>=';
SCOPE : '::';

// Seperators
LPAREN : '(';
RPAREN : ')';
LBRACKET : '[';
RBRACKET : ']';
DOT : '.';
COMMA : ',';
SEMICOLON : ';';
COLON : ':';
LBRACE : '{';
RBRACE : '}';
ASSIGN : '=';

// Identifier
ID: (LETTER | '_') (LETTER | UNDERSCORE | DIGIT)*;

// Literal
INT_LITERAL: NON_ZERO_DIGIT DIGIT_WITH_UNDERSCORE* | '0' {self.text = self.text.replace('_','')};
FLOAT_LITERAL: INT_LITERAL '.' DIGIT* EXPONENT? | INT_LITERAL EXPONENT;
BOOLEAN_LITERAL: TRUE | FALSE;
STRING_LITERAL: '"' (ESC_SEQ | STR_CHAR)* '"';
//ARRAY_LITERAL : '{' (expression (',' expression)*)? '}'; // Implement expression

// fragment
fragment LETTER: [a-zA-Z];
fragment DIGIT: [0-9];
fragment NON_ZERO_DIGIT: [1-9];
fragment DIGIT_WITH_UNDERSCORE: [0-9_];
fragment UNDERSCORE: '_';
fragment EXPONENT : [eE] [+-]? [0-9_]+;
fragment STR_CHAR: ~[\\"\n];
fragment ESC_SEQ:'\\b'
			   | '\\f'
			   | '\\r'
			   | '\\n'
			   | '\\t'
			   | '\\\''
			   | '\\\\'
			   | '\'"';

ERROR_CHAR: .{raise ErrorToken(self.text)};
UNCLOSE_STRING: '"' (STR_CHAR | ESC_SEQ)* (EOF | '\n'){
	content = str(self.text)
	esc = '\n'
	if content[-1] in esc:
		raise UncloseString(content[1:-1])
	else:
		raise UncloseString(content[1:])
};
ILLEGAL_ESCAPE: .;