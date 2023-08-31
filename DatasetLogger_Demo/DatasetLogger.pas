unit DatasetLogger;
{*
It's intended to create JSON string records while performing CRUD operations on the dataset object.
If there's a need to track multiple datasets, the LoggerList singleton can be employed.
Alternatively, the TDatasetLogger can also be utilized as per your preference.
*}
interface

uses
   DB, System.Generics.Collections, Dialogs, Classes, Windows, JsonLog;

type
   TEventType = (etNone, etBeforeDelete, etBeforeEdit, etBeforeInsert, etBeforePost, etAfterDelete, etAfterEdit, etAfterInsert, etAfterPost);

   TLogEvent = (leNone, leDelete, leInsert, leEdit);

   TLogEventHelper = record helper for TLogEvent
      function toString: string;
   end;

   TDatasetEvents = class
      OldEvent: TDataSetNotifyEvent;
      NewEvent: TDataSetNotifyEvent;
   public
      class function New(OldEvent, NewEvent: TDataSetNotifyEvent): TDatasetEvents;
   end;

   TLogDetail = record
      event: TLogEvent;
      LotString: string;
   end;

   TDatasetLogger = class
      fDataset: TDataSet;
      eventList: TDictionary<TEventType, TDatasetEvents>;
      eventLog: TLogDetail;
      curEvent: TLogEvent;
      fLogValues: array[0..1] of string;
      function GenerateLogMsg: string;
   private
      procedure CommonEvent;
      procedure BeforeDelete(Dataset: TDataSet);
      procedure BeforeEdit(Dataset: TDataSet);
      procedure BeforeInsert(Dataset: TDataSet);
      procedure AfterInsert(Dataset: TDataSet);
      procedure AfterDelete(Dataset: TDataSet);
      procedure AfterEdit(Dataset: TDataSet);
      procedure BeforePost(Dataset: TDataSet);
      procedure AfterPost(Dataset: TDataSet);

      function ExecuteEvent(event: TEventType): Boolean;
      function GetDataset: TDataSet;

      procedure SetDataset(const Value: TDataSet);
      function GetLogLatest: string;
      function GetLogDetails: TLogDetail;
      property Dataset: TDataSet read GetDataset write SetDataset;

   public
      property Log: string read GetLogLatest;
      property LogDetails: TLogDetail read GetLogDetails;
      constructor Create(Dataset: TDataSet);
      destructor Destroy; override;
   end;

   TLoggerList = class
      fLoggers: TList<TDatasetLogger>;
      constructor Create;
      destructor Destroy; override;
   public
      procedure AddDataset(Dataset: TDataSet);
      function GetLog(Dataset: TDataSet): string;
      function GetLogDetails(Dataset: TDataSet): TLogDetail;
   end;

var
   LoggerList: TLoggerList;

implementation

class function TDatasetEvents.New(OldEvent, NewEvent: TDataSetNotifyEvent): TDatasetEvents;
begin
   Result := TDatasetEvents.Create;
   Result.OldEvent := OldEvent;
   Result.NewEvent := NewEvent;
end;

procedure TDatasetLogger.AfterDelete(Dataset: TDataSet);
begin
   ExecuteEvent(etAfterDelete);
end;

procedure TDatasetLogger.AfterEdit(Dataset: TDataSet);
begin
   ExecuteEvent(etAfterEdit);
end;

procedure TDatasetLogger.AfterInsert(Dataset: TDataSet);
begin
   ExecuteEvent(etAfterInsert);
end;

procedure TDatasetLogger.AfterPost(Dataset: TDataSet);
begin
   ExecuteEvent(etAfterPost);
end;

procedure TDatasetLogger.BeforeDelete(Dataset: TDataSet);
begin
   ExecuteEvent(etBeforeDelete);
end;

procedure TDatasetLogger.BeforeEdit(Dataset: TDataSet);
begin
   ExecuteEvent(etBeforeEdit);
end;

procedure TDatasetLogger.BeforeInsert(Dataset: TDataSet);
begin
   ExecuteEvent(etBeforeInsert);
end;

procedure TDatasetLogger.BeforePost(Dataset: TDataSet);
begin
   ExecuteEvent(etBeforePost);
end;

procedure TDatasetLogger.CommonEvent;
begin
   case curEvent of
      leNone:
         ;
      leDelete:
         begin

         end;

      leInsert:
         begin
            fLogValues[0] := TJSONLog.DataSetToJSONString(fDataset);
            fLogValues[1] := '';
         end;
      leEdit:
         begin
            fLogValues[1] := TJSONLog.DataSetToJSONString(fDataset);
         end;
   end;
   OutputDebugString(PWideChar(GenerateLogMsg));
end;

constructor TDatasetLogger.Create;
begin
   eventList := TDictionary<TEventType, TDatasetEvents>.Create;
   curEvent := leNone;
   Self.Dataset := Dataset;
end;

destructor TDatasetLogger.Destroy;
var
   tmpEvents: TDatasetEvents;
   tmpEventTypes: TEventType;
begin

   for tmpEventTypes in eventList.Keys do
   begin
      eventList.TryGetValue(tmpEventTypes, tmpEvents);

      case tmpEventTypes of
         etNone:
            ;
         etBeforeDelete:
            begin
               Dataset.BeforeDelete := tmpEvents.OldEvent;
            end;

         etBeforeEdit:
            begin
               Dataset.BeforeEdit := tmpEvents.OldEvent;
            end;
         etBeforeInsert:
            begin
               Dataset.BeforeInsert := tmpEvents.OldEvent;

            end;
         etBeforePost:
            begin
               Dataset.BeforePost := tmpEvents.OldEvent;

            end;
         etAfterDelete:
            begin
               Dataset.AfterDelete := tmpEvents.OldEvent;

            end;
         etAfterEdit:
            begin
               Dataset.AfterEdit := tmpEvents.OldEvent;

            end;
         etAfterInsert:
            begin
               Dataset.AfterInsert := tmpEvents.OldEvent;
            end;
         etAfterPost:
            begin
               Dataset.AfterPost := tmpEvents.OldEvent;
            end;
      end;
      eventList.Remove(tmpEventTypes);
      tmpEvents.Free;
   end;
   eventList.Clear;
   eventList.Free;
   inherited;
end;

function TDatasetLogger.ExecuteEvent(event: TEventType): Boolean;
var
   originalEvents: TDatasetEvents;
begin
   Result := True;

   if eventList.TryGetValue(event, originalEvents) then
      if Assigned(originalEvents.OldEvent) then
         originalEvents.OldEvent(Dataset);

   case event of
      etNone:
         ;
      etBeforeDelete:
         begin
            fLogValues[0] := TJSONLog.DataSetToJSONString(fDataset);
            fLogValues[1] := '';
         end;

      etBeforeEdit:
         begin
            fLogValues[0] := TJSONLog.DataSetToJSONString(fDataset);
            fLogValues[1] := '';
         end;

      etBeforeInsert:
         ;
      etBeforePost:
         begin

         end;

      etAfterDelete:
         begin
            curEvent := leDelete;
            CommonEvent;
         end;

      etAfterEdit:
         begin
            curEvent := leEdit;
         end;

      etAfterInsert:
         begin
            curEvent := leInsert;
         end;
      etAfterPost:
         begin
            CommonEvent;
            curEvent := leNone;
         end;
   end;

end;

function TDatasetLogger.GenerateLogMsg: string;
begin
   Result := '';

   case curEvent of
      leNone:
         ;
      leDelete:
         begin
            Result := fLogValues[0];
            eventLog.event := leDelete;
            eventLog.LotString := Result;
            Result := 'Deleted :' + #13#10 + Result;

         end;

      leInsert:
         begin
            Result := fLogValues[0];
            eventLog.event := leDelete;
            eventLog.LotString := Result;
            Result := 'Inserted :' + #13#10 + Result;
         end;

      leEdit:
         begin
            Result := fLogValues[0] + ',' + fLogValues[1];
            eventLog.event := leEdit;
            eventLog.LotString := Result;
            Result := 'Edited :' + #13#10 + Result;
         end;
   end;

end;

function TDatasetLogger.GetDataset: TDataSet;
begin
   Result := fDataset;
end;

function TDatasetLogger.GetLogDetails: TLogDetail;
begin
   Result := eventLog;
end;

function TDatasetLogger.GetLogLatest: string;
begin
   Result := eventLog.LotString;
end;

procedure TDatasetLogger.SetDataset(const Value: TDataSet);
begin
   fDataset := Value;
   if Assigned(fDataset.BeforeDelete) then
      eventList.add(etBeforeDelete, TDatasetEvents.New(fDataset.BeforeDelete, BeforeDelete));
   fDataset.BeforeDelete := BeforeDelete;
   if Assigned(fDataset.BeforeEdit) then
      eventList.add(etBeforeEdit, TDatasetEvents.New(fDataset.BeforeEdit, BeforeEdit));
   fDataset.BeforeEdit := BeforeEdit;
   if Assigned(fDataset.BeforeInsert) then
      eventList.add(etBeforeInsert, TDatasetEvents.New(fDataset.BeforeInsert, BeforeInsert));
   fDataset.BeforeInsert := BeforeInsert;
   if Assigned(fDataset.AfterDelete) then
      eventList.add(etAfterDelete, TDatasetEvents.New(fDataset.AfterDelete, BeforeInsert));
   fDataset.AfterDelete := AfterDelete;
   if Assigned(fDataset.AfterEdit) then
      eventList.add(etAfterEdit, TDatasetEvents.New(fDataset.AfterEdit, AfterDelete));
   fDataset.AfterEdit := AfterEdit;
   if Assigned(fDataset.AfterInsert) then
      eventList.add(etAfterInsert, TDatasetEvents.New(fDataset.AfterInsert, AfterEdit));
   fDataset.AfterInsert := AfterInsert;
   if Assigned(fDataset.BeforePost) then
      eventList.add(etBeforePost, TDatasetEvents.New(fDataset.BeforePost, BeforePost));
   fDataset.BeforePost := BeforePost;
   if Assigned(fDataset.AfterPost) then
      eventList.add(etAfterPost, TDatasetEvents.New(fDataset.AfterPost, AfterPost));
   fDataset.AfterPost := AfterPost;
end;

{ TLoggerList }

procedure TLoggerList.AddDataset(Dataset: TDataSet);
begin
   if not Assigned(LoggerList) then
      LoggerList := TLoggerList.Create;
   LoggerList.fLoggers.Add(TDatasetLogger.Create(Dataset));
end;

constructor TLoggerList.Create;
begin
   fLoggers := TList<TDatasetLogger>.Create;
end;

destructor TLoggerList.Destroy;
var
   tmpLogger: TDatasetLogger;
begin
   for tmpLogger in fLoggers do
   begin
      tmpLogger.Free;
   end;
   fLoggers.Clear;
   fLoggers.Free;
   inherited;
end;

function TLoggerList.GetLog(Dataset: TDataSet): string;
var
   tmpDatasetLogger: TDatasetLogger;
begin
   Result := '';
   for tmpDatasetLogger in Self.fLoggers do
   begin
      if tmpDatasetLogger.Dataset = Dataset then
         Result := tmpDatasetLogger.Log;
   end;
end;

function TLoggerList.GetLogDetails(Dataset: TDataSet): TLogDetail;
var
   tmpDatasetLogger: TDatasetLogger;
begin
   Result.event := leNone;
   Result.LotString := '';
   for tmpDatasetLogger in Self.fLoggers do
   begin
      if tmpDatasetLogger.Dataset = Dataset then
         Result := tmpDatasetLogger.LogDetails;
   end;
end;

{ TLogEventHelper }

function TLogEventHelper.toString: string;
begin
   case Self of
      leNone:
         Result := 'None';
      leDelete:
         Result := 'Delete';
      leInsert:
         Result := 'Insert';
      leEdit:
         Result := 'Edit';
   end;
end;

initialization
   LoggerList := TLoggerList.Create;


finalization
   LoggerList.Free;

end.

