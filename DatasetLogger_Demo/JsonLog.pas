unit JsonLog;

interface
{*
DataSetToJSONString
Prepared for instant export of records in TDataset as JSON
USAGE
var
str:String;
str:=TJSONLog.DataSetToJSONString(Adoquery1);


JSONStringToDataSet
It can be used to transfer dataset of previously retrieved JSonString data

*}

uses
   System.SysUtils, System.JSON, System.Classes, Data.DB, FireDAC.Comp.Client, Variants;

type
   TJSONLog = class
      class function DataSetToJSONString(DataSet: TDataSet): string; static;
      class function JSONStringToDataSet(const JsonString: string; DataSet: TDataSet): Boolean; static;
   public
      destructor Destroy; override;
   end;

implementation


{ TJSONHelper }

function GetVariantTypeAsFieldType(const V: Variant): TFieldType;
begin
   case VarType(V) of
      varSmallint, varInteger, varByte, varWord, varLongWord:
         Result := ftInteger;
      varSingle, varDouble, varCurrency:
         Result := ftFloat;
      varDate:
         Result := ftDateTime;
      varBoolean:
         Result := ftBoolean;
      varString, varUString, varOleStr:
         Result := ftString;
      varNull:
         Result := ftUnknown;
   else
      Result := ftUnknown;
   end;
end;

class function TJSONLog.DataSetToJSONString(DataSet: TDataSet): string;
var
   Field: TField;
   Row: TJSONObject;
   Rows: TJSONArray;
begin
   Rows := TJSONArray.Create;
   try
      try
         Row := TJSONObject.Create;
         try
            for Field in DataSet.Fields do
            begin
               if not Field.IsNull then
                  Row.AddPair(Field.FieldName, Field.AsVariant);
            end;
            Rows.AddElement(Row);
         except
            Row.Free;
            raise;
         end;
         Result := Rows.ToString;
      except
         Rows.Free;
         raise;
      end;

   finally
      Rows.Free;
   end;

end;

destructor TJSONLog.Destroy;
begin
   Self.DisposeOf;
   inherited;
end;

class function TJSONLog.JSONStringToDataSet(const JSONString: string; DataSet: TDataSet): Boolean;
var
   JSONArray: TJSONArray;
   Row: TJSONObject;
   FieldName, FieldValue: string;
   FDJSONValue: TJSONValue;
   i: Integer;
begin
   Result := True;
   Row := nil;
   FDJSONValue := TJSONObject.ParseJSONValue(JSONString);
   JSONArray := TJSONArray(TJSONObject.ParseJSONValue(FDJSONValue.ToJSON));
   try
      DataSet.DisableControls;
      if not (DataSet.Active) then
         DataSet.Open
      else
         while DataSet.RecordCount > 0 do
            DataSet.Delete;

      if JSONArray.Count > 0 then
      begin
         Row := JSONArray.Items[0] as TJSONObject;
         for i := 0 to Row.Count - 1 do
         begin
            FieldName := Row.Pairs[i].JSONString.Value;
            FieldValue := Row.Pairs[i].JSONValue.Value;
            DataSet.Append;
            DataSet.FieldByName('ID').AsInteger := i + 1;
            DataSet.FieldByName('FIELDVALUE').AsString := FieldValue;
            DataSet.Post;
         end;
      end;
   finally
      DataSet.First;
      DataSet.EnableControls;
      FDJSONValue.Free;
      JSONArray.Free;
      Row.Free;
   end;
end;

end.

