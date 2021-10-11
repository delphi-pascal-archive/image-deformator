unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math, U_Quadrangle;

type
  TForm1 = class(TForm)
    PB1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PB1Paint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PB1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PB1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PB1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    renderbuffer:tbitmap;
    image:tbitmap;
    procedure Render;

  end;

var
  Form1: TForm1;
  A, B, C, D : TPoint;
  Coin:integer;
  Quadrangle: tquadrangle;

implementation

{$R *.dfm}

{initialisation des valeurs et création des objets}
procedure TForm1.FormCreate(Sender: TObject);
begin
 PB1.ControlStyle:=PB1.ControlStyle+[csOpaque]; // évite le clignotement
 RenderBuffer:=TBitmap.Create;
 RenderBuffer.Width:=PB1.Width;
 RenderBuffer.Height:=PB1.Height;
 A:=Point(50,30);   B:=Point(190,30);
 D:=Point(50,170);   C:=Point(190,170);
 Coin:=0;
 Image:=TBitmap.Create;
 Image.LoadFromFile('test200.bmp');
 render;
end;

{liberation des objets à la fermeture du programme}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Image.Free;
 RenderBuffer.Free;
end;

{dessin du PaintBox}
procedure TForm1.PB1Paint(Sender: TObject);
begin
 PB1.Canvas.Draw(0,0,RenderBuffer);
end;

{déformation & rendu de l'image}
procedure TForm1.Render;
begin

 {effacer l'image}
 RenderBuffer.Canvas.Brush.Color:=ClWhite;
 RenderBuffer.Canvas.FillRect(RenderBuffer.Canvas.ClipRect);

 Quadrangle.A:=A;
 Quadrangle.B:=B;
 Quadrangle.C:=C;
 Quadrangle.D:=D;
                                // deformation //
 RenderBuffer.Canvas.Draw(OX,OY,Distorsion(Quadrangle,Image,clWhite));

 {dessiner les points A, B, C, D}
 with RenderBuffer.Canvas do begin
  Brush.Color:=clred;
  Pen.Style :=psSolid;
  Rectangle(A.X-5,A.Y-5,A.X+5,A.Y+5); // poiit "A" en rouge
  Brush.Color:=clBlue;
  Rectangle(B.X-5,B.Y-5,B.X+5,B.Y+5); // les autres en bleu
  Rectangle(C.X-5,C.Y-5,C.X+5,C.Y+5);
  Rectangle(D.X-5,D.Y-5,D.X+5,D.Y+5);
 end;

 {dessiner les contours (connections ABCD)}
 with RenderBuffer.Canvas do begin
  MoveTo(A.X,A.Y);
  LineTo(B.X,B.Y);
  LineTo(C.X,C.Y);
  LineTo(D.X,D.Y);
  LineTo(A.X,A.Y);
 end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 render;
 PB1.Invalidate;
end;

//-------- GESTION DE LA SOURIS DANS LE PAINTBOX --------//
procedure TForm1.PB1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 {vérifier où se trouve la souris}
 Coin:=0;
 if (x in [A.X-5..A.X+5]) and (y in [A.Y-5..A.Y+5]) then Coin:=1;
 if (x in [B.X-5..B.X+5]) and (y in [B.Y-5..B.Y+5]) then Coin:=2;
 if (x in [C.X-5..C.X+5]) and (y in [C.Y-5..C.Y+5]) then Coin:=3;
 if (x in [D.X-5..D.X+5]) and (y in [D.Y-5..D.Y+5]) then Coin:=4;
end;

procedure TForm1.PB1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if Coin=1 then begin
  A.X:=X; A.Y:=Y;
 end;
 if Coin=2 then begin
  B.X:=X; B.Y:=Y;
 end;
 if Coin=3 then begin
  C.X:=X; C.Y:=Y;
 end;
 if Coin=4 then begin
  D.X:=X; D.Y:=Y;
 end;
 //Bloquer la sortie d'écran
 if A.X<5 then A.X:=8;
 If A.X>PB1.Width-5 then A.X:=PB1.Width-8;
 if A.Y<5 then A.Y:=8;
 If A.Y>PB1.Height-5 then A.Y:=PB1.Height-8;
 if B.X<5 then B.X:=8;
 If B.X>PB1.Width-5 then B.X:=PB1.Width-8;
 if B.Y<5 then B.Y:=8;
 If B.Y>PB1.Height-5 then B.Y:=PB1.Height-8;
 if C.X<5 then C.X:=8;
 If C.X>PB1.Width-5 then C.X:=PB1.Width-8;
 if C.Y<5 then C.Y:=8;
 If C.Y>PB1.Height-5 then C.Y:=PB1.Height-8;
 if D.X<5 then D.X:=8;
 If D.X>PB1.Width-5 then D.X:=PB1.Width-8;
 if D.Y<5 then D.Y:=8;
 If D.Y>PB1.Height-5 then D.Y:=PB1.Height-8;

 Render;
 PB1.Invalidate;
end;

procedure TForm1.PB1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 Coin:=0;
end;

end.
