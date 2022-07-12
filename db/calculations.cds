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
    functionLookupFunction,
    formula,
} from './commonAspects';
// using {FunctionResultFunctionsVH} from './commonEntities';
using {Functions, } from './functions';
using {
    Fields,
    FieldType,
    FieldClass,
} from './fields';
using {Checks} from './checks';

entity Calculations : managed, function, functionExecutable {
    key ID              : GUID                                @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type            : Association to one CalculationTypes @title       : 'Type';
        lookupFunctions : Composition of many CalculationLookupFunctions
                              on lookupFunctions.calculation = $self;
        inputFields     : Composition of many CalculationInputFields
                              on inputFields.calculation = $self;
        signatureFields : Composition of many CalculationSignatureFields
                              on signatureFields.calculation = $self;
        workbook        : Workbook;
        rules           : Composition of many CalculationRules
                              on rules.calculation = $self;
        checks          : Composition of many CalculationChecks
                              on checks.calculation = $self;
}

entity CalculationInputFields : managed, function, functionInputFields {
    calculation : Association to one Calculations;
    selections  : Composition of many CalculationInputFieldSelections
                      on selections.inputField = $self;
}

entity CalculationInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one CalculationInputFields;
}

entity CalculationLookupFunctions : managed, function, functionLookupFunction {
    key ID          : GUID;
        calculation : Association to one Calculations;
}

entity CalculationSignatureFields : managed, function, signatureGSA {
    key ID          : GUID;
        calculation : Association to one Calculations;
}

entity CalculationRules : managed, function {
    key ID          : GUID @Common.Text : description  @Common.TextArrangement : #TextOnly;
        calculation : Association to one Calculations;
        sequence    : Sequence;
        conditions  : Composition of many CalculationRuleConditions
                          on conditions.rule = $self;
        actions     : Composition of many CalculationRuleActions
                          on actions.rule = $self;
        description : Description;
}

entity CalculationRuleConditions : managed, function {
    key ID         : GUID;
        rule       : Association to one CalculationRules;
        field      : Association to one Fields;
        selections : Composition of many CalculationRuleConditionSelections
                         on selections.condition = $self;
}

entity CalculationRuleConditionSelections : managed, function, selection {
    key ID        : GUID;
        condition : Association to one CalculationRuleConditions;
}

entity CalculationRuleActions : managed, function, formula {
    key ID    : GUID;
        rule  : Association to one CalculationRules;
        field : Association to one Fields;
}

entity CalculationChecks : managed, function {
    key ID          : GUID;
        calculation : Association to one Calculations;
        check       : Association to one Checks;
}

type CalculationType @(assert.range) : String(10) @title : 'Type' enum {
    Relative = 'RELATIVE';
    Absolute = 'ABSOLUTE';
    Workbook = 'WORKBOOK';
}

entity CalculationTypes : CodeList {
    key code : CalculationType default 'RELATIVE';
}

type Workbook : LargeString @title : 'Workbook';
