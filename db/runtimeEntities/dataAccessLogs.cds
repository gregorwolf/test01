using {
    managed,
    Currency,
    temporal,
    Country,
    extensible,
    sap.common.CodeList
} from '@sap/cds/common';

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
    Package,
    MainFunction,
    Run,
    Message,
    PrimaryKey,
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
} from '../commonAspects';

using {CheckCategories} from '../checks';

entity DataAccessLogs : managed {
    key ID          : GUID @UI.Hidden : false;
        httpMethod  : Association to one DataAccessHttpMethods;
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        function    : Function;
        primaryKey      : PrimaryKey; // primary key in JSON field-value format, e.g. {ID: 'X', CLIENT: '100'}
        details     : Composition of many DataAccessLogDetails
                          on details.log = $self;

}

entity DataAccessLogDetails : managed {
    key ID         : GUID @UI.Hidden : false;
        log        : Association to one DataAccessLogs;
        field      : Field;
        dataBefore : DataBefore;
        dataAfter  : DataAfter;
}

type DataAccessHttpMethod @(assert.range) : String(10) enum {
    Get   = 'GET';
    Put   = 'PUT';
    Post  = 'POST';
    Patch = 'PATCH';
}

entity DataAccessHttpMethods : CodeList {
    key code : DataAccessHttpMethod default 'GET';
}

type DataBefore : String @title : 'Data Before';
type DataAfter : String @title : 'Data After';
