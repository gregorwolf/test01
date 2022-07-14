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
    Step,
    Conversion,
    Partition,
    Connection,
    Package,
    MainFunction,
    Run,
    Message
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
} from '../commonAspects';

using {CheckCategories} from '../checks';

entity BusinessEvents : managed {
    key ID           : GUID @UI.Hidden : false;
        state        : Association to one BusinessEventStates;
        handling: Association to one BusinessEventHandlings;
        run          : Run;
        package      : Package;
        environment  : Environment;
        version      : Version;
        process      : Process;
        activity     : Activity;
        mainFunction : MainFunction;
        quantity     : Quantity;
        newQuantity  : NewQuantity;
        message      : Message;
}

type Quantity : Integer64 @title : 'Quantity';
type NewQuantity : Quantity @title : 'New Quantity';


type BusinessEventState @(assert.range) : String(10) enum {
    Error = 'E';
    Abort = 'A';
}

entity BusinessEventStates : CodeList {
    key code : BusinessEventState default 'E';
}

type BusinessEventHandling @(assert.range) : String(10) enum {
    Event  = '';
    Ignore = 'IGNORE';
}

entity BusinessEventHandlings : CodeList {
    key code : BusinessEventHandling default 'CORRECT';
}
