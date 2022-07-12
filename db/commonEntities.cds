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
    function,
    formulaOrder,
    selection,
    signatureGSA
} from './commonAspects';
using {Functions} from './functions';

using {
    GUID,
    Environment,
    Function
} from './commonTypes';

@cds.autoexpose
@cds.odata.valuelist
entity FunctionResultFunctionsVH                                                        as projection on Functions where(
    type.code = 'MT'
);


@cds.autoexpose
@cds.odata.valuelist
entity FunctionInputFunctionsVH                                                         as projection on Functions as F where(
    type.code in (
        'MT', 'AL')
    );

@cds.autoexpose
@title : 'Parent Function'
entity FunctionParentFunctionsVH                as projection on Functions where(
       type.code = 'CU'
    or type.code = 'DS'
);

annotate sap.common.CodeList with @UI.TextArrangement : #TextOnly;
