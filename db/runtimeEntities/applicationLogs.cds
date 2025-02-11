using {
    GUID,
    Environment,
    Version,
    Process,
    Activity,
    Function,
    Field,
    Check,
    Step,
    Conversion,
    Partition,
    Connection,
    Run,
    MainFunction,
    Package,
    Message,
    PrimaryKey,
    BusinessEvent,
    Statement,
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
    formula,
} from '../commonAspects';

using {CheckCategories} from '../checks';

using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    sap.common.CodeList,
} from '@sap/cds/common';

entity ApplicationLogs : managed {
    key ID            : GUID                                    @UI.Hidden : false;
        run           : Run;
        type          : ApplicationLogType;
        environment   : Environment;
        version       : Version;
        process       : Process;
        activity      : Activity;
        mainFunction  : MainFunction;
        businessEvent : BusinessEvent;
        field         : Field;
        check         : Check;
        conversion    : Conversion;
        partition     : Partition;
        package       : Package;
        state         : Association to one ApplicationLogStates @title     : 'State';
        messages      : Composition of many ApplicationLogMessages
                            on messages.log = $self             @title     : 'Messages';
        statistics    : Composition of many ApplicationLogStatistics
                            on statistics.log = $self           @title     : 'Statistics';
}

entity ApplicationLogStatistics : managed {
    key ID                 : GUID                               @UI.Hidden : false;
        log                : Association to one ApplicationLogs @title     : 'Log';
        function           : Function;
        startTimestamp     : StartTimestamp;
        endTimestamp       : EndTimestamp;
        inputRecords       : InputRecords;
        resultRecords      : ResultRecords;
        successRecords     : SuccessRecords;
        warningRecords     : WarningRecords;
        errorRecords       : ErrorRecords;
        abortRecords       : AbortRecords;
        inputDuration      : InputDuration;
        processingDuration : ProcessingDuration;
        outputDuration     : OutputDuration;

}

type StartTimestamp : Timestamp @title : 'Start Timestamp (UTC)';
type EndTimestamp : Timestamp @title : 'End Timestamp (UTC)';
type InputRecords : Integer64 @title : 'Input Records';
type ResultRecords : Integer64 @title : 'Output Records';
type SuccessRecords : Integer64 @title : 'Success Records';
type WarningRecords : Integer64 @title : 'Warning Records';
type ErrorRecords : Integer64 @title : 'Error Records';
type AbortRecords : Integer64 @title : 'Abort Records';
type InputDuration : Decimal @title : 'Input Reading Duration (s)';
type ProcessingDuration : Decimal @title : 'Processing Duration (s)';
type OutputDuration : Decimal @title : 'Output Writing Duration (s)';

entity ApplicationLogMessages : managed {
    key ID             : GUID                                          @UI.Hidden : false;
        log            : Association to one ApplicationLogs            @title     : 'Log';
        type           : Association to one ApplicationLogMessageTypes @title     : 'Type';
        function       : Function;
        code           : MessageCode; // e.g. "ENVTYPE_CHANGE_NOT_ALLOWED", if this is given the message will be translated including args
        entity         : Entity; // table or view
        primaryKey     : PrimaryKey; // primary key in JSON field-value format, e.g. {ID: 'X', CLIENT: '100'}
        target         : Target; // Field
        argument1      : Argument1;
        argument2      : Argument2;
        argument3      : Argument3;
        argument4      : Argument4;
        argument5      : Argument5;
        argument6      : Argument6;
        messageDetails : MessageDetails;
}

entity ApplicationLogChecks : managed {
    key ID          : GUID                                          @UI.Hidden : false;
        log         : Association to one ApplicationLogs            @title     : 'Log';
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        function    : Function;
        check       : Check;
        type        : Association to one ApplicationLogMessageTypes @title     : 'Type';
        message     : Message                                       @mandatory; // usually english, e.g. "HANA run out of memory"
        // category    : Association to one CheckCategories            @title     : 'Category';
        statement   : Statement;
}

entity ApplicationLogFields : managed, formula {
    key ID          : GUID                               @UI.Hidden : false;
        log         : Association to one ApplicationLogs @title     : 'Log';
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        field       : Field;
        selections  : Composition of many ApplicationLogFieldSelections
                          on selections.logField = $self;
}

entity ApplicationLogFieldSelections : managed, selection {
    key ID          : GUID                               @UI.Hidden : false;
        log         : Association to one ApplicationLogs @title     : 'Log';
        logField    : Association to one ApplicationLogFields;
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        field       : Field;
}

type MessageDetails : LargeString @title : 'Message Details';
type Argument1 : String @title : 'Argument 1';
type Argument2 : Argument1 @title : 'Argument 1';
type Argument3 : Argument1 @title : 'Argument 1';
type Argument4 : Argument1 @title : 'Argument 1';
type Argument5 : Argument1 @title : 'Argument 1';
type Argument6 : Argument1 @title : 'Argument 1';
type Entity : String @title : 'Entity';
type Args : LargeString @title : 'Arguments';
type Target : String @title : 'Target';
type MessageCode : String @title : 'Code';
type Parameters : LargeString @title : 'Parameters';
type Selections : LargeString @title : 'Selections';
type ApplicationLogType : String @title : 'Type';

type ApplicationLogState @(assert.range) : String(10) enum {
    Running = 'RUNNING';
    OK      = 'OK';
    Warning = 'WARNING';
    Error   = 'ERROR';
    Abort   = 'ABORT';
}

entity ApplicationLogStates : CodeList {
    key code : ApplicationLogState default 'OK';
}

type ApplicationLogMessageType @(assert.range) : String(10) enum {
    Status  = 'S';
    Warning = 'W';
    Error   = 'E';
    Abort   = 'A';
}

entity ApplicationLogMessageTypes : CodeList {
    key code : ApplicationLogMessageType default 'I';
}
