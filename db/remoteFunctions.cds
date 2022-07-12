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
    Formula,
} from './commonTypes';

using {
    function,
    functionExecutable,
    field,
    functionInputFields,
    functionInputFieldSelections,
    signatureGSA,
} from './commonAspects';
using {Fields} from './Fields';

entity RemoteFunctions : managed, function, functionExecutable {
    key ID              : GUID                                      @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        type            : Association to one RemoteFunctionTypes    @title       : 'Type';
        connection      : Connection;
        inputFields     : Composition of many RemoteFunctionInputFields
                              on inputFields.remoteFunction = $self @title       : 'View';
        signatureFields : Composition of many RemoteFunctionSignatureFields
                              on signatureFields.remoteFunction = $self;
        glMapping       : Composition of one RemoteFunctionGlMapping;
        // gliMapping : Composition of one RemoteFunctionGliMapping;
        // ...
}

entity remoteFunctionGLs as projection on RemoteFunctions {
    ID,
    type,
    connection,
    inputFields,
    signatureFields,
    glMapping as mapping,
};

entity RemoteFunctionInputFields : managed, function, functionInputFields {
    remoteFunction : Association to one RemoteFunctions;
    selections     : Composition of many RemoteFunctionInputFieldSelections
                         on selections.inputField = $self;
}

entity RemoteFunctionInputFieldSelections : managed, function, functionInputFieldSelections {
    key ID         : GUID;
        inputField : Association to one RemoteFunctionInputFields;
}

entity RemoteFunctionSignatureFields : managed, function, signatureGSA {
    key ID             : GUID;
        remoteFunction : Association to one RemoteFunctions;
}

entity RemoteFunctionGlMapping : managed, function {
    key ID             : GUID;
        remoteFunction : Association to one RemoteFunctions;
        comp_code      : CompanyCode;
        costcenter     : CostCenter;
        gl_account     : GlAccount @mandatory;
// ...
}

// Todo: More user friendly would be separate structures for each RF Type, because then we can provide better value help for input, output and parameter fields
// entity RemoteFunctionMappings : managed, field {
//     key ID             : GUID;
//         RemoteFunction : Association to one RemoteFunctions;
//         component      : Association to one RemoteFunctionComponents;
//         field          : Association to one Fields;
//         formula        : Formula;
// }

type RemoteFunctionType @(assert.range) : String(10) enum {
    FinanceAccountsPayable      = 'FI_AP';
    FinanceAccountsReceivable   = 'FI_AR';
    FinanceGeneralLedger        = 'FI_GL';
    FinanceGeneralLedgerItems   = 'FI_GLI';
    FinancialStatementItems     = 'FSI';
    HanaStoredProcedure         = 'HANA_SP';
    JavaScript                  = 'JS';
    PurchaseOrder               = 'PO';
    Python                      = 'PYTHON';
    SalesAndDistribution        = 'SD';
    SecondaryCostElementPosting = 'SP';
}

entity RemoteFunctionTypes : CodeList {
    key code : RemoteFunctionType default 'ENV';
}

entity RemoteFunctionComponents : CodeList {
    key code      : String;
        type      : Association to one RemoteFunctionTypes;
        sequence  : Sequence;
        mandatory : Mandatory;
}

type Mandatory : Boolean @title : 'Mandatory';
type CompanyCode : String(4) @title : 'Company Code'  @Common.IsUpperCase;
type CostCenter : String(10) @title : 'Cost Center'  @Common.IsUpperCase;
type GlAccount : String(10) @ttitle : 'GL Account'  @Common.IsUpperCase;
