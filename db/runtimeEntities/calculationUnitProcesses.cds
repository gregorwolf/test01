using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
    Description,
    Process,
    Activity,
    Report,
    Element,
    Sequence,
    Environment,
    Version,
    Function,
    PerformerGroup,
    ReviewerGroup,
    StartDate,
    DueDate,
    Url,
    Content,
    CalculationCode,
} from '../commonTypes';
using {function} from '../commonAspects';
using {Functions} from '../functions';


entity CalculationUnitProcesses : managed {
    key ID          : GUID;
        environment : Environment;
        version     : Version;
        process     : Process;
        type        : Association to one CalculationUnitProcessTypes;
        state       : Association to one CalculationUnitProcessStates;
        description : Description;
        activities  : Composition of many CalculationUnitProcessActivities
                          on activities.process = $self;

}

entity CalculationUnitProcessActivities : managed, function {
    key ID             : GUID;
        process        : Association to one CalculationUnitProcesses;
        activity       : Activity;
        parent         : Association to one CalculationUnitProcessActivities     @title : 'Parent';
        sequence       : Sequence;
        activityType   : Association to one CalculationUnitProcessActivityTypes  @title : 'Type';
        activityState  : Association to one CalculationUnitProcessActivityStates @title : 'State';
        function       : Function                                                @title : 'Function';
        performerGroup : PerformerGroup;
        reviewerGroup  : ReviewerGroup;
        startDate      : StartDate;
        endDate        : DueDate;
        url            : Url;
}

entity CalculationUnitProcessActivityLinks : managed, function {
    key ID               : GUID;
        process          : Association to one CalculationUnitProcesses;
        activity         : Association to one CalculationUnitProcessActivities @title : 'Activity';
        previousActivity : Association to one CalculationUnitProcessActivities @title : 'Previous Activity';
}

entity CalculationUnitProcessReports : managed, function {
    key ID              : GUID;
        process         : Association to one CalculationUnitProcesses;
        report          : Report;
        sequence        : Sequence;
        description     : Description;
        content         : Content;
        calculationCode : CalculationCode;
}

entity CalculationUnitProcessReportElements : managed, function {
    key ID          : GUID;
        report      : Association to one CalculationUnitProcessReports;
        element     : Element;
        description : Description;
        content     : Content;
}

type CalculationUnitProcessType @(assert.range) : String @title : 'Type' enum {
    Run        = 'RUN';
    Simulation = 'SIMULATION';
}

entity CalculationUnitProcessTypes : CodeList {
    key code : CalculationUnitProcessType default 'SIMULATION';
}

type CalculationUnitProcessState @(assert.range) : String @title : 'State' enum {
    Inactive  = '';
    Active    = 'ACTIVE';
    Open      = 'OPEN';
    Deployed  = 'DEPLOYED';
    //    Suspended = 'SUSPENDED'; "Open" should be enough
    Completed = 'COMPLETED';
    Aborted   = 'ABORTED';
}

entity CalculationUnitProcessStates : CodeList {
    key code : CalculationUnitProcessState default '';
}

type CalculationUnitProcessActivityType @(assert.range) : String @title : 'Type' enum {
    Execution   = 'EXECUTION';
    InputOutput = 'IO';
    Node        = 'NODE';
    Url         = 'URL';
}

entity CalculationUnitProcessActivityTypes : CodeList {
    key code : CalculationUnitProcessActivityType default 'OPEN';
}

type CalculationUnitProcessActivityState @(assert.range) : String @title : 'State' enum {
    Open       = 'OPEN';
    Pending    = 'PENDING';
    InApproval = 'APPROVAL';
    Completed  = 'COMPLETED';
}

entity CalculationUnitProcessActivityStates : CodeList {
    key code : CalculationUnitProcessActivityState default 'OPEN';
}
