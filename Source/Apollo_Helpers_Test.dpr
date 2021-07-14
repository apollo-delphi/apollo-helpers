program Apollo_Helpers_Test;

{$STRONGLINKTYPES ON}
uses
  Vcl.Forms,
  System.SysUtils,
  DUnitX.Loggers.GUI.VCL,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  tstApollo_Helpers in 'tstApollo_Helpers.pas',
  Apollo_Helpers in 'Apollo_Helpers.pas',
  Apollo_Types in '..\Vendors\Apollo_Types\Apollo_Types.pas';

begin
  Application.Initialize;
  Application.Title := 'DUnitX';
  Application.CreateForm(TGUIVCLTestRunner, GUIVCLTestRunner);
  Application.Run;
end.
