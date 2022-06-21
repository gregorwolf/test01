const cds = require("@sap/cds");

async function beforeNewEnrichment(data, target) {
  let mainEntity = {};
  if (data.allocation_ID) {
    mainEntity = await SELECT.one.from("Allocations").where({
      ID: data.allocation_ID,
    });
  } else if (data.modelTable_ID) {
    mainEntity = await SELECT.one.from("ModelTables").where({
      ID: data.modelTable_ID,
    });
  }
  if (target.elements.environment_ID)
    data.environment_ID = mainEntity.environment_ID;
  if (target.elements.function_ID) data.function_ID = mainEntity.function_ID;
}

async function onCreate(req) {
  const d = cds.model.definitions;
  const data = req.data;
  const details = {
    environment_ID: data.environment_ID,
    function_ID: data.ID,
    ID: data.ID,
  };
  switch (data.type_code) {
    case d.FunctionType.enum.Allocation.val:
      data.allocation_ID = data.ID;
      await INSERT.into(d.Allocations).entries([details]);
      break;
    case d.FunctionType.enum.CalculationUnit.val:
      data.calculationUnit_ID = data.ID;
      await INSERT.into(d.CalculationUnits).entries([details]);
      break;
    case d.FunctionType.enum.ModelTable.val:
      data.modelTable_ID = data.ID;
      await INSERT.into(d.ModelTables).entries([details]);
      break;
  }
}

async function beforeDelete(req) {
  const snapshot = await SELECT.one
    .from("Allocations")
    .where({
      ID: req.data.ID,
    })
    .columns(getDeepEntityColumns(req._model.definitions, "Allocations"));
  // snapshot.ID = undefined;
  // snapshot.DraftAdministrativeData_DraftUUID =  cds.utils.uuid();
  // snapshot.IsActiveEntity = false;
  // snapshot.HasActiveEntity = false;
  // snapshot.HasDraftEntity = false;
  // const draftEntity = cds.entities["ModelingService.Allocations"].drafts;
  // const x = await cds.run(cds.create(draftEntity, snapshot));
  console.log(snapshot);
}

function getDeepEntityColumns(csn, entityName) {
  const columns = [];
  for (const element of Object.values(csn[entityName].elements)) {
    if (element.type === "cds.Association" || element["@Core.Computed"]) {
      continue;
    }
    if (element.type === "cds.Composition" && element.target) {
      columns.push({
        ref: [element.name],
        expand: getDeepEntityColumns(csn, element.target),
      });
    } else {
      columns.push({
        ref: [element.name],
      });
    }
  }
  return columns;
}

function getHttpReqFromContext(context) {
  let req;
  let nextContext = context;
  while (!req && nextContext) {
    req = nextContext._?.req || nextContext._propagated?.req;
    if (!req) {
      nextContext = nextContext.context;
    }
  }
  return req;
}

module.exports = { onCreate, beforeDelete, beforeNewEnrichment };
