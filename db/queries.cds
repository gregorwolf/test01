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
    Field,
    Formula,
} from './commonTypes';

using {
    function,
    field,
    selection,
} from './commonAspects';

using {Functions} from './functions';
using {
    Fields,
    FieldHierarchies
} from './fields';

entity Queries : managed, function {
    key ID            : GUID                         @Common.Text : function.description  @Common.TextArrangement : #TextOnly;
        Editable      : Editable default false;
        inputFunction : Association to one Functions @title       : 'Input';
        components    : Composition of many QueryComponents
                            on components.query = $self;
}

entity QueryComponents : managed, function {
    key ID                     : GUID;
        query                  : Association to one Queries;
        component              : Component;
        type                   : Association to one QueryFieldTypes                   @title : 'Type';
        layout                 : Association to one QueryFieldLayouts                 @title : 'Layout';
        tag                    : Association to one QueryFieldTags                    @title : 'Tag';
        editable               : Editable; // KF only
        field                  : Association to one Fields; // CH, KF and Unit only
        hierarchy              : Association to one FieldHierarchies; // Ch only
        display                : Association to one QueryFieldDisplays; // Ch and unit only
        resultRow              : Association to one QueryFieldResultRows              @title : 'Show Result Rows'; // Ch and unit only
        variableRepresentation : Association to one QueryFieldVariableRepresentations @title : 'Variable Representation'; // Ch and unit only
        variableMandatory      : VariableMandatory; // Ch and unit only
        variableDefaultValue   : VariableDefaultValue; // Ch and unit only
        fixSelections          : Composition of many QueryComponentFixSelections
                                     on fixSelections.component = $self; // Ch and unit only
        aggregation            : Association to one QueryFieldAggregations; // KF, formula and selection only
        hiding                 : Association to one QueryFieldHidings                 @title : 'Hiding'; // KF, formula and selection only
        decimalPlaces          : Association to one QueryFieldDecimalPlaces           @title : 'Decimal Places'; // KF, formula and selection only
        scalingFactor          : Association to one QueryFieldScalingFactors          @title : 'Scaling Factor'; // KF, formula and selection only
        changeSign             : ChangeSign; // KF, formula and selection only
        formula                : Formula; // formula only
        keyfigure              : Association to one Fields; // selection only
        selections             : Composition of many QueryComponentSelections
                                     on selections.component = $self; // selection only
}

entity QueryComponentFixSelections : managed, function, selection {
    key ID        : GUID;
        component : Association to one QueryComponents;
}

entity QueryComponentSelections : managed, function, selection {
    key ID        : GUID;
        component : Association to one QueryComponents;
}

type QueryFieldType @(assert.range) : String(10) enum {
    Characteristic = 'CHA';
    Unit           = 'UNI';
    KeyFigure      = 'KYF';
    Formula        = 'FML';
    Selection      = 'SEL';
}

entity QueryFieldTypes : CodeList {
    key code : QueryFieldType default 'CHA';
}

type QueryFieldLayout @(assert.range) : String(10) enum {
    Row    = 'ROW';
    Column = 'COL';
    Free   = 'FRE';
}

entity QueryFieldLayouts : CodeList {
    key code : QueryFieldLayout default 'ROW';
}


type QueryFieldVariableRepresentation @(assert.range) : String(10) enum {
    NoVariable   = '';
    SelectOption = 'S';
    SingleValue  = 'P';
}

entity QueryFieldVariableRepresentations : CodeList {
    key code : QueryFieldVariableRepresentation default '';
}

type VariableMandatory : Boolean @title : 'Variable Mandatory';

type QueryFieldHiding @(assert.range) : String(10) enum {
    AlwaysShow = '';
    AlwaysHide = 'X';
    Hide       = 'Y';
}

entity QueryFieldHidings : CodeList {
    key code : QueryFieldHiding default '';
}

type QueryFieldDisplay @(assert.range) : String(10) enum {
    KeyText = '';
    Text    = 'X';
    ![Key]  = 'Y';
}

entity QueryFieldDisplays : CodeList {
    key code : QueryFieldDisplay default '';
}

type QueryFieldScalingFactor @(assert.range) : String(10) enum {
    DivBy1          = '0';
    DivBy10         = '1';
    DivBy100        = '2';
    DivBy1000       = '3';
    DivBy10000      = '4';
    DivBy100000     = '5';
    DivBy1000000    = '6';
    DivBy10000000   = '7';
    DivBy100000000  = '8';
    DivBy1000000000 = '9';
}

entity QueryFieldScalingFactors : CodeList {
    key code : QueryFieldScalingFactor default '';
}

type QueryFieldDecimalPlace @(assert.range) : String(10) enum {
    Decimals0 = '0';
    Decimals1 = '1';
    Decimals2 = '2';
    Decimals3 = '3';
    Decimals4 = '4';
    Decimals5 = '5';
    Decimals6 = '6';
    Decimals7 = '7';
    Decimals8 = '8';
    Decimals9 = '9';
}

entity QueryFieldDecimalPlaces : CodeList {
    key code : QueryFieldDecimalPlace default '';
}

type QueryFieldResultRow @(assert.range) : String(10) enum {
    Always             = '';
    Never              = 'U';
    IfMultipleChildren = 'C';
}

entity QueryFieldResultRows : CodeList {
    key code : QueryFieldResultRow default '';
}

type QueryFieldTag @(assert.range) : String(10) enum {
    None          = '';
    Description   = 'DESCR';
    HierarchyName = 'HIER_NAME';
    IsNode        = 'IS_NODE';
    ![Key]        = 'KEY';
    Language      = 'LANGUAGE';
    ParentKey     = 'PARENT_KEY';
    Sequence      = 'SEQUENCE';
}

entity QueryFieldTags : CodeList {
    key code : QueryFieldTag default '';
}


type QueryFieldAggregation @(assert.range) : String(10) enum {
    Summation = 'SUM';
    Minimum   = 'MIN';
    Maximum   = 'MAX';
}

entity QueryFieldAggregations : CodeList {
    key code : QueryFieldAggregation default 'SUM';
}

type ChangeSign : Boolean @title : 'Change Sign';
type Component : Field @title : 'Component';
type VariableDefaultValue : String @title : 'Variable Default Value';
type Editable : Boolean @title : 'Editable';
