/*
 Copyright (C) 2017, Ulrich Wolffgang <ulrich.wolffgang@proleap.io>
 All rights reserved.

 Portions copyright (C) 2019 - 2021 Craig Schneiderwent.

 This software may be modified and distributed under the terms
 of the MIT license. See the LICENSE file for details.
*/

/*
 COBOL Preprocessor Grammar for ANTLR4

 This is a preprocessor grammar for COBOL, which is part of the COBOL 
 parser at https://github.com/uwol/proleap-cobol-parser.
*/

lexer grammar CobolPreprocessorLexer;

// lexer rules --------------------------------------------------------------------------------

CLASSIC_COMMENT_TAG : TEXT TEXT TEXT TEXT TEXT TEXT '*' {getCharPositionInLine() == 7}? -> pushMode(CLASSIC_COMMENT_MODE);
CLASSIC_LINE_NUMBER : TEXT TEXT TEXT TEXT TEXT TEXT {getCharPositionInLine() == 6}? -> skip;
CLASSIC_EOL_COMMENT : TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT {getCharPositionInLine()==80}? -> skip;

ID_DIVISION_TAG : ID DIVISION {getCharPositionInLine()==18}?;

NIST_SEMI_COMMENT_A : BOL TEXT TEXT TEXT TEXT TEXT TEXT A {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_B : BOL TEXT TEXT TEXT TEXT TEXT TEXT B {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_C : BOL TEXT TEXT TEXT TEXT TEXT TEXT C {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_G : BOL TEXT TEXT TEXT TEXT TEXT TEXT G TEXT* {getCharPositionInLine() < 73}? -> skip;
NIST_SEMI_COMMENT_J : BOL TEXT TEXT TEXT TEXT TEXT TEXT J TEXT* {getCharPositionInLine() < 73}? -> skip;
NIST_SEMI_COMMENT_P : BOL TEXT TEXT TEXT TEXT TEXT TEXT P {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_S : BOL TEXT TEXT TEXT TEXT TEXT TEXT S {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_T : BOL TEXT TEXT TEXT TEXT TEXT TEXT T {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_U : BOL TEXT TEXT TEXT TEXT TEXT TEXT U {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_X : BOL TEXT TEXT TEXT TEXT TEXT TEXT X {getCharPositionInLine() == 7}? -> skip;
NIST_SEMI_COMMENT_Y : BOL TEXT TEXT TEXT TEXT TEXT TEXT Y {getCharPositionInLine() == 7}? -> skip;

// keywords
ABD : A B D;
ADATA : A D A T A;
ADV : A D V;
AFP : A F P;
ALIAS : A L I A S;
ALPHNUM : A L P H N U M;
ANSI : A N S I;
ANY : A N Y;
APOST : A P O S T;
AR : A R;
ARCH : A R C H;
ARITH : A R I T H;
AUTO : A U T O;
AWO : A W O;
BIN : B I N;
BLOCK0 : B L O C K '0';
BUF : B U F;
BUFSIZE : B U F S I Z E;
BY : B Y;
CBL : C B L;
CBLCARD : C B L C A R D;
CICS : C I C S;
CO : C O;
COBOL2 : C O B O L '2';
COBOL3 : C O B O L '3';
CODEPAGE : C O D E P A G E;
COMPAT : C O M P A T;
COMPILE : C O M P I L E;
COPY : C O P Y;
COPYLOC : C O P Y L O C;
COPYRIGHT : C O P Y R I G H T;
CP : C P;
CPLC : C P L C;
CPP : C P P;
CPSM : C P S M;
CPYR : C P Y R;
CS : C S;
CURR : C U R R;
CURRENCY : C U R R E N C Y;
DATA : D A T A;
DATEPROC : D A T E P R O C;
DBCS : D B C S;
DD : D D;
DEBUG : D E B U G;
DEC : D E C;
DECK : D E C K;
DEF : D E F;
DEFINE : D E F I N E;
DIAGTRUNC : D I A G T R U N C;
DISPSIGN : D I S P S I G N;
DIVISION : D I V I S I O N;
DLI : D L I;
DLL : D L L;
DP : D P;
DS : D S;
DSN : D S N;
DSNAME : D S N A M E;
DTR : D T R;
DU : D U;
DUMP : D U M P;
DWARF : D W A R F;
DYN : D Y N;
DYNAM : D Y N A M;
EDF : E D F;
EJECT : E J E C T;
EJPD : E J P D;
EN : E N;
ENDP : E N D P;
ENDPERIOD : E N D P E R I O D;
ENGLISH : E N G L I S H;
END_EXEC : E N D '-' E X E C;
EPILOG : E P I L O G;
EVENP : E V E N P;
EVENPACK : E V E N P A C K;
EXCI : E X C I;
EXEC : E X E C;
EXIT : E X I T;
EXP : E X P;
EXPORTALL : E X P O R T A L L;
EXTEND : E X T E N D;
FASTSRT : F A S T S R T;
FEPI : F E P I;
FLAG : F L A G;
FLAGSTD : F L A G S T D;
FSRT : F S R T;
FULL : F U L L;
GDS : G D S;
GRAPHIC : G R A P H I C;
HEX : H E X;
HGPR : H G P R;
HOOK : H O O K;
IC : I C;
ID : I D {getCharPositionInLine()==9}?;
IDENTIFICATION : I D E N T I F I C A T I O N {getCharPositionInLine()==21}?;
IN : I N;
INITCHECK : I N I T C H E C K;
INTDATE : I N T D A T E;
INITIAL : I N I T I A L;
INL : I N L;
JA : J A;
JP : J P;
KA : K A;
LANG : L A N G;
LANGUAGE : L A N G U A G E;
LAX : L A X;
LAXPERF : L A X P E R F;
LC : L C;
LEASM : L E A S M;
LENGTH : L E N G T H;
LIB : L I B;
LILIAN : L I L I A N;
LIN : L I N;
LINECOUNT : L I N E C O U N T;
LINKAGE : L I N K A G E;
LIST : L I S T;
LM : L M;
LONGMIXED : L O N G M I X E D;
LONGUPPER : L O N G U P P E R;
LP : L P;
LPARENCHAR : '(';
LU : L U;
LXPRF : L X P R F;
MAP : M A P;
MARGINS : M A R G I N S;
MAX : M A X;
MD : M D;
MDECK : M D E C K;
MIG : M I G;
MIXED : M I X E D;
MAXPCF : M A X P C F;
MSG : M S G;
NAME : N A M E;
NAT : N A T;
NATIONAL : N A T I O N A L;
NATLANG : N A T L A N G;
NC : N C;
NN : N N;
NO : N O;
NOADATA : N O A D A T A;
NOADV : N O A D V;
NOALIAS : N O A L I A S;
NOALPHNUM : N O A L P H N U M;
NOAWO : N O A W O;
NOBIN : N O B I N;
NOBLOCK0 : N O B L O C K '0';
NOC : N O C;
NOCBLCARD : N O C B L C A R D;
NOCICS : N O C I C S;
NOCMPR2 : N O C M P R '2';
NOCOMPILE : N O C O M P I L E;
NOCOPYLOC : N O C O P Y L O C;
NOCOPYRIGHT : N O C O P Y R I G H T;
NOCPLC : N O C P L C;
NOCPSM : N O C P S M;
NOCPYR : N O C P Y R;
NOCURR : N O C U R R;
NOCURRENCY : N O C U R R E N C Y;
NOD : N O D;
NODATEPROC : N O D A T E P R O C;
NODBCS : N O D B C S;
NODE : N O D E;
NODEBUG : N O D E B U G;
NODECK : N O D E C K;
NODEFINE : N O D E F I N E;
NODEF : N O D E F;
NODIAGTRUNC : N O D I A G T R U N C;
NODLL : N O D L L;
NODSNAME : N O D S N A M E;
NODU : N O D U;
NODUMP : N O D U M P;
NODP : N O D P;
NODTR : N O D T R;
NODWARF : N O D W A R F;
NODYN : N O D Y N;
NODYNAM : N O D Y N A M;
NOEDF : N O E D F;
NOEJPD : N O E J P D;
NOENDP : N O E N D P;
NOENDPERIOD : N O E N D P E R I O D;
NOEPILOG : N O E P I L O G;
NOEVENP : N O E V E N P;
NOEVENPACK : N O E V E N P A C K;
NOEXIT : N O E X I T;
NOEXP : N O E X P;
NOEXPORTALL : N O E X P O R T A L L;
NOF : N O F;
NOFASTSRT : N O F A S T S R T;
NOFEPI : N O F E P I;
NOFLAG : N O F L A G;
NOFLAGMIG : N O F L A G M I G;
NOFLAGSTD : N O F L A G S T D;
NOFSRT : N O F S R T;
NOGRAPHIC : N O G R A P H I C;
NOHOOK : N O H O O K;
NOINITCHECK : N O I N I T C H E C K;
NOIC : N O I C;
NOINITIAL : N O I N I T I A L;
NOINLINE : N O I N L I N E;
NOINL : N O I N L;
NOLAXPERF : N O L A X P E R F;
NOLENGTH : N O L E N G T H;
NOLIB : N O L I B;
NOLINKAGE : N O L I N K A G E;
NOLIST : N O L I S T;
NOLXPRF : N O L X P R F;
NOMAP : N O M A P;
NOMD : N O M D;
NOMDECK : N O M D E C K;
NONAME : N O N A M E;
NONUM : N O N U M;
NONUMBER : N O N U M B E R;
NOOBJ : N O O B J;
NOOBJECT : N O O B J E C T;
NOOMITODOMIN : N O O M I T O D O M I N;
NOOFF : N O O F F;
NOOFFSET : N O O F F S E T;
NOOOM : N O O O M;
NOOPSEQUENCE : N O O P S E Q U E N C E;
NOOPT : N O O P T;
NOOPTIMIZE : N O O P T I M I Z E;
NOOPTIONS : N O O P T I O N S;
NOP : N O P;
NOPAC : N O P A C;
NOPARMCHECK : N O P A R M C H E C K;
NOPFD : N O P F D;
NOPRESERVE : N O P R E S E R V E;
NOPROLOG : N O P R O L O G;
NORENT : N O R E N T;
NORULES : N O R U L E S;
NOS : N O S;
NOSEP : N O S E P;
NOSEPARATE : N O S E P A R A T E;
NOSEQ : N O S E Q;
NOSERV : N O S E R V;
NOSERVICE : N O S E R V I C E;
NOSLACKBYTES : N O S L A C K B Y T E S;
NOSLCKB : N O S L C K B;
NOSO : N O S O;
NOSOURCE : N O S O U R C E;
NOSPIE : N O S P I E;
NOSQL : N O S Q L;
NOSQLC : N O S Q L C;
NOSQLCCSID : N O S Q L C C S I D;
NOSQLIMS : N O S Q L I M S;
NOSSR : N O S S R;
NOSSRANGE : N O S S R A N G E;
NOSTDTRUNC : N O S T D T R U N C;
NOSEQUENCE : N O S E Q U E N C E;
NOSTGOPT : N O S T G O P T;
NOSUPP : N O S U P P;
NOSUPPRESS : N O S U P P R E S S;
NOTERM : N O T E R M;
NOTERMINAL : N O T E R M I N A L;
NOTEST : N O T E S T;
NOTHREAD : N O T H R E A D;
NOTRIG : N O T R I G;
NOUNRA : N O U N R A;
NOUNREFALL : N O U N R E F A L L;
NOUNREFSOURCE : N O U N R E F S O U R C E;
NOUNRS : N O U N R S;
NOVBREF : N O V B R E F;
NOVOLATILE : N O V O L A T I L E;
NOWD : N O W D;
NOWORD : N O W O R D;
NOX : N O X;
NOXREF : N O X R E F;
NOZC : N O Z C;
NOZLEN : N O Z L E N;
NOZON : N O Z O N;
NOZONECHECK : N O Z O N E C H E C K;
NOZWB : N O Z W B;
NS : N S;
NSEQ : N S E Q;
NSYMBOL : N S Y M B O L;
NUM : N U M;
NUMBER : N U M B E R;
NUMCHECK : N U M C H E C K;
NUMPROC : N U M P R O C;
OBJ : O B J;
OBJECT : O B J E C T;
OF : O F;
OFF : O F F;
OFFSET : O F F S E T;
ON : O N;
OMITODOMIN : O M I T O D O M I N;
OOM : O O M;
OP : O P;
OPMARGINS : O P M A R G I N S;
OPSEQUENCE : O P S E Q U E N C E;
OPT : O P T;
OPTFILE : O P T F I L E;
OPTIMIZE : O P T I M I Z E;
OPTIONS : O P T I O N S;
OUT : O U T;
OUTDD : O U T D D;
PAC : P A C;
PARMCHECK : P A R M C H E C K;
PATH : P A T H;
PC : P C;
PFD : P F D;
PPTDBG : P P T D B G;
PGMN : P G M N;
PGMNAME : P G M N A M E;
PRESERVE : P R E S E R V E;
PROCESS : P R O C E S S;
PROLOG : P R O L O G;
QUALIFY : Q U A L I F Y;
QUA : Q U A;
QUOTE : Q U O T E;
RENT : R E N T;
REPLACE : R E P L A C E;
REPLACING : R E P L A C I N G;
RMODE : R M O D E;
RPARENCHAR : ')';
RULES : R U L E S;
SEP : S E P;
SEPARATE : S E P A R A T E;
SEQ : S E Q;
SEQUENCE : S E Q U E N C E;
SERV : S E R V;
SERVICE : S E R V I C E;
SHORT : S H O R T;
SIZE : S I Z E;
SLACKBYTES : S L A C K B Y T E S;
SLCKB : S L C K B;
SOURCE : S O U R C E;
SP : S P;
SPACE : S P A C E;
SPIE : S P I E;
SQL : S Q L;
SQLC : S Q L C;
SQLCCSID : S Q L C C S I D;
SQLIMS : S Q L I M S;
SKIP1 : S K I P '1';
SKIP2 : S K I P '2';
SKIP3 : S K I P '3';
SO : S O;
SS : S S;
SSR : S S R;
SSRANGE : S S R A N G E;
STANDARD : S T A N D A R D;
STD : S T D;
STGOPT : S T G O P T;
STRICT : S T R I C T;
SUCC : S U C C;
SUPP : S U P P;
SUPPRESS : S U P P R E S S;
SYSEIB : S Y S E I B;
SZ : S Z;
TERM : T E R M;
TERMINAL : T E R M I N A L;
TEST : T E S T;
THREAD : T H R E A D;
TITLE : T I T L E;
TRIG : T R I G;
TRUNC : T R U N C;
UE : U E;
UNREF : U N R E F;
UPPER : U P P E R;
VBREF : V B R E F;
VLR : V L R;
VOLATILE : V O L A T I L E;
VS : V S;
VSAMOPENFS : V S A M O P E N F S;
WD : W D;
WORD : W O R D;
XMLPARSE : X M L P A R S E;
XMLSS : X M L S S;
XOPTS: X O P T S;
XP : X P;
XREF : X R E F;
YEARWINDOW : Y E A R W I N D O W;
YW : Y W;
ZC : Z C;
ZD : Z D;
ZLEN : Z L E N;
ZON : Z O N;
ZONECHECK : Z O N E C H E C K;
ZONEDATA : Z O N E D A T A;
ZWB : Z W B;

C_CHAR : C;
D_CHAR : D;
E_CHAR : E;
F_CHAR : F;
H_CHAR : H;
I_CHAR : I;
M_CHAR : M;
N_CHAR : N;
O_CHAR : O;
Q_CHAR : Q;
S_CHAR : S;
U_CHAR : U;
W_CHAR : W;
X_CHAR : X;


// symbols
//COLONCHAR : ':';
COMMENTTAG : '*>';
COMMACHAR : ',';
COMPILER_DIRECTIVE_TAG : '>>' -> pushMode(COMPILER_DIRECTIVE_MODE);
DOT : '.';
DOUBLEEQUALCHAR : '==';


// literals
NONNUMERICLITERAL : STRINGLITERAL | HEXNUMBER | BINNUMBER {getCharPositionInLine() > 7}? ;
NUMERICLITERAL : [0-9]+ {getCharPositionInLine() > 7}? ;

fragment BINNUMBER :
	B '"' [01]+ '"'
	| B '\'' [01]+ '\''
;

fragment HEXNUMBER :
	X '"' [0-9A-F]+ '"'
	| X '\'' [0-9A-F]+ '\''
;

fragment STRINGLITERAL :
	'"' (~["\n\r] | '""' | '\'')* '"'
	| '\'' (~['\n\r] | '\'\'' | '"')* '\''
;

IDENTIFIER : [a-zA-Z0-9]+ ([-_]+ [a-zA-Z0-9]+)* {getCharPositionInLine() > 7 && getCharPositionInLine() < 73}? ;
FILENAME : [a-zA-Z0-9]+ '.' [a-zA-Z0-9]+ {getCharPositionInLine() > 7 && getCharPositionInLine() < 73}? ;
PSEUDOTEXTIDENTIFIER : [:a-zA-Z0-9]+ ([-_]+ [:a-zA-Z0-9]*)* {getCharPositionInLine() > 7 && getCharPositionInLine() < 73}? ;


// whitespace, line breaks, comments, ...
NEWLINE : '\r'? '\n';
MULTINEWLINE : ('\n' | '\r')+ -> skip;
COMMENTLINE : COMMENTTAG ~('\n' | '\r')* -> channel(HIDDEN);
WS : [ \t\f;]+ -> channel(HIDDEN);
TEXT : ~('\n' | '\r');
BOL : [\r\n\f]+ ;
//LEGACYCOMMENTLINE : BOL ~('\n' | '\r') ~('\n' | '\r') ~('\n' | '\r') ~('\n' | '\r') ~('\n' | '\r') ~('\n' | '\r') '*' TEXT* [\r\n\f]+ -> channel(HIDDEN);

// case insensitive chars
fragment A:('a'|'A');
fragment B:('b'|'B');
fragment C:('c'|'C');
fragment D:('d'|'D');
fragment E:('e'|'E');
fragment F:('f'|'F');
fragment G:('g'|'G');
fragment H:('h'|'H');
fragment I:('i'|'I');
fragment J:('j'|'J');
fragment K:('k'|'K');
fragment L:('l'|'L');
fragment M:('m'|'M');
fragment N:('n'|'N');
fragment O:('o'|'O');
fragment P:('p'|'P');
fragment Q:('q'|'Q');
fragment R:('r'|'R');
fragment S:('s'|'S');
fragment T:('t'|'T');
fragment U:('u'|'U');
fragment V:('v'|'V');
fragment W:('w'|'W');
fragment X:('x'|'X');
fragment Y:('y'|'Y');
fragment Z:('z'|'Z');

mode CLASSIC_COMMENT_MODE;

CLASSIC_COMMENT_NEWLINE : NEWLINE ->type(NEWLINE),popMode;

CLASSIC_COMMENT_TEXT : TEXT;

mode COMPILER_DIRECTIVE_MODE;

CD_NEWLINE : NEWLINE ->type(NEWLINE),popMode;
CD_WS : WS ->channel(HIDDEN);
CD_CLASSIC_EOL_COMMENT : TEXT TEXT TEXT TEXT TEXT TEXT TEXT TEXT {getCharPositionInLine()==80}? -> skip;

ASTERISKCHAR : '*';
EQUALCHAR : '=';
GREATERTHANCHAR : '>';
LESSTHANCHAR : '<';
PLUSCHAR : '+';
MINUSCHAR : '-';
SLASHCHAR : '/';
NOTEQUALCHAR : '<>';
GREATEROREQUALCHAR : '>=';
LESSOREQUALCHAR : '<=';
ZERO : Z E R O;

CD_LPARENCHAR : LPARENCHAR ->type(LPARENCHAR);
CD_RPARENCHAR : RPARENCHAR ->type(RPARENCHAR);

AS : A S;
AND : A N D;
CALLINT : C A L L I N T;
CALLINTERFACE : C A L L I N T E R F A C E;
COND_COMP_DEFINE : D E F I N E -> type(DEFINE);
DEFINED : D E F I N E D;
DLL_INTERFACE : D L L;
DYNAMIC : D Y N A M I C;
ELSE : E L S E;
END_EVALUATE : E N D '-' E V A L U A T E;
END_IF : E N D '-' I F;
EQUAL : E Q U A L;
EVALUATE : E V A L U A T E;
GREATER : G R E A T E R;
IF : I F;
INLINE : I N L I N E;
INLINE_OFF : O F F;
INLINE_ON : O N;
IS : I S;
LESS : L E S S;
NOT : N O T;
OR : O R;
OTHER : O T H E R;
OVERRIDE : O V E R R I D E;
PARAMETER : P A R A M E T E R;
STATIC : S T A T I C;
THAN : T H A N;
THROUGH : T H R O U G H;
THRU : T H R U;
TO : T O;
TRUE : T R U E;
WHEN : W H E N;

CD_NONNUMERICLITERAL : NONNUMERICLITERAL ->type(NONNUMERICLITERAL);
CD_NUMERICLITERAL : NUMERICLITERAL ->type(NUMERICLITERAL);
CD_IDENTIFIER : IDENTIFIER ->type(IDENTIFIER);

