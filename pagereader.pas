unit pagereader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  Tout = record
    CreatorMM: TStringList;
    SkriptorMM: TStringList;
  end;

function DecodePage(filename: string): Tout;

implementation

type Tteg=class(TStringList)
  public pre,post,opentegallow:array of TStringList;
  parcom:array of array of TStringList;
  needlevl:array of longint;
  postlevl:array of longint;
  open,clos:array of boolean;
  paraforclos:array of string;
  par:array of TStringList;
  typpar:array of array of longint;
  end;


var  teggi:Tteg;

const
  del: set of char = [ '=', '<', '>', '"', ' '];

var
  ouut: Tout;

procedure NewDecodeOpenteg(s: string);
var n,i:longint;
  ss:string;
begin
delete(s,1,pos('$',s));
n:=strtoint(copy(s,1,pos('$',s)-1));
delete(s,1,pos('$',s));

for i:=1 to n do
begin
  ss:='';
  delete(s,1,1);
  while s[1]<>'"' do
  begin
    ss:=ss+s[1];
    delete(s,1,1);
  end;
  delete(s,1,1);
  ouut.CreatorMM.Add(ss);
end;

end;


function CheckTeg(s, teg: string): boolean;
begin
  CheckTeg := False;
  if (length(s) = length(teg)) then
    if (copy(s, 1, length(teg)) = teg) then
      CheckTeg := True;
  if length(s) > length(teg) then
    if (copy(s, 1, length(teg)) = teg) and (s[length(teg) + 1] in del) then
      CheckTeg := True;
end;

function CheckAllTeg(s: string;var index:integer): boolean;
var q,i:integer;
  teg:string;
begin
CheckAllTeg := False;

for i:=1 to teggi.Count do
begin
teg:=teggi[i-1];
if (length(s) = length(teg)) then
  if (copy(s, 1, length(teg)) = teg) then
  begin
    CheckAllTeg := True;
    index:=i-1;
  end;
if length(s) > length(teg) then
  if (copy(s, 1, length(teg)) = teg) and (s[length(teg) + 1] in del) then
  begin
    CheckAllTeg := True;
    index:=i-1;
  end;
end;

end;

function CheckAllParam(s: string;tegId:longint;var index:integer): boolean;
var q,i:integer;
  teg:string;
begin
CheckAllParam := False;

for i:=1 to teggi.par[tegId].Count do
begin
teg:=teggi.par[tegId][i-1];
if (length(s) = length(teg)) then
  if (copy(s, 1, length(teg)) = teg) then
  begin
    CheckAllParam  := True;
    index:=i-1;
  end;
if length(s) > length(teg) then
  if (copy(s, 1, length(teg)) = teg) and (s[length(teg) + 1] in del) then
  begin
    CheckAllParam  := True;
    index:=i-1;
  end;
end;

end;

function DecodePage(filename: string): Tout;
var
  i, ii, iii,iv: longint;
  Text: TStringList;
  sost, sp: longint;
  s: string;
  teg, param: string;
  pr, vl: TStringList;
  q: real;
  qq,qqq: longint;
  openTeg: TStringList;
begin
  ouut.CreatorMM := TStringList.Create;
  ouut.SkriptorMM := TStringList.Create;
  pr := TStringList.Create;
  vl := TStringList.Create;
  Text := TStringList.Create;
  openTeg := TStringList.Create;

  Text.LoadFromFile(filename);
 //  text.SaveToFile('pagereaderIN.txt');
  i := 1;
  while i <= Text.Count do
  begin
    if (Text[i - 1] = '') or (Text[i - 1] = ' ') then
    begin
      Text.Delete(i - 1);
      Continue;
    end;
    ii := 1;

    while ii + 1 <= length(Text[i - 1]) do
    begin
      if (Text[i - 1][ii] = ' ') and (Text[i - 1][ii + 1] in del) then
      begin
        s := Text[i - 1];
        Delete(s, ii, 1);
        Text[i - 1] := s;
      end
      else
        Inc(ii);
    end;
    if (Text[i - 1] = '') or (Text[i - 1] = ' ') then
    begin
      Text.Delete(i - 1);
      Continue;
    end;
    Inc(I);
  end;

  i := 1;
  while i <= Text.Count do
  begin
    if (Text[i - 1] = '') or (Text[i - 1] = ' ') then
    begin
      Text.Delete(i);
      Continue;
    end;
    ii := 2;
    while ii <= length(Text[i - 1]) do
    begin
      if (Text[i - 1][ii] = ' ') and (Text[i - 1][ii - 1] in del) then
      begin
        s := Text[i - 1];
        Delete(s, ii, 1);
        Text[i - 1] := s;
      end
      else
        Inc(ii);
    end;
    if (Text[i - 1] = '') or (Text[i - 1] = ' ') then
      Text.Delete(i - 1);
    Inc(I);
  end;
//  text.SaveToFile('pagereaderOUT.txt');
  sost := 0;
  i := 1;
  ii:=0;
  sost := 0;
  sp := 0;

  while (sost >= 0) do
  begin
    Inc(ii);
    if ii > length(Text[i - 1]) then
      if i < Text.Count then
      begin
        Inc(i);
        ii := 1;
      end
      else
        break;
    if (sost < 2) and (Text[i - 1][ii] = '<') and (ii < length(Text[i - 1])) then
    begin
      s := copy(Text[i - 1], ii + 1, length(Text[i - 1]) - ii);
      s := LowerCase(s);

      IF CheckAllTeg(s,qq) then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := teggi[qq];
        ii := ii + length(teggi[qq]);
      end;


    end
    else

    if (sost = 2) and (not (Text[i - 1][ii] in del)) then
    begin
      s := '';
      while (not (Text[i - 1][ii] in del)) and (ii < length(Text[i - 1])) do
      begin
        s := s + Text[i - 1][ii];
        Inc(ii);
      end;
      s := LowerCase(s);
      if Text[i - 1][ii] <> '=' then
        Dec(ii)
      else
      begin
        if CheckAllTeg(teg,qq) then
        If CheckAllParam(s,qq,qqq) and (sost<>3) then
        begin
        param:=s;
        sost:=3;
        end;

      end;
    end
    else


    if (sost = 3) and (Text[i - 1][ii] = '"') then
    begin
      s := '';
      Inc(ii);
      if ii > length(Text[i - 1]) then
      begin
        Inc(i);
        ii := 1;
      end;
      if i > Text.Count then
        Continue;

      while (Text[i - 1][ii] <> '"') do
      begin
        while (Text[i - 1][ii] <> '"') and (ii < length(Text[i - 1])) do
        begin
          s := s + Text[i - 1][ii];
          Inc(ii);
        end;
        if (i < Text.Count) and (Text[i - 1][ii] <> '"') then
        begin
          s := s + #10;
          Inc(i);
          ii := 1;
        end
        else
          break;
      end;

      if Text[i - 1][ii] = '"' then
      begin
        pr.Add(param);
        vl.Add(s);
      end;
      sost := 2;
    end
    else



    if (sost = 3) and (not (Text[i - 1][ii] in del)) then
    begin
      s := '';
      while (not (Text[i - 1][ii] in del)) and (ii < length(Text[i - 1])) do
      begin
        s := s + Text[i - 1][ii];
        Inc(ii);
      end;

      pr.Add(param);
      vl.Add(s);
      sost := 2;
      Dec(ii);

    end
    else

    if (sost >= 2) and (Text[i - 1][ii] = '>') then
    begin
      if (CheckAllTeg(teg,qq)) then
      begin
        sost := 1;
        if (sp = teggi.needlevl[qq]) and (not teggi.open[qq]) and (not teggi.clos[qq]) then
          begin
          For iii:=1 to teggi.pre[qq].Count do ouut.CreatorMM.Add(teggi.pre[qq][iii-1]);

          for iii := openTeg.Count downto 1 do
                     if teggi.opentegallow[qq].Find(copy(openTeg[iii - 1],1,pos('$',openTeg[iii - 1])-1),qqq) then
                       NewDecodeOpenteg(openTeg[iii - 1]);

                   for iii := 1 to pr.Count do
                   begin
                     If CheckAllParam(pr[iii - 1],qq,qqq) then
                       begin
                       if teggi.typpar[qq][qqq]=2 then
                       try
                         q := StrToFloat(vl[iii - 1]);
                       finally
                         For iv:=1 to teggi.parcom[qq][qqq].Count do
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then ouut.CreatorMM.Add(teggi.parcom[qq][qqq][iv-1]) else
                         ouut.CreatorMM.Add(teggi.parcom[qq][qqq][iv-1] + vl[iii - 1]);
                       end;
                    if teggi.typpar[qq][qqq]=3 then
                   For iv:=1 to teggi.parcom[qq][qqq].Count do
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then ouut.CreatorMM.Add(teggi.parcom[qq][qqq][iv-1]) else  ouut.CreatorMM.Add(copy(teggi.parcom[qq][qqq][iv-1],1,length(teggi.parcom[qq][qqq][iv-1])-1)+'*'+teggi.parcom[qq][qqq][iv-1][length(teggi.parcom[qq][qqq][iv-1])]+vl[iii-1]);  //параметр может значить несколько мнемокодов
                        end;
                    end;


                 For iii:=1 to teggi.post[qq].Count do ouut.CreatorMM.Add(teggi.post[qq][iii-1]);

                 sp:=teggi.postlevl[qq];
                 end;



        if (sp = teggi.needlevl[qq]) and (teggi.open[qq]) then
        begin
          s:=teggi[qq]+'$'+inttostr(pr.Count)+'$';
          for iii:=1 to pr.Count do
          If teggi.par[qq].Find(pr[iii-1],qqq) then
          begin
                if teggi.typpar[qq][qqq]=2 then
                       try
                         q := StrToFloat(vl[iii - 1]);
                       finally
                         For iv:=1 to teggi.parcom[qq][qqq].Count do
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then s:=s+'"'+teggi.parcom[qq][qqq][iv-1]+'"' else s:=s+'"'+teggi.parcom[qq][qqq][iv-1]+vl[iii-1]+'"'  //параметр может значить несколько мнемокодов
                       end;
                if teggi.typpar[qq][qqq]=3 then
                       For iv:=1 to teggi.parcom[qq][qqq].Count do
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then s:=s+'"'+teggi.parcom[qq][qqq][iv-1]+'"' else s:=s+'"'+copy(teggi.parcom[qq][qqq][iv-1],1,length(teggi.parcom[qq][qqq][iv-1])-1)+'*'+teggi.parcom[qq][qqq][iv-1][length(teggi.parcom[qq][qqq][iv-1])]+vl[iii-1]+'"'  //параметр может значить несколько мнемокодов

          end;
        openTeg.Add(s);
        sp:=teggi.postlevl[qq];
        end;

        If (sp = teggi.needlevl[qq]) and (teggi.clos[qq]) then
        begin
        For iii:=openTeg.Count downto 1 do
             if copy(openTeg[iii - 1],1,pos('$',openTeg[iii - 1])-1)=teggi[qq] then begin openTeg.Delete(qq); Break; end;
        sp:=teggi.postlevl[qq];
        end;
      end;

    end;

  end;

  DecodePage := ouut;

  pr.Free;
  vl.Free;
  Text.Free;
  openTeg.Free;
end;

var t:text;
  i,ii,iii,n,nn,nnn,q:longint;
  s:string;
initialization
teggi:=Tteg.Create;

Assign(t,ExtractFilePath(ParamStr(0))+'teggi.conf');
reset(t);
readln(t,n);
for i:=1 to n do
begin
  readln(t,s);
  teggi.Add(lowercase(s));  //тег

  setlength(teggi.open,teggi.Count);
  setlength(teggi.clos,teggi.Count);
  setlength(teggi.pre,teggi.Count);
  teggi.pre[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.post,teggi.Count);
  teggi.post[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.opentegallow,teggi.Count);
  teggi.opentegallow[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.needlevl,teggi.Count);
  setlength(teggi.postlevl,teggi.Count);
  setlength(teggi.parcom,teggi.Count);
  setlength(teggi.par,teggi.Count);
  teggi.par[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.typpar,teggi.Count);
  setlength(teggi.paraforclos,teggi.Count);

  readln(t,q);
  teggi.open[teggi.Count-1]:=q=1;  //открывающийся
  readln(t,q);
  teggi.clos[teggi.Count-1]:=q=1;  //закрывающийся
  if q=1 then
  begin
  readln(t,s);
  teggi.paraforclos[teggi.Count-1]:=s;  //ПАРА для закр
  end;
  readln(t,q);
  teggi.needlevl[teggi.Count-1]:=q; //пространство   space=1 world=2

  readln(t,q);
  teggi.postlevl[teggi.Count-1]:=q; //Постпространство   space=1 world=2

  readln(t,nn);          //PRE
  for ii:=1 to nn do
  begin
  readln(t,s);
  teggi.pre[teggi.Count-1].Add(s);
  end;

  readln(t,nn);           //POST
  for ii:=1 to nn do
  begin
  readln(t,s);
  teggi.post[teggi.Count-1].Add(s);
  end;

  readln(t,nn);     // OpenTagAllow
  for ii:=1 to nn do
  begin
  readln(t,s);
  teggi.opentegallow[teggi.Count-1].Add(s);
  end;

  readln(t,nn);      //параметр
  for ii:=1 to nn  do
  begin
  readln(t,s);
  teggi.par[teggi.Count-1].Add(s); //параметр

setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;

readln(t,q);  //тип 2=real  3=файл
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=q;

readln(t,nnn);     //команды       $=применить параметр
for iii:=1 to nnn do
begin
readln(t,s);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add(s);
end;

end;
end;
close(t);

end.
