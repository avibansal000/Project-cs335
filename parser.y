%{
    #include<bits/stdc++.h>
    using namespace std;   
    extern "C" int yylex();
    extern "C" FILE *yyin;
    extern "C" int yylineno; 
    void yyerror(char *s);
    char* numtochar( int num){
        string s="0";
        while(num>0){
            s.push_back(num%10+'0');
            num/=10;
        }
        reverse(s.begin(),s.end());
        int n=s.size();
        char* c= (char*)malloc(sizeof(char)*(n+1));
        for( int i=0;i<n;i++){  
            c[i]=s[i];
        }
        c[n]='\0';
        return c;
    }
    int chartonum(char * c){
        int i=0;
        int num=0;
        while(c[i]!='\0'){
            num*=10;
            num+=c[i]-'0';
            i++;
        }
        return num;
    } 
    string chartostring(char* c){
        string s;
        int i=0;
        while(c[i]!='\0'){
            s.push_back(c[i]);
            i++;
        }
        return s;
    }
    struct label{
        int num;
        string l;
    } ;
    struct edge{
        int a;
        int b;
        string l;
    };
    
    vector<label> labels;
    vector<edge> edges;
    char* addlabel(string c){  // takes argument as the label of the node in string form and output a char* which is a unique number to the node
        // string c=chartostring(c1);
        int n=labels.size()+1;
        label q;
        q.num=n*10;
        q.l=c;
        labels.push_back(q);
        return numtochar(n);
    }
    void addedge(char* a, char* b, string l=""){  // takes numbers of node in char* and label in string form
        edge q;
        q.a=chartonum(a);
        q.b=chartonum(b);
        q.l=l;
        edges.push_back(q);
        
    }
%}
%union{
    char* val;
}

/* data types */
%start COMPILATIONUNIT
%type<val>  DIMS
%token<val> BOOLEAN BYTE SHORT INT LONG CHAR FLOAT DOUBLE 

/* Separators */
%token<val> COMMA QUESTIONMARK SEMICOLON  OPENCURLY CLOSECURLY ANGULARLEFT ANGULARRIGHT OPENSQUARE CLOSESQUARE OPENPARAN CLOSEPARAN DOUBLECOLON TRIPLEDOT WS

/* Operators  AND -> & COMPLEMENT -> ~ */
%token<val> EQUALS MULTIPLYEQUALS DIVIDEEQUALS MODEQUALS PLUSEQUALS MINUSEQUALS PLUS MINUS DIVIDE MULTIPLY MOD OR XOR COLON NOT COMPLEMENT AND DOT OROR ANDAND PLUSPLUS MINUSMINUS ANGULARLEFTANGULARLEFT ANGULARRIGHTANGULARRIGHT ANGULARRIGHTANGULARRIGHTANGULARRIGHT
EQUALSEQUALS NOTEQUALS
/* Literals */
%token<val> INTEGERLITERAL FLOATINGPOINTLITERAL BOOLEANLITERAL CHARACTERLITERAL STRINGLITERAL TEXTBLOCK NULLLITERAL

/* Keywords */
%token<val> EXTENDS SUPER CLASS PUBLIC PRIVATE IMPLEMENTS PERMITS PROTECTED STATIC FINAL TRANSIENT VOLATILE INSTANCEOF THIS VOID NEW THROW ASSERT VAR BREAK CONTINUE RETURN YIELD IF ELSE WHILE FOR ABSTRACT SYNCHRONIZED NATIVE STRICTFP

/*  Unused keywords  See throw, throws and throwss check non_sealed*/
%token<val> SWITCH DEFAULT PACKAGE DO GOTO IMPORT THROWS CASE ENUM CATCH TRY INTERFACE FINALLY CONST UNDERSCORE EXPORTS OPENS REQUIRES USES MODULE SEALED PROVIDES TO WITH OPEN RECORD TRANSITIVE ERROR ONCE NL NON_SEALED


%token<val> IDENTIFIER UNQUALIFIEDMETHODIDENTIFIER  DOTCLASS
%token<val> EOFF


/* %type<val> CHAPTERTITLE SECTIONTITLE  */

%%

COMPILATIONUNIT     :   EOFF  {$$=addlabel("COMPILATIONUNIT");$1=addlabel("eoff" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   ORDINARYCOMPILATIONUNIT EOFF {$$=addlabel("COMPILATIONUNIT");addedge($$, $1);$2=addlabel("eoff" +  "(" +  chartostring($2)+")");addedge($$, $2);}
TYPE    :   PRIMITIVETYPE{$$=addlabel("TYPE");addedge($$, $1);}
            |   REFERENCETYPE;{$$=addlabel("TYPE");addedge($$, $1);}
PRIMITIVETYPE   :   NUMERICTYPE{$$=addlabel("PRIMITIVETYPE");addedge($$, $1);}
                |   BOOLEAN;{$$=addlabel("PRIMITIVETYPE");addedge($$, $1);}
NUMERICTYPE     :   INTEGRALTYPE{$$=addlabel("NUMERICTYPE");addedge($$, $1);}
                |   FLOATINGTYPE;{$$=addlabel("NUMERICTYPE");addedge($$, $1);}
INTEGRALTYPE    : BYTE{$$=addlabel("INTEGRALTYPE");$1=addlabel("byte" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                | SHORT {$$=addlabel("INTEGRALTYPE");$1=addlabel("short" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                | INT {$$=addlabel("INTEGRALTYPE");$1=addlabel("int" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                | LONG {$$=addlabel("INTEGRALTYPE");$1=addlabel("long" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                | CHAR;{$$=addlabel("INTEGRALTYPE");addedge($$, $1);}
FLOATINGTYPE    :   FLOAT{$$=addlabel("FLOATINGTYPE");$1=addlabel("float" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                |   DOUBLE;{$$=addlabel("FLOATINGTYPE");addedge($$, $1);}
REFERENCETYPE   :   CLASSORINTERFACETYPE{$$=addlabel("REFERENCETYPE");addedge($$, $1);}
CLASSORINTERFACETYPE    :   CLASSTYPE {$$=addlabel("CLASSORINTERFACETYPE");addedge($$, $1);}
CLASSTYPE   :   CLASSTYPE1{$$=addlabel("CLASSTYPE");addedge($$, $1);}
CLASSTYPE1  :   IDENTIFIER{$$=addlabel("CLASSTYPE1");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
TYPEARGUMENTS   :   ANGULARLEFT TYPEARGUMENTLIST  ANGULARRIGHT{$$=addlabel("TYPEARGUMENTS");$1=addlabel("angularleft" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$4=addlabel("angularright" +  "(" +  chartostring($4)+")");addedge($$, $4);}
TYPEARGUMENTLIST    :   TYPEARGUMENT{$$=addlabel("TYPEARGUMENTLIST");addedge($$, $1);}
                    |   TYPEARGUMENTLIST COMMA TYPEARGUMENT{$$=addlabel("TYPEARGUMENTLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
TYPEARGUMENT    :   REFERENCETYPE{$$=addlabel("TYPEARGUMENT");addedge($$, $1);}
                |   WILDCARD;{$$=addlabel("TYPEARGUMENT");addedge($$, $1);}
WILDCARD    :   QUESTIONMARK {$$=addlabel("WILDCARD");$1=addlabel("questionmark" +  "(" +  chartostring($1)+")");addedge($$, $1);}
            |   QUESTIONMARK WILDCARDBOUNDS{$$=addlabel("WILDCARD");$1=addlabel("questionmark" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
WILDCARDBOUNDS  :   EXTENDS REFERENCETYPE{$$=addlabel("WILDCARDBOUNDS");$1=addlabel("extends" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                |   SUPER REFERENCETYPE;{$$=addlabel("WILDCARDBOUNDS");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
INTERFACETYPE   :   CLASSTYPE{$$=addlabel("INTERFACETYPE");addedge($$, $1);}
DIMS    :   OPENSQUARE CLOSESQUARE {$$=addlabel("DIMS");$1=addlabel("opensquare" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("closesquare" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        |   DIMS OPENSQUARE CLOSESQUARE{$$=addlabel("DIMS");addedge($$, $1);$2=addlabel("opensquare" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closesquare" +  "(" +  chartostring($3)+")");addedge($$, $3);}
METHODNAME  :   IDENTIFIER {$$=addlabel("METHODNAME");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
EXPRESSIONNAME   :   IDENTIFIER DOT IDENTIFIER{$$=addlabel("EXPRESSIONNAME");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |   EXPRESSIONNAME DOT IDENTIFIER{$$=addlabel("EXPRESSIONNAME");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
ORDINARYCOMPILATIONUNIT :   TOPLEVELCLASSORINTERFACEDECLARATION {$$=addlabel("ORDINARYCOMPILATIONUNIT");addedge($$, $1);}
                        |   ORDINARYCOMPILATIONUNIT TOPLEVELCLASSORINTERFACEDECLARATION{$$=addlabel("ORDINARYCOMPILATIONUNIT");addedge($$, $1);addedge($$, $2);}
TOPLEVELCLASSORINTERFACEDECLARATION :   CLASSDECLARATION{$$=addlabel("TOPLEVELCLASSORINTERFACEDECLARATION");addedge($$, $1);}
                                    |   SEMICOLON;{$$=addlabel("TOPLEVELCLASSORINTERFACEDECLARATION");addedge($$, $1);}
CLASSDECLARATION    :   NORMALCLASSDECLARATION{$$=addlabel("CLASSDECLARATION");addedge($$, $1);}
NORMALCLASSDECLARATION  :    CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER TYPEPARAMETERS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                            | CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                            | CLASS IDENTIFIER CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | CLASS IDENTIFIER CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                            | CLASS IDENTIFIER CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                            | CLASS IDENTIFIER CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");$1=addlabel("class" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);addedge($$, $8);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER TYPEPARAMETERS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER1 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER1 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER1 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER1 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER1 CLASS IDENTIFIER CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER1 CLASS IDENTIFIER CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);addedge($$, $8);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER TYPEPARAMETERS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER2 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER2 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER2 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER2 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER2 CLASS IDENTIFIER CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER2 CLASS IDENTIFIER CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);addedge($$, $8);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER TYPEPARAMETERS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER3 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);addedge($$, $7);}
                            | SUPER3 CLASS IDENTIFIER CLASSEXTENDS CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER CLASSEXTENDS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER CLASSEXTENDS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER3 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);addedge($$, $6);}
                            | SUPER3 CLASS IDENTIFIER CLASSIMPLEMENTS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER3 CLASS IDENTIFIER CLASSPERMITS CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);addedge($$, $5);}
                            | SUPER3 CLASS IDENTIFIER CLASSBODY{$$=addlabel("NORMALCLASSDECLARATION");addedge($$, $1);$2=addlabel("class" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
TYPEPARAMETERS  :   ANGULARLEFT TYPEPARAMETERLIST ANGULARRIGHT{$$=addlabel("TYPEPARAMETERS");$1=addlabel("angularleft" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("angularright" +  "(" +  chartostring($3)+")");addedge($$, $3);}
TYPEPARAMETERLIST   :   TYPEPARAMETER{$$=addlabel("TYPEPARAMETERLIST");addedge($$, $1);}
                    |   TYPEPARAMETERLIST COMMA TYPEPARAMETER{$$=addlabel("TYPEPARAMETERLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
TYPEPARAMETER   :   IDENTIFIER TYPEBOUND{$$=addlabel("TYPEPARAMETER");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                |   IDENTIFIER;{$$=addlabel("TYPEPARAMETER");addedge($$, $1);}
TYPEBOUND   :  EXTENDS IDENTIFIER{$$=addlabel("TYPEBOUND");$1=addlabel("extends" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |   EXTENDS CLASSORINTERFACETYPE ADDITIONALBOUND{$$=addlabel("TYPEBOUND");$1=addlabel("extends" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
ADDITIONALBOUND :   AND INTERFACETYPE{$$=addlabel("ADDITIONALBOUND");$1=addlabel("and" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                |   ADDITIONALBOUND AND INTERFACETYPE{$$=addlabel("ADDITIONALBOUND");addedge($$, $1);$2=addlabel("and" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
CLASSEXTENDS    :   EXTENDS CLASSTYPE{$$=addlabel("CLASSEXTENDS");$1=addlabel("extends" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
CLASSIMPLEMENTS :    IMPLEMENTS INTERFACETYPELIST{$$=addlabel("CLASSIMPLEMENTS");$1=addlabel("implements" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
INTERFACETYPELIST   :   INTERFACETYPE{$$=addlabel("INTERFACETYPELIST");addedge($$, $1);}
                    |   INTERFACETYPELIST COMMA INTERFACETYPE{$$=addlabel("INTERFACETYPELIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
CLASSPERMITS    :   PERMITS TYPENAMES{$$=addlabel("CLASSPERMITS");$1=addlabel("permits" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
TYPENAMES   :   IDENTIFIER{$$=addlabel("TYPENAMES");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
            |   TYPENAMES COMMA IDENTIFIER{$$=addlabel("TYPENAMES");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
CLASSBODY   :  OPENCURLY CLOSECURLY {$$=addlabel("CLASSBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("closecurly" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |   OPENCURLY CLASSBODYDECLARATIONS CLOSECURLY{$$=addlabel("CLASSBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
CLASSBODYDECLARATIONS   :   CLASSBODYDECLARATION{$$=addlabel("CLASSBODYDECLARATIONS");addedge($$, $1);}
                        |   CLASSBODYDECLARATIONS CLASSBODYDECLARATION{$$=addlabel("CLASSBODYDECLARATIONS");addedge($$, $1);addedge($$, $2);}
CLASSBODYDECLARATION    :   CLASSMEMBERDECLARATION{$$=addlabel("CLASSBODYDECLARATION");addedge($$, $1);}
                        |   INSTANCEINITIALIZER{$$=addlabel("CLASSBODYDECLARATION");addedge($$, $1);}
                        |   STATICINITIALIZER{$$=addlabel("CLASSBODYDECLARATION");addedge($$, $1);}
                        |   CONSTRUCTORDECLARATION;{$$=addlabel("CLASSBODYDECLARATION");addedge($$, $1);}
CLASSMEMBERDECLARATION:     FIELDDECLARATION{$$=addlabel("CLASSMEMBERDECLARATION");addedge($$, $1);}
                            |   METHODDECLARATION{$$=addlabel("CLASSMEMBERDECLARATION");addedge($$, $1);}
                            |   CLASSDECLARATION{$$=addlabel("CLASSMEMBERDECLARATION");addedge($$, $1);}
                            |   SEMICOLON{$$=addlabel("CLASSMEMBERDECLARATION");$1=addlabel("semicolon" +  "(" +  chartostring($1)+")");addedge($$, $1);}
FIELDDECLARATION    :   FIELDMODIFIERS TYPE VARIABLEDECLARATORLIST SEMICOLON{$$=addlabel("FIELDDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                    |   SUPER1 TYPE VARIABLEDECLARATORLIST SEMICOLON{$$=addlabel("FIELDDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                    |   SUPER2 TYPE VARIABLEDECLARATORLIST SEMICOLON{$$=addlabel("FIELDDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                    |   TYPE VARIABLEDECLARATORLIST SEMICOLON;{$$=addlabel("FIELDDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
VARIABLEDECLARATORLIST  :   VARIABLEDECLARATOR{$$=addlabel("VARIABLEDECLARATORLIST");addedge($$, $1);}
                        |   VARIABLEDECLARATORLIST COMMA VARIABLEDECLARATOR;{$$=addlabel("VARIABLEDECLARATORLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
VARIABLEDECLARATOR  :   VARIABLEDECLARATORID EQUALS VARIABLEINITIALIZER{$$=addlabel("VARIABLEDECLARATOR");addedge($$, $1);$2=addlabel("equals" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                    |   VARIABLEDECLARATORID{$$=addlabel("VARIABLEDECLARATOR");addedge($$, $1);}
VARIABLEDECLARATORID    :   IDENTIFIER {$$=addlabel("VARIABLEDECLARATORID");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                        |   IDENTIFIER DIMS{$$=addlabel("VARIABLEDECLARATORID");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
VARIABLEINITIALIZER :    EXPRESSION{$$=addlabel("VARIABLEINITIALIZER");addedge($$, $1);}
                    |   ARRAYINITIALIZER{$$=addlabel("VARIABLEINITIALIZER");addedge($$, $1);}
EXPRESSION  :  ASSIGNMENTEXPRESSION{$$=addlabel("EXPRESSION");addedge($$, $1);}
ASSIGNMENTEXPRESSION    :   CONDITIONALEXPRESSION{$$=addlabel("ASSIGNMENTEXPRESSION");addedge($$, $1);}
                        |   ASSIGNMENT{$$=addlabel("ASSIGNMENTEXPRESSION");addedge($$, $1);}
ASSIGNMENT  :   LEFTHANDSIDE ASSIGNMENTOPERATOR EXPRESSION{$$=addlabel("ASSIGNMENT");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
LEFTHANDSIDE    :   EXPRESSIONNAME{$$=addlabel("LEFTHANDSIDE");addedge($$, $1);}
                |   IDENTIFIER{$$=addlabel("LEFTHANDSIDE");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                |   FIELDACCESS{$$=addlabel("LEFTHANDSIDE");addedge($$, $1);}
                |   ARRAYACCESS{$$=addlabel("LEFTHANDSIDE");addedge($$, $1);}
ASSIGNMENTOPERATOR  :  EQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("equals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |  MULTIPLYEQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("multiplyequals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   DIVIDEEQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("divideequals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   MODEQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("modequals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   PLUSEQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("plusequals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   MINUSEQUALS{$$=addlabel("ASSIGNMENTOPERATOR");$1=addlabel("minusequals" +  "(" +  chartostring($1)+")");addedge($$, $1);}
FIELDACCESS: PRIMARY DOT IDENTIFIER{$$=addlabel("FIELDACCESS");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
            |	SUPER DOT IDENTIFIER{$$=addlabel("FIELDACCESS");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
            |	IDENTIFIER DOT SUPER DOT IDENTIFIER{$$=addlabel("FIELDACCESS");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("dot" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("identifier" +  "(" +  chartostring($5)+")");addedge($$, $5);}
PRIMARY: PRIMARYNONEWARRAY{$$=addlabel("PRIMARY");addedge($$, $1);}
        |	ARRAYCREATIONEXPRESSION{$$=addlabel("PRIMARY");addedge($$, $1);}
PRIMARYNONEWARRAY: LITERAL{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	CLASSLITERAL{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	THIS{$$=addlabel("PRIMARYNONEWARRAY");$1=addlabel("this" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                  |	IDENTIFIER DOT THIS{$$=addlabel("PRIMARYNONEWARRAY");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("this" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                  |	OPENPARAN EXPRESSION CLOSEPARAN{$$=addlabel("PRIMARYNONEWARRAY");$1=addlabel("openparan" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                  |	CLASSINSTANCECREATIONEXPRESSION         {$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	FIELDACCESS{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	ARRAYACCESS{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	METHODINVOCATION{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
                  |	METHODREFERENCE{$$=addlabel("PRIMARYNONEWARRAY");addedge($$, $1);}
LITERAL: INTEGERLITERAL{$$=addlabel("LITERAL");$1=addlabel("integerliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	FLOATINGPOINTLITERAL{$$=addlabel("LITERAL");$1=addlabel("floatingpointliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	BOOLEANLITERAL{$$=addlabel("LITERAL");$1=addlabel("booleanliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	CHARACTERLITERAL{$$=addlabel("LITERAL");$1=addlabel("characterliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	STRINGLITERAL{$$=addlabel("LITERAL");$1=addlabel("stringliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	TEXTBLOCK{$$=addlabel("LITERAL");$1=addlabel("textblock" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        |	NULLLITERAL{$$=addlabel("LITERAL");$1=addlabel("nullliteral" +  "(" +  chartostring($1)+")");addedge($$, $1);}
CLASSLITERAL: IDENTIFIER DOTCLASS{$$=addlabel("CLASSLITERAL");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dotclass" +  "(" +  chartostring($2)+")");addedge($$, $2);}
             |	NUMERICTYPE DOTCLASS{$$=addlabel("CLASSLITERAL");addedge($$, $1);$2=addlabel("dotclass" +  "(" +  chartostring($2)+")");addedge($$, $2);}
             |	BOOLEAN DOTCLASS{$$=addlabel("CLASSLITERAL");$1=addlabel("boolean" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dotclass" +  "(" +  chartostring($2)+")");addedge($$, $2);}
             |	VOID DOTCLASS{$$=addlabel("CLASSLITERAL");$1=addlabel("void" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dotclass" +  "(" +  chartostring($2)+")");addedge($$, $2);}
             | IDENTIFIER SQUARESTAR DOTCLASS{$$=addlabel("CLASSLITERAL");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("dotclass" +  "(" +  chartostring($3)+")");addedge($$, $3);}
             |	NUMERICTYPE SQUARESTAR DOTCLASS{$$=addlabel("CLASSLITERAL");addedge($$, $1);addedge($$, $2);$3=addlabel("dotclass" +  "(" +  chartostring($3)+")");addedge($$, $3);}
             |	BOOLEAN SQUARESTAR DOTCLASS{$$=addlabel("CLASSLITERAL");$1=addlabel("boolean" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("dotclass" +  "(" +  chartostring($3)+")");addedge($$, $3);}
SQUARESTAR  :   OPENSQUARE CLOSESQUARE{$$=addlabel("SQUARESTAR");$1=addlabel("opensquare" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("closesquare" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |   SQUARESTAR  OPENSQUARE CLOSESQUARE{$$=addlabel("SQUARESTAR");addedge($$, $1);$3=addlabel("opensquare" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("closesquare" +  "(" +  chartostring($4)+")");addedge($$, $4);}
CLASSINSTANCECREATIONEXPRESSION: UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION{$$=addlabel("CLASSINSTANCECREATIONEXPRESSION");addedge($$, $1);}
                                |	EXPRESSIONNAME DOT UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION{$$=addlabel("CLASSINSTANCECREATIONEXPRESSION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                                |	IDENTIFIER DOT UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION{$$=addlabel("CLASSINSTANCECREATIONEXPRESSION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                                |	PRIMARY DOT UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION{$$=addlabel("CLASSINSTANCECREATIONEXPRESSION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION:     NEW CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN CLOSEPARAN{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                                            |   NEW CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN CLOSEPARAN CLASSBODY{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
                                            |   NEW CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                                            |   NEW CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN ARGUMENTLIST CLOSEPARAN CLASSBODY {$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);}
                                            |   NEW TYPEARGUMENTS CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN CLOSEPARAN{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                                            |   NEW TYPEARGUMENTS CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN CLOSEPARAN CLASSBODY{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);}
                                            |   NEW TYPEARGUMENTS CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                                            |   NEW TYPEARGUMENTS CLASSORINTERFACETYPETOINSTANTIATE OPENPARAN ARGUMENTLIST CLOSEPARAN CLASSBODY{$$=addlabel("UNQUALIFIEDCLASSINSTANCECREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
CLASSORINTERFACETYPETOINSTANTIATE:  IDENTIFIER  {$$=addlabel("CLASSORINTERFACETYPETOINSTANTIATE");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
ARGUMENTLIST: EXPRESSION{$$=addlabel("ARGUMENTLIST");addedge($$, $1);}
            |   ARGUMENTLIST COMMA EXPRESSION{$$=addlabel("ARGUMENTLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
METHODINVOCATION: METHODNAME OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                 |  METHODNAME OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                 |	IDENTIFIER DOT IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                 |	IDENTIFIER DOT IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	IDENTIFIER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	IDENTIFIER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                 |	EXPRESSIONNAME DOT IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                 |	EXPRESSIONNAME DOT IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	EXPRESSIONNAME DOT TYPEARGUMENTS IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	EXPRESSIONNAME DOT TYPEARGUMENTS IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                 |	PRIMARY DOT IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                 |	PRIMARY DOT IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	PRIMARY DOT TYPEARGUMENTS IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	PRIMARY DOT TYPEARGUMENTS IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                 |	SUPER DOT IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                 |	SUPER DOT IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	SUPER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                 |	SUPER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                 |	IDENTIFIER DOT SUPER DOT IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("dot" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("identifier" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("openparan" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                 |	IDENTIFIER DOT SUPER DOT IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("dot" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("identifier" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("openparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);$8=addlabel("closeparan" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                 |	IDENTIFIER DOT SUPER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("dot" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("identifier" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("openparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("closeparan" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                 |	IDENTIFIER DOT SUPER DOT TYPEARGUMENTS IDENTIFIER OPENPARAN ARGUMENTLIST CLOSEPARAN{$$=addlabel("METHODINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("dot" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("identifier" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("openparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);$9=addlabel("closeparan" +  "(" +  chartostring($9)+")");addedge($$, $9);}
METHODREFERENCE:    PRIMARY DOUBLECOLON TYPEARGUMENTS IDENTIFIER{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |	CLASSTYPE DOUBLECOLON TYPEARGUMENTS IDENTIFIER{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |	SUPER DOUBLECOLON TYPEARGUMENTS IDENTIFIER{$$=addlabel("METHODREFERENCE");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |	IDENTIFIER DOT SUPER DOUBLECOLON TYPEARGUMENTS IDENTIFIER{$$=addlabel("METHODREFERENCE");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("doublecolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("identifier" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                |	CLASSTYPE DOUBLECOLON TYPEARGUMENTS NEW{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("new" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |   CLASSTYPE DOUBLECOLON IDENTIFIER{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |	PRIMARY DOUBLECOLON IDENTIFIER{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |	SUPER DOUBLECOLON IDENTIFIER{$$=addlabel("METHODREFERENCE");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |	IDENTIFIER DOT SUPER DOUBLECOLON IDENTIFIER{$$=addlabel("METHODREFERENCE");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("doublecolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("identifier" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                |	CLASSTYPE DOUBLECOLON NEW{$$=addlabel("METHODREFERENCE");addedge($$, $1);$2=addlabel("doublecolon" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("new" +  "(" +  chartostring($3)+")");addedge($$, $3);}
ARRAYCREATIONEXPRESSION: NEW PRIMITIVETYPE DIMEXPRS DIMS{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                        |	NEW CLASSORINTERFACETYPE DIMEXPRS DIMS{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                        |	NEW PRIMITIVETYPE DIMS ARRAYINITIALIZER{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                        |	NEW CLASSORINTERFACETYPE DIMS ARRAYINITIALIZER{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                        |   NEW PRIMITIVETYPE DIMEXPRS {$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |	NEW CLASSORINTERFACETYPE DIMEXPRS {$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |   NEW PRIMITIVETYPE DIMS{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |	NEW CLASSORINTERFACETYPE DIMS{$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |   NEW PRIMITIVETYPE {$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                        |	NEW CLASSORINTERFACETYPE {$$=addlabel("ARRAYCREATIONEXPRESSION");$1=addlabel("new" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
ARRAYINITIALIZER    :  OPENCURLY ARRAYINITIALIZER1 CLOSECURLY{$$=addlabel("ARRAYINITIALIZER");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                    |   OPENCURLY CLOSECURLY{$$=addlabel("ARRAYINITIALIZER");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("closecurly" +  "(" +  chartostring($2)+")");addedge($$, $2);}
ARRAYINITIALIZER1   :  VARIABLEINITIALIZERLIST {$$=addlabel("ARRAYINITIALIZER1");addedge($$, $1);}
                    |   COMMA{$$=addlabel("ARRAYINITIALIZER1");$1=addlabel("comma" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                    |   VARIABLEINITIALIZERLIST COMMA{$$=addlabel("ARRAYINITIALIZER1");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);}
DIMEXPRS: DIMEXPR{$$=addlabel("DIMEXPRS");addedge($$, $1);}
        |   DIMEXPRS DIMEXPR{$$=addlabel("DIMEXPRS");addedge($$, $1);addedge($$, $2);}
DIMEXPR: OPENSQUARE EXPRESSION CLOSESQUARE;{$$=addlabel("DIMEXPR");$1=addlabel("opensquare" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
VARIABLEINITIALIZERLIST :   VARIABLEINITIALIZER{$$=addlabel("VARIABLEINITIALIZERLIST");addedge($$, $1);}
                        |   VARIABLEINITIALIZERLIST COMMA VARIABLEINITIALIZER{$$=addlabel("VARIABLEINITIALIZERLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
ARRAYACCESS: EXPRESSIONNAME OPENSQUARE EXPRESSION CLOSESQUARE{$$=addlabel("ARRAYACCESS");addedge($$, $1);$2=addlabel("opensquare" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closesquare" +  "(" +  chartostring($4)+")");addedge($$, $4);}
            |	PRIMARYNONEWARRAY OPENSQUARE EXPRESSION CLOSESQUARE{$$=addlabel("ARRAYACCESS");addedge($$, $1);$2=addlabel("opensquare" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closesquare" +  "(" +  chartostring($4)+")");addedge($$, $4);}
            |	IDENTIFIER OPENSQUARE EXPRESSION CLOSESQUARE{$$=addlabel("ARRAYACCESS");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("opensquare" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closesquare" +  "(" +  chartostring($4)+")");addedge($$, $4);}
CONDITIONALEXPRESSION: CONDITIONALOREXPRESSION{$$=addlabel("CONDITIONALEXPRESSION");addedge($$, $1);}
                      |	CONDITIONALOREXPRESSION QUESTIONMARK EXPRESSION COLON CONDITIONALEXPRESSION{$$=addlabel("CONDITIONALEXPRESSION");addedge($$, $1);$2=addlabel("questionmark" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("colon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
CONDITIONALOREXPRESSION: CONDITIONALANDEXPRESSION{$$=addlabel("CONDITIONALOREXPRESSION");addedge($$, $1);}
                        |	CONDITIONALOREXPRESSION OROR CONDITIONALANDEXPRESSION{$$=addlabel("CONDITIONALOREXPRESSION");addedge($$, $1);$2=addlabel("oror" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
CONDITIONALANDEXPRESSION: INCLUSIVEOREXPRESSION{$$=addlabel("CONDITIONALANDEXPRESSION");addedge($$, $1);}
                         |	CONDITIONALANDEXPRESSION ANDAND INCLUSIVEOREXPRESSION{$$=addlabel("CONDITIONALANDEXPRESSION");addedge($$, $1);$2=addlabel("andand" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
INCLUSIVEOREXPRESSION: EXCLUSIVEOREXPRESSION{$$=addlabel("INCLUSIVEOREXPRESSION");addedge($$, $1);}
                      |	INCLUSIVEOREXPRESSION OR EXCLUSIVEOREXPRESSION{$$=addlabel("INCLUSIVEOREXPRESSION");addedge($$, $1);$2=addlabel("or" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
EXCLUSIVEOREXPRESSION: ANDEXPRESSION{$$=addlabel("EXCLUSIVEOREXPRESSION");addedge($$, $1);}
                      |	EXCLUSIVEOREXPRESSION XOR ANDEXPRESSION{$$=addlabel("EXCLUSIVEOREXPRESSION");addedge($$, $1);$2=addlabel("xor" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
ANDEXPRESSION: EQUALITYEXPRESSION{$$=addlabel("ANDEXPRESSION");addedge($$, $1);}
              |	ANDEXPRESSION AND EQUALITYEXPRESSION{$$=addlabel("ANDEXPRESSION");addedge($$, $1);$2=addlabel("and" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
EQUALITYEXPRESSION: RELATIONALEXPRESSION{$$=addlabel("EQUALITYEXPRESSION");addedge($$, $1);}
                   |	EQUALITYEXPRESSION EQUALSEQUALS RELATIONALEXPRESSION{$$=addlabel("EQUALITYEXPRESSION");addedge($$, $1);$2=addlabel("equalsequals" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                   |	EQUALITYEXPRESSION NOTEQUALS RELATIONALEXPRESSION{$$=addlabel("EQUALITYEXPRESSION");addedge($$, $1);$2=addlabel("notequals" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
RELATIONALEXPRESSION: SHIFTEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);}
                     |	RELATIONALEXPRESSION ANGULARLEFT SHIFTEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);$2=addlabel("angularleft" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                     |	RELATIONALEXPRESSION ANGULARRIGHT SHIFTEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);$2=addlabel("angularright" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                     |	RELATIONALEXPRESSION ANGULARRIGHT EQUALS SHIFTEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);$2=addlabel("angularright" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("equals" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
                     |	RELATIONALEXPRESSION ANGULARLEFT EQUALS SHIFTEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);$2=addlabel("angularleft" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("equals" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
                     |	INSTANCEOFEXPRESSION{$$=addlabel("RELATIONALEXPRESSION");addedge($$, $1);}
SHIFTEXPRESSION: ADDITIVEEXPRESSION{$$=addlabel("SHIFTEXPRESSION");addedge($$, $1);}
                |	SHIFTEXPRESSION ANGULARLEFTANGULARLEFT ADDITIVEEXPRESSION{$$=addlabel("SHIFTEXPRESSION");addedge($$, $1);$2=addlabel("angularleftangularleft" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                |	SHIFTEXPRESSION ANGULARRIGHTANGULARRIGHT ADDITIVEEXPRESSION{$$=addlabel("SHIFTEXPRESSION");addedge($$, $1);$2=addlabel("angularrightangularright" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                |	SHIFTEXPRESSION ANGULARRIGHTANGULARRIGHTANGULARRIGHT ADDITIVEEXPRESSION{$$=addlabel("SHIFTEXPRESSION");addedge($$, $1);$2=addlabel("angularrightangularrightangularright" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
ADDITIVEEXPRESSION: MULTIPLICATIVEEXPRESSION{$$=addlabel("ADDITIVEEXPRESSION");addedge($$, $1);}
                   |	ADDITIVEEXPRESSION PLUS MULTIPLICATIVEEXPRESSION{$$=addlabel("ADDITIVEEXPRESSION");addedge($$, $1);$2=addlabel("plus" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                   |	ADDITIVEEXPRESSION MINUS MULTIPLICATIVEEXPRESSION{$$=addlabel("ADDITIVEEXPRESSION");addedge($$, $1);$2=addlabel("minus" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
MULTIPLICATIVEEXPRESSION: UNARYEXPRESSION{$$=addlabel("MULTIPLICATIVEEXPRESSION");addedge($$, $1);}
                         |	MULTIPLICATIVEEXPRESSION MULTIPLY UNARYEXPRESSION{$$=addlabel("MULTIPLICATIVEEXPRESSION");addedge($$, $1);$2=addlabel("multiply" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                         |	MULTIPLICATIVEEXPRESSION DIVIDE UNARYEXPRESSION{$$=addlabel("MULTIPLICATIVEEXPRESSION");addedge($$, $1);$2=addlabel("divide" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
                         |	MULTIPLICATIVEEXPRESSION MOD UNARYEXPRESSION{$$=addlabel("MULTIPLICATIVEEXPRESSION");addedge($$, $1);$2=addlabel("mod" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
UNARYEXPRESSION: PREINCREMENTEXPRESSION{$$=addlabel("UNARYEXPRESSION");addedge($$, $1);}
                |	PREDECREMENTEXPRESSION{$$=addlabel("UNARYEXPRESSION");addedge($$, $1);}
                |	PLUS UNARYEXPRESSION{$$=addlabel("UNARYEXPRESSION");$1=addlabel("plus" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                |	MINUS UNARYEXPRESSION{$$=addlabel("UNARYEXPRESSION");$1=addlabel("minus" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                |	UNARYEXPRESSIONNOTPLUSMINUS{$$=addlabel("UNARYEXPRESSION");addedge($$, $1);}
PREINCREMENTEXPRESSION: PLUSPLUS UNARYEXPRESSION{$$=addlabel("PREINCREMENTEXPRESSION");$1=addlabel("plusplus" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
PREDECREMENTEXPRESSION: MINUSMINUS UNARYEXPRESSION{$$=addlabel("PREDECREMENTEXPRESSION");$1=addlabel("minusminus" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
UNARYEXPRESSIONNOTPLUSMINUS: POSTFIXEXPRESSION{$$=addlabel("UNARYEXPRESSIONNOTPLUSMINUS");addedge($$, $1);}
                            |	COMPLEMENT UNARYEXPRESSION{$$=addlabel("UNARYEXPRESSIONNOTPLUSMINUS");$1=addlabel("complement" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
                            |	NOT UNARYEXPRESSION{$$=addlabel("UNARYEXPRESSIONNOTPLUSMINUS");$1=addlabel("not" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
POSTFIXEXPRESSION: PRIMARY{$$=addlabel("POSTFIXEXPRESSION");addedge($$, $1);}
                  |	EXPRESSIONNAME{$$=addlabel("POSTFIXEXPRESSION");addedge($$, $1);}
                  | IDENTIFIER{$$=addlabel("POSTFIXEXPRESSION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
                  |	POSTINCREMENTEXPRESSION{$$=addlabel("POSTFIXEXPRESSION");addedge($$, $1);}
                  |	POSTDECREMENTEXPRESSION{$$=addlabel("POSTFIXEXPRESSION");addedge($$, $1);}
POSTINCREMENTEXPRESSION: POSTFIXEXPRESSION PLUSPLUS{$$=addlabel("POSTINCREMENTEXPRESSION");addedge($$, $1);$2=addlabel("plusplus" +  "(" +  chartostring($2)+")");addedge($$, $2);}
POSTDECREMENTEXPRESSION: POSTFIXEXPRESSION MINUSMINUS{$$=addlabel("POSTDECREMENTEXPRESSION");addedge($$, $1);$2=addlabel("minusminus" +  "(" +  chartostring($2)+")");addedge($$, $2);}
INSTANCEOFEXPRESSION: RELATIONALEXPRESSION INSTANCEOF REFERENCETYPE{$$=addlabel("INSTANCEOFEXPRESSION");addedge($$, $1);$2=addlabel("instanceof" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
METHODDECLARATION:  METHODHEADER METHODBODY{$$=addlabel("METHODDECLARATION");addedge($$, $1);addedge($$, $2);}
                    |   SUPER1 METHODHEADER METHODBODY{$$=addlabel("METHODDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                    |   SUPER2 METHODHEADER METHODBODY{$$=addlabel("METHODDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                    |   SUPER3 METHODHEADER METHODBODY{$$=addlabel("METHODDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                    |   METHODMODIFIERS METHODHEADER METHODBODY{$$=addlabel("METHODDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
METHODHEADER: TYPE METHODDECLARATOR THROWS2{$$=addlabel("METHODHEADER");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
            |   TYPE METHODDECLARATOR {$$=addlabel("METHODHEADER");addedge($$, $1);addedge($$, $2);}
             |	TYPEPARAMETERS TYPE METHODDECLARATOR THROWS2{$$=addlabel("METHODHEADER");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
             |  TYPEPARAMETERS TYPE METHODDECLARATOR {$$=addlabel("METHODHEADER");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
             |  VOID METHODDECLARATOR THROWS2{$$=addlabel("METHODHEADER");$1=addlabel("void" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
            |   VOID METHODDECLARATOR {$$=addlabel("METHODHEADER");$1=addlabel("void" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
             |	TYPEPARAMETERS VOID METHODDECLARATOR THROWS2{$$=addlabel("METHODHEADER");addedge($$, $1);$2=addlabel("void" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);addedge($$, $4);}
             |  TYPEPARAMETERS VOID METHODDECLARATOR {$$=addlabel("METHODHEADER");addedge($$, $1);$2=addlabel("void" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
THROWS2: THROWS EXCEPTIONTYPELIST{$$=addlabel("THROWS2");$1=addlabel("throws" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
EXCEPTIONTYPELIST: EXCEPTIONTYPE    {$$=addlabel("EXCEPTIONTYPELIST");addedge($$, $1);}
                |   EXCEPTIONTYPELIST COMMA EXCEPTIONTYPE{$$=addlabel("EXCEPTIONTYPELIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
EXCEPTIONTYPE: CLASSTYPE{$$=addlabel("EXCEPTIONTYPE");addedge($$, $1);}
METHODDECLARATOR: IDENTIFIER OPENPARAN CLOSEPARAN {$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |   IDENTIFIER OPENPARAN CLOSEPARAN DIMS{$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);}
                |   IDENTIFIER OPENPARAN FORMALPARAMETERLIST CLOSEPARAN DIMS{$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
                |   IDENTIFIER OPENPARAN FORMALPARAMETERLIST CLOSEPARAN {$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |   IDENTIFIER RECEIVERPARAMETER COMMA OPENPARAN CLOSEPARAN {$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("comma" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                |   IDENTIFIER RECEIVERPARAMETER COMMA OPENPARAN CLOSEPARAN DIMS{$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("comma" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);}
                |   IDENTIFIER RECEIVERPARAMETER COMMA OPENPARAN FORMALPARAMETERLIST CLOSEPARAN DIMS{$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("comma" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                |   IDENTIFIER RECEIVERPARAMETER COMMA OPENPARAN FORMALPARAMETERLIST CLOSEPARAN {$$=addlabel("METHODDECLARATOR");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("comma" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
RECEIVERPARAMETER:  TYPE THIS{$$=addlabel("RECEIVERPARAMETER");addedge($$, $1);$2=addlabel("this" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                |   TYPE IDENTIFIER DOT THIS{$$=addlabel("RECEIVERPARAMETER");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("dot" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("this" +  "(" +  chartostring($4)+")");addedge($$, $4);}
FORMALPARAMETERLIST: FORMALPARAMETER {$$=addlabel("FORMALPARAMETERLIST");addedge($$, $1);}
                    |   FORMALPARAMETERLIST COMMA FORMALPARAMETER{$$=addlabel("FORMALPARAMETERLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
FORMALPARAMETER:  TYPE VARIABLEDECLARATORID{$$=addlabel("FORMALPARAMETER");addedge($$, $1);addedge($$, $2);}
                |	VARIABLEARITYPARAMETER{$$=addlabel("FORMALPARAMETER");addedge($$, $1);}
                |   FINAL TYPE VARIABLEDECLARATORID{$$=addlabel("FORMALPARAMETER");$1=addlabel("final" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
VARIABLEARITYPARAMETER  :  TYPE TRIPLEDOT IDENTIFIER{$$=addlabel("VARIABLEARITYPARAMETER");addedge($$, $1);$2=addlabel("tripledot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("identifier" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                        |   FINAL TYPE TRIPLEDOT IDENTIFIER{$$=addlabel("VARIABLEARITYPARAMETER");$1=addlabel("final" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("tripledot" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("identifier" +  "(" +  chartostring($4)+")");addedge($$, $4);}
METHODBODY: BLOCK{$$=addlabel("METHODBODY");addedge($$, $1);}
           |	SEMICOLON{$$=addlabel("METHODBODY");$1=addlabel("semicolon" +  "(" +  chartostring($1)+")");addedge($$, $1);}
INSTANCEINITIALIZER: BLOCK{$$=addlabel("INSTANCEINITIALIZER");addedge($$, $1);}
STATICINITIALIZER: STATIC BLOCK{$$=addlabel("STATICINITIALIZER");$1=addlabel("static" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);}
BLOCK: OPENCURLY BLOCKSTATEMENTS CLOSECURLY{$$=addlabel("BLOCK");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
    |   OPENCURLY  CLOSECURLY{$$=addlabel("BLOCK");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
BLOCKSTATEMENTS: BLOCKSTATEMENT {$$=addlabel("BLOCKSTATEMENTS");addedge($$, $1);}
                |  BLOCKSTATEMENTS BLOCKSTATEMENT {$$=addlabel("BLOCKSTATEMENTS");addedge($$, $1);addedge($$, $2);}
BLOCKSTATEMENT: LOCALCLASSORINTERFACEDECLARATION{$$=addlabel("BLOCKSTATEMENT");addedge($$, $1);}
               |	LOCALVARIABLEDECLARATIONSTATEMENT{$$=addlabel("BLOCKSTATEMENT");addedge($$, $1);}
               |	STATEMENT{$$=addlabel("BLOCKSTATEMENT");addedge($$, $1);}
LOCALCLASSORINTERFACEDECLARATION: CLASSDECLARATION{$$=addlabel("LOCALCLASSORINTERFACEDECLARATION");addedge($$, $1);}
LOCALVARIABLEDECLARATIONSTATEMENT: LOCALVARIABLEDECLARATION SEMICOLON{$$=addlabel("LOCALVARIABLEDECLARATIONSTATEMENT");addedge($$, $1);$2=addlabel("semicolon" +  "(" +  chartostring($2)+")");addedge($$, $2);}
LOCALVARIABLEDECLARATION: FINAL LOCALVARIABLETYPE VARIABLEDECLARATORLIST{$$=addlabel("LOCALVARIABLEDECLARATION");$1=addlabel("final" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |   LOCALVARIABLETYPE VARIABLEDECLARATORLIST{$$=addlabel("LOCALVARIABLEDECLARATION");addedge($$, $1);addedge($$, $2);}
LOCALVARIABLETYPE: TYPE{$$=addlabel("LOCALVARIABLETYPE");addedge($$, $1);}
                  |	VAR{$$=addlabel("LOCALVARIABLETYPE");$1=addlabel("var" +  "(" +  chartostring($1)+")");addedge($$, $1);}
STATEMENT: STATEMENTWITHOUTTRAILINGSUBSTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
          |	LABELEDSTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
          |	IFTHENSTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
          |	IFTHENELSESTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
          |	WHILESTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
          |	FORSTATEMENT{$$=addlabel("STATEMENT");addedge($$, $1);}
STATEMENTWITHOUTTRAILINGSUBSTATEMENT: BLOCK{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	EMPTYSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	EXPRESSIONSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	ASSERTSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	BREAKSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	CONTINUESTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	RETURNSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	THROWSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
                                     |	YIELDSTATEMENT{$$=addlabel("STATEMENTWITHOUTTRAILINGSUBSTATEMENT");addedge($$, $1);}
EMPTYSTATEMENT: SEMICOLON{$$=addlabel("EMPTYSTATEMENT");$1=addlabel("semicolon" +  "(" +  chartostring($1)+")");addedge($$, $1);}
EXPRESSIONSTATEMENT: STATEMENTEXPRESSION SEMICOLON{$$=addlabel("EXPRESSIONSTATEMENT");addedge($$, $1);$2=addlabel("semicolon" +  "(" +  chartostring($2)+")");addedge($$, $2);}
STATEMENTEXPRESSION: ASSIGNMENT{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	PREINCREMENTEXPRESSION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	PREDECREMENTEXPRESSION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	POSTINCREMENTEXPRESSION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	POSTDECREMENTEXPRESSION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	METHODINVOCATION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
                    |	CLASSINSTANCECREATIONEXPRESSION{$$=addlabel("STATEMENTEXPRESSION");addedge($$, $1);}
ASSERTSTATEMENT: ASSERT EXPRESSION SEMICOLON{$$=addlabel("ASSERTSTATEMENT");$1=addlabel("assert" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |	ASSERT EXPRESSION COLON EXPRESSION SEMICOLON{$$=addlabel("ASSERTSTATEMENT");$1=addlabel("assert" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("colon" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);}
BREAKSTATEMENT: BREAK SEMICOLON{$$=addlabel("BREAKSTATEMENT");$1=addlabel("break" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("semicolon" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                |   BREAK IDENTIFIER SEMICOLON{$$=addlabel("BREAKSTATEMENT");$1=addlabel("break" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
CONTINUESTATEMENT: CONTINUE SEMICOLON{$$=addlabel("CONTINUESTATEMENT");$1=addlabel("continue" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("semicolon" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                |   CONTINUE IDENTIFIER SEMICOLON{$$=addlabel("CONTINUESTATEMENT");$1=addlabel("continue" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("identifier" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
RETURNSTATEMENT: RETURN EXPRESSION SEMICOLON{$$=addlabel("RETURNSTATEMENT");$1=addlabel("return" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |   RETURN SEMICOLON{$$=addlabel("RETURNSTATEMENT");$1=addlabel("return" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("semicolon" +  "(" +  chartostring($2)+")");addedge($$, $2);}
THROWSTATEMENT: THROW EXPRESSION SEMICOLON{$$=addlabel("THROWSTATEMENT");$1=addlabel("throw" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
YIELDSTATEMENT: YIELD EXPRESSION SEMICOLON{$$=addlabel("YIELDSTATEMENT");$1=addlabel("yield" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);}
LABELEDSTATEMENT: IDENTIFIER COLON STATEMENT{$$=addlabel("LABELEDSTATEMENT");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("colon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
IFTHENSTATEMENT: IF OPENPARAN EXPRESSION CLOSEPARAN STATEMENT{$$=addlabel("IFTHENSTATEMENT");$1=addlabel("if" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
IFTHENELSESTATEMENT: IF OPENPARAN EXPRESSION CLOSEPARAN STATEMENTNOSHORTIF ELSE STATEMENT{$$=addlabel("IFTHENELSESTATEMENT");$1=addlabel("if" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("else" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
IFTHENELSESTATEMENTNOSHORTIF: IF OPENPARAN EXPRESSION CLOSEPARAN  STATEMENTNOSHORTIF ELSE STATEMENTNOSHORTIF{$$=addlabel("IFTHENELSESTATEMENTNOSHORTIF");$1=addlabel("if" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $6);$7=addlabel("else" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
STATEMENTNOSHORTIF: STATEMENTWITHOUTTRAILINGSUBSTATEMENT{$$=addlabel("STATEMENTNOSHORTIF");addedge($$, $1);}
                   |	LABELEDSTATEMENTNOSHORTIF{$$=addlabel("STATEMENTNOSHORTIF");addedge($$, $1);}
                   |	IFTHENELSESTATEMENTNOSHORTIF{$$=addlabel("STATEMENTNOSHORTIF");addedge($$, $1);}
                   |	WHILESTATEMENTNOSHORTIF{$$=addlabel("STATEMENTNOSHORTIF");addedge($$, $1);}
                   |	FORSTATEMENTNOSHORTIF{$$=addlabel("STATEMENTNOSHORTIF");addedge($$, $1);}
LABELEDSTATEMENTNOSHORTIF: IDENTIFIER COLON STATEMENTNOSHORTIF{$$=addlabel("LABELEDSTATEMENTNOSHORTIF");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("colon" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
WHILESTATEMENTNOSHORTIF: WHILE OPENPARAN EXPRESSION CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("WHILESTATEMENTNOSHORTIF");$1=addlabel("while" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
FORSTATEMENTNOSHORTIF: BASICFORSTATEMENTNOSHORTIF{$$=addlabel("FORSTATEMENTNOSHORTIF");addedge($$, $1);}
                      |	ENHANCEDFORSTATEMENTNOSHORTIF{$$=addlabel("FORSTATEMENTNOSHORTIF");addedge($$, $1);}
WHILESTATEMENT: WHILE OPENPARAN EXPRESSION CLOSEPARAN STATEMENT{$$=addlabel("WHILESTATEMENT");$1=addlabel("while" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);}
FORSTATEMENT: BASICFORSTATEMENT{$$=addlabel("FORSTATEMENT");addedge($$, $1);}
             |	ENHANCEDFORSTATEMENT{$$=addlabel("FORSTATEMENT");addedge($$, $1);}
BASICFORSTATEMENT: FOR OPENPARAN SEMICOLON SEMICOLON CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);}
                  |	FOR OPENPARAN SEMICOLON SEMICOLON FORUPDATE CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN SEMICOLON EXPRESSION SEMICOLON CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN SEMICOLON EXPRESSION SEMICOLON FORUPDATE CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON SEMICOLON CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN FORINIT SEMICOLON SEMICOLON FORUPDATE CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON EXPRESSION SEMICOLON CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON EXPRESSION SEMICOLON FORUPDATE CLOSEPARAN STATEMENT{$$=addlabel("BASICFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);$8=addlabel("closeparan" +  "(" +  chartostring($8)+")");addedge($$, $8);addedge($$, $9);}
BASICFORSTATEMENTNOSHORTIF: FOR OPENPARAN SEMICOLON SEMICOLON CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);}
                  |	FOR OPENPARAN SEMICOLON SEMICOLON FORUPDATE CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN SEMICOLON EXPRESSION SEMICOLON CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN SEMICOLON EXPRESSION SEMICOLON FORUPDATE CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("semicolon" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON SEMICOLON CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
                  |	FOR OPENPARAN FORINIT SEMICOLON SEMICOLON FORUPDATE CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON EXPRESSION SEMICOLON CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);addedge($$, $8);}
                  |	FOR OPENPARAN FORINIT SEMICOLON EXPRESSION SEMICOLON FORUPDATE CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("BASICFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);$8=addlabel("closeparan" +  "(" +  chartostring($8)+")");addedge($$, $8);addedge($$, $9);}
ENHANCEDFORSTATEMENT: FOR OPENPARAN LOCALVARIABLEDECLARATION COLON EXPRESSION CLOSEPARAN STATEMENT{$$=addlabel("ENHANCEDFORSTATEMENT");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("colon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
ENHANCEDFORSTATEMENTNOSHORTIF: FOR OPENPARAN LOCALVARIABLEDECLARATION COLON EXPRESSION CLOSEPARAN STATEMENTNOSHORTIF{$$=addlabel("ENHANCEDFORSTATEMENTNOSHORTIF");$1=addlabel("for" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("colon" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);addedge($$, $7);}
FORINIT: STATEMENTEXPRESSIONLIST{$$=addlabel("FORINIT");addedge($$, $1);}
        |	LOCALVARIABLEDECLARATION{$$=addlabel("FORINIT");addedge($$, $1);}
FORUPDATE: STATEMENTEXPRESSIONLIST{$$=addlabel("FORUPDATE");addedge($$, $1);}
STATEMENTEXPRESSIONLIST: STATEMENTEXPRESSION {$$=addlabel("STATEMENTEXPRESSIONLIST");addedge($$, $1);}
                        |   STATEMENTEXPRESSIONLIST COMMA STATEMENTEXPRESSION {$$=addlabel("STATEMENTEXPRESSIONLIST");addedge($$, $1);$2=addlabel("comma" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);}
CONSTRUCTORDECLARATION:     CONSTRUCTORDECLARATOR THROWS2 CONSTRUCTORBODY{$$=addlabel("CONSTRUCTORDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
                        |   CONSTRUCTORDECLARATOR CONSTRUCTORBODY{$$=addlabel("CONSTRUCTORDECLARATION");addedge($$, $1);addedge($$, $2);}
                        |   SUPER1 CONSTRUCTORDECLARATOR THROWS2 CONSTRUCTORBODY  {$$=addlabel("CONSTRUCTORDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);addedge($$, $4);}
                        |   SUPER1 CONSTRUCTORDECLARATOR CONSTRUCTORBODY {$$=addlabel("CONSTRUCTORDECLARATION");addedge($$, $1);addedge($$, $2);addedge($$, $3);}
CONSTRUCTORDECLARATOR: SIMPLETYPENAME OPENPARAN  CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                    |   SIMPLETYPENAME OPENPARAN FORMALPARAMETERLIST CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                    |   SIMPLETYPENAME OPENPARAN RECEIVERPARAMETER COMMA CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("comma" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                    |   SIMPLETYPENAME OPENPARAN RECEIVERPARAMETER COMMA FORMALPARAMETERLIST CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("comma" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                    |   TYPEPARAMETERS SIMPLETYPENAME OPENPARAN  CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                    |   TYPEPARAMETERS SIMPLETYPENAME OPENPARAN FORMALPARAMETERLIST CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                    |   TYPEPARAMETERS SIMPLETYPENAME OPENPARAN RECEIVERPARAMETER COMMA CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("comma" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                    |   TYPEPARAMETERS SIMPLETYPENAME OPENPARAN RECEIVERPARAMETER COMMA FORMALPARAMETERLIST CLOSEPARAN{$$=addlabel("CONSTRUCTORDECLARATOR");addedge($$, $1);addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("comma" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);}
SIMPLETYPENAME: IDENTIFIER{$$=addlabel("SIMPLETYPENAME");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);}
CONSTRUCTORBODY: OPENCURLY EXPLICITCONSTRUCTORINVOCATION BLOCKSTATEMENTS CLOSECURLY{$$=addlabel("CONSTRUCTORBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);addedge($$, $3);$4=addlabel("closecurly" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                |   OPENCURLY EXPLICITCONSTRUCTORINVOCATION CLOSECURLY{$$=addlabel("CONSTRUCTORBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |   OPENCURLY BLOCKSTATEMENTS CLOSECURLY{$$=addlabel("CONSTRUCTORBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);addedge($$, $2);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
                |   OPENCURLY  CLOSECURLY{$$=addlabel("CONSTRUCTORBODY");$1=addlabel("opencurly" +  "(" +  chartostring($1)+")");addedge($$, $1);$3=addlabel("closecurly" +  "(" +  chartostring($3)+")");addedge($$, $3);}
EXPLICITCONSTRUCTORINVOCATION: THIS OPENPARAN CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("this" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                            |    THIS OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("this" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                            |   TYPEARGUMENTS THIS OPENPARAN  CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("this" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   TYPEARGUMENTS THIS OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("this" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   SUPER OPENPARAN CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("closeparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("semicolon" +  "(" +  chartostring($4)+")");addedge($$, $4);}
                            |    SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("super" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("openparan" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("closeparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("semicolon" +  "(" +  chartostring($5)+")");addedge($$, $5);}
                            |   TYPEARGUMENTS SUPER OPENPARAN  CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("super" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   TYPEARGUMENTS SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("super" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("openparan" +  "(" +  chartostring($3)+")");addedge($$, $3);addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   EXPRESSIONNAME DOT SUPER OPENPARAN CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   EXPRESSIONNAME DOT SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("semicolon" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                            |   EXPRESSIONNAME DOT TYPEARGUMENTS SUPER OPENPARAN  CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                            |   EXPRESSIONNAME DOT TYPEARGUMENTS SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                            |   IDENTIFIER DOT SUPER OPENPARAN CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   IDENTIFIER DOT SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("semicolon" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                            |   IDENTIFIER DOT TYPEARGUMENTS SUPER OPENPARAN  CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                            |   IDENTIFIER DOT TYPEARGUMENTS SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");$1=addlabel("identifier" +  "(" +  chartostring($1)+")");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                            |  PRIMARY DOT SUPER OPENPARAN CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("closeparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$6=addlabel("semicolon" +  "(" +  chartostring($6)+")");addedge($$, $6);}
                            |   PRIMARY DOT SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);$3=addlabel("super" +  "(" +  chartostring($3)+")");addedge($$, $3);$4=addlabel("openparan" +  "(" +  chartostring($4)+")");addedge($$, $4);addedge($$, $5);$6=addlabel("closeparan" +  "(" +  chartostring($6)+")");addedge($$, $6);$7=addlabel("semicolon" +  "(" +  chartostring($7)+")");addedge($$, $7);}
                            |   PRIMARY DOT TYPEARGUMENTS SUPER OPENPARAN  CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
                            |   PRIMARY DOT TYPEARGUMENTS SUPER OPENPARAN ARGUMENTLIST CLOSEPARAN SEMICOLON{$$=addlabel("EXPLICITCONSTRUCTORINVOCATION");addedge($$, $1);$2=addlabel("dot" +  "(" +  chartostring($2)+")");addedge($$, $2);addedge($$, $3);$4=addlabel("super" +  "(" +  chartostring($4)+")");addedge($$, $4);$5=addlabel("openparan" +  "(" +  chartostring($5)+")");addedge($$, $5);addedge($$, $6);$7=addlabel("closeparan" +  "(" +  chartostring($7)+")");addedge($$, $7);$8=addlabel("semicolon" +  "(" +  chartostring($8)+")");addedge($$, $8);}
SUPER1 : PUBLIC | PRIVATE | PROTECTED{$$=addlabel("SUPER1");$1=addlabel("public" +  "(" +  chartostring($1)+")");addedge($$, $1);$3=addlabel("private" +  "(" +  chartostring($3)+")");addedge($$, $3);$5=addlabel("protected" +  "(" +  chartostring($5)+")");addedge($$, $5);}
        | SUPER1 PUBLIC {$$=addlabel("SUPER1");addedge($$, $1);$2=addlabel("public" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER1 PRIVATE {$$=addlabel("SUPER1");addedge($$, $1);$2=addlabel("private" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER1 PROTECTED{$$=addlabel("SUPER1");addedge($$, $1);$2=addlabel("protected" +  "(" +  chartostring($2)+")");addedge($$, $2);}
SUPER2 : STATIC{$$=addlabel("SUPER2");$1=addlabel("static" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        | FINAL {$$=addlabel("SUPER2");$1=addlabel("final" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        | SUPER1 STATIC{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("static" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER1 FINAL{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("final" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 STATIC{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("static" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 FINAL{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("final" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 PUBLIC{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("public" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 PRIVATE{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("private" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 PROTECTED{$$=addlabel("SUPER2");addedge($$, $1);$2=addlabel("protected" +  "(" +  chartostring($2)+")");addedge($$, $2);}
SUPER3 : ABSTRACT{$$=addlabel("SUPER3");$1=addlabel("abstract" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        | STRICTFP{$$=addlabel("SUPER3");$1=addlabel("strictfp" +  "(" +  chartostring($1)+")");addedge($$, $1);}
        | SUPER2 ABSTRACT{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("abstract" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER2 STRICTFP{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("strictfp" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 ABSTRACT{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("abstract" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 STRICTFP{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("strictfp" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 PUBLIC{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("public" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 PRIVATE{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("private" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 PROTECTED{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("protected" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 STATIC{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("static" +  "(" +  chartostring($2)+")");addedge($$, $2);}
        | SUPER3 FINAL{$$=addlabel("SUPER3");addedge($$, $1);$2=addlabel("final" +  "(" +  chartostring($2)+")");addedge($$, $2);}
FIELDMODIFIERS: SUPER3 TRANSIENT{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("transient" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |   SUPER3 VOLATILE{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("volatile" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |  FIELDMODIFIERS TRANSIENT{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("transient" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            |  FIELDMODIFIERS VOLATILE{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("volatile" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            | FIELDMODIFIERS PUBLIC{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("public" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            | FIELDMODIFIERS PRIVATE{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("private" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            | FIELDMODIFIERS PROTECTED{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("protected" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            | FIELDMODIFIERS STATIC{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("static" +  "(" +  chartostring($2)+")");addedge($$, $2);}
            | FIELDMODIFIERS FINAL{$$=addlabel("FIELDMODIFIERS");addedge($$, $1);$2=addlabel("final" +  "(" +  chartostring($2)+")");addedge($$, $2);}
METHODMODIFIERS : SUPER3 SYNCHRONIZED{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("synchronized" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | SUPER3 NATIVE{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("native" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS SYNCHRONIZED{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("synchronized" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS NATIVE{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("native" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS ABSTRACT{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("abstract" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS STRICTFP{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("strictfp" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS PUBLIC{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("public" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS PRIVATE{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("private" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS PROTECTED{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("protected" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS STATIC{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("static" +  "(" +  chartostring($2)+")");addedge($$, $2);}
                | METHODMODIFIERS FINAL{$$=addlabel("METHODMODIFIERS");addedge($$, $1);$2=addlabel("final" +  "(" +  chartostring($2)+")");addedge($$, $2);}


%%


void yyerror(char *s){
    cout<<"syntax error"<<endl;
}

int main(){
    yyparse();
    cout << "digraph ASTVisual {\n";
    for(auto e: labels){
        cout<<e.num<<" [ label=\""<<e.l<<"\"]\n";
    }
    for(auto e: edges){
        cout<<e.a<< " -> "<<e.b << "[ label=\""<<e.l<<"\"]\n";
    }
    cout << "  }\n";

}