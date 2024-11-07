unit u_lista;

interface
uses
crt,u_archivos;
const
  max= 9;
    Type
  t_simbolo_gramatical= (error, tid, tdec, tpuntoycoma, treal, tlista, tparentesisa, tparentesisc, tcoma, tpunto, tmas, tigual, tmayor, tmenor, tmenos, tpor, tbarra, traiz, tpotencia,
  twhile, tdo, tbegin, tdeclaracion, tend, toprel, tllavea, tllavec,tread, tcadena, twrite, tif, tthen, topasig, tand, tor, tnot, telse, telemento, pesos, vprograma,
  vprograma1, vsentencia, vsentencia1, vlist_var, vcond, vcond1, vcondP, vboolTerm, vboolTerm1, vboolTermP, vbooltermp1, vboolFactor, vexprel, voprel,
  voprel1, voprel2, vexparit, vT, vtermino, vF, vfactor, vfactor1, vprimario, velemento, vlista_w, vlista_w2);



    T_dato = Record
      Lexema:String;
      CompLex:t_simbolo_gramatical;
    end;

    T_Punt=^T_nodo;

    T_lista=Record
      tam:integer;
      Act,Cab:T_punt;
    end;

    T_Nodo=Record
      Info:T_Dato;
      Sig:T_Punt;
    end;

procedure cargar(var L:T_lista; E:T_Dato);
procedure eliminar(var L:T_lista; buscado:string; var E:T_dato);
procedure Iniciar_lista(var L:T_lista);
procedure recuperar(L:T_lista; var E:T_dato);
function lista_llena(L:T_lista):boolean;
function lista_vacia(L:T_lista):boolean;
procedure Primero(var L:T_lista);
function Fin(L:T_lista):boolean;
procedure Siguiente(var L:T_lista);

implementation

procedure cargar(var L:T_lista; E:T_Dato);
 var
   Dir,ant:T_punt;
  begin
    new(Dir);
    Dir^.Info:=E;
     If (L.Cab=NIL) then
       begin
         Dir^.Sig:=L.cab;
         L.Cab:=Dir;
       end
     else
      begin
        Ant:=L.Cab;
        L.Act:=L.Cab^.Sig;
         while (L.Act<>NIL) do
          begin
            Ant:=L.Act;
            L.Act:=L.Act^.Sig;
          end;
         Ant^.Sig:=Dir;
         Dir^.Sig:=L.Act;
      end;
      inc(L.tam);
  end;
procedure eliminar(var L:T_lista; buscado:string; var E:T_dato);
 var
   ant:T_punt;
  begin
    if L.Cab^.Info.Lexema=buscado then
      begin
        E:=L.Cab^.Info;
        L.Act:=L.Cab;
        L.Cab:=L.Cab^.Sig;
        dispose(L.Act);
      end
    else
     begin
        Ant:=L.Cab;
        L.Act:=L.Cab^.Sig;
         while (L.Act<>NIL) and (L.Act^.Info.Lexema<>buscado) do
          begin
             Ant:=L.Act;
             L.Act:=L.Act^.Sig;
          end;
         E:=L.Act^.Info;
         Ant^.Sig:=L.Act^.Sig;
         dispose(L.Act);
     end;
     dec(L.tam);
  end;
procedure Iniciar_lista(var L:T_lista);
 begin
   L.tam:=0;
   L.cab:=nil;
 end;

procedure recuperar(L:T_lista; var E:T_dato);
  begin
    E:=L.Act^.Info;
  end;

function lista_llena(L:T_lista):boolean;
  begin
   lista_llena:=getheapstatus.totalfree<SizeOf(T_Nodo)
  end;

function lista_vacia(L:T_lista):boolean;
  begin
   lista_vacia:=(L.tam=0);
  end;

procedure Primero(var L:T_lista);
  begin
   L.Act:=L.Cab;
  end;

function Fin(L:T_lista):boolean;
  begin
   Fin:=L.Act=NIL;
  end;

procedure Siguiente(var L:T_lista);
  begin
   L.Act:=L.Act^.Sig;
  end;
end.

