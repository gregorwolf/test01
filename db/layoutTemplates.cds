using {
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

using {
    GUID,
} from './commonTypes';

entity LayoutTemplates : managed {
    key ID       : GUID;
        category : Association to one LayoutTemplateCategories;
        variants : Composition of many LayoutTemplateVariants on variants.template = $self;
}

entity LayoutTemplateVariants : managed {
    key ID      : GUID;
        template: Association to LayoutTemplates;
        variant : Variant;
        content : VariantContent;
}

type Variant : String @title : 'Variant';
type VariantContent : LargeString @title : 'Content';

type LayoutTemplateCategory @(assert.range) : String(10) enum {
    Show      = 'SHOW';
    Analyze   = 'ANALYZE';
    Visualize = 'VISUALIZE';
    Report    = 'REPORT';
    Element   = 'ELEMENT';
}

entity LayoutTemplateCategories : CodeList {
    key code : LayoutTemplateCategory default 'SHOW';
}
