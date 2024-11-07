unit menu_principal;
{$codepage UTF8}
interface

uses
  u_analizadorLexico,u_analizadorsintactico, lista_TS, u_lista,u_arbol,u_archivos, crt;
const
  COLOR_FONDO = black;
  COLOR_MENU =  cyan;


  Procedure BorrarPantalla();
  Procedure SetOpcionColor(opcion,selected:byte);
  Procedure MostrarAnalizadorLexico(var Fuente2:t_archivo);
  procedure menu;


var archivo:t_archivo;arbol:t_arbol_derivacion;estado:t_mensaje;

implementation
procedure BorrarPantalla();
 begin
     TextBackground(COLOR_FONDO);
     clrscr;
 end;

procedure SetOpcionColor(opcion,selected:byte);
  begin
      if(opcion=selected) then Textbackground(COLOR_MENU) else TextBackground(COLOR_FONDO);
  end;
procedure menu;
var
   archivo:t_archivo;
   arbol:t_arbol_derivacion;
begin
 assign(archivo,ruta);
abrir_arch(archivo);
//MostrarAnalizadorLexico(archivo);
//readkey;
analizadorSintactico(archivo,arbol{,estado});

//guardararbol(arbol,ruta2);

writeln(estado);

//evaluador(arbol);

close(archivo);

end;

Procedure MostrarAnalizadorLexico(var Fuente2:t_archivo);
    var
       Control2:Longint;
       CompLex2:t_simbolo_gramatical;
       Lexema2:String;
       TS2:t_lista;
       Contador:byte;

    begin
     Control2:=0;
     CargarPalabrasReservadas(TS2,CompLex2);
     ObtenerSiguienteCompLex(Fuente2,Control2,CompLex2,Lexema2,TS2);
     While  not(CompLex2 in [pesos,error]) do
    begin
      writeln(Lexema2,' es: ',CompLex2 );
      ObtenerSiguienteCompLex(Fuente2,Control2,CompLex2,Lexema2,TS2);
      readkey;
      end;

      lista_no_vacia(TS2);
      readkey;
    end;

end.
