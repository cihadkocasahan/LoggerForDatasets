unit uMain;

interface

uses
   winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
   Vcl.Forms, Vcl.Dialogs, Data.DB, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
   dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
   dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary,
   dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark,
   dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
   dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
   dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark, dxSkinPumpkin,
   dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
   dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters, dxSkinValentine,
   dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
   dxSkinXmas2008Blue, Data.Win.ADODB, cxDBEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, Vcl.DBCtrls, Vcl.StdCtrls,
   Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, DatasetLogger, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
   FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet,
   FireDAC.Comp.Client, FireDAC.Stan.StorageXML, IOUtils;

type
   TForm1 = class(TForm)
      Panel2: TPanel;
      Memo2: TMemo;
      Panel1: TPanel;
      DBNavigator1: TDBNavigator;
      DataSource1: TDataSource;
      FDMemTable1: TFDMemTable;
      FDStanStorageXMLLink1: TFDStanStorageXMLLink;
      FDMemTable1NAME: TWideStringField;
      FDMemTable1SURNAME: TWideStringField;
      DBGrid1: TDBGrid;
      Panel3: TPanel;
      Label3: TLabel;
      Label2: TLabel;
      cxDBTextEdit1: TcxDBTextEdit;
      cxDBTextEdit2: TcxDBTextEdit;
      procedure FormCreate(Sender: TObject);
      procedure FDMemTable1AfterPost(DataSet: TDataSet);
      procedure FDMemTable1AfterDelete(DataSet: TDataSet);
   private
      procedure LogToMemo;
   public
    { Public declarations }
   end;

var
   Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FDMemTable1AfterDelete(DataSet: TDataSet);
begin
   LogToMemo;
end;

procedure TForm1.FDMemTable1AfterPost(DataSet: TDataSet);
begin
   LogToMemo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

   if not FileExists('testdata.xml') then
   begin
      ShowMessage('Sample Data Not Found,Please Configure FDMemtable1''s Data');
      Exit;
   end;
   FDMemTable1.LoadFromFile('testdata.xml', sfXML);
   LoggerList.AddDataset(FDMemTable1);
end;

procedure TForm1.LogToMemo;
begin
   Memo2.lines.add(LoggerList.GetLogDetails(FDMemTable1).event.toString + LoggerList.GetLog(FDMemTable1));
   FDMemTable1.SaveToFile('testdata.xml', sfXML);
end;

end.

