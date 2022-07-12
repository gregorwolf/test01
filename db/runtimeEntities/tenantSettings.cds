using {
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

using {Name, Value} from '../commonTypes';

entity tenantSettings : managed {
    name  : Name;
    value : Value;
}

