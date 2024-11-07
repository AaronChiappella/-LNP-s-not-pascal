unit u_arbol;

interface

uses
crt, u_lista;
type

  t_arbol_derivacion=^t_nodo_arbol;
  t_nodo_arbol= record
                simbolo:t_simbolo_gramatical;
                Lexema:string;
                Hijos: array[1..max] of t_arbol_derivacion;
                cant:byte;   //cantidad de hijos.

  end;


procedure crear_nodo(var raiz : t_arbol_derivacion; complex:t_simbolo_gramatical);
Procedure crear_arbol(var raiz:t_arbol_derivacion);
Procedure agregar_al_arbol(var raiz:t_arbol_derivacion; CompLex:t_simbolo_gramatical ;Lexema:String);
Procedure Mostrar_arbol (var arbol:t_arbol_derivacion);
procedure guardarArbol(var arbol:t_arbol_derivacion;ruta2:string);
procedure llenar_Arbol(var arch:text; var raiz: t_arbol_derivacion; Desplazamiento:integer);
procedure guardarArbola(var ar:text; var raiz: t_arbol_derivacion; Desplazamiento:integer);
Procedure agregar_hijo(var raiz:t_arbol_derivacion; var hijo:t_arbol_derivacion);
procedure guardarArbola(var ar:text; var raiz: t_arbol_derivacion; Desplazamiento:integer);
implementation

procedure crear_nodo(var raiz : t_arbol_derivacion; complex:t_simbolo_gramatical);
{crea un nodo e inicializa todas las celdas del vector hijos}
var i: integer;
 begin
        new(raiz);
        raiz^.simbolo:=complex;
        raiz^.lexema:= '' ;
        raiz^.cant:= 0;
        for i:= 1 to max do
        raiz^.hijos[i]:=nil;

 end;

Procedure crear_arbol(var raiz:t_arbol_derivacion);
{crea raiz del arbol}
  begin
    raiz:=nil;
  end;

Procedure agregar_al_arbol(var raiz:t_arbol_derivacion;CompLex:t_simbolo_gramatical;Lexema:String);
//agrega nodo al arbol, es necesario que se le asigne un componente lexico y un lexema para agregar el nodo
var
  i:integer;
  aux:t_arbol_derivacion;
 begin
   new(aux);
   aux^.simbolo:=CompLex;
   aux^.Lexema:=lexema;
   aux^.cant:=0;
   for i:=1 to max do aux^.hijos[i]:=nil;
   raiz:=aux;
 end;

{Procedure agregar_hijo(var raiz:t_arbol_derivacion; var hijo:t_arbol_derivacion);
{agrega nodo hijo al arbol, es necesario utilizar crear nodo antes de agregarlo}
begin
raiz.cant:=1;  ((((¿?))))
  If raiz^.cant< maxProduccion then
  begin
   inc(raiz^.cant);
   raiz^.hijos[raiz^.cant]:=hijo;
 end;
end;}

Procedure Mostrar_arbol (var arbol:t_arbol_derivacion);
{escribe la serie de componentes lexicos que componen el arbol, una especie de grafico de arbol. Ira escribiendo un nodo y todos sus hijos recorriendo de izquierda a derecha.}
var i:integer;
begin
   writeln(arbol^.simbolo) ;
 for i:=1 to arbol^.cant do
   begin
      Mostrar_arbol(arbol^.hijos[i]);
   end;
end;

procedure llenar_Arbol(var arch:text; var raiz: t_arbol_derivacion; Desplazamiento:integer);
{GUARDA ARBOL EN UN ARCHIVO DE TEXTO}
var i : integer;
begin
     {Writeln(arch, ':',desplazamiento,raiz^.simbolo,': ',raiz^.lexema);
        for i:=1 to raiz^.cant do  begin
          llenar_Arbol(arch,raiz^.hijos[i],Desplazamiento+2);
        end;}
end;

procedure guardarArbol(var arbol:t_arbol_derivacion;ruta2:string);
var arch:text;
begin
      assign(arch,ruta2);
      rewrite(arch);
      llenar_arbol(arch,arbol,0);

      close(arch);
end;
Procedure agregar_hijo(var raiz:t_arbol_derivacion; var hijo:t_arbol_derivacion);
begin
  If raiz^.cant< max then
  begin
   inc(raiz^.cant);
   raiz^.hijos[raiz^.cant]:=hijo;
 end;
end;

procedure guardarArbola(var ar:text; var raiz: t_arbol_derivacion; Desplazamiento:integer);
var i : integer;
begin
     Writeln(ar, '':desplazamiento,raiz^.simbolo,': ',raiz^.lexema);
        for i:=1 to raiz^.cant do  begin
            guardarArbola(ar,raiz,desplazamiento);
        end;

end;
end.

