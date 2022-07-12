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
    Function,
    Sequence,
    Description,
    Documentation
} from './commonTypes';
using {
    environment,
} from './commonAspects';
using {FunctionParentFunctionsVH} from './commonEntities';
using {Fields} from './fields';
using {Checks} from './checks';
using {Partitions} from './partitions';


@assert.unique     : {
    function    : [
        environment,
        function,
    ],
    functionDescription : [
        environment,
        description,
    ]
}
@cds.odata.valuelist
@UI.Identification : [{Value : function}]
entity Functions : managed, environment {
    key ID                  : GUID                               @Common.Text : description  @Common.TextArrangement : #TextOnly;
        function            : Function;
        sequence            : Sequence default 10;
        parent              : Association to one FunctionParentFunctionsVH @title       : 'Parent';
        type                : Association to one FunctionTypes   @title       : 'Type';
        description         : Description;
        documentation       : Documentation;
        virtual url         : String;
        virtual isUrlHidden : Boolean;
}

type FunctionType @(assert.range) : String(10) @title : 'Type' enum {
    Allocation      = 'AL';
    CalculationUnit = 'CU';
    Description     = 'DS';
    ModelTable      = 'MT';
};


entity FunctionTypes : CodeList {
    key code : FunctionType default 'MT';
};


entity FunctionParentCalculationUnits as projection on Functions where type.code = 'CU';

type ProcessingType @(assert.range) : String(10) @title : 'Processing Type' enum {
    subFunction = '';
    Executable  = 'NW';
};

entity FunctionProcessingTypes : CodeList {
    key code : ProcessingType default '';
}

type FunctionBusinessEventType @(assert.range) : String(10) @title : 'Business Event Management Type' enum {
    Logging    = '';
    Correction = 'CORRECT';
};

entity FunctionBusinessEventTypes : CodeList {
    key code : FunctionBusinessEventType default '';
}
