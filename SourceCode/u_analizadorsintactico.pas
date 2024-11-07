unit u_analizadorsintactico;

interface


uses
  u_arbol,u_lista,lista_TS,u_archivos,u_analizadorLexico,crt;
const
  maxPila=2000;
  maxProduccion=8;
type

  t_elem_Pila= record
                simb: t_simbolo_gramatical;
                nodo: t_arbol_derivacion;
  end;

  t_pila= record
          elem: array [1..maxPila] of t_elem_Pila;
          tope: word;
  end;
  t_produccion= record
          elem: array [1..maxProduccion] of t_simbolo_gramatical;
          cant: byte;
  end;
  t_puntero_produccion=  ^t_produccion;
  tipo_TAS= array [vprograma..vlista_w2,tid..pesos] of ^t_produccion;

  t_mensaje=(exito,errorlexico,errorsintactico,enproceso);

  procedure inicializar_TAS(var TAS: tipo_TAS);
  procedure cargar_TAS(var TAS:tipo_TAS);
  procedure crear_TAS(var TAS: tipo_TAS);
  procedure crearpila(var p:t_pila);
  procedure apilar (var p:t_pila; x:t_elem_Pila);
  procedure desapilar (var p:t_pila;var x:t_elem_Pila);
  {REVISAR EN U_ARBOL: function crear_nodo(clave: tsimgram; lexema:string):t_punt_arbol;
  function agregar_hijo(var padre:t_punt_arbol; pos: byte; simbolo:tsimgram): t_punt_arbol;}
  Procedure analizadorSintactico(var Fuente: t_archivo;var raiz:t_arbol_derivacion);


implementation

  procedure inicializar_TAS(var TAS: tipo_TAS);
  var i,j:t_simbolo_gramatical;
  begin
      for i:=vprograma to vlista_w2 do
        for j:=tid to pesos do
          TAS[i,j]:=NIL;
  end;

  procedure cargar_TAS(var TAS:tipo_TAS);
  var
  i,j:t_simbolo_gramatical;
  begin
    for i:=vprograma to vlista_w2 do
        for j:=tid to pesos do
            TAS[i,j]:=nil;
    //Programa-> Sentencia; Programa1
        new (TAS[vprograma,tid]);
        TAS[vprograma,tid]^.elem[1]:=vsentencia;
        TAS[vprograma,tid]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,tid]^.elem[3]:=vprograma1;
        TAS[vprograma,tid]^.cant:=3;

        new (TAS[vprograma,tif]);
        TAS[vprograma,tif]^.elem[1]:=vsentencia;
        TAS[vprograma,tif]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,tif]^.elem[3]:=vprograma1;
        TAS[vprograma,tif]^.cant:=3;

        new (TAS[vprograma,tdec]);
        TAS[vprograma,tdec]^.elem[1]:=vsentencia;
        TAS[vprograma,tdec]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,tdec]^.elem[3]:=vprograma1;
        TAS[vprograma,tdec]^.cant:=3;

        new (TAS[vprograma,twhile]);
        TAS[vprograma,twhile]^.elem[1]:=vsentencia;
        TAS[vprograma,twhile]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,twhile]^.elem[3]:=vprograma1;
        TAS[vprograma,twhile]^.cant:=3;

        new (TAS[vprograma,tread]);
        TAS[vprograma,tread]^.elem[1]:=vsentencia;
        TAS[vprograma,tread]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,tread]^.elem[3]:=vprograma1;
        TAS[vprograma,tread]^.cant:=3;

        new (TAS[vprograma,twrite]);
        TAS[vprograma,twrite]^.elem[1]:=vsentencia;
        TAS[vprograma,twrite]^.elem[2]:=tpuntoycoma;
        TAS[vprograma,twrite]^.elem[3]:=vprograma1;
        TAS[vprograma,twrite]^.cant:=3;

    //Programa1->Programa
      new (TAS[vprograma1,tid]);
      TAS[vprograma1,tid]^.elem[1]:=vprograma;
      TAS[vprograma1,tid]^.cant:=1;

      new (TAS[vprograma1,tif]);
      TAS[vprograma1,tif]^.elem[1]:=vprograma;
      TAS[vprograma1,tif]^.cant:=1;

      new (TAS[vprograma1,tdec]);
      TAS[vprograma1,tdec]^.elem[1]:=vprograma;
      TAS[vprograma1,tdec]^.cant:=1;

      new (TAS[vprograma1,twhile]);
      TAS[vprograma1,twhile]^.elem[1]:=vprograma;
      TAS[vprograma1,twhile]^.cant:=1;

      new (TAS[vprograma1,tread]);
      TAS[vprograma1,tread]^.elem[1]:=vprograma;
      TAS[vprograma1,tread]^.cant:=1;

      new (TAS[vprograma1,twrite]);
      TAS[vprograma1,twrite]^.elem[1]:=vprograma;
      TAS[vprograma1,twrite]^.cant:=1;

    //Programa1->epsilon
      new (TAS[vprograma1,pesos]);
      TAS[vprograma1,pesos]^.cant:=0;

    //Sentencia->id:=ExpArit
      new (TAS[vsentencia,tid]);
      TAS[vsentencia,tid]^.elem[1]:=tid;
      TAS[vsentencia,tid]^.elem[2]:=topasig;
      TAS[vsentencia,tid]^.elem[3]:=vexparit;
      TAS[vsentencia,tid]^.cant:=3;

    //Sentencia->if Cond then begin Programa Sentencia1
      new (TAS[vsentencia,tif]);
      TAS[vsentencia,tif]^.elem[1]:=tif;
      TAS[vsentencia,tif]^.elem[2]:=vcond;
      TAS[vsentencia,tif]^.elem[3]:=tthen;
      TAS[vsentencia,tif]^.elem[4]:=tbegin;
      TAS[vsentencia,tif]^.elem[5]:=vprograma;
      TAS[vsentencia,tif]^.elem[6]:=vsentencia1;
      TAS[vsentencia,tif]^.cant:=6;

    //Sentencia->dec id Lista_var;
      new (TAS[vsentencia,tdec]);
      TAS[vsentencia,tdec]^.elem[1]:=tdec;
      TAS[vsentencia,tdec]^.elem[2]:=tid;
      TAS[vsentencia,tdec]^.elem[3]:=vlist_var;
      TAS[vsentencia,tdec]^.elem[4]:=tpuntoycoma;
      TAS[vsentencia,tdec]^.cant:=4;

    //Sentencia->while Cond do Programa end
      new (TAS[vsentencia,twhile]);
      TAS[vsentencia,twhile]^.elem[1]:=twhile;
      TAS[vsentencia,twhile]^.elem[2]:=vcond;
      TAS[vsentencia,twhile]^.elem[3]:=vcond;
      TAS[vsentencia,twhile]^.elem[4]:=vprograma;
      TAS[vsentencia,twhile]^.elem[5]:=tend;
      TAS[vsentencia,twhile]^.cant:=5;

    //Sentencia->read (cad,id)
      new (TAS[vsentencia,tread]);
      TAS[vsentencia,tread]^.elem[1]:=tread;
      TAS[vsentencia,tread]^.elem[2]:=tparentesisa;
    //  TAS[vsentencia,tread]^.elem[3]:=tcad;
      TAS[vsentencia,tread]^.elem[4]:=tcoma;
      TAS[vsentencia,tread]^.elem[5]:=tid;
      TAS[vsentencia,tread]^.elem[6]:=tparentesisc;
      TAS[vsentencia,tread]^.cant:=6;

    //Sentencia->write (Lista_w)
      new (TAS[vsentencia,twrite]);
      TAS[vsentencia,twrite]^.elem[1]:=twrite;
      TAS[vsentencia,twrite]^.elem[2]:=tparentesisa;
      TAS[vsentencia,twrite]^.elem[3]:=vlista_w;
      TAS[vsentencia,twrite]^.elem[4]:=tparentesisc;
      TAS[vsentencia,twrite]^.cant:=4;

    //Sentencia1->end
      new (TAS[vsentencia1,tend]);
      TAS[vsentencia1,tend]^.elem[1]:=tend;
      TAS[vsentencia1,tend]^.cant:=1;

    //Sentencia1->else Programa end
      new (TAS[vsentencia1,telse]);
      TAS[vsentencia1,telse]^.elem[1]:=telse;
      TAS[vsentencia1,telse]^.elem[2]:=vprograma;
      TAS[vsentencia1,telse]^.elem[3]:=tend;
      TAS[vsentencia1,telse]^.cant:=3;

    //Lista_var->,id Lista_var
      new (TAS[vlist_var,tcoma]);
      TAS[vlist_var,tcoma]^.elem[1]:=tcoma;
      TAS[vlist_var,tcoma]^.elem[2]:=tid;
      TAS[vlist_var,tcoma]^.elem[3]:=vlist_var;
      TAS[vlist_var,tcoma]^.cant:=3;

    //Lista_var->epsilon
        new (TAS[vlist_var,tpuntoycoma]);
        TAS[vlist_var,tpuntoycoma]^.cant:=0;

    //Cond->BoolTerm Cond1
      new (TAS[vcond,tid]);
      TAS[vcond,tid]^.elem[1]:=vboolTerm;
      TAS[vcond,tid]^.elem[2]:=vcond1;
      TAS[vcond,tid]^.cant:=2;

      new (TAS[vcond,treal]);
      TAS[vcond,treal]^.elem[1]:=vboolTerm;
      TAS[vcond,treal]^.elem[2]:=vcond1;
      TAS[vcond,treal]^.cant:=2;

      new (TAS[vcond,tnot]);
      TAS[vcond,tnot]^.elem[1]:=vboolTerm;
      TAS[vcond,tnot]^.elem[2]:=vcond1;
      TAS[vcond,tnot]^.cant:=2;

      new (TAS[vcond,tllavea]);
      TAS[vcond,tllavea]^.elem[1]:=vboolTerm;
      TAS[vcond,tllavea]^.elem[2]:=vcond1;
      TAS[vcond,tllavea]^.cant:=2;

      new (TAS[vcond,traiz]);
      TAS[vcond,traiz]^.elem[1]:=vboolTerm;
      TAS[vcond,traiz]^.elem[2]:=vcond1;
      TAS[vcond,traiz]^.cant:=2;

      new (TAS[vcond,tparentesisa]);
      TAS[vcond,tparentesisa]^.elem[1]:=vboolTerm;
      TAS[vcond,tparentesisa]^.elem[2]:=vcond1;
      TAS[vcond,tparentesisa]^.cant:=2;

      new (TAS[vcond,tmenos]);
      TAS[vcond,tmenos]^.elem[1]:=vboolTerm;
      TAS[vcond,tmenos]^.elem[2]:=vcond1;
      TAS[vcond,tmenos]^.cant:=2;

    //Cond1->CondP
      new (TAS[vcond1,tor]);
      TAS[vcond1,tor]^.elem[1]:=vcondP;
      TAS[vcond1,tor]^.cant:=1;

    //Cond1->epsilon
      new (TAS[vcond1,tthen]);
      TAS[vcond1,tthen]^.cant:=0;

      new (TAS[vcond1,tllavea]);
      TAS[vcond1,tllavea]^.cant:=0;

      new (TAS[vcond1,tdo]);
      TAS[vcond1,tdo]^.cant:=0;

    //CondP-> OR BoolTerm Cond1
      new (TAS[vcondP,tor]);
      TAS[vcondP,tor]^.elem[1]:=tor;
      TAS[vcondP,tor]^.elem[2]:=vboolTerm;
      TAS[vcondP,tor]^.elem[3]:=vcond1;
      TAS[vcondP,tor]^.cant:=3;

    //BoolTerm-> BoolFactor BoolTerm1
    new (TAS[vboolTerm,tid]);
    TAS[vboolTerm,tid]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,tid]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,tid]^.cant:=2;

    new (TAS[vboolTerm,treal]);
    TAS[vboolTerm,treal]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,treal]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,treal]^.cant:=2;

    new (TAS[vboolTerm,tnot]);
    TAS[vboolTerm,tnot]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,tnot]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,tnot]^.cant:=2;

    new (TAS[vboolTerm,tllavea]);
    TAS[vboolTerm,tllavea]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,tllavea]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,tllavea]^.cant:=2;

    new (TAS[vboolTerm,traiz]);
    TAS[vboolTerm,traiz]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,traiz]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,traiz]^.cant:=2;

    new (TAS[vboolTerm,tparentesisa]);
    TAS[vboolTerm,tparentesisa]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,tparentesisa]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,tparentesisa]^.cant:=2;

    new (TAS[vboolTerm,tmenos]);
    TAS[vboolTerm,tmenos]^.elem[1]:=vboolFactor;
    TAS[vboolTerm,tmenos]^.elem[2]:=vboolTerm1;
    TAS[vboolTerm,tmenos]^.cant:=2;

    //BoolTerm1-> BoolTermP
    new (TAS[vboolTerm1,tand]);
    TAS[vboolTerm1,tand]^.elem[1]:=vboolTermP;
    TAS[vboolTerm1,tand]^.cant:=1;

    //BoolTerm1-> épsilon
    new (TAS[vboolTerm1,tthen]);
    TAS[vboolTerm1,tthen]^.cant:=0;

    new (TAS[vboolTerm1,tor]);
    TAS[vboolTerm1,tor]^.cant:=0;

    new (TAS[vboolTerm1,tllavec]);
    TAS[vboolTerm1,tllavec]^.cant:=0;

    new (TAS[vboolTerm1,tdo]);
    TAS[vboolTerm1,tdo]^.cant:=0;

    //BoolTermP-> AND BoolFactor BoolTerm1
    new (TAS[vboolTermP,tand]);
    TAS[vboolTermP,tand]^.elem[1]:=tand;
    TAS[vboolTermP,tand]^.elem[2]:=vboolFactor;
    TAS[vboolTermP,tand]^.elem[3]:=vboolTerm1;
    TAS[vboolTermP,tand]^.cant:=3;

    //BoolFactor-> NOT BoolFactor
    new (TAS[vboolFactor,tnot]);
    TAS[vboolFactor,tnot]^.elem[1]:=tnot;
    TAS[vboolFactor,tnot]^.elem[2]:=vboolFactor;
    TAS[vboolFactor,tnot]^.cant:=2;

    //BoolFactor-> {Cond}
    new (TAS[vboolFactor,tllavea]);
    TAS[vboolFactor,tllavea]^.elem[1]:=tllavea;
    TAS[vboolFactor,tllavea]^.elem[2]:=vcond;
    TAS[vboolFactor,tllavea]^.elem[3]:=tllavec;
    TAS[vboolFactor,tllavea]^.cant:=3;

    //BoolFactor-> ExpRel
    new (TAS[vboolFactor,tid]);
    TAS[vboolFactor,tid]^.elem[1]:=vexprel;
    TAS[vboolFactor,tid]^.cant:=1;

    new (TAS[vboolFactor,treal]);
    TAS[vboolFactor,treal]^.elem[1]:=vexprel;
    TAS[vboolFactor,treal]^.cant:=1;

    new (TAS[vboolFactor,traiz]);
    TAS[vboolFactor,traiz]^.elem[1]:=vexprel;
    TAS[vboolFactor,traiz]^.cant:=1;

    new (TAS[vboolFactor,tparentesisa]);
    TAS[vboolFactor,tparentesisa]^.elem[1]:=vexprel;
    TAS[vboolFactor,tparentesisa]^.cant:=1;

    new (TAS[vboolFactor,tmenos]);
    TAS[vboolFactor,tmenos]^.elem[1]:=vexprel;
    TAS[vboolFactor,tmenos]^.cant:=1;

    //ExpRel-> ExpArit OpRel ExpArit
    new (TAS[vexprel,tid]);
    TAS[vexprel,tid]^.elem[1]:=vexparit;
    TAS[vexprel,tid]^.elem[2]:=voprel;
    TAS[vexprel,tid]^.elem[3]:=vexparit;
    TAS[vexprel,tid]^.cant:=3;

    new (TAS[vexprel,treal]);
    TAS[vexprel,treal]^.elem[1]:=vexparit;
    TAS[vexprel,treal]^.elem[2]:=voprel;
    TAS[vexprel,treal]^.elem[3]:=vexparit;
    TAS[vexprel,treal]^.cant:=3;

    new (TAS[vexprel,traiz]);
    TAS[vexprel,traiz]^.elem[1]:=vexparit;
    TAS[vexprel,traiz]^.elem[2]:=voprel;
    TAS[vexprel,traiz]^.elem[3]:=vexparit;
    TAS[vexprel,traiz]^.cant:=3;

    new (TAS[vexprel,tparentesisa]);
    TAS[vexprel,tparentesisa]^.elem[1]:=vexparit;
    TAS[vexprel,tparentesisa]^.elem[2]:=voprel;
    TAS[vexprel,tparentesisa]^.elem[3]:=vexparit;
    TAS[vexprel,tparentesisa]^.cant:=3;

    new (TAS[vexprel,tmenos]);
    TAS[vexprel,tmenos]^.elem[1]:=vexparit;
    TAS[vexprel,tmenos]^.elem[2]:=voprel;
    TAS[vexprel,tmenos]^.elem[3]:=vexparit;
    TAS[vexprel,tmenos]^.cant:=3;

    //OpRel -> >OpRel2
    new (TAS[voprel,tmayor]);
    TAS[voprel,tmayor]^.elem[1]:=tmayor;
    TAS[voprel,tmayor]^.elem[2]:=voprel2;
    TAS[voprel,tmayor]^.cant:=2;

    //OpRel -> <OpRel1
    new (TAS[voprel,tmenor]);
    TAS[voprel,tmenor]^.elem[1]:=tmenor;
    TAS[voprel,tmenor]^.elem[2]:=voprel1;
    TAS[voprel,tmenor]^.cant:=2;

    //OpRel -> =
    new (TAS[voprel,tigual]);
    TAS[voprel,tigual]^.elem[1]:=tigual;
    TAS[voprel,tigual]^.cant:=1;

    //OpRel1-> =
    new (TAS[voprel1,tigual]);
    TAS[voprel1,tigual]^.elem[1]:=tigual;
    TAS[voprel1,tigual]^.cant:=1;

    //OpRel1-> >
    new (TAS[voprel1,tmayor]);
    TAS[voprel1,tmayor]^.elem[1]:=tmayor;
    TAS[voprel1,tmayor]^.cant:=1;

    //OpRel1-> epsilon
    new (TAS[voprel1,tid]);
    TAS[voprel1,tid]^.cant:=0;

    new (TAS[voprel1,treal]);
    TAS[voprel1,treal]^.cant:=0;

    new (TAS[voprel1,traiz]);
    TAS[voprel1,traiz]^.cant:=0;

    new (TAS[voprel1,tparentesisa]);
    TAS[voprel1,tparentesisa]^.cant:=0;

    new (TAS[voprel1,tmenos]);
    TAS[voprel1,tmenos]^.cant:=0;

    //OpRel2-> =
    new (TAS[voprel2,tigual]);
    TAS[voprel2,tigual]^.elem[1]:=tigual;
    TAS[voprel2,tigual]^.cant:=1;

    //OpRel2-> epsilon
    new (TAS[voprel2,tid]);
    TAS[voprel2,tid]^.cant:=0;

    new (TAS[voprel2,treal]);
    TAS[voprel2,treal]^.cant:=0;

    new (TAS[voprel2,traiz]);
    TAS[voprel2,traiz]^.cant:=0;

    new (TAS[voprel2,tparentesisa]);
    TAS[voprel2,tparentesisa]^.cant:=0;

    new (TAS[voprel2,tmenos]);
    TAS[voprel2,tmenos]^.cant:=0;

    //ExpArit-> Termino T
    new (TAS[vexparit,tid]);
    TAS[vexparit,tid]^.elem[1]:=vtermino;
    TAS[vexparit,tid]^.elem[2]:=vT;
    TAS[vexparit,tid]^.cant:=2;

    new (TAS[vexparit,treal]);
    TAS[vexparit,treal]^.elem[1]:=vtermino;
    TAS[vexparit,treal]^.elem[2]:=vT;
    TAS[vexparit,treal]^.cant:=2;

    new (TAS[vexparit,traiz]);
    TAS[vexparit,traiz]^.elem[1]:=vtermino;
    TAS[vexparit,traiz]^.elem[2]:=vT;
    TAS[vexparit,traiz]^.cant:=2;

    new (TAS[vexparit,tparentesisa]);
    TAS[vexparit,tparentesisa]^.elem[1]:=vtermino;
    TAS[vexparit,tparentesisa]^.elem[2]:=vT;
    TAS[vexparit,tparentesisa]^.cant:=2;

    new (TAS[vexparit,tmenos]);
    TAS[vexparit,tmenos]^.elem[1]:=vtermino;
    TAS[vexparit,tmenos]^.elem[2]:=vT;
    TAS[vexparit,tmenos]^.cant:=2;

    //T -> +Termino T
    new (TAS[vT,tmas]);
    TAS[vT,tmas]^.elem[1]:=tmas;
    TAS[vT,tmas]^.elem[2]:=vtermino;
    TAS[vT,tmas]^.elem[3]:=vT;
    TAS[vT,tmas]^.cant:=3;

    //T -> -Termino T
    new (TAS[vT,tmenos]);
    TAS[vT,tmenos]^.elem[1]:=tmenos;
    TAS[vT,tmenos]^.elem[2]:=vtermino;
    TAS[vT,tmenos]^.elem[3]:=vT;
    TAS[vT,tmenos]^.cant:=3;

    //T -> epsilon
    new (TAS[vT,tthen]);
    TAS[vT,tthen]^.cant:=0;

    new (TAS[vT,tcoma]);
    TAS[vT,tcoma]^.cant:=0;

    new (TAS[vT,tpuntoycoma]);
    TAS[vT,tpuntoycoma]^.cant:=0;

    new (TAS[vT,tor]);
    TAS[vT,tor]^.cant:=0;

    new (TAS[vT,tand]);
    TAS[vT,tand]^.cant:=0;

    new (TAS[vT,tllavea]);
    TAS[vT,tllavea]^.cant:=0;

    new (TAS[vT,tmenor]);
    TAS[vT,tmenor]^.cant:=0;

    new (TAS[vT,tmayor]);
    TAS[vT,tmayor]^.cant:=0;

    new (TAS[vT,tdo]);
    TAS[vT,tdo]^.cant:=0;

    new (TAS[vT,tigual]);
    TAS[vT,tigual]^.cant:=0;

    //Termino-> FactorF
    new (TAS[vtermino,tid]);
    TAS[vtermino,tid]^.elem[1]:=vfactor;
    TAS[vtermino,tid]^.elem[2]:=vF;
    TAS[vtermino,tid]^.cant:=2;

    new (TAS[vtermino,treal]);
    TAS[vtermino,treal]^.elem[1]:=vfactor;
    TAS[vtermino,treal]^.elem[2]:=vF;
    TAS[vtermino,treal]^.cant:=2;

    new (TAS[vtermino,traiz]);
    TAS[vtermino,traiz]^.elem[1]:=vfactor;
    TAS[vtermino,traiz]^.elem[2]:=vF;
    TAS[vtermino,traiz]^.cant:=2;

    new (TAS[vtermino,tparentesisa]);
    TAS[vtermino,tparentesisa]^.elem[1]:=vfactor;
    TAS[vtermino,tparentesisa]^.elem[2]:=vF;
    TAS[vtermino,tparentesisa]^.cant:=2;

    new (TAS[vtermino,tmenos]);
    TAS[vtermino,tmenos]^.elem[1]:=vfactor;
    TAS[vtermino,tmenos]^.elem[2]:=vF;
    TAS[vtermino,tmenos]^.cant:=2;

    //F-> *FactorF
    new (TAS[vF,tpor]);
    TAS[vF,tpor]^.elem[1]:=tpor;
    TAS[vF,tpor]^.elem[2]:=vfactor;
    TAS[vF,tpor]^.elem[3]:=vF;
    TAS[vF,tpor]^.cant:=3;

    //F-> /FactorF
    new (TAS[vF,tbarra]);
    TAS[vF,tbarra]^.elem[1]:=tbarra;
    TAS[vF,tbarra]^.elem[2]:=vfactor;
    TAS[vF,tbarra]^.elem[3]:=vF;
    TAS[vF,tbarra]^.cant:=3;

    //F-> epsilon
    new (TAS[vF,tthen]);
    TAS[vF,tthen]^.cant:=0;

    new (TAS[vF,tcoma]);
    TAS[vF,tcoma]^.cant:=0;

    new (TAS[vF,tpuntoycoma]);
    TAS[vF,tpuntoycoma]^.cant:=0;

    new (TAS[vF,tor]);
    TAS[vF,tor]^.cant:=0;

    new (TAS[vF,tand]);
    TAS[vF,tand]^.cant:=0;

    new (TAS[vF,tllavec]);
    TAS[vF,tllavec]^.cant:=0;

    new (TAS[vF,tmayor]);
    TAS[vF,tmayor]^.cant:=0;

    new (TAS[vF,tmenor]);
    TAS[vF,tmenor]^.cant:=0;

    new (TAS[vF,tdo]);
    TAS[vF,tdo]^.cant:=0;

    new (TAS[vF,tparentesisc]);
    TAS[vF,tparentesisc]^.cant:=0;

    new (TAS[vF,tmenos]);
    TAS[vF,tmenos]^.cant:=0;

    new (TAS[vF,tmas]);
    TAS[vF,tmas]^.cant:=0;

    new (TAS[vF,tigual]);
    TAS[vF,tigual]^.cant:=0;

    //Factor-> Primario Factor1
    new (TAS[vfactor,tid]);
    TAS[vfactor,tid]^.elem[1]:=vprimario;
    TAS[vfactor,tid]^.elem[2]:=vfactor1;
    TAS[vfactor,tid]^.cant:=2;

    new (TAS[vfactor,treal]);
    TAS[vfactor,treal]^.elem[1]:=vprimario;
    TAS[vfactor,treal]^.elem[2]:=vfactor1;
    TAS[vfactor,treal]^.cant:=2;

    new (TAS[vfactor,traiz]);
    TAS[vfactor,traiz]^.elem[1]:=vprimario;
    TAS[vfactor,traiz]^.elem[2]:=vfactor1;
    TAS[vfactor,traiz]^.cant:=2;

    new (TAS[vfactor,tparentesisa]);
    TAS[vfactor,tparentesisa]^.elem[1]:=vprimario;
    TAS[vfactor,tparentesisa]^.elem[2]:=vfactor1;
    TAS[vfactor,tparentesisa]^.cant:=2;

    new (TAS[vfactor,tmenos]);
    TAS[vfactor,tmenos]^.elem[1]:=vprimario;
    TAS[vfactor,tmenos]^.elem[2]:=vfactor1;
    TAS[vfactor,tmenos]^.cant:=2;

    //Factor1-> ^ Factor
    new (TAS[vfactor1,tpotencia]);
    TAS[vfactor1,tpotencia]^.elem[1]:=tpotencia;
    TAS[vfactor1,tpotencia]^.elem[2]:=vfactor;
    TAS[vfactor1,tpotencia]^.cant:=2;

    //Factor1-> epsilon
    new (TAS[vfactor1,tthen]);
    TAS[vfactor1,tthen]^.cant:=0;

    new (TAS[vfactor1,tbegin]);
    TAS[vfactor1,tbegin]^.cant:=0;

    new (TAS[vfactor1,tcoma]);
    TAS[vfactor1,tcoma]^.cant:=0;

    new (TAS[vfactor1,tpuntoycoma]);
    TAS[vfactor1,tpuntoycoma]^.cant:=0;

    new (TAS[vfactor1,tor]);
    TAS[vfactor1,tor]^.cant:=0;

    new (TAS[vfactor1,tand]);
    TAS[vfactor1,tand]^.cant:=0;

    new (TAS[vfactor1,tllavec]);
    TAS[vfactor1,tllavec]^.cant:=0;

    new (TAS[vfactor1,tmenor]);
    TAS[vfactor1,tmenor]^.cant:=0;

    new (TAS[vfactor1,tmayor]);
    TAS[vfactor1,tmayor]^.cant:=0;

    new (TAS[vfactor1,tdo]);
    TAS[vfactor1,tdo]^.cant:=0;

    new (TAS[vfactor1,tparentesisc]);
    TAS[vfactor1,tparentesisc]^.cant:=0;

    new (TAS[vfactor1,tmenos]);
    TAS[vfactor1,tmenos]^.cant:=0;

    new (TAS[vfactor1,tpor]);
    TAS[vfactor1,tpor]^.cant:=0;

    new (TAS[vfactor1,tbarra]);
    TAS[vfactor1,tbarra]^.cant:=0;

    new (TAS[vfactor1,tmas]);
    TAS[vfactor1,tmas]^.cant:=0;

    new (TAS[vfactor1,tigual]);
    TAS[vfactor1,tigual]^.cant:=0;

    //Primario-> -Primario
    new (TAS[vprimario,tmenos]);
    TAS[vprimario,tmenos]^.elem[1]:=tmenos;
    TAS[vprimario,tmenos]^.elem[2]:=vprimario;
    TAS[vprimario,tmenos]^.cant:=2;

    //Primario-> Elemento
    new (TAS[vprimario,tid]);
    TAS[vprimario,tid]^.elem[1]:=velemento;
    TAS[vprimario,tid]^.cant:=1;

    new (TAS[vprimario,treal]);
    TAS[vprimario,treal]^.elem[1]:=velemento;
    TAS[vprimario,treal]^.cant:=1;

    new (TAS[vprimario,traiz]);
    TAS[vprimario,traiz]^.elem[1]:=velemento;
    TAS[vprimario,traiz]^.cant:=1;

    new (TAS[vprimario,tparentesisa]);
    TAS[vprimario,tparentesisa]^.elem[1]:=velemento;
    TAS[vprimario,tparentesisa]^.cant:=1;

    //Elemento-> (ExpArit)
    new (TAS[velemento,tparentesisa]);
    TAS[velemento,tparentesisa]^.elem[1]:=tparentesisa;
    TAS[velemento,tparentesisa]^.elem[2]:=vexparit;
    TAS[velemento,tparentesisa]^.elem[3]:=tparentesisc;
    TAS[velemento,tparentesisa]^.cant:=3;

    //Elemento-> id
    new (TAS[velemento,tid]);
    TAS[velemento,tid]^.elem[1]:=tid;
    TAS[velemento,tid]^.cant:=1;

    //Elemento-> const
    new (TAS[velemento,treal]);
    TAS[velemento,treal]^.elem[1]:=treal;
    TAS[velemento,treal]^.elem[2]:=tparentesisa;
    TAS[velemento,treal]^.elem[3]:=vexparit;
    TAS[velemento,treal]^.elem[4]:=tparentesisc;
    TAS[velemento,treal]^.cant:=4;

    //Elemento-> raiz(ExpArit)
    new (TAS[velemento,traiz]);
    TAS[velemento,traiz]^.elem[1]:=traiz;
    TAS[velemento,traiz]^.elem[2]:=tparentesisa;
    TAS[velemento,traiz]^.elem[3]:=vexparit;
    TAS[velemento,traiz]^.elem[4]:=tparentesisc;
    TAS[velemento,traiz]^.cant:=4;

    //Lista_w-> cad Lista_w2
    new (TAS[vlista_w,tcadena]);
    TAS[vlista_w,tcadena]^.elem[1]:=tcadena;
    TAS[vlista_w,tcadena]^.elem[2]:=vlista_w2;
    TAS[vlista_w,tcadena]^.cant:=2;

    //Lista_w-> ExpArit Lista_w2
    new (TAS[vlista_w,tid]);
    TAS[vlista_w,tid]^.elem[1]:=vexparit;
    TAS[vlista_w,tid]^.elem[2]:=vlista_w2;
    TAS[vlista_w,tid]^.cant:=2;

    new (TAS[vlista_w,treal]);
    TAS[vlista_w,treal]^.elem[1]:=vexparit;
    TAS[vlista_w,treal]^.elem[2]:=vlista_w2;
    TAS[vlista_w,treal]^.cant:=2;

    new (TAS[vlista_w,traiz]);
    TAS[vlista_w,traiz]^.elem[1]:=vexparit;
    TAS[vlista_w,traiz]^.elem[2]:=vlista_w2;
    TAS[vlista_w,traiz]^.cant:=2;

    new (TAS[vlista_w,tparentesisa]);
    TAS[vlista_w,tparentesisa]^.elem[1]:=vexparit;
    TAS[vlista_w,tparentesisa]^.elem[2]:=vlista_w2;
    TAS[vlista_w,tparentesisa]^.cant:=2;

    new (TAS[vlista_w,tmenos]);
    TAS[vlista_w,tmenos]^.elem[1]:=vexparit;
    TAS[vlista_w,tmenos]^.elem[2]:=vlista_w2;
    TAS[vlista_w,tmenos]^.cant:=2;

    //Lista_w2-> ,Lista_w
    new (TAS[vlista_w2,tcoma]);
    TAS[vlista_w2,tcoma]^.elem[1]:=tcoma;
    TAS[vlista_w2,tcoma]^.elem[2]:=vlista_w;
    TAS[vlista_w2,tcoma]^.cant:=2;

    //Lista_w2-> epsilon
    new (TAS[vlista_w2,tparentesisc]);
    TAS[vlista_w2,tparentesisc]^.cant:=0;
  end;

  procedure crear_TAS(var TAS: tipo_TAS);
  begin
    inicializar_TAS(TAS);
    cargar_TAS(TAS);
  end;

  procedure crearpila(var p:t_pila);
  begin
   p.tope:=0;
  end;

  procedure apilar (var p:t_pila; x:t_elem_pila);
  begin
  p.tope:=p.tope+1;
  p.elem[p.tope]:=x;
  end;

  procedure desapilar (var p:t_pila;var x:t_elem_pila);
  begin
   x:= p.elem[p.tope];
  p.tope:=p.tope-1;
   end;

  Procedure ApilarTodos(var Celda:t_puntero_produccion; var padre:t_arbol_derivacion; var pila: t_pila);
var
dir: t_punt;
i:byte;
elemento_pila:t_elem_pila;
A:t_simbolo_gramatical;
begin
for i:= celda^.cant downto 1 do
  begin
  elemento_pila.simb:=celda^.elem[i];
  elemento_pila.nodo:=padre^.Hijos[i];
  apilar(pila,elemento_pila);
  end;
end;

{ REVISAR EN U_ARBOL: function crear_nodo(clave: tsimgram; lexema:string):t_punt_arbol;
var x:t_punt_arbol;
begin
    new(x);
    x^.info.clave:=clave;
    x^.info.lexema:=lexema;
    x^.hijos.cantidad:=0;
    crear_nodo:=x;
end;

function agregar_hijo(var padre:t_punt_arbol; pos: byte; simbolo:tsimgram): t_punt_arbol;
begin
    padre^.hijos.contenido[pos]:=crear_nodo(simbolo, '');
    if padre^.hijos.cantidad < pos then padre^.hijos.cantidad:=pos;
    agregar_hijo:=padre^.hijos.contenido[pos];
end;
}

Procedure analizadorSintactico(var Fuente: t_archivo;var raiz:t_arbol_derivacion);
  var
    TS:t_lista;
    TAS:tipo_TAS;
    pila:t_pila;
    elemento_pila:t_elem_pila;
    estado:(enProceso,exito, errorSintactico);
    control:Longint;
    Lexema:string;
    A:t_simbolo_gramatical;
    i:byte;
    //
    w:char;
    //NodoActual:t_arbol_derivacion;
    hijo:t_arbol_derivacion;
    aux:t_simbolo_gramatical;
    archArbol:text;

  begin
    CargarPalabrasReservadas(TS,A);
    inicializar_TAS(TAS);
    cargar_TAS(TAS);
    Crear_nodo(raiz,vprograma);
    elemento_pila.simb:=pesos;
    elemento_pila.nodo:=nil;
    crearpila(pila);
    apilar(pila,elemento_pila);
    elemento_pila.simb:=vprograma;
    elemento_pila.nodo:=raiz;
    apilar(pila,elemento_pila);


    estado:=enProceso;
    Control:=0;
    ObtenerSiguienteCompLex(Fuente,Control,A,Lexema,TS);
    writeln(control:8,': ',A,' - ', lexema );

        while estado = enProceso do
        begin
         desapilar(pila,elemento_pila);
         If elemento_pila.simb=pesos then
           writeln('Se alcanzo pesos');
         //X es elemento_pila.simbolo
         writeln('Se desapilo ', elemento_pila.simb);
         //Si X es Terminal
           if elemento_pila.simb in [tid..telemento] then
            begin
            if  elemento_pila.simb=A then
              begin
               elemento_pila.nodo^.Lexema:=Lexema;
               ObtenerSiguienteCompLex(Fuente,Control,A,Lexema,TS);
               writeln(control:8,': ',A,' - ', lexema );
              end                                                              //controlar programa fuente la gramatica, ver error, verificar TAS
            else
              begin
                  estado:=errorSintactico;

                  writeln('Error Sintactico: se esperaba ',A, ' y se encontro ',elemento_pila.simb);
              end
            end
            else
         //Si X es Variable               <<<<<<<<<CONTROLAR>>>>>>>>>>>>
         if elemento_pila.simb in [vprograma..vlista_w2] then
            begin
            if TAS[elemento_pila.simb,A]= nil then
                begin
                estado:=errorSintactico;
                writeln('Error Sintactico: desde la variable ',elemento_pila.simb, ' no se puede llegar a ',A);
                end
            else
                begin
                   write('produccion: ',elemento_pila.simb,' --> ');
                  For i:=1 to TAS[elemento_pila.simb,A]^.cant do
                 begin
                     aux:=TAS[elemento_pila.simb,A]^.elem[i];
                     write(aux, ' ');
                     crear_nodo(hijo,aux);
                     agregar_hijo(elemento_pila.nodo,hijo);
                  end;
                  writeln();
                  readkey;
               ApilarTodos(TAS[elemento_pila.simb,A],elemento_pila.nodo, pila);     //lo llaman con una variable auxiliar,
                 end;                                                   //digamos "hijo" y con cada símbolo de
             end
            else

         //Si X=a=$, Éxito
           If (A=pesos) and (elemento_pila.simb=pesos) then
               estado:=exito;
            end;
       // Mostrar_arbol(raiz);
        //readkey;
     //   assign(archArbol,ruta2);
        //rewrite(archArbol);
       // guardarArbola(archArbol,raiz,0);
//        Close(archArbol);
        readkey;
    end;

{function agregar_hijo(var padre:t_arbol_derivacion; pos: byte; simbolo:t_simbolo_gramatical): t_arbol_derivacion;
begin
    padre^.hijos.contenido[pos]:=crear_nodo(simbolo, '');
    if padre^.hijos.cantidad < pos then padre^.hijos.cantidad:=pos;
    agregar_hijo:=padre^.hijos.contenido[pos];
end;
 }





end.
