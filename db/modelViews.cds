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
    Sequence,
    Connection,
} from './commonTypes';

using {
    function,
    field,
} from './commonAspects';

using {SourceField} from './modelTables';

entity ModelViews : managed, function {
    key ID         : GUID                              @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type       : Association to one ModelViewTypes @title       : 'Type';
        connection : Connection;
        fields     : Composition of many ModelViewFields
                         on fields.ModelView = $self;
}


entity ModelViewFields : managed, field {
    key ID          : GUID;
        ModelView   : Association to one ModelViews;
        sourceField : SourceField;
}

type ModelViewType @(assert.range) : String(10) enum {
    HANATable = 'HANA_TABLE';
    HANAView  = 'HANA_VIEW';
    OData     = 'ODATA';
}

entity ModelViewTypes : CodeList {
    key code : ModelViewType default 'HANA_VIEW';
}
