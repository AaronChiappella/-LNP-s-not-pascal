unit Evaluador;


interface

uses
  Classes, u_arbol, u_lista, math;

const
  maxVariables=100;
  maxReales=100;

type
  tElementoEstado=record
    lexemaId:string;
    valorReal:real;
  end;
  tEstado=record
    elementos:array [1..maxVariables] of tElementoEstado;
    cant:word;
  end;
 Procedure inicializar_estado(var E:tEstado);
 Procedure AsignarValor(var lexemaId:string;var E:tEstado; var valor:real);
 Procedure AgregarVariable(var E:tEstado;var lexemaId:string);
 Function obtenerValor(var E:tEstado; var lex:string):real;
 function ValorReal(texto: string): real;

 //Evaluadores
Procedure evalPrograma(var arbol:t_arbol_derivacion; var estado:tEstado);
Procedure EvalPrograma1(var arbol:t_arbol_derivacion; var estado:tEstado);
Procedure evalSentencia(var arbol:t_arbol_derivacion; var estado:tEstado);
Procedure evalSentencia1(var arbol:t_arbol_derivacion; var estado:tEstado);
Procedure evalLista_var(var arbol:t_arbol_derivacion; var estado:tEstado);
Procedure EvalBoolTermP(Var Arbol:t_arbol_derivacion; Var Estado:tEstado;var operando1:boolean ; Var Resultado:Boolean);
Procedure EvalBoolFactor(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Var Resultado:Boolean);
Procedure EvalExpRel(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Var Resultado:Boolean);
Procedure EvalOpRel(Var Arbol:t_arbol_derivacion; Var Operador:Shortstring);
Procedure EvalOpRel1(Var Arbol:t_arbol_derivacion;Var Operador:Shortstring);
Procedure EvalOpRel2(Var Arbol:t_arbol_derivacion;Var Operador:Shortstring);
procedure EvalExpArit(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoExparit:real);
procedure EvalT(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Operando1:real; var Resultado:real);
procedure EvalF(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Operando1:real; var Resultado:real);
procedure EvalTermino(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoTermino:real);
procedure EvalFactor(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoPotencia:real);
procedure EvalFactor1(var Arbol:t_arbol_derivacion; var Estado:tEstado; var indice:real);
procedure EvalPrimario(var Arbol:t_arbol_derivacion; var Estado:tEstado; var Resultado:real);
procedure EvalLista_w(var Arbol:t_arbol_derivacion; var Estado:tEstado);
procedure EvalLista_w2(var Arbol:t_arbol_derivacion; var Estado:tEstado);
procedure evalCond (var arbol:t_arbol_derivacion; var estado:tEstado;var resultadoCond:boolean);
procedure evalCond1(var arbol:t_arbol_derivacion; var estado:tEstado;var resultado:boolean);
procedure EvalBoolTerm(var Arbol:t_arbol_derivacion;var Estado:tEstado;var resultado:boolean);
procedure evalBoolTerm1(var arbol:t_arbol_derivacion;var estado:tEstado;var operando1:boolean;var resultado:boolean);
procedure EvalElemento(var Arbol:t_arbol_derivacion; var Estado:tEstado; var Resultado:real);
implementation

Procedure inicializar_estado(var E:tEstado);
begin
   E.cant:=0;
       end;

Procedure AsignarValor(var lexemaId:string;var E:tEstado; var valor:real);
var
i:integer;
begin
    For i:=1 to E.cant do
    begin
             if upcase(E.elementos[i].lexemaId)=upcase(lexemaId) then
               E.elementos[i].valorReal:=valor;
    end;
  end;

Procedure AgregarVariable(var E:tEstado;var lexemaId:string);
begin
  E.cant:= E.cant+1;
  E.elementos[E.cant].lexemaId:=lexemaId;
  E.elementos[E.cant].valorReal:=0;
  end;

Function obtenerValor(var E:tEstado; var lex:string):real;
var
i:integer;
begin
  obtenerValor:=0;
    For i:=1 to E.cant do
    begin
             if upcase(E.elementos[i].lexemaId)=upcase(lex) then
                obtenerValor:=E.elementos[i].valorReal;
    end;
  end;


//parte Tadeo


//Programa-> Sentencia; Programa1
Procedure evalPrograma(var arbol:t_arbol_derivacion; var estado:tEstado);
begin
    EvalSentencia(Arbol^.Hijos[1], Estado);
    EvalPrograma1(Arbol^.Hijos[3],Estado);
end;
//Programa1-> Programa | epsilon
Procedure EvalPrograma1(var arbol:t_arbol_derivacion; var estado:tEstado);
begin
If arbol^.cant>0 then
      begin
			EvalPrograma(Arbol^.hijos[1], Estado);
      end;
end;
//Sentencia-> dec id Lista_var ; | id := ExpArit | if Cond then begin Programa Sentencia1 | while Cond do Programa end | write (Lista_w)  | read (cad,id)
Procedure evalSentencia(var arbol:t_arbol_derivacion; var estado:tEstado);
var
ResultadoCond:boolean;
resultadoExpArit,X:real;
begin
  ResultadoCond:=false;
           case arbol^.hijos[1]^.simbolo of

           //EvalSentencia(Arbol, Estado)
           tdec: EvalLista_var(Arbol^.hijos[3], Estado);
           tid: begin
                       resultadoExpArit:=0;
                       EvalExpArit(Arbol^.hijos[3], Estado, resultadoExpArit);
                       AsignarValor(Arbol^.{hijos[1].}lexema, Estado, ResultadoExpArit);
	               end;
           tif: begin
			EvalCond(Arbol^.hijos[2], Estado, ResultadoCond);
                        if ResultadoCond then
                          EvalPrograma(Arbol^.hijos[5], Estado)
                          else
			  EvalSentencia1(Arbol^.hijos[6], Estado);
                          end;

           twhile: begin
			EvalCond(Arbol^.hijos[2], Estado, ResultadoCond);
                        While ResultadoCond do//true
                                begin
				EvalPrograma(Arbol^.hijos[4], Estado);
				EvalCond(Arbol^.hijos[2], Estado, ResultadoCond);
                                end;
                        end;

           twrite: EvalLista_w(Arbol^.hijos[3], Estado);


           tread: begin
			Write(Arbol^{.hijos[3]}.Lexema);
                        Readln(X);
			AsignarValor(Arbol^.{hijos[5].}Lexema, Estado, X);
                        end;

end;
end;
//Sentencia1-> else Programa end | end
Procedure evalSentencia1(var arbol:t_arbol_derivacion; var estado:tEstado);
begin
EvalPrograma(Arbol^.hijos[2], Estado);
end;

//Lista_var-> ,id Lista_var | epsilon
Procedure evalLista_var(var arbol:t_arbol_derivacion; var estado:tEstado);
begin
if arbol^.cant>0 then
begin
EvalLista_var(Arbol^.hijos[3], Estado)
end;
end;

 //aaron
//Cond-> BoolTerm Cond1

procedure evalCond (var arbol:t_arbol_derivacion; var estado:tEstado;var resultadoCond:boolean);
var
op1,op2:boolean;
begin
op1:=false;
op2:=false;
evalBoolTerm(arbol^.hijos[1],estado,op1); //evalua el primer termino de cond
evalCond1(arbol^.hijos[2],estado,op2); //evalua el segundo termino de cond
resultadoCond:=op1 or op2
end;
//acá agregué una nueva variable, op2, para evaluar cond1. Si una de las dos es verdadera,
//el condicional es verdadero, xq las producciones son de la forma boolterm or boolterm or boolterm…
//con que una sea verdad ya hace verdadero el condicional. En la siguiente producción, cond1, en caso de que sea épsilon,
//la hacemos falsa, y quedaría op1 or op2. Op2 sería falso, y op1 dependería de evaluaboolterm.


//Cond1->OR BoolTerm Cond1 | épsilon

procedure evalCond1(var arbol:t_arbol_derivacion; var estado:tEstado;var resultado:boolean);
var
operando2:boolean;
begin
case arbol^.hijos[1]^.simbolo of
tor:
     begin
         operando2:=false;
         EvalBoolTerm(Arbol^.hijos[2],estado,operando2); //A v B-> ya tiene A(result),evalua B y realiza la 1
         resultado:=resultado or operando2;
         evalCond1(Arbol^.hijos[3],estado,resultado);
     end
else
	resultado:=false;
end;
end;

//else resultado:=operando1; si no hay produccion or entonces entra resultado y sale como, resultado por lo tanto no es necesario
// en realidad, acá si se produce epsilon, al resultado le asigno falso. Así, viéndolo desde las producciones de Cond,
//hacemos que el resultado en evalCond dependa solamente de evalBoolterm.


//BoolTerm-> BoolFactor BoolTerm1

procedure EvalBoolTerm(var Arbol:t_arbol_derivacion;var Estado:tEstado;var resultado:boolean);
var
resultado1,resultado2,operando1:boolean;
begin
     {operando1:=false;
     resultado1:=false;
     resultado2:=false;}
     EvalBoolFactor(Arbol^.hijos[1], Estado,resultado1);
     EvalBoolTerm1(Arbol^.hijos[2],Estado,operando1,resultado2);
     Resultado:=resultado1 and resultado2
end;
//agregué la línea de resultado:= ...

//BoolTerm1-> AND BoolFactor BoolTerm1 | épsilon
procedure evalBoolTerm1(var arbol:t_arbol_derivacion;var estado:tEstado;var operando1:boolean;var resultado:boolean);
var
resultado1,aux:boolean;
begin

case arbol^.hijos[1]^.simbolo of

tor:
begin
         resultado1:=true;
         EvalBoolTermP(Arbol,estado,operando1,resultado);
	 EvalBoolFactor(Arbol^.Hijos[2],Estado,resultado1);
	 aux:=resultado and resultado1;
         EvalBoolTerm1(Arbol^.Hijos[3],Estado,aux,resultado);
end;
   else resultado:=true; // si no hay and entonces no es necesario asignar resultado
end;
end;
//en este no cambie nada, lo q si, al principio dice boolterm1 -> “AND BoolFactor Boolterm1 | // épsilon” y después usaste evalbooltermP, cuál de las producciones va?
//fin aaron

//parte facu

//BoolTermP-> AND BoolFactor BoolTerm1
Procedure EvalBoolTermP(Var Arbol:t_arbol_derivacion; Var Estado:tEstado;var operando1:boolean ; Var Resultado:Boolean);
var
resultado1,resultado2: boolean;
Begin
     resultado1:=false;
     resultado2:=false;
  EvalBoolFactor(Arbol^.hijos[2], Estado, Resultado1);
  EvalBoolTerm1(Arbol^.hijos[3], Estado, operando1, Resultado2);
  If Resultado1 and Resultado2 then
    Resultado:=TRUE
  else
    Resultado:=FALSE;
End;


//BoolFactor-> NOT BoolFactor | {Cond} | ExpRel
Procedure EvalBoolFactor(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Var Resultado:Boolean);
Begin
  Case Arbol^.hijos[1]^.simbolo of
    tnot:EvalBoolFactor(Arbol^.hijos[2],Estado,{NOT }Resultado);
    vcond:EvalCond(Arbol^.hijos[2],Estado,Resultado);
    vExpRel:EvalExpRel(Arbol^.hijos[2],Estado,Resultado);
End;
end;

//ExpRel-> ExpArit OpRel ExpArit
Procedure EvalExpRel(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Var Resultado:Boolean);
Var
  Operador:string[11];
  ResultadoExpArit1,ResultadoExpArit2:real;
Begin
  ResultadoExpArit1:=0;
  ResultadoExpArit2:=0;
  Operador:='';
  EvalExpArit(Arbol^.Hijos[1], Estado, ResultadoExpArit1);
	EvalExpArit(Arbol^.Hijos[3], Estado, ResultadoExpArit2);
	EvalOpRel(Arbol^.Hijos[2], Operador);
  Case operador of
    'Igual': Resultado:= ResultadoExpArit1 = resultadoExpArit2;
    'Menor': Resultado:= ResultadoExpArit1 < resultadoExpArit2;
    'Menoroigual': Resultado:= ResultadoExpArit1 <= ResultadoExpArit2;
    'Mayor': Resultado:= ResultadoExpArit1 > ResultadoExpArit2;
    'Mayoroigual': Resultado:= resultadoExpArit1 >= resultadoExpArit2;
    'Distinto': Resultado:= ResultadoExpArit1 <> ResultadoExpArit2;
End;
end;

//OpRel -> >OpRel2 | <OpRel1 | =
Procedure EvalOpRel(Var Arbol:t_arbol_derivacion; Var Operador:Shortstring);
Begin
  Case Arbol^.hijos[1]^.simbolo of
    tmayor:EvalOpRel1(Arbol,operador);
    tmenor:EvalOpRel2(Arbol,operador);
    tigual:Operador:='Igual';
End;
end;

//OpRel1-> = | > | epsilon
Procedure EvalOpRel1(Var Arbol:t_arbol_derivacion;Var Operador:Shortstring);
Begin
  Case Arbol^.hijos[1]^.simbolo of
    tmayor:Operador:='Distinto';
    tigual:Operador:='Menoroigual';
    else
    Operador:='Menor';
End;
end;

//OpRel2-> = | epsilon
Procedure EvalOpRel2(Var Arbol:t_arbol_derivacion;Var Operador:Shortstring);
Begin
  Case Arbol^.hijos[1]^.simbolo of
    tigual:Operador:='Mayoroigual';
    else
    Operador:='Mayor';
  End;

end;

//termina parte de facu

//parte Juan

//ExpArit-> TerminoT
procedure EvalExpArit(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoExparit:real);
var
  ResultadoTermino:real;
begin
    ResultadoTermino:=0;
    EvalTermino(Arbol^.Hijos[1], Estado, ResultadoTermino);
	    EvalT(Arbol^.Hijos[2], Estado, ResultadoTermino, ResultadoExparit);
end;

//T -> +Termino T | -Termino T | epsilon
procedure EvalT(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Operando1:real; var Resultado:real);
var
  ResultadoTermino:real;
begin
  if arbol^.cant=0 then
  Resultado := Operando1
                  else
                      begin
                        case Arbol^.Hijos[1]^.simbolo of
                          tmas:
                            begin
                                 ResultadoTermino:=0;
                                EvalTermino(Arbol^.Hijos[2], Estado, ResultadoTermino);
                          			Operando1 := Operando1 + ResultadoTermino;
                          			EvalT(Arbol^.Hijos[3], Estado, Operando1, Resultado);
                            end;
                          tmenos:
                            begin
                                EvalTermino(Arbol^.Hijos[2], Estado, ResultadoTermino);
                          			Operando1 := Operando1 - ResultadoTermino;
                          			EvalT(Arbol^.Hijos[3], Estado, Operando1, Resultado);
                            end;
                        end;
                    end;
end;

//Termino-> FactorF
procedure EvalTermino(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoTermino:real);
	var
  ResultadoFactor:real;
begin
  ResultadoFactor:=0;
  EvalFactor(Arbol^.hijos[1], Estado,ResultadoFactor);
	EvalF(Arbol^.Hijos[2], Estado, ResultadoFactor, ResultadoTermino);
end;

//F-> *FactorF | /FactorF | epsilon
procedure EvalF(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; Operando1:real; var Resultado:real);
var
  ResultadoFactor:real;
begin
    if arbol^.cant=0 then
    Resultado := Operando1
                  else
                      begin
                        case Arbol^.Hijos[1]^.simbolo of
                            tpor:
                              begin
                                           ResultadoFactor:=0;
                                  EvalFactor(Arbol^.hijos[2],Estado, ResultadoFactor);
    			                        Operando1:= Operando1 * ResultadoFactor;
    			                        EvalF(Arbol^.Hijos[3], Estado, Operando1, Resultado);
                              end;
                            tbarra:
                              begin
                            			EvalFactor(Arbol^.hijos[2],Estado, ResultadoFactor);
                            			Operando1:= Operando1 / ResultadoFactor;
                            			EvalF(Arbol^.Hijos[3], Estado, Operando1, Resultado);
                              end;
                         end;
                      end;
end;

//  Factor-> Primario Factor1
procedure EvalFactor(Var Arbol:t_arbol_derivacion; Var Estado:tEstado; var ResultadoPotencia:real);
var
Base: real;           //¿esta bien definida?
Exponente: real;   //¿esta bien definida?
begin
  Base:=0;
  Exponente:=1;
  EvalPrimario(Arbol^.hijos[1], Estado, Base);
  EvalFactor1(Arbol^.hijos[2], Estado, Exponente);
  ResultadoPotencia:= power(Base,Exponente);  // NO FUNCIONA
end;

//termina parte Juan



//parte Manu

//Factor1-> ^ Factor | epsilon
procedure EvalFactor1(var Arbol:t_arbol_derivacion; var Estado:tEstado; var indice:real);
var
ResultadoPotencia: real;
begin
		if arbol^.cant>0 then
    begin
                if Arbol^.Hijos[1]^.simbolo = Tpotencia then
                begin
                        ResultadoPotencia:=0;
			EvalFactor(Arbol^.Hijos[2],Estado,Indice);
                        Indice:=ResultadoPotencia
                end
                else Indice:=1;
    end;
end;
//Devuelve el valor del índice, si la produccion es epsilon el indice es 1.

//Primario-> -Primario | Elemento
procedure EvalPrimario(var Arbol:t_arbol_derivacion; var Estado:tEstado; var Resultado:real);
var ResultadoPrimario:real;
begin
		case Arbol^.hijos[1]^.simbolo of
                  tmenos:begin
                              ResultadoPrimario:=0;
                              EvalPrimario(Arbol^.Hijos[2], Estado, ResultadoPrimario);
                              Resultado := -1 * ResultadoPrimario;
                              end;
                  velemento:EvalElemento(Arbol^.Hijos[1], Estado, Resultado);
                end;
end;

function ValorReal(texto: string): real;
var
  valor: real;
begin
  valor := 0;
  val(texto, valor);
  ValorReal := valor;
end;

//Elemento-> (ExpArit) | id | const | raiz(ExpArit)
procedure EvalElemento(var Arbol:t_arbol_derivacion; var Estado:tEstado; var Resultado:real);
var ResultadoExparit:real;
begin
  case Arbol^.hijos[1]^.simbolo of
    tparentesisa: EvalExpArit(Arbol^.Hijos[2], Estado, Resultado);
    tid: obtenerValor(Estado,Arbol^.Hijos[1]^.Lexema);
    treal: Resultado := ValorReal(Arbol^.Hijos[1]^.Lexema);    //que hacer con el const
    traiz: begin
              ResultadoExparit:=0;
              EvalExparit(Arbol^.hijos[3], Estado, ResultadoExparit);
              Resultado:= sqrt(ResultadoExparit);
  end;
end;
end;


//Lista_w-> cad Lista_w2 | ExpArit Lista_w2
procedure EvalLista_w(var Arbol:t_arbol_derivacion; var Estado:tEstado);
var
resultadoExpArit: real;
begin
		case Arbol^.hijos[1]^.simbolo of
                    tcadena: begin
                             write(Arbol^.hijos[1]^.lexema);
                             EvalLista_w2(Arbol^.hijos[2],Estado);
                             end;
                    vexparit: begin
                              resultadoExpArit:=0;
                              EvalExpArit(Arbol^.hijos[1],Estado,resultadoExpArit);
                              write(resultadoExpArit);
                              EvalLista_w2(Arbol^.hijos[2], Estado);
                              end;
                end;
end;
//Lista_w2-> ,Lista_w | epsilon
procedure EvalLista_w2(var Arbol:t_arbol_derivacion; var Estado:tEstado);
begin
		if arbol^.cant>0 then
			EvalLista_w(Arbol^.hijos[2],Estado)
                        else
                        writeln();
end;

//termina parte Manu
end.
