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

procedure decodeOpenteg(s: string);
var
  iii: longint;
  ss, sss: string;
  q:real;
begin
  if pos('TEXTURE', s) <> 0 then
  begin
    if pos('$', s) <> 0 then
      Delete(s, 1, pos('$', s) - 1);
    while s[1] = '$' do
    begin
      Delete(s, 1, 1);
      ss := copy(s, 1, pos('=', s) - 1);
      Delete(s, 1, pos('=', s));
      if pos('$', s) <> 0 then
      begin
        sss := copy(s, 1, pos('$', s) - 1);
        Delete(s, 1, pos('$', s) - 1);
      end
      else
        sss := s;

      if ss = 'src' then
        ouut.CreatorMM.Add('TEXTURE$' + sss);
    end;

  end else

if pos('ROTATION', s) <> 0 then
  begin
    if pos('$', s) <> 0 then
      Delete(s, 1, pos('$', s) - 1);
    while s[1] = '$' do
    begin
      Delete(s, 1, 1);
      ss := copy(s, 1, pos('=', s) - 1);
      Delete(s, 1, pos('=', s));
      if pos('$', s) <> 0 then
      begin
        sss := copy(s, 1, pos('$', s) - 1);
        Delete(s, 1, pos('$', s) - 1);
      end
      else
        sss := s;

      if ss = 'x' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('ROTX$' + sss);
      end;

      if ss = 'y' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('ROTY$' + sss);
      end;

      if ss = 'z' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('ROTZ$' + sss);
      end;
    end;

  end else


if pos('SCALE', s) <> 0 then
  begin
    if pos('$', s) <> 0 then
      Delete(s, 1, pos('$', s) - 1);
    while s[1] = '$' do
    begin
      Delete(s, 1, 1);
      ss := copy(s, 1, pos('=', s) - 1);
      Delete(s, 1, pos('=', s));
      if pos('$', s) <> 0 then
      begin
        sss := copy(s, 1, pos('$', s) - 1);
        Delete(s, 1, pos('$', s) - 1);
      end
      else
        sss := s;

      if ss = 'x' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SCLX$' + sss);
      end;

      if ss = 'y' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SCLY$' + sss);
      end;

      if ss = 'z' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SCLZ$' + sss);
      end;
    end;

  end else


if pos('POSITION', s) <> 0 then
  begin
    if pos('$', s) <> 0 then
      Delete(s, 1, pos('$', s) - 1);
    while s[1] = '$' do
    begin
      Delete(s, 1, 1);
      ss := copy(s, 1, pos('=', s) - 1);
      Delete(s, 1, pos('=', s));
      if pos('$', s) <> 0 then
      begin
        sss := copy(s, 1, pos('$', s) - 1);
        Delete(s, 1, pos('$', s) - 1);
      end
      else
        sss := s;

      if ss = 'x' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SETX$' + sss);
      end;

      if ss = 'y' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SETY$' + sss);
      end;

      if ss = 'z' then
      try
        q:=StrToFloat(sss);
      finally
              ouut.CreatorMM.Add('SETZ$' + sss);
      end;
    end;

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
//  text.SaveToFile('asd.txt');
  sost := 0;
  i := 1;
  ii:=0;
  sost := 0;
  sp := -1;

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

      if CheckTeg(s, '/space') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/space';
        ii := ii + length('/space');
      end
      else
       if CheckTeg(s, 'space') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'space';
        ii := ii + length('space');
      end
      else
      if CheckTeg(s, 'world') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'world';
        ii := ii + length('world');
      end
      else
      if CheckTeg(s, '/world') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/world';
        ii := ii + length('/world');
      end
      else
      if CheckTeg(s, 'model') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'model';
        ii := ii + length('model');
      end
      else
      if CheckTeg(s, 'light') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'light';
        ii := ii + length('light');
      end
      else
      if CheckTeg(s, 'texture') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'texture';
        ii := ii + length('texture');
      end
      else
      if CheckTeg(s, 'position') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'position';
        ii := ii + length('position');
      end
      else
      if CheckTeg(s, 'scale') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'scale';
        ii := ii + length('scale');
      end
      else
      if CheckTeg(s, 'rotation') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := 'rotation';
        ii := ii + length('rotation');
      end
      else
            if CheckTeg(s, '/position') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/position';
        ii := ii + length('/position');
      end
      else
      if CheckTeg(s, '/scale') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/scale';
        ii := ii + length('/scale');
      end
      else
      if CheckTeg(s, '/rotation') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/rotation';
        ii := ii + length('/rotation');
      end
      else
      if CheckTeg(s, '/texture') then
      begin
        sost := 2;
        pr.Clear;
        vl.Clear;
        teg := '/texture';
        ii := ii + length('/texture');
      end else
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
        if ((teg = 'model') or (teg = 'texture')) and (s = 'src') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'light') or (teg='model')) and (s = 'posy') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'light') or (teg='model')) and (s = 'posx') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'light') or (teg='model')) and (s = 'posz') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'light')) and (s = 'power') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'position') or (teg='rotation') or (teg='scale')) and (s = 'x') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'position') or (teg='rotation') or (teg='scale')) and (s = 'y') then
           begin
           param := s;
           sost := 3;
           end;
        if ((teg = 'position') or (teg='rotation') or (teg='scale')) and (s = 'z') then
           begin
           param := s;
           sost := 3;
           end;

        if teggi.Find(teg,qq) then
        If teggi.par[qq].Find(s,qqq) and (sost<>3) then
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
      if teg = '/space' then
        sost := -1;
      if teg = 'space' then
         begin
        sost := 0;
        sp:=0;
         end;

      if (teg = 'world') then
        if (sp = 0) then
        begin
          sp := 2;
          sost := 1;
        end
        else
          sost := 1;

      if (teg = '/world') then
        if (sp = 2) then
        begin
          sp := 0;
          sost := 1;
        end
        else
          sost := 1;

      if (teg = 'model') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          ouut.CreatorMM.Add('ADDMODEL');
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'src' then
              ouut.CreatorMM.Add('LOADMODEL$' + vl[iii - 1]);

            if pr[iii - 1] = 'posy' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETY$' + vl[iii - 1]);
              end;
            if pr[iii - 1] = 'posz' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETZ$' + vl[iii - 1]);
              end;
            if pr[iii - 1] = 'posx' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETX$' + vl[iii - 1]);
              end;

          end;

          for iii := openTeg.Count downto 1 do
          begin
            if pos('TEXTURE', openTeg[iii - 1]) <> 0 then
              decodeOpenteg(openTeg[iii - 1]);
            if pos('POSITION', openTeg[iii - 1]) <> 0 then
              decodeOpenteg(openTeg[iii - 1]);
            if pos('ROTATION', openTeg[iii - 1]) <> 0 then
              decodeOpenteg(openTeg[iii - 1]);
            if pos('SCALE', openTeg[iii - 1]) <> 0 then
              decodeOpenteg(openTeg[iii - 1]);
          end;

          ouut.CreatorMM.Add('UP');
        end;
      end;

      if (teg = 'light') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          ouut.CreatorMM.Add('ADDLIGHT');
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'posy' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETY$' + vl[iii - 1]);
              end;
            if pr[iii - 1] = 'posz' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETZ$' + vl[iii - 1]);
              end;
            if pr[iii - 1] = 'posx' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETX$' + vl[iii - 1]);
              end;
            if pr[iii - 1] = 'power' then
              try
                q := StrToFloat(vl[iii - 1]);
              finally
                ouut.CreatorMM.Add('SETPOWER$' + vl[iii - 1]);
              end;
          end;

          for iii := openTeg.Count downto 1 do
          begin
            if pos('POSITION', openTeg[iii - 1]) <> 0 then
              decodeOpenteg(openTeg[iii - 1]);
          end;
          ouut.CreatorMM.Add('UP');
        end;
      end;


      if (teg = 'texture') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          s := 'TEXTURE';
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'src' then
              s := s + '$' + 'src=' + vl[iii - 1];
          end;
          openTeg.Add(s);
        end;

      end;

      if (teg = 'position') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          s := 'POSITION';
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'x' then
              s := s + '$' + 'x=' + vl[iii - 1];
            if pr[iii - 1] = 'y' then
              s := s + '$' + 'y=' + vl[iii - 1];
            if pr[iii - 1] = 'z' then
              s := s + '$' + 'z=' + vl[iii - 1];
          end;
          openTeg.Add(s);
        end;
      end;

    if (teg = 'rotation') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          s := 'ROTATION';
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'x' then
              s := s + '$' + 'x=' + vl[iii - 1];
            if pr[iii - 1] = 'y' then
              s := s + '$' + 'y=' + vl[iii - 1];
            if pr[iii - 1] = 'z' then
              s := s + '$' + 'z=' + vl[iii - 1];
          end;
          openTeg.Add(s);
        end;
      end;

      if (teg = 'scale') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          s := 'SCALE';
          for iii := 1 to pr.Count do
          begin
            if pr[iii - 1] = 'x' then
              s := s + '$' + 'x=' + vl[iii - 1];
            if pr[iii - 1] = 'y' then
              s := s + '$' + 'y=' + vl[iii - 1];
            if pr[iii - 1] = 'z' then
              s := s + '$' + 'z=' + vl[iii - 1];
          end;
          openTeg.Add(s);
        end;
      end;

      if (teg = '/texture') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          iii := openTeg.Count - 1;
          while (iii >= 0) and (pos('TEXTURE', openTeg[iii]) = 0) do
            Dec(iii);
          if (pos('TEXTURE', openTeg[iii]) <> 0) then
            openTeg.Delete(iii);
        end;
      end;

      if (teg = '/rotation') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          iii := openTeg.Count - 1;
          while (iii > 0) and (pos('ROTATION', openTeg[iii]) = 0) do
            Dec(iii);
          if (pos('ROTATION', openTeg[iii]) <> 0) then
            openTeg.Delete(iii);
        end;
      end;

    if (teg = '/scale') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          iii := openTeg.Count - 1;
          while (iii > 0) and (pos('SCALE', openTeg[iii]) = 0) do
            Dec(iii);
          if (pos('SCALE', openTeg[iii]) <> 0) then
            openTeg.Delete(iii);
        end;
      end;

    if (teg = '/position') then
      begin
        sost := 1;
        if (sp = 2) then
        begin
          iii := openTeg.Count - 1;
          while (iii > 0) and (pos('POSITION', openTeg[iii]) = 0) do
            Dec(iii);
          if (pos('POSITION', openTeg[iii]) <> 0) then
            openTeg.Delete(iii);
        end;
      end;



    if (teggi.Find(teg,qq)) then
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
                     If teggi.par[qq].Find(pr[iii - 1],qqq) then
                       if teggi.typpar[qq][qqq]=2 then
                       try
                         q := StrToFloat(vl[iii - 1]);
                       finally
                         For iv:=1 to teggi.parcom[qq][qqq].Count do
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then ouut.CreatorMM.Add(teggi.parcom[qq][qqq][iv-1]) else
                         ouut.CreatorMM.Add(teggi.parcom[qq][qqq][iv-1] + vl[iii - 1]);
                       end;
                   end;


                 For iii:=1 to teggi.post[qq].Count do ouut.CreatorMM.Add(teggi.post[qq][iii-1]);
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
                          If pos('$',teggi.parcom[qq][qqq][iv-1])=0 then s:=s+'"'+teggi.parcom[qq][qqq][iv-1]+'"' else s:=s+'"'+teggi.parcom[qq][qqq][iv-1]+vl[iii-1]+'"'
                       end;
          end;
        openTeg.Add(s);
        end;

        If (sp = teggi.needlevl[qq]) and (teggi.clos[qq]) then
        begin
        For iii:=openTeg.Count downto 1 do
             if copy(openTeg[iii - 1],1,pos('$',openTeg[iii - 1])-1)=teggi[qq] then begin openTeg.Delete(qq); Break; end;
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

teggi.Add('box');  //тег
setlength(teggi.open,teggi.Count);
setlength(teggi.clos,teggi.Count);
setlength(teggi.pre,teggi.Count);
teggi.pre[teggi.Count-1]:=TStringList.Create;
setlength(teggi.post,teggi.Count);
teggi.post[teggi.Count-1]:=TStringList.Create;
setlength(teggi.opentegallow,teggi.Count);
teggi.opentegallow[teggi.Count-1]:=TStringList.Create;
setlength(teggi.needlevl,teggi.Count);
teggi.open[teggi.Count-1]:=false;  //открывающийся
teggi.clos[teggi.Count-1]:=false;  //закрывающийся
teggi.needlevl[teggi.Count-1]:=2; //пространство
teggi.pre[teggi.Count-1].Add('ADDBOX');   //До параметров
teggi.post[teggi.Count-1].Add('UP');      //После параметров
teggi.opentegallow[teggi.Count-1].Add('rotating');
setlength(teggi.parcom,teggi.Count);
setlength(teggi.par,teggi.Count);
teggi.par[teggi.Count-1]:=TStringList.Create;
setlength(teggi.typpar,teggi.Count);


teggi.par[teggi.Count-1].Add('width'); //параметр
setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=2;
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add('SETW$');






teggi.Add('rotate');  //тег
setlength(teggi.open,teggi.Count);
setlength(teggi.clos,teggi.Count);
setlength(teggi.pre,teggi.Count);
teggi.pre[teggi.Count-1]:=TStringList.Create;
setlength(teggi.post,teggi.Count);
teggi.post[teggi.Count-1]:=TStringList.Create;
setlength(teggi.opentegallow,teggi.Count);
teggi.opentegallow[teggi.Count-1]:=TStringList.Create;
setlength(teggi.needlevl,teggi.Count);
teggi.open[teggi.Count-1]:=true;  //открывающийся
teggi.clos[teggi.Count-1]:=false;  //закрывающийся
teggi.needlevl[teggi.Count-1]:=2; //пространство
setlength(teggi.parcom,teggi.Count);
setlength(teggi.par,teggi.Count);
teggi.par[teggi.Count-1]:=TStringList.Create;
setlength(teggi.typpar,teggi.Count);


teggi.par[teggi.Count-1].Add('x'); //параметр
setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=2;
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add('ROTATEX$');

teggi.par[teggi.Count-1].Add('y'); //параметр
setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=2;
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add('ROTATEY$');

teggi.par[teggi.Count-1].Add('z'); //параметр
setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=2;
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add('ROTATEZ$');

teggi.Add('/rotate');  //тег
setlength(teggi.open,teggi.Count);
setlength(teggi.clos,teggi.Count);
setlength(teggi.pre,teggi.Count);
teggi.pre[teggi.Count-1]:=TStringList.Create;
setlength(teggi.post,teggi.Count);
teggi.post[teggi.Count-1]:=TStringList.Create;
setlength(teggi.opentegallow,teggi.Count);
teggi.opentegallow[teggi.Count-1]:=TStringList.Create;
setlength(teggi.needlevl,teggi.Count);
teggi.open[teggi.Count-1]:=false;  //открывающийся
teggi.clos[teggi.Count-1]:=true;  //закрывающийся
teggi.needlevl[teggi.Count-1]:=2; //пространство
setlength(teggi.parcom,teggi.Count);
setlength(teggi.par,teggi.Count);
teggi.par[teggi.Count-1]:=TStringList.Create;
setlength(teggi.typpar,teggi.Count);
setlength(teggi.paraforclos,teggi.Count);
teggi.paraforclos[teggi.Count-1]:='ratate';


Assign(t,ExtractFilePath(ParamStr(0))+'teggi.conf');
reset(t);
readln(t,n);
for i:=1 to n do
begin
  readln(t,s);
  teggi.Add(s);  //тег

  setlength(teggi.open,teggi.Count);
  setlength(teggi.clos,teggi.Count);
  setlength(teggi.pre,teggi.Count);
  teggi.pre[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.post,teggi.Count);
  teggi.post[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.opentegallow,teggi.Count);
  teggi.opentegallow[teggi.Count-1]:=TStringList.Create;
  setlength(teggi.needlevl,teggi.Count);
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
  teggi.needlevl[teggi.Count-1]:=q; //пространство

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

  readln(t,nn);     // OpenTAG
  for ii:=1 to nn do
  begin
  readln(t,s);
  teggi.opentegallow[teggi.Count-1].Add(s);
  end;

  readln(t,nn);      //теги
  for ii:=1 to nn  do
  begin
  readln(t,s);
  teggi.par[teggi.Count-1].Add(s); //параметр

setlength(teggi.typpar[teggi.Count-1],teggi.par[teggi.Count-1].Count);
setlength(teggi.parcom[teggi.Count-1],teggi.par[teggi.Count-1].Count);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=TStringList.Create;

readln(t,q);  //тип 2=real
teggi.typpar[teggi.Count-1][teggi.par[teggi.Count-1].Count-1]:=q;

readln(t,nnn);     //команды
for iii:=1 to nnn do
begin
readln(t,s);
teggi.parcom[teggi.Count-1][teggi.par[teggi.Count-1].Count-1].Add(s);
end;

end;
end;
close(t);

end.
