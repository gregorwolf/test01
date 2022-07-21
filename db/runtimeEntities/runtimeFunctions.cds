using {
    managed,
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
    Step,
    Conversion,
    Partition,
    Connection,
    Run,
    MainFunction,
    Package,
    Message,
    PrimaryKey,
    BusinessEvent,
    Description,
    Range,
    Sequence,
    Level,
    Value,
    Statement,
} from '../commonTypes';

using {
    FunctionTypes,
    FunctionBusinessEventTypes,
    FunctionProcessingTypes,
} from '../functions';

using {
    HanaView,
    HanaTable
} from '../connections';

using {Workbook} from '../calculations';
using {RuntimeFields} from './RuntimeFields';

entity RuntimeFunctions : managed {
    key ID                      : GUID;
        environment             : Environment;
        version                 : Version;
        process                 : Process;
        activity                : Activity;
        function                : Function;
        description             : Description;
        type                    : Association to one FunctionTypes              @title : 'Type';
        state                   : Association to one RuntimeFunctionStates      @title : 'State';
        processingType          : Association to one FunctionProcessingTypes    @title : 'Processing Type';
        businessEventType       : Association to one FunctionBusinessEventTypes @title : 'Business Event Type';
        partition               : Composition of one RuntimePartitions          @title : 'Runtime Partition';
        storedProcedure         : StoredProcedure;
        appServerStatement      : AppServerStatement;
        preStatement            : PreStatement;
        statement               : Statement;
        postStatement           : PostStatement;
        hanaTable               : HanaTable;
        hanaView                : HanaView;
        synonym                 : Synonym;
        masterDataHierarchyView : MasterDataHierarchyView;
        calculationView         : CalculationView;
        workBook                : Workbook;
        resultModelTable        : Association to one RuntimeFunctions           @title : 'Result Model Table';
        processChains           : Composition of many RuntimeProcessChains
                                      on processChains.function = $self         @title : 'Process Chains';
        inputFunctions          : Composition of many RuntimeInputFunctions
                                      on inputFunctions.function = $self        @title : 'Input Functions';
        outputFields            : Composition of many RuntimeOutputFields
                                      on outputFields.function = $self          @title : 'Output Fields';
        shareLocks              : Composition of many RuntimeShareLocks
                                      on shareLocks.function = $self            @title : 'Share Locks';
}

// todo use select.forShareLock() to block parallel calls of same activity or function or partitionFieldRangeValue
entity RuntimeShareLocks : managed {
    key ID                       : GUID @UI.Hidden : false;
        function                 : Association to one RuntimeFunctions;
        environment              : Environment;
        version                  : Version;
        process                  : Process;
        activity                 : Activity;
        partitionField           : Association to one RuntimeFields;
        partitionFieldRangeValue : PartitionFieldRangeValue;
}

// This entity needs to be filled automatically during generation for the activated function and potentially all subsequent activated functions
entity RuntimeOutputFields : managed {
    key ID       : GUID;
        environment              : Environment;
        version                  : Version;
        function : Association to one RuntimeFunctions;
        field    : Field;
}

entity RuntimeProcessChains : managed {
    key ID       : GUID;
        function : Association to one RuntimeFunctions;
        level    : Level;
        chains   : Composition of many RuntimeProcessChainFunctions
                       on chains.processChain = $self @title : 'Chain Functions';
}

entity RuntimeProcessChainFunctions : managed {
    key ID           : GUID;
        processChain : Association to one RuntimeProcessChains;
        function     : Association to one RuntimeFunctions;
}

entity RuntimeInputFunctions : managed {
    key ID            : GUID;
        function      : Association to one RuntimeFunctions;
        inputFunction : Association to one RuntimeFunctions;
}

entity RuntimePartitions : managed {
    key ID          : GUID;
        partition   : Partition;
        description : Description;
        field       : Association to one RuntimeFields;
        ranges      : Composition of many RuntimePartitionRanges
                          on ranges.partition = $self;
}

entity RuntimePartitionRanges : managed {
    key ID        : GUID;
        partition : Association to one RuntimePartitions;
        range     : Range;
        sequence  : Sequence;
        level     : Level default 0;
        value     : Value;
}

type RuntimeFunctionState @(assert.range) : String(10) @title : 'State' enum {
    Active  = 'ACTIVE';
    Error   = 'ERROR';
    Checked = 'CHECKED';
};


entity RuntimeFunctionStates : CodeList {
    key code : RuntimeFunctionState default 'CHECKED';
};

type AppServerStatement : LargeString @title : 'App Server Statement';
type PreStatement : LargeString @title : 'Pre-Statement';
type PostStatement : LargeString @title : 'Post-Statement';
type InputFunction : Function @title : 'Input function';
type MasterDataHierarchyView : HanaView @title : 'Master data and Hierarchy View';
type CalculationView : HanaView @title : 'Calculation View';
type Synonym : HanaView @title : 'Synonym';
type StoredProcedure : String @title : 'Stored Procedure';
type PartitionField : String @title : 'Partition Range Field';
type PartitionFieldRangeValue : String @title : 'Partition Range Field Value';
