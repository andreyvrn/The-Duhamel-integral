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
function Integral(upperBound, lowerBound: double; segments: word; Time: double): double;

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

function Integral(upperBound, lowerBound: double; segments: word; Time: double): double;
var
  step, value, sum, tau: double;
  index: integer;
begin
  step := (upperBound - lowerBound) / segments;
  sum := 0;
  for index := 0 to segments do
  begin
    tau := lowerBound + index * step;
    value := InputSignal(tau) * Kernel(Time - tau);
    if index <> 0 then
    begin
      if (index mod 2) = 0 then
      begin
        if index <> segments then
          value := 2 * value;
      end
      else
        value := 4 * value;
    end;
    sum := sum + value;
  end;
  Result := step * sum / 3;
end;

end.
