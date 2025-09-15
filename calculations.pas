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
function Kernel(deltaTime: double): double;
function Integral(lowerLimit, upperLimit: double; segmentCount: word; sampleTime: double): double;

implementation


function InputSignal(Time: double): double;
var
  normalizedTime: double;
begin
  if Time <= TimeRange / 2 then
    Result := 1 - exp(-(Alpha * Time) / TimeRange)
  else
  begin
    normalizedTime := Alpha * Time / TimeRange - Shift;
    Result := (1 - exp(-Shift)) * exp(-sqr(normalizedTime));
  end;
end;

function Kernel(deltaTime: double): double;
begin
  Result := ExpFactor1 * exp(Rate1 * deltaTime) +
            ExpFactor2 * exp(Rate2 * deltaTime) +
            ExpFactor3 * exp(Rate3 * deltaTime);
end;

function Integral(lowerLimit, upperLimit: double; segmentCount: word; sampleTime: double): double;
var
  segmentWidth, weightedValue, total, integrationTime: double;
  segmentIndex: integer;
begin
  segmentWidth := (upperLimit - lowerLimit) / segmentCount;
  total := 0;
  for segmentIndex := 0 to segmentCount do
  begin
    integrationTime := lowerLimit + segmentIndex * segmentWidth;
    weightedValue := InputSignal(integrationTime) * Kernel(sampleTime - integrationTime);
    if segmentIndex <> 0 then
    begin
      if (segmentIndex mod 2) = 0 then
      begin
        if segmentIndex <> segmentCount then
          weightedValue := 2 * weightedValue;
      end
      else
        weightedValue := 4 * weightedValue;
    end;
    total := total + weightedValue;
  end;
  Result := segmentWidth * total / 3;
end;

end.
