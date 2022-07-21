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

@assert.unique : {
    fieldname        : [
        environment,
        field
    ],
    fieldDescription : [
        environment,
        description,
    ]
}
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
        anonymized : Anonymized;
        identities : Composition of many UserIdentities
                         on identities.user = $self @title : 'Identities';
        profiles   : Composition of many UserProfiles
                         on profiles.user = $self   @title : 'Profiles';
}

entity UserIdentities : managed {
    key ID       : GUID;
        user     : Association to one Users;
        provider : Provider;
        identity : Identity;
}

entity UserProfiles : managed {
    key ID    : GUID;
        user  : Association to one Users;
        eMail : EMail;
}

type Obsolete : Boolean @title : 'Obsolete';
type EMail : String @title : 'E-Mail';
type Identity : String @title : 'External Identity ID';
type Provider : String @title : 'External Identity Provider';
type Anonymized : Boolean @title : 'Anonymized';
