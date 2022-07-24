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
    Name,
    Comment,
    File,
} from '../commonTypes';
using {RuntimeFunctionInputFunctions} from './runTypes';
using {Teams} from './Teams';

entity CuProcesses : managed {
    key ID          : GUID;
        environment : Environment;
        version     : Version;
        process     : Process;
        type        : Association to one CuProcessTypes  @title : 'Type';
        state       : Association to one CuProcessStates @title : 'State';
        description : Description;
        activities  : Composition of many CuProcessActivities
                          on activities.process = $self  @title : 'Activities';
}

entity CuProcessActivities : managed {
    key ID             : GUID;
        process        : Association to one CuProcesses                   @title : 'Process';
        activity       : Activity;
        parent         : Association to one CuProcessActivities           @title : 'Parent';
        sequence       : Sequence;
        activityType   : Association to one CuProcessActivityTypes        @title : 'Type';
        activityState  : Association to one CuProcessActivityStates       @title : 'State';
        function       : Association to one RuntimeFunctionInputFunctions @title : 'Function';
        performerTeams : Composition of many CuProcessActivityPerformerTeams
                             on performerTeams.activity = $self           @title : 'Performer Teams';
        reviewerTeams  : Composition of many CuProcessActivityReviewerTeams
                             on reviewerTeams.activity = $self            @title : 'Reviewer Teams';
        startDate      : StartDate;
        endDate        : DueDate;
        url            : Url;
        comments       : Composition of many CuProcessActivityComments
                             on comments.activity = $self                 @title : 'Comments';
}

entity CuProcessActivityPerformerTeams : managed {
    key ID       : GUID;
        process  : Association to one CuProcesses         @title : 'Process';
        activity : Association to one CuProcessActivities @title : 'Activity';
        team     : Association to one Teams               @title : 'Team';
}

entity CuProcessActivityReviewerTeams : managed {
    key ID       : GUID;
        process  : Association to one CuProcesses         @title : 'Process';
        activity : Association to one CuProcessActivities @title : 'Activity';
        team     : Association to one Teams               @title : 'Team';
}

entity CuProcessActivityComments : managed {
    key ID          : GUID;
        process     : Association to one CuProcesses         @title : 'Process';
        activity    : Association to one CuProcessActivities @title : 'Activity';
        comment     : Comment;
        attachments : Composition of many CuProcessActivityCommentAttachments
                          on attachments.comment = $self     @title : 'Attachments';
}

entity CuProcessActivityCommentAttachments : managed {
    key ID       : GUID;
        process  : Association to one CuProcesses               @title : 'Process';
        activity : Association to one CuProcessActivities       @title : 'Activity';
        comment  : Association to one CuProcessActivityComments @title : 'Comment';
        name     : Name;
        file     : File;
}

entity CuProcessActivityLinks : managed {
    key ID               : GUID;
        process          : Association to one CuProcesses;
        activity         : Association to one CuProcessActivities @title : 'Activity';
        previousActivity : Association to one CuProcessActivities @title : 'Previous Activity';
}

entity CuProcessReports : managed {
    key ID              : GUID;
        process         : Association to one CuProcesses;
        report          : Report;
        sequence        : Sequence;
        description     : Description;
        content         : Content;
        calculationCode : CalculationCode;
}

entity CuProcessReportElements : managed {
    key ID          : GUID;
        process     : Association to one CuProcesses;
        report      : Association to one CuProcessReports;
        element     : Element;
        description : Description;
        content     : Content;
}

type CuProcessType @(assert.range) : String @title : 'Type' enum {
    Run        = 'RUN';
    Simulation = 'SIMULATION';
}

entity CuProcessTypes : CodeList {
    key code : CuProcessType default 'SIMULATION';
}

type CuProcessState @(assert.range) : String @title : 'State' enum {
    Inactive  = '';
    Active    = 'ACTIVE';
    Open      = 'OPEN';
    Deployed  = 'DEPLOYED';
    //    Suspended = 'SUSPENDED'; "Open" should be enough
    Completed = 'COMPLETED';
    Aborted   = 'ABORTED';
}

entity CuProcessStates : CodeList {
    key code : CuProcessState default '';
}

type CuProcessActivityType @(assert.range) : String @title : 'Type' enum {
    Execution   = 'EXECUTION';
    InputOutput = 'IO';
    Node        = 'NODE';
    Url         = 'URL';
}

entity CuProcessActivityTypes : CodeList {
    key code : CuProcessActivityType default 'IO';
}

type CuProcessActivityState @(assert.range) : String @title : 'State' enum {
    Open       = 'OPEN';
    Pending    = 'PENDING';
    InApproval = 'APPROVAL';
    Completed  = 'COMPLETED';
}

entity CuProcessActivityStates : CodeList {
    key code : CuProcessActivityState default 'OPEN';
}
