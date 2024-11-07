unit u_analizadorLexico;
 {#UTF-8}
interface
uses
 crt, u_lista, lista_ts, u_archivos, sysutils;
const
  fin_archivo=#0;
  max= 9;


  Function EsIdentificador(Var Fuente:T_Archivo;Var Control:Longint;Var Lexema:String):Boolean;
  Function EsConstReal(Var Fuente:T_Archivo;Var Control:Longint;Var Lexema:String):Boolean;
  Function EsConstCadena(Var Fuente: T_Archivo ; Var Control: Longint ; Var Lexema: String): Boolean;
  Procedure LeerCar(Var Fuente:T_Archivo;Var Control:Longint; var Car:char);
  Procedure ObtenerSiguienteCompLex(Var Fuente:T_Archivo;Var Control:Longint; Var CompLex:t_simbolo_gramatical;Var Lexema:String;Var TS:t_lista);
  Function EsSimboloEspecial(Var Fuente:T_Archivo;Var Control:Longint; Var CompLex:t_simbolo_gramatical;Var Lexema:String):boolean;

implementation

Function EsIdentificador(Var Fuente:T_Archivo;Var Control:Longint;Var Lexema:String):Boolean;
Const
  q0=0;
  F=[3];
Type
  Q=0..3;
  Sigma=(Letra, Digito,Guion, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual:Q;
  Delta:TipoDelta;
  P:Longint;
  Car:char;

   Function CarASimb(Car:Char):Sigma;
Begin
  Case Car of
    'a'..'z', 'A'..'Z':CarASimb:=Letra;
    '0'..'9'	     :CarASimb:=Digito;
    '_':CarASimb:=Guion;
  else
   CarASimb:=Otro;
  End;
End;

Begin
  {Cargar la tabla de transiciones}
  Delta[0,Letra]:=1;
  Delta[0,Guion]:=1;
  Delta[0,Digito]:=2;
  Delta[0,Otro]:=2;
  Delta[1,Digito]:=1;
  Delta[1,Letra]:=1;
  Delta[1,Guion]:=1;
  Delta[1,Otro]:=3;


  {Recorrer la cadena de entrada y cambiar estados}
  EstadoActual:=q0;
P:=Control;
Lexema:= '';
While EstadoActual in [0,1] do
begin
     LeerCar(Fuente,P,Car);
     EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
     P:=P+1;
     If EstadoActual = 1 then
          Lexema:= Lexema + car;
          esIdentificador:= True;


end;
     If EstadoActual in F then
          Control:= P-1;
     EsIdentificador:= EstadoActual in F
end;

 Function EsConstReal(Var Fuente:T_Archivo;Var Control:Longint;Var Lexema:String):Boolean;
Const
  q0=0;
  F=[4];
Type
  Q=0..5;
  Sigma=(Digito, coma ,Punto, Menos , Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  P: Longint;
  Car: Char;
  EstadoActual:Q;
  Delta:TipoDelta;

   Function CarASimb(Car:Char):Sigma;
Begin
  Case Car of
       '0'..'9':CarASimb:=Digito;
       '.' : CarASimb:=Punto;
  else
   CarASimb:= Otro;
  End;
End;

Begin
  {Cargar la tabla de transiciones}

  Delta[0,Punto]:=1;
  Delta[0,Digito]:=2;
  Delta[0,Otro]:=1;
  Delta[2,Punto]:=3;
  Delta[2,Digito]:=2;
  Delta[2,Otro]:=1;
  Delta[3,Punto]:=1;
  Delta[3,Digito]:=5;
  Delta[3,Otro]:=1;
  Delta[5,Punto]:=1;
  Delta[5,Digito]:=5;
  Delta[5,Otro]:=4;


  {Recorrer la cadena de entrada y cambiar estados}
  EstadoActual:=q0;
P:=Control;
Lexema:= '';
While EstadoActual in [0,2,3,5] do
begin
     LeerCar(Fuente,P,Car);
     EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
     P:=P+1;
     If EstadoActual in [0,2,3,5] then
          Lexema:= Lexema + car;

end;
     If EstadoActual in F then
          Control:= P-1;
     EsConstReal:= EstadoActual in F
end;

Function EsConstCadena(Var Fuente: T_Archivo ; Var Control: Longint ; Var Lexema: String): Boolean;
Const
     q0=0;
     F=[3];
Type
    Q=0..3;
    Sigma=(Letra, Digito, caracter , comillas ,  Otro);
    TipoDelta=Array[Q,Sigma] of Q;
Var
   EstadoActual:Q;
   Delta:TipoDelta;
   P: Longint;
   Car: Char;
   anterior:Q;

   Function CarASimb(car:char):Sigma;
   begin
     Case Car of
       '"' : CarASimb:= comillas;
     else
      CarASimb:=Otro;
   end;
     end;
Begin
{Cargar la tabla de transiciones}

  Delta[0,Comillas]:=1;
  Delta[0,Otro]:=2;
  Delta[1,Comillas]:=3;
  Delta[1,Otro]:=1;

{Recorrer la cadena de entrada y cambiar estados}
EstadoActual:=q0;
P:=Control;
Lexema:= '';
anterior:=q0;
While EstadoActual in [0,1] do
begin
     LeerCar(Fuente,P,Car);
     EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
     P:=P+1;
     If (EstadoActual = 1) and (anterior<>0) then
     begin
          Lexema:= Lexema + car;

     end;
     anterior:=estadoactual;
end;
If EstadoActual in F then
begin
     Control:= P;
end;
EsConstCadena:=EstadoActual in F;

end;

 Procedure LeerCar(Var Fuente:T_Archivo;Var Control:Longint; var Car:char);
 begin
 if control< filesize(fuente) then
 begin
 seek(fuente,control);
 read(fuente,car);
 end
           else
              car:= fin_archivo;
 end;
 Function EsSimboloEspecial(Var Fuente:T_Archivo;Var Control:Longint; Var CompLex:t_simbolo_gramatical;Var Lexema:String):boolean;
 var
   car: char;
begin
    EsSimboloEspecial := true;
    LeerCar(Fuente,Control,Car);
    Case car of
      '(' :
        begin
             Lexema:= '(';
             CompLex:= tparentesisa;
             Control:= Control+1;
        end;
      ')' :
        begin
             Lexema:= ')';
             CompLex:= tparentesisc;
             Control:= Control+1;
        end;

      '>' :
        begin
             CompLex:= toprel;
             Control:= Control+1;
             LeerCar(Fuente,Control,Car);
             If car = '=' then
             begin
                  Lexema := '>=';
                  Control:= Control+1;
             end
             else
                 Lexema := '>';
        end;

      '<' :
        begin
             CompLex:= toprel;
             Control:= Control+1;
             LeerCar(Fuente,Control,Car);
             Case car of
              '=':
                   begin
                        Lexema := '<=';
                        Control:= Control+1;
                   end;
              '>':
                   begin
                        Lexema := '<>';
                        Control:= Control+1;
                   end;
             else
                 Lexema := '<';

             end;
        end;

     '=':
         begin
              Lexema:='=';
              CompLex:= toprel;
              Control:= Control + 1;
         end;

      '{':
         begin
              Lexema:='{';
              CompLex:= tllavea;
              Control:=Control + 1;
         end;
      '}':
         begin
              Lexema:='}';
              CompLex:= tllavec;
              Control:=Control + 1;
         end;

     ':':
         begin
              CompLex:=topasig;
              Control:= Control + 1;
              LeerCar(Fuente,Control,Car);
              Case Car of
              '=':
                   begin
                        Lexema:=':=';
                        Control:= Control + 1;
                   end;
               else
                   EsSimboloEspecial := false;                                   //        ----->                    Colocamos else lexema:= ':';
              end;
         end;
     ',':
         begin
             Lexema:=',';
             CompLex:=tcoma;
             Control:= Control + 1;
         end;
     '+':
         begin
             Lexema:='+';
             CompLex:=tmas;
             Control:= Control + 1;
         end;
     '-':
         begin
             Lexema:='-';
             CompLex:=tmenos;
             Control:= Control + 1;
         end;
     '*':
         begin
             Lexema:='*';
             CompLex:=tpor;
             Control:= Control + 1;
         end;
     '/':
         begin
             Lexema:='/';
             CompLex:=tbarra;
             Control:= Control + 1;
         end;
     '^':
         begin
             Lexema:='^';
             CompLex:=tpotencia;
             Control:= Control + 1;
             end;
      ';':
        begin
             Lexema:= ';';
             CompLex:= tpuntoycoma;
             Control:= Control+1;
        end;


      else
       EsSimboloEspecial := false;
    end;

end;

Procedure ObtenerSiguienteCompLex(Var Fuente:T_Archivo;Var Control:Longint; Var CompLex:t_simbolo_gramatical;Var Lexema:String;Var TS:t_lista);
  var
    car:char;
Begin {La TS ya ingresa cargada con las Palabras Reservadas}
  {Avanzar el Control salteando todos los caracteres de control y espacios, hasta el primer carácter significativo}
  LeerCar(Fuente,Control,Car);

  while car in [#1..#32] do
  begin
       Control:=Control+1;
       LeerCar(Fuente,Control,Car);
  end;
  If car=fin_archivo then
     CompLex:= pesos
  else
     begin
        If EsIdentificador(Fuente,Control,Lexema) then
	 //  InstalarEnTS(Lexema,TS,CompLex)
            else If EsConstReal(Fuente,Control,Lexema) then
                 begin
	         CompLex:=treal
                 end
                    else
                        If EsConstCadena(Fuente,Control,Lexema) then
                                CompLex:=tcadena
                                else
                                 if Not EsSimboloEspecial(Fuente,Control,CompLex,Lexema) then
                                   begin
                                   CompLex:=Error;
                                    {writeln(Lexema + ' Error');   }

                                       end;
     end;
End;


end.
