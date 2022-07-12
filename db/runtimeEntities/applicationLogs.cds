using {
    GUID,
    Environment,
    Version,
    Process,
    Activity,
    Function,
    Field,
    Check,
    SField,
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
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
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
        parameters    : Parameters;
        selections    : Selections;
        businessEvent : BusinessEvent;
        field         : Field;
        check         : Check;
        conversion    : Conversion;
        partition     : Partition;
        package       : Package;
        state         : Association to one ApplicationLogStates @title     : 'State';
        messages      : Composition of many ApplicationLogMessages
                            on messages.applicationLog = $self  @title     : 'Messages';
}

entity ApplicationLogMessages : managed {
    key ID             : GUID                                          @UI.Hidden : false;
        applicationLog : Association to one ApplicationLogs            @title     : 'Log';
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

entity ApplicationChecks : managed {
    key ID          : GUID                                          @UI.Hidden : false;
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

// entity ApplicationFields : managed, formulaGroupOrder {
//     key ID          : GUID @UI.Hidden : false;
//         environment : Environment;
//         version     : Version;
//         process     : Process;
//         activity    : Activity;
//         sField      : SField;
//         field       : Field;
//         step        : Step;
//         selections  : Composition of many ApplicationFieldSelections
//                           on selections.applicationField = $self;
// }

// entity ApplicationFieldSelections : managed, selection {
//     key ID               : GUID @UI.Hidden : false;
//         applicationField : Association to one ApplicationFields;
// }

type MessageDetails : LargeString @title : 'Message Details';
type Argument1 : String @title : 'Argument 1';
type Argument2 : Argument1 @title : 'Argument 1';
type Argument3 : Argument1 @title : 'Argument 1';
type Argument4 : Argument1 @title : 'Argument 1';
type Argument5 : Argument1 @title : 'Argument 1';
type Argument6 : Argument1 @title : 'Argument 1';
type Statement : LargeString @title : 'Statement';
type Entity : String @title : 'Entity';
type Args : LargeString @title : 'Arguments';
type Target : String @title : 'Target';
type MessageCode : String @title : 'Code';
type Parameters : LargeString @title : 'Parameters';
type Selections : LargeString @title : 'Selections';
type ApplicationLogType : String @title : 'Type';

type ApplicationLogState @(assert.range) : String(10) enum {
    Running = 'Running';
    OK      = 'OK';
    Warning = 'Warning';
    Error   = 'Error';
    Abort   = 'Abort';
}

entity ApplicationLogStates : CodeList {
    key code : ApplicationLogState default 'OK';
}

type ApplicationLogMessageType @(assert.range) : String(10) enum {
    Info    = 'I';
    Status  = 'S';
    Warning = 'W';
    Error   = 'E';
    Abort   = 'A';
}

entity ApplicationLogMessageTypes : CodeList {
    key code : ApplicationLogMessageType default 'I';
}
