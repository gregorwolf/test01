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

entity Joins : managed, function, functionExecutable {
    key ID              : GUID                            @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type            : Association to one JoinTypes    @title       : 'Type';
        inputFields     : Composition of many JoinInputFields
                              on inputFields.Join = $self @title       : 'View';
        signatureFields : Composition of many JoinSignatureFields
                              on signatureFields.Join = $self;
        rules           : Composition of many JoinRules
                              on rules.Join = $self;
        checks          : Composition of many JoinChecks
                              on checks.Join = $self      @title       : 'Checks';
}

entity modelJoins as projection on Joins excluding {
    includeInputData,
    resultHandling,
    includeInitialResult,
    resultFunction,
    processingType,
    businessEventType,
    partition,
    inputFunction,
    inputFields,
    checks,
};

entity JoinInputFields : managed, function, functionInputFields {
    Join       : Association to one Joins;
    selections : Composition of many JoinInputFieldSelections
                     on selections.inputField = $self;
}

entity JoinInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one JoinInputFields;
}

entity JoinSignatureFields : managed, function, signatureGSA {
    key ID   : GUID;
        Join : Association to one Joins;
}

entity JoinRules : managed, function {
    key ID                : GUID                               @Common.Text : description  @Common.TextArrangement : #TextOnly;
        Join              : Association to one Joins;
        parent            : Association to one JoinRules;
        type              : Association to one JoinRuleTypes;
        inputFunction     : Association to one Functions       @title       : 'Input';
        inputFields       : Composition of many JoinRuleInputFields
                                on inputFields.rule = $self    @title       : 'View';
        joinType          : Association to one JoinRuleJoinTypes;
        joinPredicates    : Composition of many JoinRulePredicates
                                on joinPredicates.rule = $self @title       : 'Predicates';
        complexPredicates : ComplexPredicates;
        sequence          : Sequence;
        description       : Description;
}

entity JoinRuleInputFields : managed, function, functionInputFields {
    key ID         : GUID;
        rule       : Association to one JoinRules;
        selections : Composition of many JoinRuleInputFieldSelections
                         on selections.inputField = $self;
}

entity JoinRuleInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one JoinRuleInputFields;
}

entity JoinRulePredicates : managed, function {
    key ID         : GUID;
        rule       : Association to one JoinRules;
        field      : Association to one Fields;
        comparison : Association to one JoinRulePredicateComparisons @title : 'Option';
        joinRule   : Association to one JoinRules                    @title : '';
        joinField  : Association to one Fields;
        sequence   : Sequence;
}

entity JoinChecks : managed, function {
    key ID    : GUID;
        Join  : Association to one Joins;
        check : Association to one Checks;
}

type JoinType @(assert.range) : String(10) @title : 'Type' enum {
    Implicit = 'IMPLICIT';
    Explicit = 'EXPLICIT';
}

entity JoinTypes : CodeList {
    key code : JoinType default 'IMPLICIT';
}

type JoinRuleType @(assert.range) : String(10) @title : 'Type' enum {
    View   = 'VIEW';
    Union  = 'UNION';
    Join   = 'JOIN';
    Lookup = 'LOOKUP';
}

entity JoinRuleTypes : CodeList {
    key code : JoinRuleType default 'VIEW';
}

type JoinRuleJoinType @(assert.range) : String(10) @title : 'Join Type' enum {
    ![From]             = 'FROM';
    FullOuterJoin       = 'FOJ';
    InnerJoin           = 'INJ';
    LeftOuterJoin       = 'LOJ';
    CrossJoin           = 'CRJ';
    Lookup              = 'LOOKUP';
    LookupAutoPredicate = 'LOOKUP_AP';

}

entity JoinRuleJoinTypes : CodeList {
    key code : JoinRuleJoinType default 'FROM';
}

type JoinRulePredicateComparison @(assert.range) : String(10) @title : 'Comparison' enum {
    Equal              = '=';
    NotEqual           = '<>';
    GreaterThan        = '>';
    LessThan           = '<';
    GreaterOrEqualThan = '>=';
    LessOrEqualThan    = '<=';
}

entity JoinRulePredicateComparisons : CodeList {
    key code : JoinRulePredicateComparison default '=';
}

type ComplexPredicates : LargeString @title : 'Complex Predicates';
