using {
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

using {GUID, } from '../commonTypes';


entity Layouts : managed {
    key ID       : GUID;
        category : Association to one LayoutCategories;
        variants : Composition of many LayoutVariants;
}

entity LayoutVariants : managed {
    key ID      : GUID;
        variant : Variant;
        content : VariantContent;
}

type Variant : String @title : 'Variant';
type VariantContent : LargeString @title : 'Content';

type LayoutCategory @(assert.range) : String(10) enum {
    Show                    = 'SHOW';
    Analyze                 = 'ANALYZE';
    Visualize               = 'VISUALIZE';
    Report                  = 'REPORT';
    Element                 = 'ELEMENT';
    ApplicationMonitor      = 'APPMON';
    BusinessEventManagement = 'BEM';
    CommentMonitor          = 'COMMON';
    ConnectionManagement    = 'CONM';
    ModelinhHistoryMonitor  = 'MOHISTMON';
    ProcessMonitor          = 'PROCMON';
    ProcessSchedulre        = 'PROCSCHED';
    TeamManagement          = 'TEAM';
}

entity LayoutCategories : CodeList {
    key code : LayoutCategory default 'SHOW';
}
