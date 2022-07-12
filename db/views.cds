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
    Description,
    Check,
    Field,
    Function,
    Sequence,
    IncludeInputData,
    IncludeInitialResult,
    ResultHandlings,
    Rule,
    IsActive,
    ParentRule,
    Formula,
} from './commonTypes';
using {
    function,
    functionChecks,
    functionExecutable,
    field,
    formulaOrder,
    selection,
    formulaGroupOrder,
    signatureGSA,
    functionInputFields,
    functionInputFieldSelections,
    formula,
} from './commonAspects';
// using {FunctionSignatureFields} from './commonEntities';
using {Functions, } from './functions';
using {
    Fields,
    FieldType,
    FieldClass,
} from './fields';
using {Checks} from './checks';

entity Views : managed, function, functionExecutable {
    key ID                       : GUID                              @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type                     : Association to one ViewTypes      @title       : 'Type';
        category                 : Association to one ViewCategories @title       : 'Category';
        top                      : Top;
        runParameterPrecondition : RunParameterPreCondition;
        default: Default;
        iterationType            : Association to one ViewIterationTypes;
        iterationLow             : Low;
        iterationHigh            : High;
        iterationParameter       : Association to one Fields;
        iterationEarlyExitCheck  : Association to one Checks;
        iterationResult          : Association to one ViewIterationResults;
        inputFields              : Composition of many ViewInputFields
                                       on inputFields.View = $self   @title       : 'View';
        signatureFields          : Composition of many ViewSignatureFields
                                       on signatureFields.View = $self;
        outputFields             : Composition of many ViewOutputFields
                                       on outputFields.View = $self;
        checks                   : Composition of many ViewChecks
                                       on checks.View = $self        @title       : 'Checks';
}

entity ViewInputFields : managed, function, functionInputFields {
    View       : Association to one Views;
    selections : Composition of many ViewInputFieldSelections
                     on selections.inputField = $self;
}

entity ViewInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one ViewInputFields;
}

entity ViewSignatureFields : managed, function, signatureGSA {
    key ID   : GUID;
        View : Association to one Views;
}

entity ViewOutputFields : managed, function, formulaGroupOrder {
    key ID         : GUID;
        View       : Association to one Views;
        sequence   : Sequence;
        field      : Association to one Fields;
        selections : Composition of many ViewOutputFieldSelections
                         on selections.outputField = $self;
}

entity ViewOutputFieldSelections : managed, function, selection {
    key ID          : GUID;
        outputField : Association to one ViewOutputFields;
        field       : Association to one Fields;
}

entity ViewChecks : managed, function {
    key ID    : GUID;
        View  : Association to one Views;
        check : Association to one Checks;
}

type ViewType @(assert.range) : String(10) @title : 'Type' enum {
    Implicit = 'IMPLICIT';
    Explicit = 'EXPLICIT';
}

entity ViewTypes : CodeList {
    key code : ViewType default 'IMPLICIT';
}

type ViewIterationType @(assert.range) : String(10) @title : 'Type' enum {
    AppForLoop        = 'APP_FOR';
    AppReverseForLoop = 'APP_REV';
}

entity ViewIterationTypes : CodeList {
    key code : ViewIterationType default 'APP_FOR';
}

type ViewCategory @(assert.range) : String(12) @title : 'Type' enum {
    Projection  = 'PROJECTION';
    Aggregation = 'AGGREGATION';
    Iteration   = 'ITERATION';
}

entity ViewCategories : CodeList {
    key code : ViewCategory default 'PROJECTION';
}

type ViewIterationResult @(assert.range) : String(12) @title : 'Type' enum {
    LastIteration = '';
    AllIterations = 'ALL';
}

entity ViewIterationResults : CodeList {
    key code : ViewIterationResult default 'PROJECTION';
}

type Top : Formula @title : 'Top';
type Low : Formula @title : 'Low';
type High : Formula @title : 'High';
type RunParameterPreCondition : Formula @title : 'Run Parameter Precondition';
type Default: Boolean @title: 'Default in case of empty input';