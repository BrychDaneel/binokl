unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, ActnList, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
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
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ScrollBox1: TScrollBox;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

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
  end;

  Tteg=record
  name:string;
  open,close: boolean;
  space,postspace: longint;
  pre,post:TStringList;
  opentagallow:TStringList;
  npar:longint;
  pars:array [1..100] of par;
end;

var tegs:array [1..100] of Tteg;
  nteg:longint;
  sot:array [1..100] of TTreeNode;
procedure TForm1.Button1Click(Sender: TObject);
   var it:TTreeNode;
begin
it:=TreeView1.Items.AddChild(TreeView1.Selected,'<neteg>');
inc(nteg);
ShowMessage(IntToStr(it.AbsoluteIndex));
end;

procedure TForm1.Button2Click(Sender: TObject);
//var index:
begin
 ComboBox1.Items.Add(ComboBox1.Text);
end;



end.

