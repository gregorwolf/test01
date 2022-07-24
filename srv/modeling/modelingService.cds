using {Environments as environments} from '../../db/environments';
using {Fields as fields} from '../../db/fields';
using {Checks as checks} from '../../db/checks';
using {CurrencyConversions as currencyConversions} from '../../db/conversions';
using {UnitConversions as unitConversions} from '../../db/conversions';
using {Partitions as partitions} from '../../db/partitions';
using {Functions as functions} from '../../db/functions';
using {Allocations as allocations} from '../../db/allocations';
using {Calculations as calculations} from '../../db/calculations';
using {Derivations as derivations} from '../../db/derivations';
using {ModelTables as modelTables} from '../../db/modelTables';
using {CalculationUnits as calculationUnits} from '../../db/calculationUnits';
using {Joins as joins} from '../../db/joins';
using {Queries as queries} from '../../db/queries';
using {ApplicationLogs as applicationLogs} from '../../db/runtimeEntities/applicationLogs';
using {RuntimeFunctions as runtimeFunctions} from '../../db/runtimeEntities/runtimeFunctions';

@path : 'service/modeling'
service ModelingService {

    @odata.draft.enabled  @readonly
    entity Environments        as projection on environments;

    @odata.draft.enabled
    entity Fields              as projection on fields;

    @odata.draft.enabled
    entity Checks              as projection on checks;

    @odata.draft.enabled
    entity CurrencyConversions as projection on currencyConversions;

    @odata.draft.enabled
    entity UnitConversions     as projection on unitConversions;

    @odata.draft.enabled
    entity Partitions          as projection on partitions;

    @odata.draft.enabled
    entity Functions           as projection on functions actions {
        @title : 'Activate'
        action activate();
    };

    @odata.draft.enabled
    entity Allocations         as projection on allocations actions {
        @title : 'Activate'
        action activate();
    };

    @odata.draft.enabled
    entity CalculationUnits    as projection on calculationUnits;

    @odata.draft.enabled
    entity ModelTables         as projection on modelTables;

    @odata.draft.enabled
    entity Calculations        as projection on calculations;

    @odata.draft.enabled
    entity Derivations         as projection on derivations;

    @odata.draft.enabled
    entity Joins               as projection on joins;

    @odata.draft.enabled
    entity Queries             as projection on queries;
}
