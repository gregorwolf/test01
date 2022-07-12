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
    Connection,
    Description
} from './commonTypes';
using {environment, } from './commonAspects';


@assert.unique     : {connectionDescription : [
    environment,
    description,
]}

@cds.autoexpose
@cds.odata.valuelist
@UI.Identification : [{Value : connection}]
entity Connections : managed, environment {
    key ID              : GUID                                 @Common.Text : description  @Common.TextArrangement : #TextOnly;
        connection      : Connection;
        description     : Description;
        source          : Association to one ConnectionSources @title       : 'Source';
        hanaTable       : HanaTable;
        hanaView        : HanaView;
        odataUrl        : ODataUrl;
        odataUrlOptions : ODataUrlOptions;
}

type HanaTable : String @title : 'HANA Table';
type HanaView : String @title : 'HANA View';
type ODataUrl : String @title : 'OData Service URL';
type ODataUrlOptions : String @title : 'OData Service URL Options';

type ConnectionSource @(assert.range) : String(10) enum {
    HanaTable = 'HANA_TABLE';
    HanaView  = 'HANA_VIEW';
    OData     = 'ODATA';
}

entity ConnectionSources : CodeList {
    key code : ConnectionSource default 'HANA_VIEW';
}
