unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, ActnList, Menus,LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    CheckBox1: TCheckBox;
    CheckGroup1: TCheckGroup;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckGroup1ChangeBounds(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1ChangeBounds(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: char);
    procedure ComboBox1Select(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure TreeView1Editing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeView1KeyPress(Sender: TObject; var Key: char);
    procedure TreeView1SelectionChanged(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


type
  par=record
  typ:longint;
  comand:TStringList;
  name:string;
  end;

  Tteg=record
  name:string;
  open,close: boolean;
  space,postspace: longint;
  opentagallow:TStringList;
  npar:longint;
  pars:array [1..100] of par;
  post,pre:TStringList;
end;

var tegs:array [0..100] of Tteg;
  qtegs: Tteg;
  nteg:longint=-1;
  sot:array [0..100] of TTreeNode;
  prs:longint=-1;
  prss:longint=-1;
  prestr:array [0..100] of string;
  comboboxsel:longint;
  maxlvl:longint=0;

procedure TForm1.Button1Click(Sender: TObject);
   var it:TTreeNode;
begin
it:=TreeView1.Items.AddChild(TreeView1.Selected,'<neteg>');
inc(nteg);
tegs[nteg].name:='newteg';
tegs[nteg].pre:=TStringList.Create;
tegs[nteg].pre.Add('ADDBOX');
tegs[nteg].post:=TStringList.Create;
tegs[nteg].post.Add('UP');
tegs[nteg].opentagallow:=TStringList.Create;
tegs[nteg].npar:=0;
if TreeView1.Selected<>nil then
begin
 If tegs[TreeView1.Selected.AbsoluteIndex].space=tegs[TreeView1.Selected.AbsoluteIndex].postspace then
 begin
  inc(maxlvl);
  tegs[TreeView1.Selected.AbsoluteIndex].postspace:=maxlvl;
 end;
 tegs[nteg].space:=tegs[TreeView1.Selected.AbsoluteIndex].postspace;
 tegs[nteg].postspace:=tegs[nteg].space;
end;
{tegs[nteg].pars[1].typ:=1;
tegs[nteg].pars[1].name:='newparametr';
tegs[nteg].pars[1].comand.Add(''); }
ComboBox1.Enabled:=false;

end;

procedure TForm1.Button2Click(Sender: TObject);
//var index:
begin
If  Memo2.Enabled=false then begin Memo2.Lines.Clear; Memo2.Lines.Add('VALUE$');ComboBox1.Text:='prm';  end;
ComboBox1.Enabled:=true;
ComboBox2.Enabled:=true;
Memo2.Enabled:=true;
 ComboBox1.Items.Add('prm');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('VALUE$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;


end;

procedure TForm1.Button4Click(Sender: TObject);
var i:longint;
begin
for i:=comboboxsel+1 to  tegs[TreeView1.Selected.AbsoluteIndex].npar-1 do
tegs[TreeView1.Selected.AbsoluteIndex].pars[i]:=tegs[TreeView1.Selected.AbsoluteIndex].pars[i+1];

//tegs[TreeView1.Selected.AbsoluteIndex].pars[tegs[TreeView1.Selected.AbsoluteIndex].npar].comand.Free;
tegs[TreeView1.Selected.AbsoluteIndex].npar-=1;

ComboBox1.Items.Delete(comboboxsel);
If ComboBox1.Items.Count=0 then begin Memo2.Enabled:=false; ComboBox2.Enabled:=false; ComboBox1.Enabled:=false; exit end;
ComboBox1.Text:=ComboBox1.Items[comboboxsel];
Memo2.Lines.Clear;
for i:=1 to tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].comand.Count do  Memo2.Lines.Add(tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].comand[i-1]);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
If  Memo2.Enabled=false then begin Memo2.Lines.Clear; Memo2.Lines.Add('SETX$'); ComboBox1.Text:='x'; end;
ComboBox1.Enabled:=true;
Memo2.Enabled:=true;
ComboBox2.Enabled:=true;
ComboBox1.Items.Add('x');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('SETX$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;

 ComboBox1.Items.Add('y');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('SETY$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;

 ComboBox1.Items.Add('z');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('SETZ$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
If  Memo2.Enabled=false then begin Memo2.Lines.Clear; Memo2.Lines.Add('ROTX$'); ComboBox1.Text:='rx'; end;
 ComboBox1.Enabled:=true;
Memo2.Enabled:=true;
ComboBox2.Enabled:=true;
ComboBox1.Items.Add('rx');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('ROTX$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;

 ComboBox1.Items.Add('ry');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('ROTY$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;

 ComboBox1.Items.Add('rz');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('ROTZ$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=2;
 end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
If  Memo2.Enabled=false then begin Memo2.Lines.Clear; Memo2.Lines.Add('TEXTURE$'); ComboBox1.Text:='texture'; end;
  ComboBox1.Enabled:=true;
Memo2.Enabled:=true;
ComboBox2.Enabled:=true;
ComboBox1.Items.Add('texture');
 with tegs[TreeView1.Selected.AbsoluteIndex] do
 begin
 npar+=1;
 pars[npar].comand:=TStringList.Create;
 pars[npar].comand.Add('TEXTURE$');
 pars[npar].name:=ComboBox1.Items[ComboBox1.Items.Count-1];
 pars[npar].typ:=3;
 end;

end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
 If TreeView1.Selected.AbsoluteIndex=-1 then exit;
  tegs[TreeView1.Selected.AbsoluteIndex].open:=CheckBox1.Checked;
  If  (CheckBox1.Checked) and (CheckGroup1.Items.IndexOf(tegs[TreeView1.Selected.AbsoluteIndex].name)=-1) then  CheckGroup1.Items.add(tegs[TreeView1.Selected.AbsoluteIndex].name);
  If  (not CheckBox1.Checked) and (CheckGroup1.Items.IndexOf(tegs[TreeView1.Selected.AbsoluteIndex].name)<>-1) then  CheckGroup1.Items.Delete(CheckGroup1.Items.IndexOf(tegs[TreeView1.Selected.AbsoluteIndex].name));
end;

procedure TForm1.CheckGroup1ChangeBounds(Sender: TObject);
var i:longint;
begin
 For i:=1 to CheckGroup1.Items.Count do
  if CheckGroup1.Checked[i-1] then tegs[TreeView1.Selected.AbsoluteIndex].opentagallow.Add(CheckGroup1.Items[i])
  else
    If tegs[TreeView1.Selected.AbsoluteIndex].opentagallow.IndexOf(CheckGroup1.Items[i])<>-1 then
    tegs[TreeView1.Selected.AbsoluteIndex].opentagallow.Delete(tegs[TreeView1.Selected.AbsoluteIndex].opentagallow.IndexOf(CheckGroup1.Items[i]));

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
 If ComboBox1.ItemIndex<>-1 then exit;
  ComboBox1.Items[comboboxsel]:=ComboBox1.Text;
    tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].name:=ComboBox1.Text;

end;

procedure TForm1.ComboBox1ChangeBounds(Sender: TObject);

begin


end;

procedure TForm1.ComboBox1EditingDone(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1KeyPress(Sender: TObject; var Key: char);
begin
// ShowMessage(IntToStr(ord(key)));
  If not ((key in ['a'..'z']) or (key in ['A'..'Z']) or (key in ['0'..'9']) or (key=#8)) then key:=#0 else
   { ComboBox1.Items[ComboBox1.ItemIndex]:=ComboBox1.Text;
    tegs[TreeView1.Selected.AbsoluteIndex].pars[ComboBox1.ItemIndex+1].name:=ComboBox1.Text;   }
end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var i:longint;
begin
 If comboboxsel<>-1 then
 begin
 tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].comand.Assign(Memo2.Lines);
 end;

 comboboxsel:=ComboBox1.ItemIndex;
   Memo2.Lines.Clear;
  for i:=1 to tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].comand.Count do
 Memo2.Lines.Add(tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].comand[i-1]);
 ComboBox2.ItemIndex:=tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].typ;

end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin


end;

procedure TForm1.ComboBox2Select(Sender: TObject);
begin
   tegs[TreeView1.Selected.AbsoluteIndex].pars[comboboxsel+1].typ:=ComboBox2.ItemIndex;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  If TreeView1.Selected.AbsoluteIndex=-1 then exit;

end;

procedure TForm1.Memo2Change(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
var i,ii:longint;
begin
  TreeView1.Items.Clear;
  CheckGroup1.Items.Clear;
  For i:=0 to nteg do
   with tegs[i] do
   begin
   pre.Free;
   post.Free;
   opentagallow.Free;
   for ii:=1 To npar do pars[ii].comand.Free;
   end;
  nteg:=-1;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var t:textfile;
  s:string;
  var i,q,qi,ii,iii:longint;
    ex:boolean;
begin
 Form1.MenuItem2Click(Sender);

  If not OpenDialog1.Execute then exit;
  assignfile(t,OpenDialog1.FileName);
  reset(t);
  readln(t,nteg);
  dec(nteg);
  i:=-1;


  for qi:=0 to nteg do
  begin
  ex:=false;
  inc(i);
  readln(t,tegs[i].name);
  readln(t,q);
  if q=1 then tegs[i].open:=true;
  readln(t,q);
  If q=1 then ex:=true;
  readln(t,tegs[i].space);
  readln(t,tegs[i].postspace);
   If tegs[i].space>tegs[i].postspace then ex:=true;


tegs[i].pre:=TStringList.Create;
  readln(t,q);
  for ii:=1 to q do
  begin
  readln(t,s);
  tegs[i].pre.Add(s);
  end;

 tegs[i].post:=TStringList.Create;
 readln(t,q);
  for ii:=1 to q do
  begin
  readln(t,s);
  tegs[i].post.Add(s);
  end;

tegs[i].opentagallow:=TStringList.Create;
readln(t,q);
for ii:=1 to q do
begin
readln(t,s);
tegs[i].opentagallow.Add(s);
end;

readln(t,tegs[i].npar);
for ii:=1 to tegs[i].npar do
begin
readln(t,tegs[i].pars[ii].name);
readln(t,tegs[i].pars[ii].typ);
tegs[i].pars[ii].comand:=TStringList.Create;
readln(t,q);
for iii:=1 to q do
begin
readln(t,s);
tegs[i].pars[ii].comand.Add(s);
end;

end;

    if ex then dec(i);
end;
  nteg:=i;
  closefile(t);

  for i:=0 to nteg-1 do
  for ii:=i+1 to nteg do
  If tegs[i].space>tegs[ii].space then
  begin
   qtegs:=tegs[i];
   tegs[i]:=tegs[ii];
   tegs[ii]:=qtegs;
  end;

 // TreeView1.Items.;
for i:=0 to nteg do
If tegs[i].space=0 then TreeView1.Items.AddChild(nil,'<'+tegs[i].name+'>') else
  begin
   For ii:=0 to TreeView1.Items.Count-1 do
   If (tegs[ii].space<tegs[ii].postspace) and (tegs[ii].postspace=tegs[i].space) then TreeView1.Items.AddChild(TreeView1.Items[ii],'<'+tegs[i].name+'>');
  end;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
var t:textfile;
    i,qn,ii,iii:longint;
begin
qn:=0;
for i:=0 to nteg do
if (tegs[i].open) or (tegs[i].space<>tegs[i].postspace) then inc(qn,2) else inc(qn);

  Assignfile(t,OpenDialog1.FileName);
  rewrite(t);
  writeln(t,qn);
  for i:=0 to nteg do
  begin
  writeln(t,tegs[i].name);
  writeln(t,ORD(tegs[i].open));
  writeln(t,0);
  WriteLn(t,tegs[i].space);
  WriteLn(t,tegs[i].postspace);
  writeln(t,tegs[i].pre.Count);
  for ii:=0 to tegs[i].pre.Count-1 do writeln(t,tegs[i].pre[ii]);

   If tegs[i].open then writeln(t,0) else
     begin
     writeln(t,tegs[i].post.Count);
  for ii:=0 to tegs[i].post.Count-1 do writeln(t,tegs[i].post[ii]);
     end;

  WriteLn(t,tegs[i].opentagallow.Count);
  for ii:=0 to tegs[i].opentagallow.Count-1 do writeln(t,tegs[i].opentagallow[ii]);
  writeln(t,tegs[i].npar);
  for ii:=1 to tegs[i].npar do
  begin
  writeln(t,tegs[i].pars[ii].name);
  writeln(t,tegs[i].pars[ii].typ);
  writeln(t,tegs[i].pars[ii].comand.Count);
  for iii:=0 to tegs[i].pars[ii].comand.Count-1 do writeln(t,tegs[i].pars[ii].comand[iii]);
  end;

  If tegs[i].space<>tegs[i].postspace then
  begin
    writeln(t,'/'+tegs[i].name);
  writeln(t,0);
  writeln(t,0);
  WriteLn(t,tegs[i].postspace);
  WriteLn(t,tegs[i].space);
  writeln(t,tegs[i].pre.Count);
  for ii:=0 to tegs[i].pre.Count-1 do writeln(t,tegs[i].pre[ii]);
  writeln(t,tegs[i].post.Count);
  for ii:=0 to tegs[i].post.Count-1 do writeln(t,tegs[i].post[ii]);
  WriteLn(t,tegs[i].opentagallow.Count);
  for ii:=0 to tegs[i].opentagallow.Count-1 do writeln(t,tegs[i].opentagallow[ii]);
  writeln(t,tegs[i].npar);
  for ii:=1 to tegs[i].npar do
  begin
  writeln(t,tegs[i].pars[ii].name);
  writeln(t,tegs[i].pars[ii].typ);
  writeln(t,tegs[i].pars[ii].comand.Count);
  for iii:=0 to tegs[i].pars[ii].comand.Count-1 do writeln(t,tegs[i].pars[ii].comand[iii]);
  end;
  end;

    If tegs[i].open then
  begin
    writeln(t,'/'+tegs[i].name);
  writeln(t,0);
  writeln(t,1);
  WriteLn(t,tegs[i].postspace);
  WriteLn(t,tegs[i].space);
  writeln(t,0);
  writeln(t,tegs[i].post.Count);
  for ii:=0 to tegs[i].post.Count-1 do writeln(t,tegs[i].post[ii]);
  WriteLn(t,tegs[i].opentagallow.Count);
  for ii:=0 to tegs[i].opentagallow.Count-1 do writeln(t,tegs[i].opentagallow[ii]);
  writeln(t,0);
  end;

  end;
  closefile(t);
end;

 function SpaceNumber(s:string):longint;
begin
SpaceNumber:=0;
while pos(' ',s)<>0 do
begin
SpaceNumber+=1;
delete(s,pos(' ',s),1);
end;
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin

end;


procedure TForm1.TreeView1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin

end;

procedure TForm1.TreeView1Edited(Sender: TObject; Node: TTreeNode; var S: string
  );
begin
    If SpaceNumber(Node.Text)<>SpaceNumber(s)  then s:= Node.Text else  tegs[TreeView1.Selected.AbsoluteIndex].name:=copy(s,2,length(s)-2);
end;

procedure TForm1.TreeView1Editing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin

end;

procedure TForm1.TreeView1KeyPress(Sender: TObject; var Key: char);
begin
   If not ((key in ['a'..'z']) or (key in ['A'..'Z']) or (key in ['0'..'9']) or (key=#8)) then key:=#0
end;

procedure TForm1.TreeView1SelectionChanged(Sender: TObject);
var i,th:longint;
begin
 If prs<>-1 then
 begin
  tegs[prs].pre.Assign(Memo1.Lines);
  tegs[prs].post.Assign(Memo3.Lines);
  if ComboBox1.Enabled then tegs[prs].pars[comboboxsel+1].comand.Assign(Memo2.Lines);
  end;


 th:=TreeView1.Selected.AbsoluteIndex;
 //Memo1.Lines.Assign(tegs[prs].pre as TStrings);

 Memo1.Lines.Clear;
for i:=1 to tegs[th].pre.Count do
 Memo1.Lines.Add(tegs[th].pre[i-1]);

Memo3.Lines.Clear;
for i:=1 to tegs[th].post.Count do
 Memo3.Lines.Add(tegs[th].post[i-1]);

Memo2.Lines.Clear;
Memo2.Lines.Add('LOAD$');
CheckBox1.Checked:=tegs[th].open;
If tegs[th].npar=0 then begin ComboBox1.Enabled:=false; Memo2.Enabled:=false; ComboBox1.Items.Clear; ComboBox1.Text:='src' end else
  begin
   ComboBox1.Enabled:=true;
   Memo2.Enabled:=true;
   ComboBox1.Items.Clear;
   ComboBox1.Text:=tegs[th].pars[1].name;
   ComboBox2.ItemIndex:=tegs[th].pars[1].typ;



 Memo2.Lines.Clear;
  for i:=1 to tegs[th].pars[1].comand.Count do
 Memo2.Lines.Add(tegs[th].pars[1].comand[i-1]);

for i:=1 to tegs[th].npar do ComboBox1.Items.Add(tegs[th].pars[i].name);
   end;

  For i:=1 to CheckGroup1.Items.Count do CheckGroup1.Checked[i-1]:=tegs[th].opentagallow.IndexOf(CheckGroup1.Items[i-1])<>-1;

  prs:=TreeView1.Selected.AbsoluteIndex;
  prss:=0;
  comboboxsel:=0;
end;



end.

