using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

type BusinessEvent : String @title : 'Business Event';
type PrimaryKey : String @title : 'Primary Key'; // Primary key in JSON format, e.g. {ID: 123; CLIENT: 'ABC'}
type Message : String @title : 'Messsage';
type MainFunction : Function @title : 'Main Version';
type Package : String @title : 'Package';
type Run : GUID @title : 'Run ID'  @UI.Hidden : false;
type GUID : UUID @odata.Type : 'Edm.String'  @UI.Hidden;
type Environment : String @title : 'Environment'  @assert.format : '[A-Z,0-9,_]{3}'  @Common.IsUpperCase;
type Version : String @title : 'Version'  @assert.format : '(^$|[A-Z,0-9,_]{4})'  @Common.IsUpperCase;
type Function : String @title : 'Function'  @assert.format : '[A-Z,0-9,_]{1,5}'  @Common.IsUpperCase;
type Field : String @title : 'Field'  @assert.format : '[A-Z,0-9,_]{1,30}'  @Common.IsUpperCase;
type Connection : String @title : 'Connection'  @assert.format : '[A-Z,0-9,_]{1,30}'  @Common.IsUpperCase;
type Partition : String @title : 'Partition'  @assert.format : '[A-Z,0-9,_]{1,20}'  @Common.IsUpperCase;
type Process : String @title : 'Process'  @assert.format : '[A-Z,0-9,_]{1,7}'  @Common.IsUpperCase;
type Activity : String @title : 'Activity'  @assert.format : '[A-Z,0-9,_]{1,7}'  @Common.IsUpperCase;
type Report : String @title : 'Report'  @assert.format : '[A-Z,0-9,_]{1,20}'  @Common.IsUpperCase;
type Element : String @title : 'Element'  @assert.format : '[A-Z,0-9,_]{1,7}'  @Common.IsUpperCase;
type Conversion : String @title : 'Conversion'  @assert.format : '[A-Z,0-9,_]{1,10}'  @Common.IsUpperCase;
type Description : String @title : 'Description'  @mandatory  @assert.notNull; //  @Core.Immutable woud bring it up in creation popup as well
type Documentation : LargeString @title : 'Documentation';
type Step : Integer @title : 'Step';
type Sequence : Integer @title : 'Sequence';
type Rule : String @title : 'Rule'  @assert.format : '[A-Z,0-9,_]{1,5}'  @Common.IsUpperCase;
type ParentRule : Rule @title : 'Parent Rule';
type IncludeInputData : Boolean @title : 'Include original Input Data';
type IncludeInitialResult : Boolean @title : 'Include initial Results';
type Content : LargeString @title : 'Content';
type CalculationCode : LargeString @title : 'Code';
type PerformerGroup : String @title : 'Performer Group';
type ReviewerGroup : String @title : 'Reviewer Group';
type StartDate : String @title : 'Start Date';
type DueDate : String @title : 'Due Date';
type Url : String @title : 'URL';
type Formula : String @title : 'Formula';
type Name : String @title : 'Name';
type File : LargeBinary @title : 'File';
type Comment : LargeString @title : 'Comment';

type MessageType @(assert.range) : String(1) @title : 'Message type' enum {
    Info    = 'I';
    Success = 'S';
    Warning = 'W';
    Error   = 'E';
    Abort   = 'A';
}

entity MessageTypes : CodeList {
    key code : MessageType default 'I';
}

type Check : String @title : 'Check'  @assert.format : '[A-Z,0-9,_]{1,30}';


type Sfield @(assert.range) : String(18) @title : 'Subset' enum {
    Selection        = 'SEL';
    Action           = 'ACTION';
    SelectionFields  = 'SEL_FIELDS';
    ActionFields     = 'ACTION_FIELDS';
    Sender           = 'SENDER_FIELD_MAP';
    SenderRuleAction = 'SRULE_ACTION';
    SenderRule       = 'SRULE_FIELD_MAP';
}

entity Sfields : CodeList {
    key code : Sfield;
}

type Group @(assert.range) : String(10) @title : 'Grouping' enum {
    Field   = '';
    group   = 'GROUP';
    NotUsed = 'NOT USED';
};

entity Groups : CodeList {
    key code : Group default '';
}

type Order @(assert.range) : String(10) @title : 'Ordering' enum {
    NoOrder    = '';
    Ascending  = 'ASC';
    Descending = 'DESC';
};

entity Orders : CodeList {
    key code : Order default '';
}

type Sign @(assert.range) : String(1) @title : 'Sign' enum {
    Include = 'I';
    Exclude = 'E';
}

entity Signs : CodeList {
    key code : Sign default 'I';
}

type Option @(assert.range) : String(2) @title : 'Option' enum {
    /**
     * Value is equal to the value in field LOW
     */
    Equal              = 'EQ';
    /**
     * Value is not equal to the value in field LOW
     */
    NotEqual           = 'NE';
    /**
     * Value is between the value in field LOW and the value in
     * field HIGH (including the boundaries)
     */
    Between            = 'BT';
    /**
     * Value is not between the value in field LOW and the value in
     * field HIGH (including the boundaries)
     */
    NotBetween         = 'NB';
    /**
     * Value is less than or equals the value in field LOW
     */
    LessThanOrEqual    = 'LE';
    /**
     * Value is greater than the value in field LOW
     */
    GreaterThan        = 'GT';
    /**
     * Value is greater than or equals the value in field LOW
     */
    GreaterThanOrEqual = 'GE';
    /**
     * Value is less than the value in field LOW
     */
    LessThan           = 'LT';
    /**
     * Masked input: Find pattern
     */
    ContainsPattern    = 'CP';
    /**
     * Masked input: Reject pattern
     */
    NotContainsPattern = 'NP';
}

entity Options : CodeList {
    key code : Option default 'EQ';
}

type ResultHandling @(assert.range) : String(10) @title : 'Result Handling' enum {
    IncludeEnrichedData    = 'ENRICHED';
    IncludeAllData         = 'ALL';
    ErrorOnNotEnrichedData = 'ERROR';
    AbortOnNotEnrichedData = 'ABORT';
}

entity ResultHandlings : CodeList {
    key code : ResultHandling default 'ENRICHED';
}


type IsActive : Boolean @title : 'Active';
type Value : String @title : 'Value';
type Statement : LargeString @title : 'Statement';
