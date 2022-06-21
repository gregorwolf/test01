const cds = require("@sap/cds");
const textbundle = require("@sap/textbundle");

module.exports = function () {
  this.on("createFolder", async (req) => {
    await createFolder(req);
  });
  this.before("READ", "Environments", (req) => {
    console.log(req._queryOptions);
  });
  this.after("READ", "Environments", (each, req) => {
    enrichEnvironments(each, req);
  });
  this.before(["PATCH", "SAVE"], "Environments", (req) => {
    const textBundle = new textbundle.TextBundle(
      "i18n/messages",
      req.user.locale
    );
    checkParentId(req.data, textBundle, req);
    checkVersion(req.data, textBundle, req);
    checkEnvironmentType(req.data, req);
  });
  this.after(["CREATE"], "Environments", (req) => {
    addRootCalcUnit(req);
  });
};

async function addRootCalcUnit(data) {
  const d = cds.model.definitions;
  if (data.type_code === d.EnvironmentType.enum.Environment.val) {
    await INSERT.into(d.Functions).entries([
      {
        environment_ID: data.ID,
        ID: data.ID,
        function: data.environment,
        description: data.description,
        type_code: d.FunctionType.enum.CalculationUnit.val,
      },
    ]);
    await INSERT.into(d.CalculationUnits).entries([
      {
        environment_ID: data.ID,
        function_ID: data.ID,
        ID: data.ID,
      },
    ]);
  }
}

function enrichEnvironments(results, req) {
  const records = Array.isArray(results) ? results : [results];
  const d = cds.model.definitions;
  records.forEach((data) => {
    if (data.type_code === d.EnvironmentType.enum.Folder.val) {
      data.url = `#Environments-manage?parent_ID=${data.ID}`;
      data.icon = "sap-icon://folder-blank";
      data.gotoSubfolders = "Child Environments";
      data.gotoFunctions = false;
    } else if (data.type_code === d.EnvironmentType.enum.Environment.val) {
      data.url = `#Functions-manage?environment_ID=${data.ID}`;
      data.icon = "sap-icon://tree";
      data.gotoFunctions = true;
    }
  });
}

function checkParentId(results, textBundle, req) {
  const records = Array.isArray(results) ? results : [results];
  records.forEach((data) => {
    if (data.ID === data.parent_ID) {
      const LOG = cds.log("PAPM");
      const text = textBundle.getText("ENVID_OWN_PARENT", [
        data.ID,
        data.parent_ID,
      ]);
      LOG.error(text);
      req.error(500, "ENVID_OWN_PARENT", "parent_ID", [
        data.ID,
        data.parent_ID,
      ]);
    }
  });
}

function checkVersion(results, textBundle, req) {
  const records = Array.isArray(results) ? results : [results];
  const d = cds.model.definitions;
  records.forEach((data) => {
    if (data.type_code === d.EnvironmentType.enum.Folder.val) {
      data.version = null;
    } else {
      if (!data.version) {
        // This happens because version cannot be mandatory statically,
        // so when user switches in edit draft from folder to environment we need to check this
        const LOG = cds.log("PAPM");
        const text = textBundle.getText("VERSION_NOT_NULL");
        LOG.error(text);
        req.error(500, "VERSION_NOT_NULL", "version", [data.version]);
      }
    }
  });
}

async function checkEnvironmentType(results, req) {
  const records = Array.isArray(results) ? results : [results];
  const d = cds.model.definitions;
  for (const data of records) {
    if (data.type_code === d.EnvironmentType.enum.Folder.val) {
      const functions = await SELECT.from("Functions").where({
        environment_ID: data.ID,
      });
      if (functions.length)
        req.error(500, "ENVTYPE_CHANGE_NOT_ALLOWED", "type", [data.type]);
    }
  }
}

async function createFolder(req) {
  const d = cds.model.definitions;

  const data = { type_code: d.EnvironmentType.enum.Folder.val };
  await cds.emit("NEW", "Environments", data);
}
