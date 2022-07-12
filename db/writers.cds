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

entity Writers : managed, function, functionExecutable {
    key ID                       : GUID                              @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type                     : Association to one WriterTypes      @title       : 'Type';
        inputFields              : Composition of many WriterInputFields
                                       on inputFields.Writer = $self   @title       : 'Writer';
        signatureFields          : Composition of many WriterSignatureFields
                                       on signatureFields.Writer = $self;
        outputFields             : Composition of many WriterOutputFields
                                       on outputFields.Writer = $self;
        checks                   : Composition of many WriterChecks
                                       on checks.Writer = $self        @title       : 'Checks';
}

entity WriterInputFields : managed, function, functionInputFields {
    Writer       : Association to one Writers;
    selections : Composition of many WriterInputFieldSelections
                     on selections.inputField = $self;
}

entity WriterInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one WriterInputFields;
}

entity WriterSignatureFields : managed, function, signatureGSA {
    key ID   : GUID;
        Writer : Association to one Writers;
}

entity WriterOutputFields : managed, function, formulaGroupOrder {
    key ID         : GUID;
        Writer       : Association to one Writers;
        sequence   : Sequence;
        field      : Association to one Fields;
        selections : Composition of many WriterOutputFieldSelections
                         on selections.outputField = $self;
}

entity WriterOutputFieldSelections : managed, function, selection {
    key ID          : GUID;
        outputField : Association to one WriterOutputFields;
        field       : Association to one Fields;
}

entity WriterChecks : managed, function {
    key ID    : GUID;
        Writer  : Association to one Writers;
        check : Association to one Checks;
}

type WriterType @(assert.range) : String(10) @title : 'Type' enum {
    Insert = 'INSERT';
    DeleteInsert = 'DEL_INSERT';
}

entity WriterTypes : CodeList {
    key code : WriterType default 'INSERT';
}