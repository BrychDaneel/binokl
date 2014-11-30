unit cacher;

{$mode objfpc}{$H+}


interface

uses
  Classes, SysUtils,dateutils,IdHTTP,FileUtil;


function addfile(URL:string):string;
function updatefile(name:string):string;
function GetTypeFromURL(s:string):string;
function NameToURL(_name:string):String;
function URLToName(_URL:string):String;
procedure CorrectURL(var URL:string);

//procedure autoremove;
var currectchar:set of char;
    OflineMode:boolean;
    MaxCacheTime:TDateTime;
    MaxCacheSize:longint;
implementation
type FileListItem=record
     url:string;
     name:string;
     UseTime:TDateTime;
     CreateTime:TDateTime;
      end;

type  TFileList=class
     list:array of FileListItem;
     leng:dword;
     function add(_url:string;_datetime:TDateTime):string;
     procedure add(_url,_name:string;_createtime,_usetime:TDateTime); overload;
    // procedure remove(_url:string);
     constructor create;
     function GetFreeIndex(_URL:string):string;
end;

var filelist:TFileList;
    http:TIdHTTP;


constructor TFileList.create;
begin
leng:=0;
setlength(list,leng+1);
end;

function TFileList.GetFreeIndex(_URL:string):string;
begin
 GetFreeIndex:=inttostr(leng+1)+'.'+GetTypeFromURL(_URL);
end;

function TFileList.add(_url:string;_datetime:TDateTime):string;
var th:string;
begin
th:=GetFreeIndex(_URL);
inc(leng);
setlength(list,leng+1);
list[leng].url:=_url;
list[leng].name:=th;
add:=list[leng].name;
list[leng].UseTime:=Now;
list[leng].CreateTime:=_datetime;
end;

procedure TFileList.add(_url,_name:string;_createtime,_usetime:TDateTime); overload;
var th:DWord;
begin
inc(leng);
setlength(list,leng+1);
list[leng].url:=_url;
list[leng].name:=_name;
list[leng].CreateTime:=_createtime;
list[leng].UseTime:=_usetime;
end;

function GetDateTime(URL:string):TDateTime;
begin
GetDateTime:=0;
   try
   http.Head(URL);
   finally
   GetDateTime:=http.Response.LastModified;
   end;
end;



function NameToURL(_name:string):String;
var i:longint;
begin
for i:=1 to FileList.leng do
if  FileList.List[i].name=_name then begin NameToURL:=FileList.List[i].URL; exit; end;
NameToURL:='440:440'
end;

function URLToName(_URL:string):String;
var i:longint;
begin
for i:=1 to FileList.leng do
if  FileList.List[i].URL=_URL then begin URLToName:=FileList.List[i].name; exit; end;
URLToName:='440:440'
end;

function addfile(URL:string):string;
var
    s:string;
    stream:TFileStream;
begin
//If not IpFileDataProvider.CheckURL (URL) then begin addfile:='error:440'; exit; end;
s:=URLtoName(URL);
If s<>'440:440' then
begin
If OflineMode then exit(s);
updatefile(s);
addfile:=s;
exit;
end;

If copy(URL,1,7)='http://' then
begin
try
stream:=TFileStream.Create(filelist.GetFreeIndex(URL),fmCreate);
http.Get(URl,stream);
except
addfile:='error';
stream.Free;
Exit;
end;

addfile:=filelist.GetFreeIndex(URL);
filelist.add(URL,http.Response.LastModified);
stream.Free;
end;

If copy(URL,1,8)='file:///' then
begin
try
{$IFDEF UNIX}
 CopyFile(copy(URL,8,length(URL)-7),GetCurrentDir+'/'+filelist.GetFreeIndex(URL));
{$ELSE}
CopyFile(copy(URL,9,length(URL)-8),GetCurrentDir+'/'+filelist.GetFreeIndex(URL));
{$ENDIF}
except
 addfile:='error';
 exit;
end;
addfile:=filelist.GetFreeIndex(URL);
 filelist.add(URL,now);


end;

end;

function updatefile(name:string):string;
var i:longint;
url,s:String;
    stream:TFileStream;
begin
url:=UrlToName(name);
For i:=1 to FileList.leng do if FileList.List[i].name=name then
begin
FileList.List[i].UseTime:=now;
If copy(url,1,7)='http://' then If GetDateTime(url)=filelist.list[i].CreateTime then exit;
end;

If copy(url,1,7)='http://' then
begin
try
stream:=TFileStream.Create(name,fmCreate);
http.Get(URl,stream);
except
updatefile:='error';
exit;
end;
stream.Free;
updatefile:='OK';
end;


If copy(URL,1,8)='file:///' then
begin
try
 {$IFDEF UNIX}
  CopyFile(copy(URL,8,length(URL)-7),GetCurrentDir+'/'+name);
 {$ELSE}
 CopyFile(copy(URL,9,length(URL)-8),GetCurrentDir+'/'+name);
 {$ENDIF}
 CopyFile(copy(URL,8,length(URL)-8),name);
finally
updatefile:='OK';
end;
updatefile:='error';
end;

end;

function GetTypeFromURL(s:string):string;
var th:longint;
begin
th:=length(s);
GetTypeFromURL:='';
while th>2 do if s[th]<>'?' then dec(th);
IF s[th]<>'?' then th:=length(s) else th:=th-1;
while (th>=1)  and (s[th]<>'.') and (s[th]<>'/') and (s[th]<>'\') do
BEGIN
GetTypeFromURL:=s[th]+GetTypeFromURL;
dec(th);
END;
If (th=0) or (s[th]<>'.') then GetTypeFromURL:='unk';
end;

procedure CorrectURL(var URL:string);
begin
while not (URL[1] in currectchar) do delete(url,1,1);
while not (URL[length(URL)] in currectchar) do delete(url,length(URL),1);

{$IfDEF Unix}
If url[1]='/' then url:='file://'+url;
{$Else}
If url[2]=':' then url:='file:///'+url;
{$ENDIF}

IF copy(URL,1,8)='https://' then exit;
IF copy(URL,1,7)='http://' then exit;
IF copy(URL,1,6)='ftp://' then exit;
IF copy(URL,1,8)='file:///' then exit;

url:='http://'+url;
end;



var t:text;
    s,ss,sss,ssss:string;
    i:longint;
initialization

currectchar:=['a'..'z']+['A'..'Z']+['0'..'9']+['.',':','#','@','!','~','$','%','&','*','(',')','_','-','=','+','/','\'];
OflineMode:=false;

If not DirectoryExists('binoklcache') then ForceDirectories('binoklcache');
ChDir('binoklcache');
http:=TIdHTTP.create;
filelist:=TFileList.create;

if FileExists('cache') then
begin
assign(t,'cache');
reset(t);
while not seekeof(t) do
begin
readln(t,s);
If s='' then Continue;
while s[1]=' ' do delete(s,1,1);
{If pos('$',s)<2 THEN continue;
ss:=copy(s,1,pos('$',s)-1);
delete(s,1,pos('$',s)-1);
while ss[length(ss)]=' ' do delete(ss,length(ss),1);
while s[1]=' ' do delete(s,1,1);
while s[length(s)]=' ' do delete(s,length(s),1);      }
If pos(' $ ',s)<2 then continue;
ss:=copy(s,1,pos(' $ ',s)-1);
while ss[length(ss)]=' ' do delete(ss,length(ss),1);
delete(s,1,pos(' $ ',s)+2);
while s[1]=' ' do delete(s,1,1);

If pos(' $ ',s)<2 then continue;
sss:=copy(s,1,pos(' $ ',s)-1);
while sss[length(sss)]=' ' do delete(sss,length(sss),1);
delete(s,1,pos(' $ ',s)+2);
while s[1]=' ' do delete(s,1,1);

If pos(' $ ',s)<2 then continue;
ssss:=copy(s,1,pos(' $ ',s)-1);
while ssss[length(ssss)]=' ' do delete(ssss,length(ssss),1);
delete(s,1,pos(' $ ',s)+2);
while s[1]=' ' do delete(s,1,1);


while s[length(s)]=' ' do
begin
If s=' ' then Continue;
delete(s,length(s),1);
end;

filelist.add(sss,ss,StrToFloat(ssss),StrToFloat(s));
end;
close(t);
end;

finalization
assign(t,'cache');
rewrite(t);
for i:=1 to filelist.leng do writeln(t,filelist.list[i].name,' $ ',filelist.list[i].url,' $ ',filelist.list[i].CreateTime,' $ ',filelist.list[i].UseTime);
close(t);


end.

