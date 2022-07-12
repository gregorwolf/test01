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
    Sfield,
    Description,
    Documentation
} from './commonTypes';
using {
    environment,
    field,
    function,
    selection,
} from './commonAspects';
using {FunctionParentFunctionsVH} from './commonEntities';
using {Fields} from './fields';
using {Checks} from './checks';
using {Partitions} from './partitions';


@cds.odata.valuelist
entity Descriptions : managed, environment {
    key ID         : GUID;
        type       : Association to one DescriptionTypes @title : 'Type';
        // Should we switch to structured approach instead of free text parameter formula condition?
        // conditions : Composition of many DescriptionRuleConditions
        //                  on conditions.description = $self;
        condition: Condition;
}

// entity DescriptionRuleConditions : managed, function {
//     key ID          : GUID;
//         description : Association to one Descriptions;
//         field       : Association to one Fields;
//         selections  : Composition of many DescriptionRuleConditionSelections
//                           on selections.condition = $self;
// }

// entity DescriptionRuleConditionSelections : managed, function, selection {
//     key ID        : GUID;
//         condition : Association to one DescriptionRuleConditions;
// }

type DescriptionType @(assert.range) : String(10) @title : 'Type' enum {
    Description = '';
    Condition   = 'CONDITION';
};


entity DescriptionTypes : CodeList {
    key code : DescriptionType default '';
};

type Condition: String @title : 'Parameter Condition';