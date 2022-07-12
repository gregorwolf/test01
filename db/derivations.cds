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

entity Derivations : managed, function, functionExecutable {
    key ID              : GUID                                  @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type            : Association to one DerivationTypes    @title       : 'Type';
        inputFields     : Composition of many DerivationInputFields
                              on inputFields.derivation = $self @title       : 'View';
        signatureFields : Composition of many DerivationSignatureFields
                              on signatureFields.derivation = $self;
        rules           : Composition of many DerivationRules
                              on rules.derivation = $self;
        checks          : Composition of many DerivationChecks
                              on checks.derivation = $self      @title       : 'Checks';
}

entity DerivationInputFields : managed, function, functionInputFields {
    derivation : Association to one Derivations;
    selections : Composition of many DerivationInputFieldSelections
                     on selections.inputField = $self;
}

entity DerivationInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one DerivationInputFields;
}

entity DerivationSignatureFields : managed, function, signatureGSA {
    key ID         : GUID;
        derivation : Association to one Derivations;
}

entity DerivationRules : managed, function {
    key ID          : GUID @Common.Text : description  @Common.TextArrangement : #TextOnly;
        derivation : Association to one Derivations;
        sequence    : Sequence;
        conditions  : Composition of many DerivationRuleConditions
                          on conditions.rule = $self;
        actions     : Composition of many DerivationRuleActions
                          on actions.rule = $self;
        description : Description;
}

entity DerivationRuleConditions : managed, function {
    key ID         : GUID;
        rule       : Association to one DerivationRules;
        field      : Association to one Fields;
        selections : Composition of many DerivationRuleConditionSelections
                         on selections.condition = $self;
}

entity DerivationRuleConditionSelections : managed, function, selection {
    key ID        : GUID;
        condition : Association to one DerivationRuleConditions;
}

entity DerivationRuleActions : managed, function, formula {
    key ID    : GUID;
        rule  : Association to one DerivationRules;
        field : Association to one Fields;
}

entity DerivationChecks : managed, function {
    key ID         : GUID;
        derivation : Association to one Derivations;
        check      : Association to one Checks;
}

type DerivationType @(assert.range) : String(10) @title : 'Type' enum {
    Relative = 'RELATIVE';
    Absolute = 'ABSOLUTE';
    Workbook = 'WORKBOOK';
}

entity DerivationTypes : CodeList {
    key code : DerivationType default 'RELATIVE';
}
