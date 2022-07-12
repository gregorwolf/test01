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

entity DataSliceLocks : managed {
    key ID          : GUID @UI.Hidden : false;
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        function    : Function;
        fields      : Composition of many DataSliceLockFields
                          on fields.lock = $self;

}

entity DataSliceLockFields : managed {
    key ID         : GUID;
        lock       : Association to one DataSliceLocks;
        field      : Field;
        selections : Composition of many DataSliceLockFieldSelections
                         on selections.field = $self;
}

entity DataSliceLockFieldSelections : managed, selection {
    key ID    : GUID;
        field : Association to one DataSliceLockFields;
}
