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
    Process,
    Activity,
    Function,
    Field,
    Check,
    SField,
    Step,
    Conversion,
    Partition,
    Connection,
    Package,
    MainFunction,
    Run,
    Message
} from '../commonTypes';

using {
    function,
    field,
    formulaGroupOrder,
    selection,
} from '../commonAspects';

using {CheckCategories} from '../checks';

entity CommentTargets : managed {
    key ID          : GUID                                       @UI.Hidden : false;
        environment : Environment;
        version     : Version;
        process     : Process;
        activity    : Activity;
        function    : Function;
        category    : Association to one CommentTargetCategories @title     : 'Category';
        comments    : Composition of many Comments
                          on comments.target = $self             @title     : 'Comments';

}

entity Comments : managed {
    key ID      : GUID @UI.Hidden : false;
        target  : Association to one CommentTargets;
        parent  : Association to one Comments;
        comment : Comment;
}

type CommentTargetCategory @(assert.range) : String(10) enum {
    Activity = 'ACTIVITY';
}

entity CommentTargetCategories : CodeList {
    key code : CommentTargetCategory default 'ACTIVITY';
}

type Comment : LargeString @title : 'Comment';
