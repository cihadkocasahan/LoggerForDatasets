object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 583
  ClientWidth = 939
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 939
    Height = 583
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 0
    object Memo2: TMemo
      Left = 1
      Top = 137
      Width = 937
      Height = 445
      Align = alClient
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 937
      Height = 136
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 111
        Width = 937
        Height = 25
        DataSource = DataSource1
        Align = alBottom
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 265
        Top = 0
        Width = 672
        Height = 111
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 265
        Height = 111
        Align = alLeft
        TabOrder = 2
        object Label3: TLabel
          Left = 16
          Top = 50
          Width = 48
          Height = 13
          Caption = 'SURNAME'
          FocusControl = cxDBTextEdit2
        end
        object Label2: TLabel
          Left = 16
          Top = 22
          Width = 28
          Height = 13
          Caption = 'NAME'
          FocusControl = cxDBTextEdit1
        end
        object cxDBTextEdit1: TcxDBTextEdit
          Left = 94
          Top = 18
          DataBinding.DataField = 'NAME'
          DataBinding.DataSource = DataSource1
          TabOrder = 0
          Width = 147
        end
        object cxDBTextEdit2: TcxDBTextEdit
          Left = 94
          Top = 46
          DataBinding.DataField = 'SURNAME'
          DataBinding.DataSource = DataSource1
          TabOrder = 1
          Width = 147
        end
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = FDMemTable1
    Left = 424
    Top = 163
  end
  object FDMemTable1: TFDMemTable
    Active = True
    AfterPost = FDMemTable1AfterPost
    AfterDelete = FDMemTable1AfterDelete
    FieldDefs = <
      item
        Name = 'NAME'
        DataType = ftWideString
        Size = 50
      end
      item
        Name = 'SURNAME'
        DataType = ftWideString
        Size = 50
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 2147483647
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 488
    Top = 160
    Content = {
      414442530F006A482D010000FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C006500310005000A0000005400610062006C0065
      00060000000000070000080032000000090000FF0AFF0B0400080000004E0041
      004D0045000500080000004E0041004D0045000C00010000000E000D000F0032
      0000001000011100011200011300011400011500011600080000004E0041004D
      004500170032000000FEFF0B04000E0000005300550052004E0041004D004500
      05000E0000005300550052004E0041004D0045000C00020000000E000D000F00
      3200000010000111000112000113000114000115000116000E00000053005500
      52004E0041004D004500170032000000FEFEFF18FEFF19FEFF1AFEFEFEFF1BFE
      FF1C1D000E000000FF1EFEFEFE0E004D0061006E0061006700650072001E0055
      0070006400610074006500730052006500670069007300740072007900120054
      00610062006C0065004C006900730074000A005400610062006C00650008004E
      0061006D006500140053006F0075007200630065004E0061006D0065000A0054
      006100620049004400240045006E0066006F0072006300650043006F006E0073
      0074007200610069006E00740073001E004D0069006E0069006D0075006D0043
      006100700061006300690074007900180043006800650063006B004E006F0074
      004E0075006C006C00140043006F006C0075006D006E004C006900730074000C
      0043006F006C0075006D006E00100053006F0075007200630065004900440018
      0064007400570069006400650053007400720069006E00670010004400610074
      00610054007900700065000800530069007A0065001400530065006100720063
      006800610062006C006500120041006C006C006F0077004E0075006C006C0008
      00420061007300650014004F0041006C006C006F0077004E0075006C006C0012
      004F0049006E0055007000640061007400650010004F0049006E005700680065
      00720065001A004F0072006900670069006E0043006F006C004E0061006D0065
      00140053006F007500720063006500530069007A0065001C0043006F006E0073
      0074007200610069006E0074004C00690073007400100056006900650077004C
      006900730074000E0052006F0077004C006900730074001800520065006C0061
      00740069006F006E004C006900730074001C0055007000640061007400650073
      004A006F00750072006E0061006C001200530061007600650050006F0069006E
      0074000E004300680061006E00670065007300}
    object FDMemTable1NAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 50
    end
    object FDMemTable1SURNAME: TWideStringField
      FieldName = 'SURNAME'
      Origin = 'SURNAME'
      Size = 50
    end
  end
  object FDStanStorageXMLLink1: TFDStanStorageXMLLink
    Left = 568
    Top = 168
  end
end
