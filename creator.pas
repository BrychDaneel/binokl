unit creator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GLLCLViewer, GLScene, GLObjects, GLVectorFileObjects,
  GLTexture, GLMaterial;

procedure CrInit(_Scene: TGLScene);
procedure GlClear;
procedure Glrequre(s: string);

implementation

var
  Scene: TGLScene;
  root: TGLDummyCube;
  th, q: TGLBaseSceneObject;

procedure CrInit(_Scene: TGLScene);
begin
  Scene := _Scene;
  root := TGLDummyCube.CreateAsChild(Scene.Objects);
  th := root;
end;

procedure GlClear;
begin
  root.DeleteChildren;
  th := root;
end;

function getpar(s:string):string;
begin
  getpar:=copy(s, pos('$', s) + 1, length(s) - pos('$', s));
end;

procedure Glrequre(s: string);
begin
  if s = 'ADDMODEL' then
  begin
    q := TGLFreeForm.CreateAsChild(th);
    th := q;
  end;

  if length(s) > length('LOADMODEL') then
    if (copy(s, 1, length('LOADMODEL')) = 'LOADMODEL') and (th is TGLFreeForm) then
      TGLFreeForm(th).LoadFromFile(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));


  if s = 'UP' then
    if th <> root then
      th := th.Parent;


  if s = 'ADDLIGHT' then
  begin
    q := TGLLightSource.CreateAsChild(th);
    TGLLightSource(q).SpotCutOff:=360;
    th := q;
  end;

  if s = 'ADDBOX' then
  begin
    q := TGLCube.CreateAsChild(th);
    th := q;
  end;

   if s = 'ADDSPHERE' then
  begin
    q := TGLSphere.CreateAsChild(th);
    TGLSphere(q).Normals:=nsSmooth;
    th := q;
  end;

  if s = 'ADDPLANE' then
  begin
    q := TGLPlane.CreateAsChild(th);
    th := q;
  end;

  if length(s) > length('SETY') then
    if (copy(s, 1, length('SETY')) = 'SETY') then
      th.Position.Y := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if (pos('SETX', s) <> 0) then
      th.Position.X := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if  (pos('SETZ', s)<> 0) then
      th.Position.Z := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));

    if (pos('SCLX', s) <> 0) then
      th.Scale.Y := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if (pos('SCLY', s) <> 0) then
      th.Scale.X := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if  (pos('SCLZ', s)<> 0) then
      th.Scale.Z := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));

    if (pos('ROTX', s) <> 0) then
      th.TurnAngle := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if (pos('ROTY', s) <> 0) then
      th.PitchAngle:= StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
    if  (pos('ROTZ', s)<> 0) then
      th.RollAngle := StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s)));

    if  (pos('SETW', s)<> 0) and (th Is TGLCube) then
      TGLCube(th).CubeWidth:= StrToFloat(getpar(s));
        if  (pos('SETH', s)<> 0) and (th Is TGLCube) then
      TGLCube(th).CubeHeight:= StrToFloat(getpar(s));
        if  (pos('SETD', s)<> 0) and (th Is TGLCube) then
      TGLCube(th).CubeDepth:= StrToFloat(getpar(s));

        if  (pos('SETRADIUS', s)<> 0) and (th Is TGLSphere) then
      TGLSphere(th).Radius:= StrToFloat(getpar(s));

    if  (pos('SETW', s)<> 0) and (th Is TGLPlane) then
      TGLPlane(th).Width:= StrToFloat(getpar(s));
        if  (pos('SETH', s)<> 0) and (th Is TGLPlane) then
      TGLPlane(th).Height:= StrToFloat(getpar(s));

   If (pos('SETPOWER$', s)<>0) and (th is TGLLightSource) then
      TGLLightSource(th).ConstAttenuation:=1/(StrToFloat(copy(s, pos('$', s) + 1, length(s) - pos('$', s))));

  if (pos('TEXTURE', s) <> 0) and (th is TGLSceneObject) then
  begin
    TGLSceneObject(q).Material.Texture.TextureMode := tmModulate;
        TGLSceneObject(q).Material.Texture.Disabled := False;
    (th as TGLSceneObject).Material.Texture.Image.LoadFromFile(
      copy(s, pos('$', s) + 1, length(s) - pos('$', s)));
  end;

end;

end.
