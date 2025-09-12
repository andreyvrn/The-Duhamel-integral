unit Calculations;

{$mode objfpc}{$H+}

interface

const
  TimeRange = 5e-3;
  Alpha = 6;
  Shift = 3;
  ExpFactor1 = -314.386;
  ExpFactor2 = 338.300;
  ExpFactor3 = -23.913;
  Rate1 = -1621.867;
  Rate2 = -776.702;
  Rate3 = -98.932;

function InputSignal(Time: double): double;
function Kernel(dt: double): double;
function Integral(verx, niz: double; n: word; Time: double): double;

implementation

uses Math;

function InputSignal(Time: double): double;
var
  arg: double;
begin
  if Time <= TimeRange / 2 then
    Result := 1 - exp(-(Alpha * Time) / TimeRange)
  else
  begin
    arg := Alpha * Time / TimeRange - Shift;
    Result := (1 - exp(-Shift)) * exp(-sqr(arg));
  end;
end;

function Kernel(dt: double): double;
begin
  Result := ExpFactor1 * exp(Rate1 * dt) +
            ExpFactor2 * exp(Rate2 * dt) +
            ExpFactor3 * exp(Rate3 * dt);
end;

function Integral(verx, niz: double; n: word; Time: double): double;
var
  d, y, S, tau: double;
  k: integer;
begin
  d := (verx - niz) / n;
  S := 0;
  for k := 0 to n do
  begin
    tau := niz + k * d;
    y := InputSignal(tau) * Kernel(Time - tau);
    if k <> 0 then
    begin
      if (k mod 2) = 0 then
      begin
        if k <> n then
          y := 2 * y;
      end
      else
        y := 4 * y;
    end;
    S := S + y;
  end;
  Result := d * S / 3;
end;

end.

