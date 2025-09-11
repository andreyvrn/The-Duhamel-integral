unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAChartListbox, Forms,
  Controls, Graphics, Dialogs, Grids, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Label1Click(Sender: TObject);

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
const
  tr = 5E-3;
  n = 100;
  otr = 100;

var
  st, t: double;
  npp: word;

function integral(vid: byte; verx, niz: double; n: word; Time: double): double;
var
  d, y, S, tau: double;
  k :integer;
begin
  d := (verx - niz) / n;
  S := 0;
  for k :=0 to n do
  begin
    tau := niz + k * d;
    case vid of
     1: y := (1-exp(-6*tau/0.005))*((-314.386*exp(-1621.867*(Time-tau)))+(338.300*exp(-776.702*(Time-tau)))-(23.913*exp(-98.932*(Time-tau))));
      2: y :=((1-0.04978706837)*exp(-(6*tau/0.005-3)*(6*tau/0.005-3)))*((-314.386*exp(-1621.867*(Time-tau)))+(338.300*exp(-776.702*(Time-tau)))-(23.913*exp(-98.932*(Time-tau))));
    end;

    if k <> 0 then
    begin
      if(k mod 2) = 0 then
      begin
        if k <> n then y :=2*y
      end
      else
        y :=  4*y;
    end;
    S := S + y; end;
    integral := d * S / 3;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  T, x, step: double;
  c, y: longint;
begin
  Chart1LineSeries1.Clear;
  step := 0.00005;
  x := 0;
  y := 0;
  T := 0.005;
  c := Trunc(T / step) + 1;

  while x + step <= T do
  begin
    x := x + step;
    y := y + 1;
    StringGrid1.Cells[0, y] := FloatToStr(y);
    if x <= T / 2 then
    begin
      StringGrid1.Cells[1, y] := FloatToStr(x);
      StringGrid1.Cells[2, y] := FloatToStr(1 - exp(-(6 * x) / 0.005));
      Chart1LineSeries1.AddXY(x, 1 - exp(-(6 * x) / 0.005));
    end;
    if x >= T / 2 then
    begin
      StringGrid1.Cells[1, y] := FloatToStr(x);
      StringGrid1.Cells[2, y] := FloatToStr((1 - 0.04978706837) * exp(-(6 * x / 0.005 - 3) * (6 * x / 0.005 - 3)));
      Chart1LineSeries1.AddXY(x, (1 - 0.04978706837) * exp(-(6 * x / 0.005 - 3) * (6 * x / 0.005 - 3)));
    end;
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Chart1LineSeries2.Clear;

  st := tr / n;
  t := 0;
  npp := 0;
  while t + st < (tr / 2) do
  begin
    npp := npp + 1;
    StringGrid1.Cells[3, npp] := FloatToStr(integral(1, t, 0, otr, t));
    Chart1LineSeries2.AddXY(t, integral(1, t, 0, otr, t));
    t := t + st;
  end;
  while t + st <= 0.005 do
  begin
    npp := npp + 1;
    StringGrid1.Cells[3, npp] :=
      FloatToStr(integral(1, tr / 2, 0, otr, t) + integral(2, t, tr / 2, otr, t));
    Chart1LineSeries2.AddXY(t,
      integral(1, tr / 2, 0, otr, t) + integral(2, t, tr / 2, otr, t));
    t := t + st;
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', ',']) then Key := #0;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;



end.

