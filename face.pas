unit face;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, GLLCLViewer, GLObjects, GLNavigator,
  GLSmoothNavigator, GLCadencer, LCLType, cacher, pagereader,
  creator, GLScene, GLMaterial, GLGeomObjects, types, GLBaseClasses;

type

  { TMain }

  TMain = class(TForm)
    GLCadencer1: TGLCadencer;
    GlMainCamera: TGLCamera;
    GLMaterialLibrary1: TGLMaterialLibrary;
    GLNavigator1: TGLNavigator;
    GLSceneee: TGLScene;
    GLSceneViewer1: TGLSceneViewer;
    GoBitBtn: TBitBtn;
    URLEdit: TEdit;
    Panel1: TPanel;
    world: TGLDummyCube;
    procedure FormCreate(Sender: TObject);
    procedure GLCadencer1Progress(Sender: TObject;
      const deltaTime, newTime: double);
    procedure GLSceneViewer1Click(Sender: TObject);
    procedure GLSceneViewer1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure GLSceneViewer1KeyUp(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure GLSceneViewer1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
    procedure GoBitBtnClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Main: TMain;

implementation

var
  com: Tout;
  MouseLockee, ku, kd, kl, kr: boolean;
  mx, my: integer;
  flySpeed: extended = 10.0;
  mousespeed: extended = 1;

{$R *.lfm}

{ TMain }

procedure TMain.GoBitBtnClick(Sender: TObject);
var
  page, s, n: string;
  i: longint;
begin
  s := URLEdit.Text;
  CorrectURL(s);
  URLEdit.Text := s;
 // clearCache;
  OflineMode:=true;
  page := (addfile(URLEdit.Text));

  if page = 'error' then
    exit;

  com := DecodePage(page);

  GlClear;
  for i := 1 to com.CreatorMM.Count do
  begin
    s := com.CreatorMM[i - 1];
    ShowMessage(s);
    if (pos('LOADMODEL', com.CreatorMM[i - 1]) <> 0) or
      (pos('TEXTURE', com.CreatorMM[i - 1]) <> 0) then
    begin
      n := copy(s, pos('$', s) + 1, length(s) - pos('$', s));
      Delete(s, pos('$', s) + 1, length(s) - pos('$', s));
      n := addfile(n);
      if n = '440:440' then
        Continue
      else
        Glrequre(s + n);
    end
    else
      Glrequre(s);
  end;

   OflineMode:=false;

  if not GLSceneViewer1.Focused then
    GLSceneViewer1.SetFocus;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  CrInit(GLSceneee);
  MouseLockee := False;
  GLCadencer1.Enabled := True;

end;

procedure TMain.GLCadencer1Progress(Sender: TObject; const deltaTime, newTime: double);

var
  x, y: integer;
begin
  //  If ((ku or kd) or kl) or kr then ShowMessage('asdf');
  if ku then
    GLNavigator1.MoveForward(flySpeed * deltaTime);
  if kd then
    GLNavigator1.MoveForward(-flySpeed * deltaTime);
  if kl then
    GLNavigator1.StrafeHorizontal(-flySpeed * deltaTime);
  if kr then
    GLNavigator1.StrafeHorizontal(flySpeed * deltaTime);

  if MouseLockee then
  begin
    x := Mouse.CursorPos.X;
    y := Mouse.CursorPos.y;
    GLNavigator1.TurnHorizontal((x - mx) * mousespeed);
    GLNavigator1.TurnVertical((my - y) * mousespeed);
    if not GLSceneViewer1.Focused then
      GLSceneViewer1.SetFocus;
    //GlMainCamera.Apply;

    Mouse.CursorPos := Point(Main.Left + (Main.Width div 2), Main.Top + (Main.Height div 2));
    //GLSceneViewer1.Render;
    //GLCadencer1.Progress;
  end;

end;

procedure TMain.GLSceneViewer1Click(Sender: TObject);
begin
  GLSceneViewer1.SetFocus;
end;

procedure TMain.GLSceneViewer1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
  begin
    MouseLockee := not MouseLockee;
    if MouseLockee then
      Mouse.CursorPos := Point(Main.Left + (Main.Width div 2), Main.Top + (Main.Height div 2));
    mx := Mouse.CursorPos.X;
    my := Mouse.CursorPos.Y;
  end;

  if (key = VK_LEFT) or (key = VK_A) then
  begin
    kl := True;
    Key := 0;
  end;
  if (key = VK_RIGHT) or (key = VK_D) then
  begin
    kr := True;
    Key := 0;
  end;
  if (key = VK_UP) or (key = VK_W) then
  begin
    ku := True;
    Key := 0;
  end;
  if (key = VK_DOWN) or (key = VK_S) then
  begin
    kd := True;
    Key := 0;
  end;

end;

procedure TMain.GLSceneViewer1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_A) then
  begin
    kl := False;
    Key := 0;
  end;
  if (key = VK_RIGHT) or (key = VK_D) then
  begin
    kr := False;
    Key := 0;
  end;
  if (key = VK_UP) or (key = VK_W) then
  begin
    ku := False;
    Key := 0;
  end;
  if (key = VK_DOWN) or (key = VK_S) then
  begin
    kd := False;
    Key := 0;
  end;

end;


procedure TMain.GLSceneViewer1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: integer; MousePos: TPoint; var Handled: boolean);
const
  km = 0.001;
  ks = 0.001;
  kf = 0.02;
var
  del: integer;
begin
  del := (Ord(Handled) * 2 - 1) * WheelDelta;
  if ssCtrl in Shift then
    GlMainCamera.FocalLength := GlMainCamera.FocalLength + mousespeed * del * kf
  else
  if ssShift in Shift then
    mousespeed := mousespeed + mousespeed * del * km
  else
    flySpeed := flySpeed + flySpeed * del * ks;
end;

end.
