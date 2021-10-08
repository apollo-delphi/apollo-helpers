unit Apollo_Helpers;

interface

uses
  System.Classes;

type
  TStringTools = record
    class function FillSpacesToLength(const aStr: string; const aLength: Integer): string; static;
    class function GetHash(const aStr: string): string; static;
    class function GetHash16(const aStr: string): string; static;
  end;

  TFileTools = record
    class function CreateFileStream(const aFilePath: string): TFileStream; static;
    class function GetFiles(const aDirectoryPath: string; const aAllDirectories: Boolean = True): TArray<string>; static;
    class procedure ClearDirectory(const aDirectoryPath: string); static;
    class procedure CreateDirIfNotExists(const aDirectoryPath: string); static;
  end;

  TStrArrHelper = record helper for TArray<string>
    function Contains(const aValue: string): Boolean;
    function CommaText: string;
    function Count: Integer;
  end;

  TIntArrHelper = record helper for TArray<Integer>
    function CommaText: string;
    function Count: Integer;
    function IsEmpty: Boolean;
    procedure Clear;
    procedure SplitCommaText(const aText: string);
  end;

  TColumnInfo = record
    AllowSort: Boolean;
    DefaultWidth: Integer;
    FieldName: string;
    Index: Integer;
    Title: string;
    constructor Create(const aIndex: Integer; const aTitle, aFieldName: string;
      const aDefaultWidth: Integer; const aAllowSort: Boolean);
  end;

  TColumnInfoHelper = record helper for TArray<TColumnInfo>
    function GetDefaultWidths: TArray<Integer>;
    function GetFieldName(const aIndex: Integer): string;
    function GetTitles: TArray<string>;
    function IsSortColumn(const aIndex: Integer): Boolean;
  end;

implementation

uses
  System.Hash,
  System.IOUtils,
  System.SysUtils;

{TIntArrHelper}

function TIntArrHelper.IsEmpty: Boolean;
begin
  Result := Length(Self) = 0;
end;

procedure TIntArrHelper.Clear;
begin
  SetLength(Self, 0);
end;

function TIntArrHelper.Count: Integer;
begin
  Result := Length(Self);
end;

procedure TIntArrHelper.SplitCommaText(const aText: string);
var
  Value: string;
  Values: TArray<string>;
begin
  Self := [];
  Values := aText.Split([',']);

  for Value in Values do
    Self := Self + [Value.ToInteger];
end;

function TIntArrHelper.CommaText: string;
var
  Value: Integer;
begin
  Result := '';

  for Value in Self do
  begin
    if not Result.IsEmpty then
      Result := Result + ',';
    Result := Result + Value.ToString;
  end;
end;

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

class function TStringTools.FillSpacesToLength(const aStr: string; const aLength: Integer): string;
var
  i: Integer;
begin
  Result := aStr;

  for i := Length(aStr) to aLength do
    Result := Result + ' ';
end;

class function TStringTools.GetHash(const aStr: string): string;
begin
  Result := THashMD5.GetHashString(aStr).ToUpper;
end;

class function TStringTools.GetHash16(const aStr: string): string;
begin
  Result := GetHash(aStr).Substring(0, 15);
end;

{TFileTools}

class procedure TFileTools.CreateDirIfNotExists(const aDirectoryPath: string);
begin
  if not TDirectory.Exists(aDirectoryPath) then
    TDirectory.CreateDirectory(aDirectoryPath);
end;

class procedure TFileTools.ClearDirectory(const aDirectoryPath: string);
var
  FilePath: string;
  FilePaths: TArray<string>;
begin
  FilePaths := GetFiles(aDirectoryPath, False{aAllDirectories});

  for FilePath in FilePaths do
    TFile.Delete(FilePath);
end;

class function TFileTools.GetFiles(const aDirectoryPath: string; const aAllDirectories: Boolean = True): TArray<string>;
begin
  if aAllDirectories then
    Result := TDirectory.GetFiles(aDirectoryPath, '*', TSearchOption.soAllDirectories)
  else
    Result := TDirectory.GetFiles(aDirectoryPath, '*', TSearchOption.soTopDirectoryOnly);
end;

class function TFileTools.CreateFileStream(const aFilePath: string): TFileStream;
begin
  Result := TFile.OpenRead(aFilePath);
end;

{ TColumnInfo }

constructor TColumnInfo.Create(const aIndex: Integer; const aTitle, aFieldName: string;
  const aDefaultWidth: Integer; const aAllowSort: Boolean);
begin
  Index := aIndex;
  Title := aTitle;
  FieldName := aFieldName;
  DefaultWidth := aDefaultWidth;
  AllowSort := aAllowSort;
end;

{ TColumnInfoHelper }

function TColumnInfoHelper.GetTitles: TArray<string>;
var
  ColumnInfo: TColumnInfo;
begin
  Result := [];

  for ColumnInfo in Self do
    Result := Result + [ColumnInfo.Title];
end;

function TColumnInfoHelper.GetDefaultWidths: TArray<Integer>;
var
  ColumnInfo: TColumnInfo;
begin
  Result := [];

  for ColumnInfo in Self do
    Result := Result + [ColumnInfo.DefaultWidth];
end;

function TColumnInfoHelper.IsSortColumn(const aIndex: Integer): Boolean;
var
  ColumnInfo: TColumnInfo;
begin
  Result := False;

  for ColumnInfo in Self do
    if (ColumnInfo.Index = aIndex) and ColumnInfo.AllowSort then
      Exit(True);
end;

function TColumnInfoHelper.GetFieldName(const aIndex: Integer): string;
var
  ColumnInfo: TColumnInfo;
begin
  Result := '';

  for ColumnInfo in Self do
    if ColumnInfo.Index = aIndex then
      Exit(ColumnInfo.FieldName);
end;

end.
