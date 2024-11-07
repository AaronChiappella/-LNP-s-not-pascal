unit u_archivos;


interface
uses
  Crt, SysUtils;
const
ruta='C:\Users\Aaron\Desktop\Facultad\arch1.txt';
ruta2='C:\Users\Aaron\Desktop\Facultad\arch2.txt';

type
t_archivo=file of char;
procedure recuperar_arch(var pos:integer;var caracter:char);
procedure abrir_arch(var arch:t_archivo);
PROCEDURE CREAR_arch(VAR ARCH:t_archivo);
procedure donde_error(var archivo:t_archivo;pos:integer);
implementation
PROCEDURE CREAR_arch(VAR ARCH:t_archivo);
BEGIN
ASSIGN(ARCH,RUTA);
REWRITE(ARCH);
END;
procedure recuperar_arch(var pos:integer;var caracter:char);
   var
     arch:t_archivo;
   begin
     abrir_arch(arch);                {abre el archivo, si no es el final}
     if pos<filesize(arch) then       {lee el caracter y lo asigna en caracter de la posicion}
       begin                          {sino, asigna #0 que es $}
         seek(arch,pos);
         read(arch,caracter);
       end
     else
      begin
        caracter:=#0
      end;
     close(arch);
   end;
procedure abrir_arch(var arch:t_archivo);
     begin
       AssignFile(arch,ruta);            {revisa si esta creado si no lo esta entonces lo crea}
      if not(FileExists(ruta)) then
      begin
               seek(arch,1);
          CloseFile(arch);
       end;
       reset(arch);       {abre el archivo en la posicion del controlador}
     end;
procedure donde_error(var fuente:t_archivo;pos:integer);
  var
    i:integer;
    x:char;
     begin
     i:=1;
     while i<=pos do
     begin
     seek(fuente,i);
     read(fuente,x);
     write(x);
     i:=i+1;
     end;
     readkey;
end;
end.
