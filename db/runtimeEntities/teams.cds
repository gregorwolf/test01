using {
    GUID,
    Name,
    Description,
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
} from '../commonAspects';

using {CheckCategories} from '../checks';

using {
    managed,
    sap.common.CodeList,
} from '@sap/cds/common';

entity Teams : managed {
    key ID          : GUID;
        name        : Name;
        description : Description;
        obsolete    : Obsolete;
        users       : Composition of many TeamUsers;
}

entity TeamUsers : managed {
    key ID   : GUID;
        team : Association to one Teams @title : 'Team';
        user : Association to one Users @title : 'User';
}

entity Users : managed {
    key ID         : GUID;
        eMail      : EMail;
        externalID : ExternalID;
}

type Obsolete : Boolean @title : 'Obsolete';
type EMail : String @title : 'E-Mail';
type ExternalID : String @title : 'External ID';
