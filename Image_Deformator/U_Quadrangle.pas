//-------- Bitmap Déformation Quadrangle
//-------- PALDACCI Antony ------ spatul@hotmail.com
//-------- Date de création : 06/10/2008
//-------- Dernière modification : 08/10/2008 15H14

unit U_Quadrangle;

interface

uses
  Windows, Graphics, Classes, Math;


type
  TRVBArray = array [0..0] of TRGBTriple;
  pRVBArray = ^TRVBArray;
  TQuadrangle = record A,B,C,D : TPoint; end;

var
  Ox, Oy, Fx, Fy : integer;

  {renvoi la distance entre deux points}
  function DistValeurs(A,B:integer):integer;
  {adapte un bitmap à un quadrangle}
  function Distorsion(AQuadrangle:TQuadrangle; ABitmap:TBitmap; BkColor:TColor):TBitmap;

implementation

function DistValeurs(A,B:integer):integer;
begin
 if A > B then result := A-B else result := B-A;
end;

function Distorsion(AQuadrangle:TQuadrangle; ABitmap:TBitmap; BkColor:TColor):TBitmap;
var
 TabScanLine, TSLFinal : array of pRVBArray;
 BmpOrigin : TBitmap;
 BmpFinal : TBitmap;
 v, u, x, y, xd, yd : integer;
 RQWidth, RQHeight : integer;
 TauxY, TauxX : real;
 DistAB, DistDC, PosXAB, PosXDC : real;
 DistAD, DistBC, PosYAD, PosYBC : real;
begin

//--calcul de la zone rectangle (rectangle maitre) contenant le quadrangle
 Ox := min(min(AQuadrangle.A.X,AQuadrangle.B.X),min(AQuadrangle.C.X,AQuadrangle.D.X));
 Oy := min(min(AQuadrangle.A.Y,AQuadrangle.B.Y),min(AQuadrangle.C.Y,AQuadrangle.D.Y));
 Fx := max(max(AQuadrangle.A.X,AQuadrangle.B.X),max(AQuadrangle.C.X,AQuadrangle.D.X));
 Fy := max(max(AQuadrangle.A.Y,AQuadrangle.B.Y),max(AQuadrangle.C.Y,AQuadrangle.D.Y));
 RQWidth := Fx-Ox;
 RQHeight := Fy-Oy;

//--création d'une copie du bitmap d'origine
 BmpOrigin := TBitmap.Create;
 BmpOrigin.HandleType := bmDIB;
 BmpOrigin.PixelFormat := pf24Bit;
 BmpOrigin.Height := RQHeight;
 BmpOrigin.Width := RQWidth;

//--création du bitmap final qui sera transféré à "result"
 BmpFinal := TBitmap.Create;
 BmpFinal.HandleType := bmDIB;
 BmpFinal.PixelFormat := pf24Bit;
 BmpFinal.Height := RQHeight;
 BmpFinal.Width := RQWidth;
 BmpFinal.Canvas.Brush.Color := BkColor;
 BmpFinal.Canvas.FillRect(rect(0,0,RQWidth,RQHeight));

//--mise à l'échelle du bitmap d'origine par rapport au rectangle maitre 
 BmpOrigin.Canvas.StretchDraw(rect(0,0,RQWidth,RQHeight),ABitmap);

//--définir la taille des tableaux dynamiques
 SetLength(TabScanLine,BmpOrigin.Height);
 SetLength(TSLFinal,BmpFinal.Height);

// transférer les données (pixels) dans chaque tableau
 For v:=0  to  RQHeight-1  do begin
  // transférer les information de l'image dans les tableaux
  TabScanLine[v] := BmpOrigin.ScanLine[v];
  TSLFinal[v] := BmpFinal.ScanLine[v];
 end;

//--Transférer les pixels au bon endroit

 {Pour chaque pixel, calcule le taux de positionnement de x et y}
 For v:=1 to BmpOrigin.Height-1 do begin
  y := v;
  TauxY := v / BmpOrigin.Height;
  DistAD := AQuadrangle.D.Y-AQuadrangle.A.Y;
  DistBC := AQuadrangle.C.Y-AQuadrangle.B.Y;
  PosYAD := AQuadrangle.A.Y-OY+(DistAD*TauxY);
  PosYBC := AQuadrangle.B.Y-OY+(DistBC*TauxY);

  For u := 1 to BmpOrigin.Width-1 do begin
   TauxX := u / BmpOrigin.Width;
   DistAB := AQuadrangle.B.X-AQuadrangle.A.X;
   DistDC := AQuadrangle.C.X-AQuadrangle.D.X;
   PosXAB := AQuadrangle.A.X-OX+(DistAB*TauxX);
   PosXDC := AQuadrangle.D.X-OX+(DistDC*TauxX);

   x := round(Int(PosXAB+(PosXDC-PosXAB)*TauxY));
   y := Round(Int(PosYAD+(PosYBC-PosYAD)*TauxX));

   xd := Round(Frac(PosXAB+(PosXDC-PosXAB)*TauxY));
   yd := Round(Frac(PosYAD+(PosYBC-PosYAD)*TauxX));

   {transfère les pixels au bon emplacement}
   TSLFinal[y,x].rgbtRed := TabScanLine[v,u].rgbtRed;
   TSLFinal[y,x].rgbtGreen := TabScanLine[v,u].rgbtGreen;
   TSLFinal[y,x].rgbtBlue := TabScanLine[v,u].rgbtBlue;

   //pour lever les "trous..."
   if (x<BmpOrigin.Width-2) and (xd>0) then begin
   TSLFinal[y,x+1].rgbtRed := TabScanLine[v,u].rgbtRed;
   TSLFinal[y,x+1].rgbtGreen := TabScanLine[v,u].rgbtGreen;
   TSLFinal[y,x+1].rgbtBlue := TabScanLine[v,u].rgbtBlue;
   end;
   if (y<BmpOrigin.Height-2) and (yd>0) then begin
   TSLFinal[y+1,x].rgbtRed := TabScanLine[v,u].rgbtRed;
   TSLFinal[y+1,x].rgbtGreen := TabScanLine[v,u].rgbtGreen;
   TSLFinal[y+1,x].rgbtBlue := TabScanLine[v,u].rgbtBlue;
   end;
  end;
 end;

//--assigne le bitmap final au "result"
 result := TBitmap.create;
 Result.Assign(bmpFinal);
 bmpFinal.Free;
 BmpOrigin.free;
end;

end.
 