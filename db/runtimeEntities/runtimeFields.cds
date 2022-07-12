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
    Environment,
    Version,
    Field,
    Description,
    Documentation,
} from '../commonTypes';

using {field, } from '../commonAspects';

using {
    FieldClasses,
    FieldTypes,
    HanaDataTypes,
    DataLength,
    DataDecimals,
    UnitFields,
    IsLowercase,
    HasMasterData,
    HasHierarchy,
    Hierarchy
} from '../fields';

entity RuntimeFields : managed {
    key ID                   : GUID;
        field                : Field;
        environment          : Environment;
        version              : Version;
        class                : Association to one FieldClasses  @title : 'Field Class';
        type                 : Association to one FieldTypes    @title : 'Field Type';
        hanaDataType         : Association to one HanaDataTypes @title : 'Data Type';
        dataLength           : DataLength default 16;
        dataDecimals         : DataDecimals default 0;
        unitField            : Association to one UnitFields;
        isLowercase          : IsLowercase default true;
        hasMasterData        : HasMasterData default false;
        hasHierarchies       : HasHierarchy default false;
        calculationHierarchy : Hierarchy;
        masterDataHanaView   : MasterDataHanaView;
        description          : Description;
        documentation        : Documentation;
}

type MasterDataHanaView : String @title : 'Master Data Hana View';
