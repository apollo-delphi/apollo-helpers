unit Apollo_Helpers;

interface

uses
  System.Classes;

type
  TStringTools = record
    class function GetHash(const aStr: string): string; static;
    class function GetHash16(const aStr: string): string; static;
  end;

  TFileTools = record
    class function CreateFileStream(const aFilePath: string): TFileStream; static;
    class function GetFiles(const aDirectoryPath: string): TArray<string>; static;
  end;

  TStrArrHelper = record helper for TArray<string>
    function Contains(const aValue: string): Boolean;
    function CommaText: string;
    function Count: Integer;
  end;

implementation

uses
  System.Hash,
  System.IOUtils,
  System.SysUtils;

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

function TStrArrHelper.Count: Integer;
begin
  Result := Length(Self);
end;

function TStrArrHelper.CommaText: string;
begin
  Result := string.Join(',', Self);
end;

{TStringTools}

class function TStringTools.GetHash(const aStr: string): string;
begin
  Result := THashMD5.GetHashString(aStr).ToUpper;
end;

class function TStringTools.GetHash16(const aStr: string): string;
begin
  Result := GetHash(aStr).Substring(0, 15);
end;

{TFileTools}

class function TFileTools.GetFiles(const aDirectoryPath: string): TArray<string>;
begin
  Result := TDirectory.GetFiles(aDirectoryPath, '*', TSearchOption.soAllDirectories);
end;

class function TFileTools.CreateFileStream(const aFilePath: string): TFileStream;
begin
  Result := TFile.OpenRead(aFilePath);
end;

end.
