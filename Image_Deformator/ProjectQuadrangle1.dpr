program ProjectQuadrangle1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  U_Quadrangle in 'U_Quadrangle.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
