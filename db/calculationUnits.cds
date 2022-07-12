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
    PerformerGroup,
    ReviewerGroup,
    StartDate,
    DueDate,
    Url,
    Content,
    CalculationCode,
} from './commonTypes';
using {function} from './commonAspects';
using {Functions} from './functions';
using {Checks} from './checks';

entity CalculationUnits : managed, function {
    key ID        : GUID @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        processes : Composition of many CalculationUnitProcessTemplates
                        on processes.CalculationUnit = $self;
}

entity CalculationUnitProcessTemplates : managed, function {
    key ID              : GUID;
        CalculationUnit : Association to one CalculationUnits;
        process         : Process;
        sequence        : Sequence default 10;
        type            : Association to one CalculationUnitProcessTemplateTypes;
        state           : Association to one CalculationUnitProcessTemplateStates;
        description     : Description;
        activities      : Composition of many CalculationUnitProcessTemplateActivities
                              on activities.process = $self;

}

entity CalculationUnitProcessTemplateActivities : managed, function {
    key ID             : GUID;
        process        : Association to one CalculationUnitProcessTemplates;
        activity       : Activity;
        parent         : Association to one CalculationUnitProcessTemplateActivities     @title : 'Parent';
        sequence       : Sequence;
        activityType   : Association to one CalculationUnitProcessTemplateActivityTypes  @title : 'Type';
        activityState  : Association to one CalculationUnitProcessTemplateActivityStates @title : 'State';
        function       : Association to one Functions                                    @title : 'Function';
        performerGroup : PerformerGroup;
        reviewerGroup  : ReviewerGroup;
        startDate      : StartDate;
        endDate        : DueDate;
        url            : Url;
        checks         : Composition of many CalculationUnitProcessTemplateActivityChecks
                             on checks.activity = $self;
}

entity CalculationUnitProcessTemplateActivityLinks : managed, function {
    key ID               : GUID;
        process          : Association to one CalculationUnitProcessTemplates;
        activity         : Association to one CalculationUnitProcessTemplateActivities @title : 'Activity';
        previousActivity : Association to one CalculationUnitProcessTemplateActivities @title : 'Previous Activity';
}

entity CalculationUnitProcessTemplateActivityChecks : managed, function {
    key ID       : GUID;
        activity : Association to one CalculationUnitProcessTemplateActivities;
        check    : Association to one Checks;
}

entity CalculationUnitProcessTemplateReports : managed, function {
    key ID              : GUID;
        process         : Association to one CalculationUnitProcessTemplates;
        report          : Report;
        sequence        : Sequence;
        description     : Description;
        content         : Content;
        calculationCode : CalculationCode;
}

entity CalculationUnitProcessTemplateReportElements : managed, function {
    key ID          : GUID;
        report      : Association to one CalculationUnitProcessTemplateReports;
        element     : Element;
        description : Description;
        content     : Content;
}

type CalculationUnitProcessTemplateType @(assert.range) : String @title : 'Type' enum {
    Run        = 'RUN';
    Simulation = 'SIMULATION';
}

entity CalculationUnitProcessTemplateTypes : CodeList {
    key code : CalculationUnitProcessTemplateType default 'SIMULATION';
}

type CalculationUnitProcessTemplateState @(assert.range) : String @title : 'State' enum {
    Inactive = '';
    Active   = 'ACTIVE';
}

entity CalculationUnitProcessTemplateStates : CodeList {
    key code : CalculationUnitProcessTemplateState default '';
}


type CalculationUnitProcessTemplateActivityType @(assert.range) : String @title : 'Type' enum {
    Execution   = 'EXECUTION';
    InputOutput = 'IO';
    Node        = 'NODE';
    Url         = 'URL';
}

entity CalculationUnitProcessTemplateActivityTypes : CodeList {
    key code : CalculationUnitProcessTemplateActivityType default 'OPEN';
}

type CalculationUnitProcessTemplateActivityState @(assert.range) : String @title : 'State' enum {
    Open       = 'OPEN';
    Pending    = 'PENDING';
    InApproval = 'APPROVAL';
    Completed  = 'COMPLETED';
}

entity CalculationUnitProcessTemplateActivityStates : CodeList {
    key code : CalculationUnitProcessTemplateActivityState default 'OPEN';
}
