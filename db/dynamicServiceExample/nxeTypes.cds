using {
    User,
    Currency,
    temporal,
    Country,
    extensible,
    sap.common.Locale,
    sap.common.Currencies,
    sap.common.Countries,
    sap.common.Languages,
    sap.common.CodeList,
} from '@sap/cds/common';

using {ApplicationLogs} from '../runtimeEntities/applicationLogs';

// needed for basics.hdblibrary
@cds.presistence.exists
entity TABLE_COLUMNS {
    SCHEMA_NAME    : String(256)   @title : 'Schema name';
    TABLE_NAME     : String(256)   @title : 'Table name';
    TABLE_OID      : Integer64     @title : 'Object ID of the table';
    COLUMN_NAME    : String(256)   @title : 'Name of the column';
    POSITION       : Integer       @title : 'Ordinal position of the column in the record';
    DATA_TYPE_ID   : hana.SMALLINT @title : 'SQL Data type ID of te column';
    DATA_TYPE_NAME : String(16)    @title : 'SQL data type name of the column';
    OFFSET         : hana.SMALLINT @title : 'Offset of the column in the record';
    LENGTH         : Integer       @title : 'Length';
    SCALE          : Integer       @title : 'Scale';
    IS_NULLABLE    : String(5)     @title : 'Is Nullable (TRUE/FALSE)';
    DEFAULT_VALUE  : String(5000)  @title : 'Default value';
    COMMENTS       : String(5000)  @title : 'Comments';
}

// needed for basics.hdblibrary
@cds.presistence.exists
entity VIEW_COLUMNS {
    SCHEMA_NAME    : String(256)   @title : 'Schema name';
    VIEW_NAME      : String(256)   @title : 'View name';
    VIEW_OID       : Integer64     @title : 'Object ID of the view';
    COLUMN_NAME    : String(256)   @title : 'Name of the column';
    POSITION       : Integer       @title : 'Ordinal position of the column in the record';
    DATA_TYPE_ID   : hana.SMALLINT @title : 'SQL Data type ID of te column';
    DATA_TYPE_NAME : String(16)    @title : 'SQL data type name of the column';
    OFFSET         : hana.SMALLINT @title : 'Offset of the column in the record';
    LENGTH         : Integer       @title : 'Length';
    SCALE          : Integer       @title : 'Scale';
    IS_NULLABLE    : String(5)     @title : 'Is Nullable (TRUE/FALSE)';
    DEFAULT_VALUE  : String(5000)  @title : 'Default value';
    COMMENTS       : String(5000)  @title : 'Comments';
}

context nxe {

    // General
    type _ID : UUID @odata.Type : 'Edm.String'  @title : 'ID';
    type _LOG_ID : UUID @odata.Type : 'Edm.String'  @title : 'Log ID';
    type _TEAM_ID : UUID @odata.Type : 'Edm.String'  @title : 'Team ID';
    type _STATE : String(5000) @title : 'State';
    // Master data
    type _DESCRIPTION : String(255) @title : 'Name';
    type _IS_NODE : Boolean @title : 'Is Node';
    type _LOCALE : Locale;
    type _HIER_NAME : String @title : 'Hierarchy Name';
    type _SEQUENCE : String @title : 'Sequence';
    type _TEAM : String @title : 'Team';


    aspect _managed {
        _createdAt  : Timestamp @cds.on.insert : $now  @UI.HiddenFilter  @Core.Immutable  @readonly  @title         : '{i18n>CreatedAt}';
        _createdBy  : User      @cds.on.insert : $user  @UI.HiddenFilter  @readonly  @title : '{i18n>CreatedBy}';
        _modifiedAt : Timestamp @cds.on.insert : $now  @cds.on.update  : $now  @UI.HiddenFilter  @Core.Immutable  @readonly  @title : '{i18n>ChangedAt}';
        _modifiedBy : User      @cds.on.insert : $user  @cds.on.update : $user  @UI.HiddenFilter  @readonly  @title : '{i18n>ChangedBy}';
    }

    @cds.autoexpose
    @cds.odata.valuelist
    aspect _table {
        key _ID : _ID;
        _LOG_ID : _LOG_ID;
        _STATE  : _STATE default 'S=OK';
        // unmanaged association to allow deletion of old application logs!
        _LOG    : Association to one ApplicationLogs
                      on _LOG.ID = _LOG_ID;
    }

    @cds.autoexpose
    @cds.odata.valuelist
    aspect _mdTable {
        _LOG_ID : _LOG_ID;
        _STATE  : _STATE default 'S=OK';
        // unmanaged association to allow deletion of old application logs!
        _LOG    : Association to one ApplicationLogs
                      on _LOG.ID = _LOG_ID;
    }

    aspect _units : CodeList {
        key code      : String(3) default 'PC' @Common.IsUnit @Common.Text:name;
        symbol        : String(5)              @(title : '{i18n>UnitSymbol}');
        decimalPlaces : Integer                @title : 'Decimal Places';
    }

    aspect _currencies : CodeList {
        key code      : String(3) @(title : '{i18n>CurrencyCode}') @Common.Text:name;
        symbol        : String(5) @(title : '{i18n>CurrencySymbol}');
        decimalPlaces : Integer   @title : 'Decimal Places';
    }

    aspect _countries : Countries {}
    aspect _languages : Languages {}

}
