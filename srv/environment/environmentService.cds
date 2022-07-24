using {
    Environments as environments,
                    Environment,
                    Description
} from '../../db/environments';
using {CuProcesses as cuProcesses} from '../../db/runtimeEntities/cuProcesses';
using {SXP0012} from '../../db/DynamicServiceExample/SXP0012';

using {ApplicationLogs as applicationLogs} from '../../db/runtimeEntities/applicationLogs';
using {RuntimeFunctions as runtimeFunctions} from '../../db/runtimeEntities/runtimeFunctions';

@path : 'service/environment'
service EnvironmentService {
    @odata.draft.enabled
    entity Environments as projection on environments order by
        environment,
        version;

    @title : 'Create Folder'
    action createFolder();

    entity CuProcesses  as projection on cuProcesses order by
        ID;

    @odata.draft.enabled
    entity AL01         as projection on SXP0012.AL01 order by
        _ID;

    @odata.draft.enabled
    entity CA01         as projection on SXP0012.CA01 order by
        _ID;

    @odata.draft.enabled
    entity DE01         as projection on SXP0012.DE01 order by
        _ID;

    @odata.draft.enabled
    entity JO01         as projection on SXP0012.JO01 order by
        _ID;

    @odata.draft.enabled
    entity MT01         as projection on SXP0012.MT01 order by
        _ID;

    @odata.draft.enabled
    entity MT02         as projection on SXP0012.MT02 order by
        _ID;

    entity _CURRENCIES  as projection on SXP0012._CURRENCIES order by
        code;

    entity _UNITS       as projection on SXP0012._UNITS order by
        code;

    @odata.draft.enabled
    entity ApplicationLogs as projection on applicationLogs;

    @odata.draft.enabled
    entity RuntimeFunctions as projection on runtimeFunctions;

}

// @path : 'system'
// service SystemService {
//     @odata.draft.enabled
//     entity _CURRENCIES as projection on nxe._Currencies order by
//         code;
// }
