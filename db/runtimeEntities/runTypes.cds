using {
  managed,
  sap.common.CodeList
} from '@sap/cds/common';

using {
  GUID,
} from '../commonTypes';

using {RuntimeFunctions} from './runtimeFunctions';

@cds.autoexpose
@cds.odata.valuelist
entity RuntimeFunctionInputFunctions      as projection on RuntimeFunctions where(
  type.code in (
    'AL', 'DE', 'JO', 'MJ', 'MT', 'MV', 'QE', 'RF', 'VW', 'WR')
  )

@cds.autoexpose
@cds.odata.valuelist
entity RuntimeFunctionResultFunctions     as projection on RuntimeFunctions where(
  type.code in (
    'MT', 'MV')
  );

