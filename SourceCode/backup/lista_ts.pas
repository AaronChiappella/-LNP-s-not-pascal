unit lista_TS;

interface

uses
  crt, u_lista;

procedure InstalarEnTS(Lexema:string;var TS:T_lista; var CompLex:t_simbolo_gramatical);
procedure recuperar(L:T_lista; var E:T_dato);
procedure listar(L:T_lista);
procedure lista_no_vacia(var L:T_lista);

Procedure cargarPalabrasReservadas(var l:t_lista; var CompLex:t_simbolo_gramatical);

implementation
procedure InstalarEnTS(Lexema:string;var TS:T_lista; var CompLex:t_simbolo_gramatical);
var
  R:T_dato;
  V:t_punt;
  encontrado:boolean;

 begin
   encontrado:=false;
   V:=ts.cab;
   while (V<>nil) and not(encontrado) do
   begin
        if upcase(v^.info.lexema)=upcase(lexema) then
        encontrado:=true
        else
         v:=v^.sig;
   end;
   if encontrado then
   Complex:=v^.info.complex
   else
   begin
     R.Lexema:=Lexema;
     R.CompLex:=tid;
     Complex:=r.complex;
     cargar(TS,R);
   end;
 end;
procedure recuperar(L:T_lista; var E:T_dato);
  begin
    E:=L.Act^.Info;
  end;

procedure listar(L:T_lista);
var
  E:T_dato;
  i:byte;
  begin
    Primero(L);
    while (not fin(L)) do
     begin
       if i<20 then
       begin
         Recuperar(L,E);
         write(E.CompLex, ' ');
         writeln(E.Lexema);
         Siguiente(L);
         inc(i);
       end
       else
        begin
          i:=0;
          readkey;
          clrscr;
        end;
     end;
  end;
procedure lista_no_vacia(var L:T_lista);
  begin
    if not lista_vacia(L) then listar(L)
    else write('Lista vacia');

  end;

Procedure CargarPalabrasReservadas(var l:t_lista; var CompLex:t_simbolo_gramatical);
var
//  A:t_dato;
  E:t_dato;
  begin
    iniciar_lista(l);
    E.Lexema:='raiz';
    E.CompLex:=TRaiz;
     Cargar(l,E);
    E.Lexema:='while';
    E.CompLex:=TWhile;
     Cargar(l,E);
    E.Lexema:='elemento';
    E.CompLex:=Telemento;
     Cargar(l,E);
    E.Lexema:='begin';
    E.CompLex:=Tbegin;
     Cargar(l,E);
    E.Lexema:='end';
    E.CompLex:=Tend;
     Cargar(l,E);
    E.Lexema:='do';
    E.CompLex:=Tdo;
     Cargar(l,E);
    E.Lexema:='then';
    E.CompLex:=Tthen;
     Cargar(l,E);
    E.Lexema:='if';
    E.CompLex:=Tif;
     Cargar(l,E);
    E.Lexema:='or';
    E.CompLex:=Tor;
     Cargar(l,E);
    E.Lexema:='and';
    E.CompLex:=Tand;
     Cargar(l,E);
    E.Lexema:='not';
    E.CompLex:=Tnot;
     Cargar(l,E);
    E.Lexema:='else';
    E.CompLex:=Telse;
     Cargar(l,E);
    E.Lexema:='read';
    E.CompLex:=Tread;
     Cargar(l,E);
    E.Lexema:='write';
    E.CompLex:=Twrite;
     Cargar(l,E);
    E.Lexema:='real';
    E.CompLex:=Treal;
     Cargar(l,E);
     E.Lexema:='lista';
    E.CompLex:=Tlista;
     Cargar(l,E);
    E.Lexema:='dec';
    E.CompLex:=Tdec;
     Cargar(l,E);
  end;
end.

