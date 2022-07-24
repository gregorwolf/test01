using {sap.common.Locale, } from '@sap/cds/common';
using {
    // Fixed environment specific fields, always available and managed by us, cannot be deleted by user!
    nxe._ID,
    nxe._DESCRIPTION,
    nxe._IS_NODE,
    nxe._STATE,
    nxe._LOCALE,
    nxe._HIER_NAME,
    nxe._SEQUENCE,
    nxe._TEAM,
    // Fixed environment specific aspects, managed by us!
    nxe._managed,
    nxe._table,
    nxe._mdTable,
    nxe._currencies,
    nxe._units,
    nxe._countries,
    nxe._languages,
} from './nxeTypes';

using {
    GUID,
    Field,
    Value
} from '../commonTypes';

context SXP0012 {
    // Fixed environment specific tables, managed and data updates by us, cannot be deleted by user!
    entity _CURRENCIES : _currencies {}
    entity _UNITS : _units {}
    entity _COUNTRIES : _countries {}
    entity _LANGUAGES : _languages {}
    // User defined environmentfields
    type PC : String(10) @title : 'Profit Center';
    type CC : String(10) @title : 'Cost Center';
    type AC : String(10) @title : 'GL Account';
    type FACTOR : Decimal @title : 'Factor';
    type AMOUNT : Decimal @title : 'Amount (TR)';
    type NAME : String(255) @title : 'Name';
    type CURRENCY : Association to one _CURRENCIES;
    type QUANTITY : Decimal @title : 'Quantity';
    type UNIT : Association to one _UNITS;
    type SUM : Decimal @title : 'Sum';

    // User defined tables
    // "Master Data" Model Table, require specific _mdtable as the key is not a GUID
    // In this example it uses standard environment fields starting with _ for convenience
    entity MTAC : _managed, _mdTable {
        key AC              : AC default '1234';
            _DESCR          : _DESCRIPTION default 'Test';
            _LOCALE         : _LOCALE default 'en';
            _IS_NODE        : _IS_NODE default false;
            _HIER_NAME      : _HIER_NAME default '';
            PARENT          : AC;
            _SEQUENCE       : _SEQUENCE default 0;
            _AUHTORIZATIONS : Composition of many MTAC.Authorizations
                                  on _AUHTORIZATIONS.value = $self;
            _CHANGES        : Composition of many ChangeLogs
                                  on _CHANGES.object = $self;
    }


    entity ChangeLogs {
        key ID        : GUID;
            object    : Association to one MTAC;
            timestamp : Timestamp;
            field     : Field;
            oldValue  : Value;
            newValue  : Value;
    }

    entity MTAC.Authorizations : _managed, _table {
        value  : Association to one MTAC;
        team   : _TEAM;
        read   : Boolean @title : 'Read';
        create : Boolean @title : 'Create';
        update : Boolean @title : 'Update';
        delete : Boolean @title : 'Delete';
    }

    // Mock example of an external hana table with no technical fields
    entity MTCC {
        key CC   : CC;
            NAME : NAME;
    }

    entity MT01 : _managed, _table {
        CC       : Association to one QECC @title                : 'Cost Center';
        PC       : PC;
        FACTOR   : FACTOR;
        CURRENCY : CURRENCY                @title                : 'Currency (TR)';
        AMOUNT   : AMOUNT                  @Measures.ISOCurrency : CURRENCY_code;
    }

    entity MT02 : _managed, _table {
        CC       : Association to one QECC @title              : 'Cost Center';
        PC       : PC;
        AC       : Association to one QEAC @title              : 'GL Account';
        UNIT     : UNIT                    @title              : 'Unit';
        QUANTITY : QUANTITY                @Measures.UNECEUnit : UNIT_code;
    }

    entity JO01 : _managed, _table {
        CC       : Association to one QECC @title                : 'Cost Center';
        PC       : PC;
        AC       : Association to one QEAC @title                : 'GL Account';
        CURRENCY : CURRENCY                @title                : 'Currency (TR)';
        AMOUNT   : AMOUNT                  @Measures.ISOCurrency : CURRENCY_code;
        UNIT     : UNIT                    @title                : 'Unit';
        QUANTITY : QUANTITY                @Measures.UNECEUnit   : UNIT_code;
    }

    entity CA01 : _managed, _table {
        CC       : Association to one QECC @title                : 'Cost Center';
        PC       : PC;
        AC       : Association to one QEAC @title                : 'GL Account';
        CURRENCY : CURRENCY                @title                : 'Currency (TR)';
        AMOUNT   : AMOUNT                  @Measures.ISOCurrency : CURRENCY_code;
        UNIT     : UNIT                    @title                : 'Unit';
        QUANTITY : QUANTITY                @Measures.UNECEUnit   : UNIT_code;
        SUM      : SUM                     @Measures.ISOCurrency : CURRENCY_code;
    }

    entity DE01 : _managed, _table {
        CC       : Association to one QECC @title                : 'Cost Center';
        PC       : PC;
        AC       : Association to one QEAC @title                : 'GL Account';
        CURRENCY : CURRENCY                @title                : 'Currency (TR)';
        AMOUNT   : AMOUNT                  @Measures.ISOCurrency : CURRENCY_code;
        UNIT     : UNIT                    @title                : 'Unit';
        QUANTITY : QUANTITY                @Measures.UNECEUnit   : UNIT_code;
        SUM      : SUM                     @Measures.ISOCurrency : CURRENCY_code;
    }

    entity AL01 : _managed, _table {
        CC       : Association to one QECC @title                : 'Cost Center';
        PC       : PC;
        AC       : Association to one QEAC @title                : 'GL Account';
        CURRENCY : CURRENCY                @title                : 'Currency (TR)';
        AMOUNT   : AMOUNT                  @Measures.ISOCurrency : CURRENCY_code;
        UNIT     : UNIT                    @title                : 'Unit';
        QUANTITY : QUANTITY                @Measures.UNECEUnit   : UNIT_code;
        SUM      : SUM                     @Measures.ISOCurrency : CURRENCY_code;
    }

    // Queries, allows tagging, which is resolved into annotations
    @UI.Identification : [{Value : AC}]
    entity QEAC  as projection on MTAC {
        AC @(common.Text : _DESCR),
        *, // Implicit fields
    }

    @UI.Identification : [{Value : CC}]
    entity QECC  as projection on MTCC {
        CC @(Common.Text : NAME),
        *
    }

    entity QERES as projection on AL01 {
        AC       @(title : 'my GL Account'), // Specific  query field description
        QUANTITY @(Measures.Scale : 3), // Specific query field scaling factor
        *, // Implicit fields
    };
}
