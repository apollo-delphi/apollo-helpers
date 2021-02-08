unit Apollo_Helpers;

interface

type
  TStrArrHelper = record helper for TArray<string>
    function Contains(const aValue: string): Boolean;
  end;

implementation

{TStrArrHelper}

function TStrArrHelper.Contains(const aValue: string): Boolean;
var
  Value: string;
begin
  Result := False;
  for Value in Self do
    if Value = aValue then
      Exit(True);
end;

end.
